# LocalSend 貢獻指南

LocalSend 是 open-source project，歡迎任何有興趣協助改善 app 的人貢獻。無論你是 developer、translator，或 documentation writer，都有許多參與方式。

LocalSend 不接受 AI 產生的貢獻，除非：

- 是 bug 修正，或
- 範圍非常小，或
- 你能證明自己具備相關領域的專業能力。

## 開始使用

若你想為 LocalSend 貢獻 code，請先依照下列步驟準備。

## 執行

安裝 [Flutter](https://flutter.dev) 後，可以輸入下列 commands 啟動 app：

```shell
cd app
flutter pub get
dart run build_runner build -d
flutter run
```

## 翻譯

你可以協助把這個 app 翻譯成其他語言。

1. Fork 此 repository。
2. 選擇一種方式：
   - 在既有語言中補上 missing translations：只更新 [assets/i18n](https://github.com/localsend/localsend/tree/main/app/assets/i18n) 中的 `_missing_translations_<locale>.json`。
   - 修正既有 translations：更新 [assets/i18n](https://github.com/localsend/localsend/tree/main/app/assets/i18n) 中的 `strings_<locale>.i18n.json`。
   - 新增語言：建立新檔案，另見 [locale codes](https://saimana.com/list-of-country-locale-code/)。
3. Optional：重新執行 app。
   1. 執行 `cd app` 進入 app 目錄。
   2. 確認你已依 [執行](#執行) 章節跑過一次 app。
   3. 透過 `flutter pub run slang` 更新 translations。
   4. 透過 `flutter run` 執行 app。
4. 開啟 pull request。

**_注意：_ 以 `@` 裝飾的 fields 不需要翻譯；它們不會以任何方式被 app 使用，只是關於檔案的資訊或給譯者的 context。**

感謝所有 [translators](https://github.com/localsend/localsend/tree/main/app/lib/pages/about/translators.dart)。

## 貢獻準則

提交 pull request 到 LocalSend 前，請確認你已遵守下列準則：

- Code 應有適當 documentation，並依照 [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) 格式化。
- 所有變更都應有 tests 覆蓋。
- Commits 應清楚、具描述性，包含變更摘要與相關 context。
- Pull requests 應以 `main` branch 為目標，並包含清楚的變更摘要。

## Bug 回報與功能請求

如果你在 LocalSend 遇到 bug，或有 feature request，請在 [issue tracker](https://github.com/localsend/localsend/issues) 提交 issue。請務必提供清楚的問題或 feature request 描述，以及相關 context 或重現步驟。

## 安全性問題

如果你發現 LocalSend 的 security issue，請不要提交到公開 issue tracker。請直接寄信到 [support@localsend.org](mailto:support@localsend.org)，讓我們能盡快且有效地處理。

## 散布通路

Git-based 散布：

| Channel | Repository | Maintainer |
|---|---|---|
| [Winget][] | [Winget Repo][] | [@sitiom][], [@Tienisto], Github Actions |
| [Scoop][] | [Scoop Repo][] | [@sitiom][], [@Tienisto], Github Actions |
| [Chocolatey][] | [Chocolatey Repo][] | [@brogers5][] |
| [Homebrew][] | [Homebrew Repo][] | [@Tienisto][], Github Actions |
| [Flathub][] | [Flathub Repo][] | [@proletarius101][], [@Tienisto][], Github Actions |
| [AUR][] | [AUR Repo][] | [@Nixuge][] |
| [Nixpkgs][] | [Nixpkgs Repo][] | [@sikmir][], [@linsui][] |
| [F-Droid][] | [F-Droid Repo][] | [@linsui][], [@Tienisto][], [F-Droid CI][] |
| [Snap][] | [Snap Repo][] | [@thatLeaflet][] |

[winget]: https://github.com/microsoft/winget-pkgs/tree/master/manifests/l/LocalSend/LocalSend
[winget repo]: https://github.com/microsoft/winget-pkgs/tree/master/manifests/l/LocalSend/LocalSend
[scoop]: https://scoop.sh/#/apps?s=0&d=1&o=true&q=localsend&id=fb88113be361ca32c0dcac423cb4afdeda0b0c66
[scoop repo]: https://github.com/ScoopInstaller/Extras/blob/master/bucket/localsend.json
[chocolatey]: https://community.chocolatey.org/packages/localsend
[chocolatey repo]: https://github.com/brogers5/chocolatey-package-localsend/tree/main
[homebrew]: https://formulae.brew.sh/cask/localsend
[homebrew repo]: https://github.com/Homebrew/homebrew-cask/blob/master/Casks/l/localsend.rb
[flathub]: https://flathub.org/apps/details/org.localsend.localsend_app
[flathub repo]: https://github.com/flathub/org.localsend.localsend_app
[aur]: https://aur.archlinux.org/packages/localsend-bin
[aur repo]: https://aur.archlinux.org/localsend-bin.git
[nixpkgs]: https://search.nixos.org/packages?show=localsend
[nixpkgs repo]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/localsend/default.nix
[f-droid]: https://f-droid.org/packages/org.localsend.localsend_app
[f-droid repo]: https://gitlab.com/fdroid/fdroiddata/-/blob/master/metadata/org.localsend.localsend_app.yml
[snap]: https://snapcraft.io/localsend
[snap repo]: https://github.com/localsend/snap

手動散布：

| Channel | Maintainer |
|---|---|
| [App Store][] | [@Tienisto](https://github.com/Tienisto) |
| [Play Store][] | [@Tienisto](https://github.com/Tienisto) |
| [Amazon][] | [@Tienisto](https://github.com/Tienisto) |

[app store]: https://apps.apple.com/us/app/localsend/id1661733229
[play store]: https://play.google.com/store/apps/details?id=org.localsend.localsend_app
[amazon]: https://www.amazon.com/dp/B0BW6MP732

Binary 散布：

| Type | Maintainer | Credits |
|---|---|---|
| Windows ZIP | [@Tienisto][] | |
| MSIX | [@Tienisto][] | |
| EXE | [@Tienisto][] | |
| APK | [@Tienisto][] | |
| TAR | [@Tienisto][] | |
| DEB | [@Tienisto][] | |
| AppImage | [@Tienisto][] | [@TheGB0077][] |
| DMG | [@Tienisto][] | |

[@Tienisto]: https://github.com/Tienisto
[@TheGB0077]: https://github.com/TheGB0077
[@sitiom]: https://github.com/sitiom
[@Nixuge]: https://github.com/Nixuge
[@proletarius101]: https://github.com/proletarius101
[@brogers5]: https://github.com/brogers5
[@sikmir]: https://github.com/sikmir
[@linsui]: https://github.com/linsui
[@thatLeaflet]: https://github.com/thatLeaflet
[F-Droid CI]: https://gitlab.com/fdroidci

待辦：

你可以協助把 LocalSend 發布到更多 platforms。請建立 issue 通知我們。

- Traditional Linux distributions，例如 Debian、Fedora 等。
- 你的想法。

## 筆記

實用筆記。

### 編譯 production APK

產生 APK 需要 signing keys。

你可以產生自己的 keys，或使用 debug signing options：

```groovy
// File: android/app/build.gradle
buildTypes {
  release {
    signingConfig signingConfigs.debug // using debug signing
  }
}
```

### 升級 Flutter

假設要把 Flutter 更新到 `3.41.9`：

1. 用 fvm 更新 Flutter：`fvm use 3.41.9`
2. 更新 Flutter submodule：
   1. `git submodule update --init`
   2. `cd support/submodules/flutter`
   3. `git fetch`
   4. `git checkout 3.41.9`
   5. `cd ../../..`
   6. `git add support/submodules/flutter`
3. 更新 Flutter constraints：
   1. CI: `.github/workflows/ci.yml`
   2. pubspec: `pubspec.yaml`

### 發版

請確認已設定 self-hosted runner，用來編譯 arm64 linux binaries。

依照下列說明設定 runner：

安裝 Flutter

```bash
sudo apt install git
git clone https://github.com/flutter/flutter.git $HOME/flutter
nano $HOME/.bashrc
```

將下列內容加入檔案結尾：

```bash
export PATH="$PATH:$HOME/flutter/bin"
```

重新啟動 terminal。

```bash
flutter doctor
```

接著依照說明設定 GitHub runner。

從 "Actions" tab 啟動 "Release Draft" workflow：https://github.com/localsend/localsend/actions/workflows/release.yml

最後，編譯 pipeline 尚未支援的 binaries。
