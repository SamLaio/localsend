# AGENTS.md

LocalSend 不接受 AI 產生的貢獻，除非：

- 是 bug 修正，或
- 範圍非常小，或
- 你能證明自己具備相關領域的專業能力。

這份文件提供 LLM 在本 repository 中工作的規則與背景。

## 文件語言

- 本專案所有說明文件與慣例檔皆使用正體中文撰寫。
- 程式識別字、命令、路徑、錯誤訊息、上游連結、套件名稱與 API 名稱保留原文。
- 若修改使用者可見功能、設定、權限、建置方式或發版輸出，同步檢查 `README.md`、`CONTRIBUTING.md`、`support/docs/` 與 i18n source 是否需要更新。

## Repository 結構

這是一個多語言 monorepo：Flutter app 建在 Rust protocol 實作之上。

| 路徑 | 內容 |
|---|---|
| `app/` | Flutter app (`localsend_app`)。包含 UI、providers、persistence、platform channels。 |
| `packages/localsend_isolates/` | Dart isolate layer 與 `flutter_rust_bridge` (FRB) bindings。擁有 `rust/` (Flutter plugin crate `rust_lib_localsend_app`) 與 `rust_builder/` (cargokit)。 |
| `packages/core/` | Rust crate `localsend`：protocol、HTTP server/client、crypto、WebRTC。不依賴 Flutter。 |
| `packages/typed_isolates/` | 小型獨立 package，用 typed send/receive channels 包裝 Dart `Isolate`。 |
| `server/` | WebRTC 使用的 Axum WebSocket signaling server (`/v1/ws`)。獨立部署，見 `server/Dockerfile`。 |
| `cli/` | Rust CLI crate (`localsend-cli`)：建立在 `packages/core` 之上的互動式 terminal client (v2 HTTP + multicast)。 |
| `support/scripts/` | Release / packaging scripts，包含各平台 build、MSIX、Inno Setup 與 FOSS stripping。 |

四個 Rust crates (`packages/core`、`packages/localsend_isolates/rust`、`server`、`cli`) 組成一個以 repository root 為根的 Cargo workspace：共用同一份 `Cargo.lock` 與 `target/`，且 `[profile.*]` 設定只放在 root `Cargo.toml`。member profiles 會被忽略。Flutter build 時，Cargokit 仍會把 plugin crate 建到自己的 target 目錄。

三個 Dart packages (`app`、`packages/localsend_isolates`、`packages/typed_isolates`) 組成一個以 repository root 為根的 pub workspace：共用同一份 `pubspec.lock` 與 `.dart_tool/`，從任一 member 執行 `pub get` 都會解析。`rust_builder` 與 vendored `cargokit/build_tool` 刻意不是 workspace members，仍維持獨立解析。

Dependency direction: `app` -> `localsend_isolates` -> (`typed_isolates`, `rust_lib_localsend_app` -> `localsend` core)。
App **只**依賴 `localsend_isolates`，不要直接依賴 `flutter_rust_bridge`、`typed_isolates` 或 plugin crate。

## Flutter 版本

Flutter 版本固定在 `.fvmrc`，並同步 mirrored 到 `.github/workflows/ci.yml`、`app/pubspec.yaml` 與 `support/submodules/flutter` git submodule。請使用 **`fvm flutter` / `fvm dart`**，不要使用系統全域 toolchain。

若要升級 Flutter，四個位置都要更新；細節見 `CONTRIBUTING.md` 的「升級 Flutter」章節。

## 指令

除非另有說明，從 `app/` 執行。

```bash
fvm flutter pub get
fvm dart run build_runner build  # dart_mappable, freezed, flutter_gen, mockito
fvm dart run slang               # i18n codegen (slang_build_runner is disabled in build.yaml)
fvm flutter run
```

檢查項目，也就是 CI 執行的內容：

```bash
fvm dart format --set-exit-if-changed lib test   # CI deletes lib/gen first; generated code is not format-checked
fvm flutter analyze
fvm flutter test
fvm flutter test test/unit/util/security_helper_test.dart          # single file
fvm flutter test --plain-name 'some test name'                     # single test
```

