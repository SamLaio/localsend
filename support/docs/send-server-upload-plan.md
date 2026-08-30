# Send Server 上傳方案

本文記錄 SamLaio/localsend fork 預計加入的 Send Server 上傳流程。目標是保留 LocalSend 原本的區網傳檔能力，另外新增一個可上傳到自架 Send Server 的目標。

## 目標流程

1. 使用者在 LocalSend 選取檔案、資料夾、媒體、文字或剪貼簿內容。
2. 在傳送目標區多一個固定項目：`上傳至 Send Server`。
3. 點選後開啟上傳設定頁或 dialog。
4. App 先讀取已設定的 Send Server URL，預設為 `https://exp.com/`。
5. App 呼叫 `GET /config` 取得伺服器限制。
6. 使用者在上傳前設定：
   - 密碼：可留空，也可自動產生。
   - 存活次數：從 `DEFAULTS.DOWNLOAD_COUNTS` 選擇，並不得超過 `LIMITS.ANON.MAX_DOWNLOADS`。
   - 存活時間：從 `DEFAULTS.EXPIRE_TIMES_SECONDS` 選擇，並不得超過 `LIMITS.ANON.MAX_EXPIRE_SECONDS`。
7. App 檢查選取內容總大小不得超過 `LIMITS.ANON.MAX_FILE_SIZE`。
8. App 自動加密並上傳到 Send Server。
9. 上傳完成後顯示實際取得的下載連結與密碼。
10. 使用者可複製或用系統分享功能分享文字。

## 設定

新增一個持久設定：

```text
sendServerUrl = https://exp.com/
```

建議放在 Settings > Send 區塊。第一版只需要單一 URL，不做多 server profile。

涉及檔案：

```text
app/lib/provider/persistence_provider.dart
app/lib/provider/settings_provider.dart
app/lib/model/state/settings_state.dart
app/lib/pages/tabs/settings_tab.dart
app/assets/i18n/en.json
app/assets/i18n/zh-TW.json
```

若新增 mapper 欄位，記得執行 codegen。

## UI 接點

不要把 Send Server 上傳混入附近裝置 discovery。最小可維護做法是在 Send tab 的目標區上方新增一個固定 tile：

```text
上傳至 Send Server
```

建議入口放在：

```text
app/lib/pages/tabs/send_tab.dart
app/lib/pages/tabs/send_tab_vm.dart
```

點擊後：

1. 若尚未選檔，沿用現有 `AddFileDialog.open(...)`。
2. 若仍沒有選檔，直接返回。
3. 開啟 `SendServerUploadOptionsDialog` 或 `SendServerUploadPage`。

## 上傳前選項頁

新增頁面或 dialog：

```text
app/lib/pages/send_server_upload_page.dart
```

或：

```text
app/lib/widget/dialogs/send_server_upload_options_dialog.dart
```

頁面責任：

- 顯示目前 Send Server URL。
- 呼叫 `/config` 載入限制。
- 顯示選取檔案總數與總大小。
- 提供密碼、下載次數、過期時間欄位。
- 檢查大小與限制。
- 觸發上傳。

## Send Server Client

新增一個獨立 uploader，不要塞進現有 P2P `send_provider`。

建議名稱：

```text
app/lib/provider/send_server/send_server_upload_provider.dart
app/lib/model/state/send_server/send_server_upload_state.dart
```

加密與 WebSocket 上傳應放在 isolate 或 Rust core，避免大檔處理卡住 Flutter UI thread。

建議新增到：

```text
packages/core/src/send_server/
packages/localsend_isolates/rust/src/api/send_server.rs
packages/localsend_isolates/lib/src/task/send_server_upload/
```

第一版只做最小功能：

- 單一 Send Server URL。
- 匿名上傳。
- 檔案與多檔上傳。
- 密碼可選。
- 存活次數可選。
- 存活時間可選。
- 進度回報。
- 完成後回傳下載連結與密碼。

先不做：

- 上傳歷史紀錄。
- 遠端刪除管理。
- 多 Send Server profile。
- 背景續傳。
- 登入帳號或 bearer token。

## Send 相容流程

Send Server 上傳不是一般 multipart upload。必須相容 Firefox Send 的 client-side encryption 流程：

1. 產生 16-byte `secretKey`。
2. 使用 HKDF SHA-256 從 `secretKey` 派生：
   - metadata AES-GCM key
   - request authentication HMAC-SHA256 key
   - ECE file encryption key stream
3. metadata 以 AES-GCM 加密，IV 為 12 bytes zero。
4. 檔案內容以 ECE `aes128gcm` record stream 加密。
5. 連線到：

```text
wss://exp.com/api/ws
```

6. 第一個 WebSocket message 傳 JSON：

```json
{
  "fileMetadata": "...",
  "authorization": "send-v1 ...",
  "timeLimit": 300,
  "dlimit": 1
}
```

7. 後續傳加密後的檔案 chunks。
8. 結尾傳單一 byte `0x00` 作 EOF。
9. Server 先回：

```json
{
  "url": "https://exp.com/download/<id>/",
  "ownerToken": "...",
  "id": "..."
}
```

10. App 組合實際分享連結：

```text
https://exp.com/download/<id>/#<secretKeyBase64Url>
```

## 密碼流程

Send 的密碼不是 URL query，也不是明文存在 server。若使用者設定密碼：

1. 以上一步的完整分享連結當 salt。
2. 使用 PBKDF2 SHA-256 從密碼派生新的 HMAC key。
3. 呼叫：

```text
POST /api/password/<id>
```

body：

```json
{
  "owner_token": "...",
  "auth": "<passwordDerivedAuthKeyBase64Url>"
}
```

4. 完成後結果頁顯示下載連結與密碼。

分享文字建議格式：

```text
下載連結：
<url>

密碼：
<password>
```

安全提醒：密碼與連結一起分享很方便，但安全性低於分開分享；第一版可照需求一起顯示，之後再加一鍵分開分享。

## 驗證重點

- `/config` 讀取失敗時顯示可理解錯誤。
- 大小超過限制時不上傳。
- 存活次數與時間不得超過 server 限制。
- 無密碼上傳後能下載。
- 有密碼上傳後，錯密碼不能下載，正密碼能下載。
- 多檔上傳下載後檔名、大小與內容正確。
- 上傳取消時 WebSocket 關閉且 UI 回到可操作狀態。
- Android 大檔上傳期間不要卡 UI。

## 推薦第一階段切法

第一階段只做 Android 可用：

1. 設定頁新增 Send Server URL。
2. Send tab 新增 `上傳至 Send Server` 入口。
3. 上傳前 dialog 讀 `/config` 並選限制。
4. 實作相容 Send 的 Rust uploader。
5. 完成頁顯示連結與密碼，支援複製。

完成後再考慮桌面平台、背景通知與歷史紀錄。
