use crate::api::cancel::RsCancellationToken;
use crate::frb_generated::StreamSink;
use bytes::Bytes;
use flutter_rust_bridge::frb;
use localsend::model::transfer::FileContent;
use localsend::util::error::ErrorChain;
use tokio::sync::mpsc;

#[frb(sync)]
pub fn encrypted_upload_size(size: u64) -> u64 {
    if size == 0 {
        21
    } else {
        const RECORD_SIZE: u64 = 64 * 1024 - 17;
        21 + size + 17 * size.div_ceil(RECORD_SIZE)
    }
}

pub async fn fetch_send_server_config(
    server_url: String,
) -> Result<SendServerConfig, RsSendServerError> {
    localsend::send_server::fetch_config(&server_url)
        .await
        .map(SendServerConfig::from)
        .map_err(RsSendServerError::from)
}

pub struct SendServerConfig {
    pub limits: SendServerLimits,
    pub defaults: SendServerDefaults,
    pub upload_auth: Option<SendServerUploadAuthConfig>,
}

pub struct SendServerLimits {
    pub anon: SendServerAnonLimits,
}

pub struct SendServerAnonLimits {
    pub max_file_size: u64,
    pub max_downloads: u64,
    pub max_expire_seconds: u64,
}

pub struct SendServerDefaults {
    pub download_counts: Vec<u64>,
    pub expire_times_seconds: Vec<u64>,
    pub expire_seconds: u64,
}

pub struct SendServerUploadAuthConfig {
    pub required: bool,
    pub kdf: String,
    pub pbkdf2_iterations: u32,
    pub challenge_ttl_seconds: u64,
}

impl From<localsend::send_server::SendServerConfig> for SendServerConfig {
    fn from(value: localsend::send_server::SendServerConfig) -> Self {
        Self {
            limits: value.limits.into(),
            defaults: value.defaults.into(),
            upload_auth: value.upload_auth.map(Into::into),
        }
    }
}

impl From<localsend::send_server::SendServerLimits> for SendServerLimits {
    fn from(value: localsend::send_server::SendServerLimits) -> Self {
        Self {
            anon: value.anon.into(),
        }
    }
}

impl From<localsend::send_server::SendServerAnonLimits> for SendServerAnonLimits {
    fn from(value: localsend::send_server::SendServerAnonLimits) -> Self {
        Self {
            max_file_size: value.max_file_size,
            max_downloads: value.max_downloads,
            max_expire_seconds: value.max_expire_seconds,
        }
    }
}

impl From<localsend::send_server::SendServerDefaults> for SendServerDefaults {
    fn from(value: localsend::send_server::SendServerDefaults) -> Self {
        Self {
            download_counts: value.download_counts,
            expire_times_seconds: value.expire_times_seconds,
            expire_seconds: value.expire_seconds,
        }
    }
}

impl From<localsend::send_server::SendServerUploadAuthConfig> for SendServerUploadAuthConfig {
    fn from(value: localsend::send_server::SendServerUploadAuthConfig) -> Self {
        Self {
            required: value.required,
            kdf: value.kdf,
            pbkdf2_iterations: value.pbkdf2_iterations,
            challenge_ttl_seconds: value.challenge_ttl_seconds,
        }
    }
}

pub struct RsSendServerFile {
    pub name: String,
    pub size: u64,
    pub mime: Option<String>,
    pub file_path: Option<String>,
    pub file_bytes: Option<Vec<u8>>,
    pub file_descriptor: Option<i32>,
}

pub struct RsSendServerUploadOptions {
    pub server_url: String,
    pub password: Option<String>,
    pub upload_auth_password: Option<String>,
    pub download_limit: u64,
    pub expire_seconds: u64,
}

pub enum RsSendServerUploadEvent {
    Progress {
        sent: u64,
        total: u64,
        progress: f64,
    },
    Finished {
        id: String,
        url: String,
        password: Option<String>,
    },
    Failed {
        error: RsSendServerError,
    },
}