格式設定是 **150 columns** (`analysis_options.yaml` 中的 `page_width: 150`，`trailing_commas: preserve`)。任何把 generated Dart 重新排成 80 columns 的工具都會製造純 diff noise；之後請用 `fvm dart format` 重新格式化。

Rust:

```bash
cargo test --features full       # in packages/core — see "Core crate features" below
cargo clippy --features full
cargo check                      # in packages/localsend_isolates/rust, server, cli
```

FRB codegen 從 `packages/localsend_isolates/` 執行：

```bash
flutter_rust_bridge_codegen generate    # config in flutter_rust_bridge.yaml (dart_format_line_length: 150)
```

Codegen 常會把 `app/test/mocks.mocks.dart` 改寫成 80 columns；如果它出現在 diff 中，請 revert 該檔。

`packages/localsend_isolates` 有自己的 `build.yaml`，其 models 改動時需要在該 package 跑自己的 `build_runner`。`pub get` 透過 pub workspace 共用。CI 另外會在 `packages/localsend_isolates/rust_builder/cargokit/build_tool` 執行 `flutter pub get`。

## Core crate 功能旗標

`packages/core` 幾乎所有內容都由 Cargo features 控制 (`crypto`、`http`、`multicast`、`webrtc`、`webrtc-signaling`、`full`)，且 `default = []`。**一律用 `--features full` build 與 test。** 裸 `cargo check` / `cargo build` 會失敗，因為 modules 無條件宣告，但 dependencies 是 optional。這是既有狀況，不是 regression。

## 架構

### State management

使用 Refena (`refena_flutter`)，不是 Riverpod。Providers 放在 `app/lib/provider/`；一般 state 使用 `NotifierProvider`，凡是 isolate layer 會碰到的內容使用 `ReduxProvider` 加 dispatched action classes。`app/lib/config/init.dart` (`preInit`) 是 bootstrap：初始化 logging、`RustLib.init()`、persistence、isolate container、tray/window，最後回傳 `main.dart` 掛載的 `RefenaContainer`。

Models 使用 `dart_mappable` (`@MappableClass`、`.mapper.dart` parts) 並改名 methods：`fromJson` / `toJson` 是 **Map** converters，`deserialize` / `serialize` 是 string converters。兩個 `build.yaml` 都有設定。Freezed 用在 FRB-adjacent unions。

### Isolates

重型 networking 不在 main isolate 執行。`packages/localsend_isolates/lib/src/isolate/`：

- `parent/parent_isolate_provider.dart`：`ParentIsolateState` 針對每個 child 持有一個 `IsolateConnector`，包含 http scan discovery、multicast discovery、http upload、http server，並持有 mirrored 到所有 children 的 `SyncState`。`IsolateSetupAction` 負責 spawn。
- `parent/actions.dart`、`parent/actions_sync.dart`：app 與 children 溝通的唯一支援方式。
- `child/*_isolate.dart`：child entry points，將 typed task messages 轉成 `lib/src/task/` calls。
- `lib/src/task/`：只能放 pure helpers；**禁止放 isolate logic**，見該目錄的 `README.md`。

Children 需要的 state，例如 alias、port、protocol、server 是否執行、web send 是否啟用，會透過 `IsolateSyncServerStateAction` 推送。Children 會在啟動時讀取 `syncState`，因此要先 sync **再**啟動 server。

### Networking (Rust)

HTTP server 與 client 是 Rust，不是 Dart。`packages/core/src/http/server/` 實作 protocol v2，v1 endpoints 不提供服務，並包含「web send」下載流程 (`server/web.rs`) 與 internal `show` endpoint，用來 foreground 已在執行的 instance。

Integration 以 channel 為主：`start_with_port` 接收 `ServerConfigV2 { pin, event_tx, web_send }`，並發出 `ServerEventV2` events (`Register`、帶有 `decision_tx` oneshot 的 `PrepareUpload`、帶有 byte stream 與 `result_tx` 的 `FileUpload`、`PrepareDownload`、`SessionEnd`、`PrepareUploadAborted`、`CancelReceived`)。同一時間只允許 **一個 upload session**；cancellation safety 由 drop guards (`PendingSessionGuard`、`UploadGuard`、`PendingWebSessionGuard`) 負責。Core 刻意沒有 `auto_accept`；app 若要 auto-accept，就是立刻回答 `decision_tx`。新的 server -> app 互動應擴充 `ServerEventV2`，不要另外加 side channels。

