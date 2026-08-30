# LocalSend

[![CI status][ci-badge]][ci-workflow]
[![Translations][translate-badge]][translate-link]
[![Packaging status][packaging-badge]][packaging-link]

[ci-badge]: https://github.com/localsend/localsend/actions/workflows/ci.yml/badge.svg
[ci-workflow]: https://github.com/localsend/localsend/actions/workflows/ci.yml
[translate-badge]: https://hosted.weblate.org/widget/localsend/app/svg-badge.svg
[translate-link]: https://hosted.weblate.org/engage/localsend/
[packaging-badge]: https://repology.org/badge/tiny-repos/localsend.svg
[packaging-link]: https://repology.org/project/localsend/versions

[Homepage][homepage] • [Discord][discord] • [GitHub][github] • [Codeberg][codeberg]

[English (Default)](README.md) • [Беларуская](/support/readme/README_BE.md) • [Español](/support/readme/README_ES.md) • [فارسی](/support/readme/README_FA.md) • [Filipino](/support/readme/README_PH.md) • [Français](/support/readme/README_FR.md) • [Indonesia](/support/readme/README_ID.md) • [Italiano](/support/readme/README_IT.md) • [日本語](/support/readme/README_JA.md) • [ភាសាខ្មែរ](/support/readme/README_KM.md) • [한국어](/support/readme/README_KO.md) • [Polski](/support/readme/README_PL.md) • [Português Brasil](/support/readme/README_PT_BR.md) • [Русский](/support/readme/README_RU.md) • [ภาษาไทย](/support/readme/README_TH.md) • [Türkçe](/support/readme/README_TR.md) • [Українська](/support/readme/README_UK.md) • [Tiếng Việt](/support/readme/README_VI.md) • [中文](/support/readme/README_ZH.md)

[homepage]: https://localsend.org
[discord]: https://discord.gg/GSRWmQNP87
[github]: https://github.com/localsend/localsend
[codeberg]: https://codeberg.org/localsend/localsend

LocalSend 是一個免費、open-source app，可讓你在 local network 中安全地與附近裝置分享檔案與訊息，不需要 internet connection。

