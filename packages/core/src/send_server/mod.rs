use aes_gcm::aead::{Aead, KeyInit};
use aes_gcm::{Aes128Gcm, Key, Nonce};
use base64::engine::general_purpose::URL_SAFE_NO_PAD;
use base64::Engine;
use bytes::{Bytes, BytesMut};
use futures_util::{SinkExt, StreamExt};
use hkdf::Hkdf;
use hmac::{Hmac, Mac};
use rand::Rng;
use serde::{Deserialize, Serialize};
use sha2_010::Sha256;
use tokio::sync::mpsc;
use tokio_tungstenite::connect_async;
use tokio_tungstenite::tungstenite::Message;
use tokio_util::sync::CancellationToken;

use crate::model::transfer::FileContent;

const ECE_RECORD_SIZE: usize = 64 * 1024;
const ECE_TAG_SIZE: usize = 16;
const ECE_DELIMITER_SIZE: usize = 1;
const ECE_HEADER_SIZE: usize = 21;
const ECE_PLAIN_RECORD_SIZE: usize = ECE_RECORD_SIZE - ECE_TAG_SIZE - ECE_DELIMITER_SIZE;
const SECRET_KEY_SIZE: usize = 16;
const AUTH_KEY_SIZE: usize = 64;
const NONCE_SIZE: usize = 12;

type HmacSha256 = Hmac<Sha256>;

pub struct SendServerFile {
    pub name: String,
    pub size: u64,
    pub mime: Option<String>,
    pub content: FileContent,
}

pub struct SendServerUploadOptions {
    pub server_url: String,
    pub password: Option<String>,
    pub download_limit: u64,
    pub expire_seconds: u64,
}