/// Uploads files to a Firefox Send compatible server, emitting progress and
/// the final share URL through [sink].
pub async fn upload_send_server(
    sink: StreamSink<RsSendServerUploadEvent>,
    files: Vec<RsSendServerFile>,
    options: RsSendServerUploadOptions,
    cancel_token: &RsCancellationToken,
) {
    let result = async {
        let files = files
            .into_iter()
            .map(resolve_file)
            .collect::<Result<Vec<_>, RsSendServerError>>()?;
        let result = localsend::send_server::upload(
            files,
            localsend::send_server::SendServerUploadOptions {
                server_url: options.server_url,
                password: options.password,
                upload_auth_password: options.upload_auth_password,
                download_limit: options.download_limit,
                expire_seconds: options.expire_seconds,
            },
            |sent, total| {
                let progress = if total == 0 {
                    1.0
                } else {
                    (sent as f64 / total as f64).min(1.0)
                };
                let _ = sink.add(RsSendServerUploadEvent::Progress {
                    sent,
                    total,
                    progress,
                });
            },
            cancel_token.inner.clone(),
        )
        .await
        .map_err(RsSendServerError::from)?;

        let _ = sink.add(RsSendServerUploadEvent::Finished {
            id: result.id,
            url: result.url,
            password: result.password,
        });
        Ok(())
    }
    .await;

    if let Err(error) = result {
        let _ = sink.add(RsSendServerUploadEvent::Failed { error });
    }
}

fn resolve_file(
    file: RsSendServerFile,
) -> Result<localsend::send_server::SendServerFile, RsSendServerError> {
    Ok(localsend::send_server::SendServerFile {
        name: file.name,
        size: file.size,
        mime: file.mime,
        content: match (file.file_path, file.file_bytes, file.file_descriptor) {
            (Some(path), None, None) => FileContent::Path(path.into()),
            (None, Some(bytes), None) => {
                let (tx, rx) = mpsc::channel(1);
                // Receiver errors are reported by the upload stream ending.
                tokio::spawn(async move {
                    let _ = tx.send(Bytes::from(bytes)).await;
                });
                FileContent::Stream(rx)
            }
            (None, None, Some(file_descriptor)) => {
                #[cfg(target_os = "android")]
                {
                    FileContent::Fd(file_descriptor)
                }
                #[cfg(not(target_os = "android"))]
                {
                    let _ = file_descriptor;
                    return Err(RsSendServerError::Other(
                        "File descriptors are only supported on Android".into(),
                    ));
                }
            }
            _ => {
                return Err(RsSendServerError::Other(
                    "Exactly one file source must be provided".into(),
                ));
            }
        },
    })
}

#[derive(Clone, Debug)]
pub enum RsSendServerError {
    InvalidUrl,
    Status { status: u16 },
    InvalidResponse(String),
    Network(String),
    Io(String),
    Cancelled,
    Crypto,
    UploadAuthRequired,
    UploadAuthFailed,
    UnsupportedUploadAuth(String),
    Other(String),
}

impl From<localsend::send_server::SendServerError> for RsSendServerError {
    fn from(e: localsend::send_server::SendServerError) -> Self {
        match e {
            localsend::send_server::SendServerError::InvalidUrl => RsSendServerError::InvalidUrl,
            localsend::send_server::SendServerError::Status { status } => {
                RsSendServerError::Status { status }
            }
            localsend::send_server::SendServerError::InvalidResponse(e) => {
                RsSendServerError::InvalidResponse(e)
            }
            localsend::send_server::SendServerError::Network(e) => RsSendServerError::Network(e),
            localsend::send_server::SendServerError::Io(e) => {
                RsSendServerError::Io(ErrorChain(&e).to_string())
            }
            localsend::send_server::SendServerError::Cancelled => RsSendServerError::Cancelled,
            localsend::send_server::SendServerError::Crypto => RsSendServerError::Crypto,
            localsend::send_server::SendServerError::UploadAuthRequired => {
                RsSendServerError::UploadAuthRequired
            }
            localsend::send_server::SendServerError::UploadAuthFailed => {
                RsSendServerError::UploadAuthFailed
            }
            localsend::send_server::SendServerError::UnsupportedUploadAuth(e) => {
                RsSendServerError::UnsupportedUploadAuth(e)
            }
        }
    }
}