- [關於](#關於)
- [Send Server 上傳](#send-server-上傳)
- [贊助者](#贊助者)
- [畫面截圖](#畫面截圖)
- [下載](#下載)
- [運作方式](#運作方式)
- [依賴層級](#依賴層級)
- [開始使用](#開始使用)
- [命令列介面](#命令列介面)
- [貢獻](#貢獻)
  - [翻譯](#翻譯)
  - [Bug 修正與改善](#bug-修正與改善)
- [疑難排解](#疑難排解)
- [建置](#建置)
  - [Android](#android)
  - [iOS](#ios)
  - [macOS](#macos)
  - [Windows](#windows)
  - [Linux](#linux)

## 關於

LocalSend 是一個 cross-platform app，使用 REST API 與 HTTPS encryption 在裝置間建立安全通訊。不同於依賴外部 server 的 messaging apps，LocalSend 不需要 internet connection 或第三方 servers，因此是快速、可靠的 local communication 解決方案。

## Send Server 上傳

SamLaio/localsend fork 額外支援「上傳至 Send Server」傳送目標。這個功能讓使用者選好檔案後，可以把檔案上傳到 Firefox Send / Mozilla Send 相容的自架 Send Server，而不只是在 local network 內傳給附近裝置。

這是額外傳送目標，不會取代或破壞 LocalSend 原本的區網 P2P、web share、WebRTC、CLI 與 server 流程。Send Server URL 與 server 層級的上傳密碼放在設定頁管理；每次分享用的下載密碼、下載次數與存活時間則在上傳前設定。

搭配的服務端是 [SamLaio/send](https://github.com/SamLaio/send)。該 server 4.0 版提供 `/config`、`/api/upload/challenge` 與 `/api/ws`，支援 Firefox Send 相容的 client-side encryption，以及可選的上傳密碼授權。LocalSend 端的實作計畫與限制見 [support/docs/send-server-upload-plan.md](support/docs/send-server-upload-plan.md)。

## 贊助者

Browser testing 由以下贊助：

<a href="https://www.testmuai.com/?utm_medium=sponsor&utm_source=localsend" target="_blank">
    <img src="https://localsend.org/img/sponsors/tesmu.svg" style="vertical-align: middle;" width="250" height="45" />
</a>

## 畫面截圖

<img src="https://localsend.org/img/screenshot-iphone.webp" alt="iPhone screenshot" height="300"/> <img src="https://localsend.org/img/screenshot-pc.webp" alt="PC screenshot" height="300"/>

## 下載

[![Packaging status](https://repology.org/badge/tiny-repos/localsend.svg)](https://repology.org/project/localsend/versions)

建議從 app store 或 package manager 下載此 app，因為 app 本身沒有 auto-update。

| Windows | macOS | Linux | Android | iOS | Fire OS |
|---|---|---|---|---|---|
| [Winget][] | [App Store][] | [Flathub][] | [Play Store][] | [App Store][] | [Amazon][] |
| [Scoop][] | [Homebrew][] | [Nixpkgs][] | [F-Droid][] | | |
| [Chocolatey][] | [DMG Installer][latest] | [Snap][] | [APK][latest] | | |
| [EXE Installer][latest] | | [AUR][] | | | |
| [Portable ZIP][latest] | | [TAR][latest] | | | |
| | | [DEB][latest] | | | |
| | | [AppImage][latest] | | | |

更多資訊請見 [distribution channels][]。

Windows binaries 已簽章。更多資訊請見 [Code signing policy][]。

> [!CAUTION]
> **非官方 MSIX preview：** 你可以在 [localsend.ob-buff.dev](https://localsend.ob-buff.dev/) 試用 latest commits 的 builds。穩定性不保證，且所有 custom code tweaks 都列在該網站上。

[windows store]: https://www.microsoft.com/store/apps/9NCB4Z0TZ6RR
[app store]: https://apps.apple.com/us/app/localsend/id1661733229
[play store]: https://play.google.com/store/apps/details?id=org.localsend.localsend_app
[f-droid]: https://f-droid.org/packages/org.localsend.localsend_app
[amazon]: https://www.amazon.com/dp/B0BW6MP732
[winget]: https://github.com/microsoft/winget-pkgs/tree/master/manifests/l/LocalSend/LocalSend
[scoop]: https://scoop.sh/#/apps?s=0&d=1&o=true&q=localsend&id=fb88113be361ca32c0dcac423cb4afdeda0b0c66
[chocolatey]: https://community.chocolatey.org/packages/localsend
[homebrew]: https://formulae.brew.sh/cask/localsend
[flathub]: https://flathub.org/apps/details/org.localsend.localsend_app
[nixpkgs]: https://search.nixos.org/packages?show=localsend
[snap]: https://snapcraft.io/localsend
[aur]: https://aur.archlinux.org/packages/localsend-bin
[latest]: https://github.com/localsend/localsend/releases/latest
[distribution channels]: https://github.com/localsend/localsend/blob/main/CONTRIBUTING.md#distribution
[code signing policy]: https://github.com/localsend/localsend/blob/main/CODE_SIGNING.md

**相容性**

| 平台 | 最低版本 | 備註 |
|---|---|---|
| Android | 5.0 | - |
| iOS | 12.0 | - |
| macOS | 11 Big Sur | 使用 OpenCore Legacy Patcher 2.0.2，見 [#1005](https://github.com/localsend/localsend/issues/1005#issuecomment-2449899384)。 |
| Windows | 10 | 最後一個支援 Windows 7 的版本是 v1.15.4。未來可能會把新版 backport 到 Windows 7。 |
| Linux | N.A. | Deps: Gnome: `xdg-desktop-portal` and `xdg-desktop-portal-gtk`, KDE: `xdg-desktop-portal` and `xdg-desktop-portal-kde` |

## 設定

多數情況下，LocalSend 應該能開箱即用。不過，如果你傳送或接收檔案時遇到問題，可能需要調整 firewall，允許 LocalSend 在 local network 中通訊。

| 流量類型 | Protocol | Port | Action |
|---|---|---|---|
| Incoming | TCP, UDP | 53317 | Allow |
| Outgoing | TCP, UDP | Any | Allow |

也請確認 router 已停用 AP isolation。通常預設會停用，但部分 routers 可能啟用，特別是 guest networks。
更多資訊請見 [疑難排解](#疑難排解)。

**Portable Mode**

(v1.13.0 引入)

在 executable 相同目錄建立名為 `settings.json` 的檔案。此檔可以是空的。
App 會改用這個檔案儲存 settings，而不是使用預設位置。

**Start hidden**

(v1.15.0 更新)

若要以 hidden 狀態啟動 app，也就是只出現在 tray，請使用 `--hidden` flag，例如 `localsend_app.exe --hidden`。

在 v1.14.0 與更早版本中，如果設定了 `autostart` flag 且 hidden setting 已啟用，app 會以 hidden 狀態啟動。

## 運作方式

LocalSend 使用安全通訊 protocol，讓裝置透過 REST API 彼此通訊。所有資料都會透過 HTTPS 安全傳送，且 TLS/SSL certificate 會在每台裝置上即時產生，以提供最高安全性。

更多 LocalSend Protocol 資訊請見 [documentation](https://github.com/localsend/protocol)。

## 依賴層級

![Dependency hierarchy](support/docs/dependency-hierarchy.svg)

## 開始使用

若要從 source code 編譯 LocalSend，請依照下列步驟：

1. 直接安裝 [Flutter](https://flutter.dev)，或使用 [fvm](https://fvm.app) 安裝，見 [.fvmrc](.fvmrc) 指定版本。
2. 安裝 [Rust](https://www.rust-lang.org/tools/install)。
3. Clone `LocalSend` repository。
4. 執行 `cd app` 進入 app 目錄。
5. 執行 `flutter pub get` 下載 dependencies。
6. 執行 `flutter run` 啟動 app。

> [!NOTE]
> LocalSend 目前需要較舊的 Flutter version，指定於 [.fvmrc](.fvmrc)。
> 因此 build issues 可能是 required version 與系統全域已安裝 Flutter version 不一致造成的。
> 為了讓開發環境更一致，LocalSend 使用 [fvm](https://fvm.app) 管理專案 Flutter version。
> 安裝 `fvm` 後，請執行 `fvm flutter`，不要直接執行 `flutter`。

## 命令列介面

LocalSend CLI 是建立在 LocalSend Protocol v2 上的 terminal client。
執行 `localsend-cli --help` 可查看所有 available options 與 hotkeys。

使用 `send` command 傳送一個或多個 files、directories，或兩者混合：

```shell
localsend-cli send report.pdf photo.jpg ./project-backup
```

此 command 會開啟已探索裝置清單；互動式選取 destination 後按 Enter 開始 transfer。

若要略過互動式 device list 直接選取 destination，請傳入精確 alias 或 IP address：

```shell
localsend-cli send --to "Cute Tomato" report.pdf
localsend-cli send --to 192.168.27.26 report.pdf
```

Alias 必須能唯一識別一個已探索裝置。IP address 會直接透過 HTTPS probing LocalSend 預設 port (`53317`)。

Directories 會遞迴收集。接收端會保留被選取的 root names 與 nested paths。Empty directories 不會送出，因為 LocalSend 傳送的是 file entries，不是 directory entries。

## 貢獻

歡迎任何想協助改善 LocalSend 的人貢獻。若你想參與，可以透過以下方式協助。

### 翻譯

你可以協助把 LocalSend 翻譯成其他語言。我們使用 [Weblate](https://hosted.weblate.org/projects/localsend/app) platform 管理 translations。

你也可以 fork 此 repository，手動新增 translations。

Translations 位於 [app/assets/i18n](https://github.com/localsend/localsend/tree/main/app/assets/i18n) 目錄。請編輯 `_missing_translations_<locale>.json` 或 `strings_<locale>.i18n.json` 來新增或更新 translations。

<a href="https://hosted.weblate.org/engage/localsend/">
<img src="https://hosted.weblate.org/widget/localsend/app/multi-auto.svg" alt="Translation status" />
</a>

**_注意：_ 以 `@` 裝飾的 fields 不需要翻譯；它們不會以任何方式被 app 使用，只是關於檔案的資訊或給譯者的 context。**

### Bug 修正與改善

- **Bug 修正：** 如果你發現 bug，請建立 pull request，並清楚描述問題與修正方式。
- **改善：** 如果你有改善 LocalSend 的想法，請先建立 issue 討論為什麼需要這個改善。

更多資訊請見 [contributing guide](https://github.com/localsend/localsend/blob/main/CONTRIBUTING.md)。

## 疑難排解

| Issue | Platform (Sending) | Platform (Receiving) | Solution |
|---|---|---|---|
| Device not visible | Any | Any | 請確認 router 已停用 AP-Isolation。若啟用，裝置之間會禁止連線。 |
| Device not visible | Any | Windows | 請確認你的 network 設定為「private」network。Windows 在 public network 下可能更嚴格。 |
| Device not visible | macOS, iOS | Any | 可嘗試在 OS settings 的 Privacy 中切換「Local Network」permission。 |
| Speed too slow | Any | Any | 使用 5 GHz；在兩台裝置上停用 encryption。 |
| Speed too slow | Any | Android | 已知 issue: https://github.com/flutter-cavalry/saf_stream/issues/4 |

## 建置

這些 commands 僅供 maintainers 使用。請確認從 `app` 目錄執行。

### Android

Traditional APK

```bash
flutter build apk
```

Google Play 使用的 AppBundle

```bash
flutter build appbundle
```

### iOS

```bash
flutter build ipa
```

### macOS

```bash
flutter build macos
```

### Windows

**傳統建置**

```bash
flutter build windows
```

**Android arm64 APK + Windows 10+ x64 portable ZIP**

```powershell
.\support\scripts\compile_release_apk_exe.ps1
```

輸出會放在：

```text
release/[版本]/release.apk
release/[版本]/release.zip
```

Windows ZIP 內的主程式檔名是 `release.exe`。

**Windows 10+ x64 portable ZIP only**

```powershell
.\support\scripts\compile_release_apk_exe.ps1 -SkipAndroid
```

輸出會放在：

```text
release/[版本]/release.zip
```

ZIP 內的 `release.exe` 是 portable bundle 的 executable，執行時需要同層的 DLL 與 `data\`。

**Windows 10+ x64 EXE installer**

```powershell
.\support\scripts\compile_windows_exe.ps1
```

本機未設定 Windows 簽章工具時，可產生 unsigned installer：

```powershell
.\support\scripts\compile_windows_exe.ps1 -SkipSignTool -SkipMsixHelper
```

輸出會放在：

```text
release/[版本]/release-installer.exe
```

**Local MSIX App**

```bash
flutter pub run msix:create
```

**Store-ready**

```bash
flutter pub run msix:create --store
```

### Linux

**傳統建置**

```bash
flutter build linux
```

**AppImage**

```bash
appimage-builder --recipe AppImageBuilder.yml
```

**Snap**

說明位於 [localsend/snap/README.md](https://github.com/localsend/snap/blob/main/README.md)。

## 貢獻者

<a href="https://github.com/localsend/localsend/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=localsend/localsend"  alt="Localsend Contributors"/>
</a>