pub struct SendServerUploadResult {
    pub id: String,
    pub url: String,
    pub password: Option<String>,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct SendServerConfig {
    #[serde(rename = "LIMITS")]
    pub limits: SendServerLimits,
    #[serde(rename = "DEFAULTS")]
    pub defaults: SendServerDefaults,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct SendServerLimits {
    #[serde(rename = "ANON")]
    pub anon: SendServerAnonLimits,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct SendServerAnonLimits {
    #[serde(rename = "MAX_FILE_SIZE")]
    pub max_file_size: u64,
    #[serde(rename = "MAX_DOWNLOADS")]
    pub max_downloads: u64,
    #[serde(rename = "MAX_EXPIRE_SECONDS")]
    pub max_expire_seconds: u64,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct SendServerDefaults {
    #[serde(rename = "DOWNLOAD_COUNTS")]
    pub download_counts: Vec<u64>,
    #[serde(rename = "EXPIRE_TIMES_SECONDS")]
    pub expire_times_seconds: Vec<u64>,
    #[serde(rename = "EXPIRE_SECONDS")]
    pub expire_seconds: u64,
}

#[derive(thiserror::Error, Debug)]
pub enum SendServerError {
    #[error("Invalid Send Server URL")]
    InvalidUrl,
    #[error("Send Server returned HTTP {status}")]
    Status { status: u16 },
    #[error("Send Server response was invalid: {0}")]
    InvalidResponse(String),
    #[error("Network error: {0}")]
    Network(String),
    #[error("I/O error: {0}")]
    Io(#[from] std::io::Error),
    #[error("Upload cancelled")]
    Cancelled,
    #[error("Crypto error")]
    Crypto,
}

pub async fn fetch_config(server_url: &str) -> Result<SendServerConfig, SendServerError> {
    let url = api_url(server_url, "config")?;
    let response = http_client()?
        .get(url)
        .send()
        .await
        .map_err(|e| SendServerError::Network(e.to_string()))?;
    if !response.status().is_success() {
        return Err(SendServerError::Status {
            status: response.status().as_u16(),
        });
    }
    response
        .json()
        .await
        .map_err(|e| SendServerError::InvalidResponse(e.to_string()))
}

pub async fn upload<F>(
    files: Vec<SendServerFile>,
    options: SendServerUploadOptions,
    mut on_progress: F,
    cancel_token: CancellationToken,
) -> Result<SendServerUploadResult, SendServerError>
where
    F: FnMut(u64, u64),
{
    if cancel_token.is_cancelled() {
        return Err(SendServerError::Cancelled);
    }

    let total_size = files.iter().map(|f| f.size).sum();
    let metadata = SendMetadata::from_files(&files);
    let keychain = Keychain::new();
    let encrypted_metadata = keychain.encrypt_metadata(&metadata)?;
    let auth_key = keychain.auth_key()?;
    let authorization = format!("send-v1 {}", b64(&auth_key));

    let (tx, rx) = mpsc::channel::<Result<Bytes, SendServerError>>(16);
    let encrypt_cancel = cancel_token.clone();
    tokio::spawn(async move {
        encrypt_files(files, keychain.raw_secret, tx, encrypt_cancel).await;
    });

    let upload_info = upload_ws(
        &options.server_url,
        encrypted_metadata,
        authorization,
        options.expire_seconds,
        options.download_limit,
        encrypted_size(total_size),
        rx,
        &mut on_progress,
        cancel_token.clone(),
    )
    .await?;

    let url = format!("{}#{}", upload_info.url, b64(&keychain.raw_secret));
    if let Some(password) = options.password.as_ref().filter(|p| !p.is_empty()) {
        set_password(
            &options.server_url,
            &upload_info.id,
            &upload_info.owner_token,
            &url,
            password,
        )
        .await?;
    }

    Ok(SendServerUploadResult {
        id: upload_info.id,
        url,
        password: options.password.filter(|p| !p.is_empty()),
    })
}

async fn upload_ws<F>(
    server_url: &str,
    encrypted_metadata: Vec<u8>,
    authorization: String,
    expire_seconds: u64,
    download_limit: u64,
    total_encrypted_size: u64,
    mut rx: mpsc::Receiver<Result<Bytes, SendServerError>>,
    on_progress: &mut F,
    cancel_token: CancellationToken,
) -> Result<UploadInfo, SendServerError>
where
    F: FnMut(u64, u64),
{
    let ws_url = ws_url(server_url)?;
    install_tls_provider();
    let (mut ws, _) = connect_async(ws_url.as_str())
        .await
        .map_err(|e| SendServerError::Network(e.to_string()))?;

    let init = serde_json::json!({
        "fileMetadata": b64(&encrypted_metadata),
        "authorization": authorization,
        "timeLimit": expire_seconds,
        "dlimit": download_limit,
    });
    ws.send(Message::Text(init.to_string().into()))
        .await
        .map_err(|e| SendServerError::Network(e.to_string()))?;

    let upload_info = read_upload_info(&mut ws).await?;
    let mut sent = 0_u64;
    on_progress(sent, total_encrypted_size);

    loop {
        tokio::select! {
            _ = cancel_token.cancelled() => return Err(SendServerError::Cancelled),
            chunk = rx.recv() => {
                match chunk {
                    Some(Ok(chunk)) => {
                        sent += chunk.len() as u64;
                        ws.send(Message::Binary(chunk)).await.map_err(|e| SendServerError::Network(e.to_string()))?;
                        on_progress(sent.min(total_encrypted_size), total_encrypted_size);
                    }
                    Some(Err(e)) => return Err(e),
                    None => break,
                }
            }
        }
    }

    ws.send(Message::Binary(Bytes::from_static(&[0])))
        .await
        .map_err(|e| SendServerError::Network(e.to_string()))?;
    read_completion(&mut ws).await?;
    Ok(upload_info)
}

async fn read_upload_info<S>(ws: &mut S) -> Result<UploadInfo, SendServerError>
where
    S: StreamExt<Item = Result<Message, tokio_tungstenite::tungstenite::Error>> + Unpin,
{
    let message = ws
        .next()
        .await
        .ok_or_else(|| {
            SendServerError::InvalidResponse("WebSocket closed before upload info".into())
        })?
        .map_err(|e| SendServerError::Network(e.to_string()))?;
    let text = message
        .to_text()
        .map_err(|e| SendServerError::InvalidResponse(e.to_string()))?;
    let info: UploadInfoWire =
        serde_json::from_str(text).map_err(|e| SendServerError::InvalidResponse(e.to_string()))?;
    if let Some(error) = info.error {
        return Err(SendServerError::InvalidResponse(error));
    }
    Ok(UploadInfo {
        id: info
            .id
            .ok_or_else(|| SendServerError::InvalidResponse("missing id".into()))?,
        url: info
            .url
            .ok_or_else(|| SendServerError::InvalidResponse("missing url".into()))?,
        owner_token: info
            .owner_token
            .ok_or_else(|| SendServerError::InvalidResponse("missing ownerToken".into()))?,
    })
}

async fn read_completion<S>(ws: &mut S) -> Result<(), SendServerError>
where
    S: StreamExt<Item = Result<Message, tokio_tungstenite::tungstenite::Error>> + Unpin,
{
    let message = ws
        .next()
        .await
        .ok_or_else(|| {
            SendServerError::InvalidResponse("WebSocket closed before completion".into())
        })?
        .map_err(|e| SendServerError::Network(e.to_string()))?;
    let text = message
        .to_text()
        .map_err(|e| SendServerError::InvalidResponse(e.to_string()))?;
    if text.trim().is_empty() || text.trim() == "{}" {
        return Ok(());
    }
    let value: serde_json::Value =
        serde_json::from_str(text).map_err(|e| SendServerError::InvalidResponse(e.to_string()))?;
    if let Some(error) = value.get("error").and_then(|v| v.as_str()) {
        return Err(SendServerError::InvalidResponse(error.to_string()));
    }
    Ok(())
}

async fn set_password(
    server_url: &str,
    id: &str,
    owner_token: &str,
    share_url: &str,
    password: &str,
) -> Result<(), SendServerError> {
    let auth = password_auth_key(password, share_url);
    let response = http_client()?
        .post(api_url(server_url, &format!("api/password/{id}"))?)
        .json(&serde_json::json!({
            "owner_token": owner_token,
            "auth": b64(&auth),
        }))
        .send()
        .await
        .map_err(|e| SendServerError::Network(e.to_string()))?;
    if response.status().is_success() {
        Ok(())
    } else {
        Err(SendServerError::Status {
            status: response.status().as_u16(),
        })
    }
}

fn http_client() -> Result<reqwest::Client, SendServerError> {
    reqwest::Client::builder()
        .tls_backend_preconfigured(send_server_tls_config())
        .build()
        .map_err(|e| SendServerError::Network(e.to_string()))
}

fn send_server_tls_config() -> rustls::ClientConfig {
    install_tls_provider();
    let mut root_store = rustls::RootCertStore::empty();
    root_store.extend(webpki_roots::TLS_SERVER_ROOTS.iter().cloned());
    rustls::ClientConfig::builder()
        .with_root_certificates(root_store)
        .with_no_client_auth()
}

fn install_tls_provider() {
    let _ = rustls::crypto::ring::default_provider().install_default();
}

async fn encrypt_files(
    files: Vec<SendServerFile>,
    secret_key: [u8; SECRET_KEY_SIZE],
    tx: mpsc::Sender<Result<Bytes, SendServerError>>,
    cancel_token: CancellationToken,
) {
    let result = encrypt_files_inner(files, secret_key, tx.clone(), cancel_token).await;
    if let Err(e) = result {
        let _ = tx.send(Err(e)).await;
    }
}

async fn encrypt_files_inner(
    files: Vec<SendServerFile>,
    secret_key: [u8; SECRET_KEY_SIZE],
    tx: mpsc::Sender<Result<Bytes, SendServerError>>,
    cancel_token: CancellationToken,
) -> Result<(), SendServerError> {
    let salt = random_array::<SECRET_KEY_SIZE>();
    tx.send(Ok(Bytes::from(ece_header(&salt))))
        .await
        .map_err(|_| SendServerError::Cancelled)?;

    let key = hkdf_expand(
        &secret_key,
        &salt,
        b"Content-Encoding: aes128gcm\0",
        SECRET_KEY_SIZE,
    )?;
    let nonce_base = hkdf_expand(
        &secret_key,
        &salt,
        b"Content-Encoding: nonce\0",
        SECRET_KEY_SIZE,
    )?;
    let cipher = Aes128Gcm::new(Key::<Aes128Gcm>::from_slice(&key));
    let mut seq = 0_u32;
    let mut pending = BytesMut::with_capacity(ECE_PLAIN_RECORD_SIZE);

    for file in files {
        let mut rx = file.content.into_receiver();
        while let Some(chunk) = rx.recv().await {
            if cancel_token.is_cancelled() {
                return Err(SendServerError::Cancelled);
            }

            let mut offset = 0;
            while offset < chunk.len() {
                let take = (ECE_PLAIN_RECORD_SIZE - pending.len()).min(chunk.len() - offset);
                pending.extend_from_slice(&chunk[offset..offset + take]);
                offset += take;
                if pending.len() == ECE_PLAIN_RECORD_SIZE {
                    let record = encrypt_record(&cipher, &nonce_base, &pending, seq, false)?;
                    seq = seq.checked_add(1).ok_or(SendServerError::Crypto)?;
                    tx.send(Ok(record.into()))
                        .await
                        .map_err(|_| SendServerError::Cancelled)?;
                    pending.clear();
                }
            }
        }
    }

    if !pending.is_empty() {
        let record = encrypt_record(&cipher, &nonce_base, &pending, seq, true)?;
        tx.send(Ok(record.into()))
            .await
            .map_err(|_| SendServerError::Cancelled)?;
    }
    Ok(())
}

fn encrypt_record(
    cipher: &Aes128Gcm,
    nonce_base: &[u8],
    data: &[u8],
    seq: u32,
    last: bool,
) -> Result<Vec<u8>, SendServerError> {
    let mut padded = Vec::with_capacity(if last {
        data.len() + 1
    } else {
        ECE_RECORD_SIZE - ECE_TAG_SIZE
    });
    padded.extend_from_slice(data);
    if last {
        padded.push(2);
    } else {
        padded.resize(ECE_RECORD_SIZE - ECE_TAG_SIZE, 0);
        padded[data.len()] = 1;
    }
    cipher
        .encrypt(
            Nonce::from_slice(&nonce(nonce_base, seq)),
            padded.as_slice(),
        )
        .map_err(|_| SendServerError::Crypto)
}

fn encrypted_size(size: u64) -> u64 {
    if size == 0 {
        ECE_HEADER_SIZE as u64
    } else {
        ECE_HEADER_SIZE as u64
            + size
            + (ECE_TAG_SIZE as u64 + ECE_DELIMITER_SIZE as u64)
                * size.div_ceil(ECE_PLAIN_RECORD_SIZE as u64)
    }
}

fn ece_header(salt: &[u8; SECRET_KEY_SIZE]) -> Vec<u8> {
    let mut header = Vec::with_capacity(ECE_HEADER_SIZE);
    header.extend_from_slice(salt);
    header.extend_from_slice(&(ECE_RECORD_SIZE as u32).to_be_bytes());
    header.push(0);
    header
}

fn nonce(base: &[u8], seq: u32) -> [u8; NONCE_SIZE] {
    let mut nonce = [0; NONCE_SIZE];
    nonce.copy_from_slice(&base[..NONCE_SIZE]);
    let seq_bytes = seq.to_be_bytes();
    for i in 0..4 {
        nonce[NONCE_SIZE - 4 + i] ^= seq_bytes[i];
    }
    nonce
}

fn hmac_sha256(key: &[u8], value: &[u8]) -> Vec<u8> {
    let mut mac = <HmacSha256 as Mac>::new_from_slice(key).expect("HMAC accepts any key length");
    mac.update(value);
    mac.finalize().into_bytes().to_vec()
}

fn password_auth_key(password: &str, share_url: &str) -> Vec<u8> {
    let mut output = [0_u8; AUTH_KEY_SIZE];
    pbkdf2_hmac_sha256(password.as_bytes(), share_url.as_bytes(), 100, &mut output);
    output.to_vec()
}

fn pbkdf2_hmac_sha256(password: &[u8], salt: &[u8], iterations: u32, output: &mut [u8]) {
    let mut block_index = 1_u32;
    let mut offset = 0;
    while offset < output.len() {
        let mut input = Vec::with_capacity(salt.len() + 4);
        input.extend_from_slice(salt);
        input.extend_from_slice(&block_index.to_be_bytes());

        let mut u = hmac_sha256(password, &input);
        let mut block = u.clone();
        for _ in 1..iterations {
            u = hmac_sha256(password, &u);
            for (left, right) in block.iter_mut().zip(&u) {
                *left ^= right;
            }
        }

        let len = block.len().min(output.len() - offset);
        output[offset..offset + len].copy_from_slice(&block[..len]);
        offset += len;
        block_index += 1;
    }
}

fn hkdf_expand(
    secret: &[u8],
    salt: &[u8],
    info: &[u8],
    len: usize,
) -> Result<Vec<u8>, SendServerError> {
    let hk = Hkdf::<Sha256>::new(Some(salt), secret);
    let mut out = vec![0_u8; len];
    hk.expand(info, &mut out)
        .map_err(|_| SendServerError::Crypto)?;
    Ok(out)
}

fn random_array<const N: usize>() -> [u8; N] {
    let mut value = [0; N];
    rand::rng().fill_bytes(&mut value);
    value
}

fn b64(value: &[u8]) -> String {
    URL_SAFE_NO_PAD.encode(value)
}

fn api_url(server_url: &str, path: &str) -> Result<reqwest::Url, SendServerError> {
    let base = reqwest::Url::parse(server_url).map_err(|_| SendServerError::InvalidUrl)?;
    base.join(path).map_err(|_| SendServerError::InvalidUrl)
}

fn ws_url(server_url: &str) -> Result<reqwest::Url, SendServerError> {
    let mut url = api_url(server_url, "api/ws")?;
    match url.scheme() {
        "https" => url
            .set_scheme("wss")
            .map_err(|_| SendServerError::InvalidUrl)?,
        "http" => url
            .set_scheme("ws")
            .map_err(|_| SendServerError::InvalidUrl)?,
        _ => return Err(SendServerError::InvalidUrl),
    }
    Ok(url)
}

struct Keychain {
    raw_secret: [u8; SECRET_KEY_SIZE],
}

impl Keychain {
    fn new() -> Self {
        Self {
            raw_secret: random_array(),
        }
    }

    fn auth_key(&self) -> Result<Vec<u8>, SendServerError> {
        hkdf_expand(&self.raw_secret, &[], b"authentication", AUTH_KEY_SIZE)
    }

    fn metadata_key(&self) -> Result<Vec<u8>, SendServerError> {
        hkdf_expand(&self.raw_secret, &[], b"metadata", SECRET_KEY_SIZE)
    }

    fn encrypt_metadata(&self, metadata: &SendMetadata) -> Result<Vec<u8>, SendServerError> {
        let key = self.metadata_key()?;
        let cipher = Aes128Gcm::new(Key::<Aes128Gcm>::from_slice(&key));
        let plain = serde_json::to_vec(metadata)
            .map_err(|e| SendServerError::InvalidResponse(e.to_string()))?;
        cipher
            .encrypt(Nonce::from_slice(&[0_u8; NONCE_SIZE]), plain.as_slice())
            .map_err(|_| SendServerError::Crypto)
    }
}

#[derive(Serialize)]
struct SendMetadata {
    name: String,
    size: u64,
    #[serde(rename = "type")]
    mime: String,
    manifest: SendManifest,
}

impl SendMetadata {
    fn from_files(files: &[SendServerFile]) -> Self {
        let manifest = SendManifest {
            files: files
                .iter()
                .map(|file| SendManifestFile {
                    name: file.name.clone(),
                    size: file.size,
                    mime: file
                        .mime
                        .clone()
                        .unwrap_or_else(|| "application/octet-stream".into()),
                })
                .collect(),
        };
        let single = files.len() == 1;
        let first = files.first();
        Self {
            name: if single {
                first
                    .map(|f| f.name.clone())
                    .unwrap_or_else(|| "LocalSend".into())
            } else {
                "Send-Archive.zip".into()
            },
            size: files.iter().map(|f| f.size).sum(),
            mime: if single {
                first
                    .and_then(|f| f.mime.clone())
                    .unwrap_or_else(|| "application/octet-stream".into())
            } else {
                "send-archive".into()
            },
            manifest,
        }
    }
}

#[derive(Serialize)]
struct SendManifest {
    files: Vec<SendManifestFile>,
}

#[derive(Serialize)]
struct SendManifestFile {
    name: String,
    size: u64,
    #[serde(rename = "type")]
    mime: String,
}

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
struct UploadInfo {
    id: String,
    url: String,
    owner_token: String,
}

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
struct UploadInfoWire {
    id: Option<String>,
    url: Option<String>,
    owner_token: Option<String>,
    #[serde(default)]
    error: Option<String>,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn ece_size_matches_send_formula() {
        assert_eq!(encrypted_size(0), 21);
        assert_eq!(encrypted_size(1), 39);
        assert_eq!(encrypted_size(ECE_PLAIN_RECORD_SIZE as u64), 65_557);
        assert_eq!(encrypted_size(ECE_PLAIN_RECORD_SIZE as u64 + 1), 65_575);
    }

    #[test]
    fn builds_urls() {
        assert_eq!(
            ws_url("https://exp.com/").unwrap().as_str(),
            "wss://exp.com/api/ws"
        );
        assert_eq!(
            api_url("https://exp.com/sub/", "config").unwrap().as_str(),
            "https://exp.com/sub/config"
        );
    }

    #[test]
    fn pbkdf2_hmac_sha256_matches_test_vector() {
        let mut output = [0_u8; 32];
        pbkdf2_hmac_sha256(b"password", b"salt", 1, &mut output);
        assert_eq!(
            output,
            [
                0x12, 0x0f, 0xb6, 0xcf, 0xfc, 0xf8, 0xb3, 0x2c, 0x43, 0xe7, 0x22, 0x52, 0x56, 0xc4,
                0xf8, 0x37, 0xa8, 0x65, 0x48, 0xc9, 0x2c, 0xcc, 0x35, 0x48, 0x08, 0x05, 0x98, 0x7c,
                0xb7, 0x0b, 0xe1, 0x7b,
            ],
        );
    }

    #[test]
    fn auth_key_matches_webcrypto_hmac_default_length() {
        assert_eq!(
            b64(&hkdf_expand(&[0_u8; SECRET_KEY_SIZE], &[], b"authentication", AUTH_KEY_SIZE).unwrap()),
            "Ri2P72hjthsX1R852ZSpbThTewluKCjaNtnosWt0c5KtdCp4OAQriXjXqi-1jxWmr83sFmLBUeHxZTNnBZ-3Dw",
        );
    }

    #[test]
    fn password_auth_key_matches_webcrypto_hmac_default_length() {
        assert_eq!(
            b64(&password_auth_key("password", "https://example.com/download/abc/#secret")),
            "rX7pVfeMVJg96aPEm6WdU8Se1pBO9l2PDYQnmR0D_sBqrxgdTt8OP7UMcVFewIXrZHQPaoZAG77B7ZFkd_fUhg",
        );
    }

    #[test]
    fn metadata_matches_single_and_multi_file_shape() {
        let files = vec![
            SendServerFile {
                name: "a.txt".into(),
                size: 3,
                mime: Some("text/plain".into()),
                content: FileContent::Path(std::path::PathBuf::from("a.txt")),
            },
            SendServerFile {
                name: "b.bin".into(),
                size: 4,
                mime: None,
                content: FileContent::Path(std::path::PathBuf::from("b.bin")),
            },
        ];
        let metadata = SendMetadata::from_files(&files);
        let value = serde_json::to_value(metadata).unwrap();
        assert_eq!(value["name"], "Send-Archive.zip");
        assert_eq!(value["type"], "send-archive");
        assert_eq!(value["manifest"]["files"][0]["name"], "a.txt");
        assert_eq!(
            value["manifest"]["files"][1]["type"],
            "application/octet-stream"
        );
    }
}