FRB layer (`packages/localsend_isolates/rust/src/api/server.rs`) 暴露 `start_server` 與 opaque `RsHttpServer`，其 `listen` 將 v2、web-send 與 internal channels 合併成單一 `RsServerEvent` stream；responder oneshots 保留在 Rust 端。Dart 端的 `child/server_isolate.dart` 會將它們轉成 `HttpServerEvent`，再由 `app/lib/provider/network/server/server_provider.dart` route 到 `ReceiveController` / `SendController`。這些是 **event handlers，不是 route handlers**。

Save targets 由 Dart 決定 (`prepareFileSaveTarget`)，Rust 負責寫入：可以是 path，或是 Android SAF file descriptor，後者透過 `com.samliao.localsend/localsend` method channel 取得。Gallery saves 會先寫進 cache file。

Server event `ip`s 是 `PeerIp` (IP + IPv6 scope)：link-local peer 會 render 成 `fe80::1%3`，HTTP client 可直接把它當 host 使用，因此 event ips 必須保持 dialable。

TLS 使用每台裝置即時產生的 certificates，且 **強制 client certificates**。Serving web pages 時可暫時 optional，讓瀏覽器可以連線。Peer identity 是 client cert DER 的 uppercase-hex SHA-256；如果 payload claimed fingerprint 與 cert 不一致，就不會 emit `Register`。優先使用 `event.certFingerprint ?? event.info.fingerprint`，payload fallback 只為 encryption-off mode 存在。

Receive pin 與 web-send pin 都在 server start 時固定，所以變更任一項都會 restart server。

瀏覽器下載頁的 web assets embedded from `packages/core/assets/web/`。

### Multicast discovery (Rust)

`packages/core/src/multicast/` (feature `multicast`，獨立於 `http`) 實作 protocol v2.2 的 UDP multicast discovery，不解析 v1 messages。

Integration 與 HTTP server 類似：`multicast::start` 接收 `MulticastConfig { group, group_v6, port, interface_filter, device, event_tx }`，並發出 `MulticastEvent::Discovered { ip, message }`；回傳的 `MulticastHandle` 提供 `announce` (announcement burst) 與 `wait_stopped`。

UDP 只用於 **announce**：回應會透過 HTTP，以 unicast register request 回到發出 announcement 的裝置。

每個 interface IPv4 address 都 bind 一個 socket (`SO_REUSEPORT` / `SO_REUSEADDR` + `IP_MULTICAST_IF`)，因為單一 socket 只能在一個 interface 上發送。Multicast loopback 保持啟用，讓同一台 host 上的多個 instances 看得到彼此；自己的 messages 會用 fingerprint 丟棄。IPv6 是 LocalSend extension (group `ff12::fd3a:e420`、`DEFAULT_MULTICAST_GROUP_V6`)，設定 `group_v6` 即啟用：每個 interface 一個 `IPV6_V6ONLY` socket，並以 interface index join。`Discovered` 會帶 source 的 scope ID (interface index)，link-local IPv6 sources 需要它才能用 HTTP 回應。

### i18n

使用 Slang，source files 位於 `app/assets/i18n/` (`<locale>.json` 加 `_missing_translations_<locale>.json`)，generated output 位於 `app/lib/gen/`。Translations 由 Weblate 管理；以 `@` 開頭的 fields 是給譯者看的 metadata，不會被 app 使用。`app/test/unit/i18n_test.dart` 負責保護 locale set。

### FOSS build

F-Droid 會透過 `support/scripts/remove_proprietary_dependencies.sh` 移除 `in_app_purchase` 與 donation UI。這個 script 依賴 `# [FOSS_REMOVE]` pubspec marker，以及 `// [FOSS_REMOVE_START]` / `// [FOSS_REMOVE_END]` comment pairs。修改 `lib/config/init.dart`、`lib/pages/donation/*` 或 `lib/provider/purchase_provider.dart` 時必須保留這些 markers。

## Release notes

`app/pubspec.yaml` 的 version 必須與 `support/scripts/compile_windows_exe-inno.iss` 中的 `#define MyAppVersion`、以及 `cli/Cargo.toml` 中的 `version` 一致。CLI 啟動 banner 會印出這個版本。版本不一致時 CI 會失敗。各平台 build commands 與 release steps 記錄在 `README.md` 的「建置」與 `CONTRIBUTING.md` 的「Release」。

## SamLaio Fork 規則

本 fork 會加入「上傳至 Send Server」功能。先看 `support/docs/send-server-upload-plan.md`，再改相關程式。

### 專案定位

- 這仍是 LocalSend fork：原本的區網 P2P 傳檔、web share、WebRTC、CLI 與 server 不應被 Send Server 功能破壞。
- Send Server 功能是另一個傳送目標，不是取代 `SendMode.link`。`SendMode.link` 仍代表本機開 web server 讓瀏覽器下載。
- 預設 Send Server URL 為 `https://exp.com/`，但必須可在設定中修改。
- Send Server 上傳密碼是 server 層級權限密碼，與 Send Server URL 一起放在設定頁；上傳 dialog 只處理每次分享的下載密碼、下載次數與存活時間。
- Send Server 上傳涉及 client-side encryption、密碼派生、WebSocket 上傳與分享連結；這是安全敏感流程，避免在 log、錯誤訊息、crash report 或 commit message 中暴露密碼、owner token、secret key 或完整私密連結。

### Send Server 功能架構

- UI 入口優先放在 `app/lib/pages/tabs/send_tab.dart` 與 `app/lib/pages/tabs/send_tab_vm.dart`：在傳送目標區加入固定項目 `上傳至 Send Server`。
- 設定儲存優先沿用 `persistence_provider.dart`、`settings_provider.dart`、`settings_state.dart` 的既有模式。
- 上傳前必須先讀取 `${sendServerUrl}/config`，再依 server 回傳限制顯示密碼、下載次數與存活時間選項。
- 不要把 Send Server 上傳塞進現有 P2P `send_provider` 的 peer session 流程。新增獨立 provider/service，讓原本附近裝置傳送邏輯保持單純。
- 大檔加密與 WebSocket 上傳不要跑在 Flutter UI thread。優先放到 `packages/core` / `packages/localsend_isolates` 的既有 Rust isolate 路徑。
- 第一版只做單一 server、匿名上傳、密碼可選、下載次數、存活時間、進度、結果連結顯示與複製/分享。歷史紀錄、遠端刪除、多 server profile、背景續傳等先不要做。

### 驗證

一般 Dart / Flutter 修改後優先跑：

```powershell
cd app
fvm flutter pub get
fvm dart format --set-exit-if-changed lib test
fvm flutter analyze
fvm flutter test
```

改到 generated model、freezed、dart_mappable、mock 或 i18n 時，先依需要跑：

```powershell
cd app
fvm dart run build_runner build -d
fvm dart run slang
```

改到 Rust core、HTTP client/server、Send Server uploader、WebSocket 或加密流程時，至少跑：

```powershell
cargo test --features full
cargo clippy --features full
```

Android 發行相關檢查：

```powershell
cd app
fvm flutter build apk
```

若直接使用 Android Gradle：

```powershell
cd app/android
.\gradlew.bat assembleRelease
```

`assembleRelease` 會在建置後複製 APK 到：

```text
release/[版本]/release.apk
```

若目前 Gradle task 尚未實作這個複製動作，發版前先補上 task 或以最小 release script 完成同等輸出；不要只把 APK 留在 `app/build/outputs/apk/`。

SamLaio fork 發版產物優先使用單一 release 腳本：

```powershell
.\support\scripts\compile_release_apk_exe.ps1 -ReleaseVersion '1.18.2_re_2'
```

此腳本會產生 Android 11+ arm64 release APK 與 Windows 10+ x64 portable ZIP：

```text
release/[版本]/release.apk
release/[版本]/release.zip
```

Android 簽章預設會 dot-source：

```text
D:\project\apkKey\localsend.local.ps1
```

該檔必須只存在本機，不可提交。只建單一平台時可使用：

```powershell
.\support\scripts\compile_release_apk_exe.ps1 -ReleaseVersion '1.18.2_re_2' -SkipWindows
.\support\scripts\compile_release_apk_exe.ps1 -ReleaseVersion '1.18.2_re_2' -SkipAndroid
```

## Commit 前檢查

每次 commit 前都要做：

1. 確認改動符合 `AGENTS.md` 與 `support/docs/send-server-upload-plan.md`。
2. 檢查程式行為是否與 `README.md`、`CONTRIBUTING.md`、`support/docs/`、i18n source 與交接檔案相符。
3. 若改到使用者可見功能、設定、權限、建置版本、release 產物或資料保存行為，更新相關文件。
4. 評估是否需要調整 `app/pubspec.yaml` 版本，並確認 CLI / Windows Inno / Cargo lock 等版本同步規則仍成立。
5. 執行可用的最小驗證；若無法執行，在回覆或 commit message 中說明原因。
6. 不要 stage 或 commit 使用者未要求處理的無關改動。
7. 不要提交 secret、Send password、owner token、完整含 fragment 的私密分享連結、`local.properties`、`key.properties`、keystore、APK、AAB 或 build cache。

## Push 前檢查

每次 push 前都要做：

1. 確認已完成 Commit 前檢查。
2. 執行本次改動需要的 Flutter / Dart / Rust / Android 最小驗證流程。
3. 若本次 push 包含使用者可見變更，確認版本號是否需要先調整。
4. 在 `release/[版本]/` 產生 release 說明：

```text
release/[版本]/release-notes.md
```

5. 若已建置 APK，確認 APK 固定放在：

```text
release/[版本]/release.apk
```

6. 若已建置 Windows portable ZIP，確認 Windows 10+ x64 bundle 固定放在：

```text
release/[版本]/release.zip
```

7. 確認 APK / Windows ZIP 版本與 `app/pubspec.yaml` 的 `version`、release 資料夾版本、release notes 版本一致。
8. 不要 push APK、AAB、ZIP、EXE、keystore、`local.properties`、`key.properties`、build cache 或其他本機產物。

## Release 前檢查

每次 release 前都要做：

1. 確認 `release/[版本]/release-notes.md` 已存在且內容為本次版本。
2. 確認 `release/[版本]/release.apk` 已存在。
3. 確認 release APK 是目前程式最新版建置出來的檔案。
4. 確認 APK 版本與 `app/pubspec.yaml` 的 `version` 一致。
5. 確認 Android SDK、minSdk、targetSdk、簽章、權限與語系資訊符合本次 release。
6. 若本次 release 包含 Windows portable ZIP，確認 `release/[版本]/release.zip` 已存在，且 ZIP 內包含 `release.exe`、必要 DLL 與 `data/`；若另產 installer，確認 `release/[版本]/release-installer.exe` 限制 Windows 10+ / x64。
7. 若 Send Server 功能有變更，用設定的 Send Server 或測試 Send Server 驗證無密碼與有密碼下載流程。
8. 發布 GitHub release 時，把 `release/[版本]/release-notes.md` 內容放到 release description。
9. 發布 GitHub release 時，把 `release/[版本]/release.apk` 與需要的 Windows ZIP / EXE 產物一併附上去。

## Release 輸出慣例

- APK 固定路徑：

```text
release/[版本]/release.apk
```

- Windows 10+ x64 portable ZIP 固定路徑：

```text
release/[版本]/release.zip
```

Windows `release.zip` 內的 `release.exe` 是 portable bundle 的 executable，必須與 ZIP 內的 DLL 與 `data/` 一起散布；安裝版若需要則輸出為：

```text
release/[版本]/release-installer.exe
```

- release 說明固定路徑：

```text
release/[版本]/release-notes.md
```

- `release/` 是本機發版輸出資料夾，不進版本庫。
