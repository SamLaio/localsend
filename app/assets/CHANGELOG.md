## 1.18.2 (2026-08-21)

- 功能：可將檔案 drag and drop 到 "Receive via link" browser page
- 功能(desktop)：可在 executable 旁建立 `web` folder 並放入 HTML files，自訂 web share pages
- 功能(cli)：在 Windows executable 加入 version info
- 功能(linux)：在 AppImage 設定實際 version
- 安全性：不要跟隨 peers 傳來的 HTTP redirects
- 修正：在缺少 multicast networks 時，恢復與 1.17.0 及更早版本的相容性
- 修正：執行 1.17.0 及更早版本的裝置無法把 1.18.0+ 裝置加入 favorite
- 修正：忽略 proxies，修正啟用 system proxy，例如 Shadowrocket 時出現的 "TLS info not found"
- 修正：HTTP / multicast server 死掉或 app resume 時自動 restart
- 修正：混合 folders 與 files 的 drag and drop
- 修正：transfer 期間 Advanced 開啟時加入 bottom padding (@Chethan616)
- 修正：executable path 無法解析時，startup 不要 crash (@Shlomo116)
- 修正(android)：讀取 files 時忽略未知或無效的 file modification times
- 語系：新增 Armenian

## 1.18.1 (2026-08-11)

Android+iOS only hotfix update。

- 修正：將 button icon sizes 還原為 24
- 修正：傳送會被立刻 accepted 的 message 時，會出現 ghost device list tile
- 修正(mobile)：傳送 link message 時，"Open" button 會 overflow
- 修正(android)：補上 Android 17+ 需要的 ACCESS_LOCAL_NETWORK permission
- 語系：新增 Belarusian (@pavel-miniutka)、Irish (@aindriu80)

## 1.18.0 (2026-08-10)

- 功能(cli)：初始 CLI release
- 功能：receive via link
- 功能：透過 color picker 自訂 color theme
- 功能：ipv6 support
- 功能：checksum support，預設啟用
- 功能：預設自動接受 favorite devices 傳來的 files
- 功能：file sizes 改用 decimal units (1 GB = 1000 MB)，以符合 macOS、iOS、Android 與 Linux
- 功能：可用 `--text` 或 `-t` flags 從 command line 開始 text share (@guilhermetiscoski)
- 功能：改善 long transfers 的 remaining time formatting (@ShlomoCode)
- 功能：duplicate file naming 從 "file-1.txt" 改為 "file (1).txt" 格式 (@kartoshka95)
- 功能(android, ios, macos)：app 首次 startup 時尊重 system-wide animation preferences (@nitheesh-daram)
- 功能(android)：file transfer 可在 background 執行
- 功能(android)：新增 quick settings tile，可快速啟動 app (@Voltra)
- 功能(windows)：將 LocalSend 加入 share sheet (@chenxdust)
- 功能(macos)：troubleshoot page 新增 button，可快速開啟 firewall settings (@ShlomoCode)
- 功能(macos)：新增 Command+Comma shortcut 開啟 settings (@ShlomoCode)
- 功能(macos)：使用較友善的 ComputerName 取代 technical hostname (@ShlomoCode)
- 功能(macos)：即使 app 未執行，也能透過 Dock icon text-drop (@ShlomoCode)
- 功能(linux)：使用 native window decorations 取代大型 GTK3 headerbar (@nixigaj)
- 效能：對較慢的 receiving devices 提供更快 transfers
- 修正：接收 / 傳送大量 files 時不再 freeze / lag
- 修正：file transfer 完成後 release wake lock，讓裝置可進入 sleep (@kartoshka95)
- 修正：history dialog 中 text message content 顯示三次 (@ew-sirenko)
- 修正：text message content size calculation (@ew-sirenko)
- 修正：將 DNG files 存到 image gallery (@ShlomoCode)
- 修正(ios, android)：unsupported media formats 改存到 folder 而不是 gallery，避免 transfer error (@ShlomoCode)
- 修正(android)：share to LocalSend 有時無法運作
- 修正(android)：分享 media 時保留 location metadata (@ShlomoCode)
- 修正(macos)："Start hidden" 啟用時，autostart 期間避免 Dock icon 短暫出現 (@ShlomoCode)
- 修正(macos)：Dock icon drag-and-drop 與 Share Extension 恢復運作 (@ShlomoCode)
- 修正(linux)：為中文、日文與韓文文字加入 CJK font support (@Mr-Ebonycat)

## 1.17.0 (2025-02-19)

- 功能：新增 advanced setting，用來 filter network interfaces (@Tienisto)
- 功能(mobile)：用 swipe gesture 選取多個 media files (@Tienisto)
- 功能(windows)：貼上 image 時自動轉成 PNG (@BrianMwit)
- 功能(android)：image/video 自動儲存後，新增開啟 gallery 的 option (@Tienisto)
- 修正：儲存 files 時的 path traversal vulnerability (@Tienisto)
- 修正：在 "Share via link" 連點兩次 "Back" 造成 black screen (@Tienisto)
- 修正(macos)：minimize to tray 啟用時按 command key 會讓 window 消失 (@Tienisto)
- 修正(windows)：不要 poll local IP，避免不必要的 location permissions (@Tienisto)

## 1.16.2 (2024-11-06)

- 修正(ios)：iOS 18 中從其他 apps share 到 LocalSend 無法運作 (@Tienisto)

## 1.16.1 (2024-11-05)

- 功能：使用 IP address dialog 或 favorite dialog 時顯示精確 error message (@Tienisto)
- 功能(desktop)：點選 "Show in folder" 時 highlight file (@Tienisto)
- 修正(android)：back gesture 可正確關閉 app (@Tienisto)

## 1.16.0 (2024-11-03)

- 功能：若 sending device 是 bottleneck，改用 Rust 作為 HTTP client 並使用 multithreading 來改善 transfer speed (@Tienisto)
- 功能：新增 option，只自動接收 favorites 傳來的 files (@Davte)
- 功能：只有 files 成功 received 或 skipped 時才自動 finish (@Tienisto)
- 功能：改善 RTL languages 中多處 padding 與 spacing issues (@ShlomoCode)
- 功能：persist "advanced settings" toggle (@Nolle10)
- 功能：新增 alias-regeneration button 與 alias update dialog (@Nolle10)
- 功能(macos)：可將 files 與 text drag-and-drop 到 menu bar icon (@ShlomoCode)
- 功能(macos)：可將 text drag-and-drop 到 app icon (@ShlomoCode)
- 功能(macos)：將 LocalSend 加入 share menu 的 share target (@ShlomoCode)
- 功能(macos)：autostart 啟用時，starts hidden in menu bar，而不是 minimized (@ShlomoCode)
- 功能(macos)：在 app icon 顯示 error 與 success state (@ShlomoCode, @Tienisto)
- 功能(macos)：sandboxed version (App Store) 也有 autostart option (@ShlomoCode)
- 功能(macos)：透過 dmg installer 安裝的 LocalSend 現在是 sandboxed (@Tienisto)
- 功能(android)：啟用 clipboard button (@Seidko)
- 功能(ios)：啟用 clipboard button (@AnessZurba)
- 修正(macos)：minimize to menu bar 後，從 launchpad reopen app 應讓 window visible (@ShlomoCode)
- 修正(macos)：app restart 後 persist download location 的 write access (@ShlomoCode)
- 語系：新增 Malaysian (@Gloridust)、Slovak (@dodog)

## 1.15.4 (2024-08-20)

- 功能：新增 button 可 retry failed file transfer (@Tienisto)
- 功能：在 "Scan" button 顯示 tooltip (@Tienisto)
- 功能：把任何 URI 視為 link，接收端可點擊，例如 file://、obsidian:// (@Tienisto)
- 功能(mobile)：調整 send tab button width，以提示可 scroll (@Tienisto)
- 功能(windows)：title bar color 應符合 system theme (@FutoTan)
- 修正：sending files 時的 memory leak，為 1.15.0 regression，1.15.2 僅修正 receiving files (@Tienisto)
- 修正(windows)：app start 時 LocalSend window invisible (@Tienisto)
- 語系：依 platform 區分 "Exit" 與 "Quit" (@sergd88)
- 語系：新增 Hindi (@rishi-singh26)

## 1.15.3 (2024-07-29)

- 功能：將 receive history length 降到 30 items 以提升 performance (@Tienisto)
- 功能：initialization failed 時顯示 error message，方便 debugging (@Tienisto)
- 修正(android)：back gesture 可正確關閉 app (@Tienisto)

## 1.15.2 (2024-07-25)

- 功能：將 network scanning 抽到 separate threads，scanning 不再造成 UI lags (@Tienisto)
- 功能(windows)：installer 使用較大的 icon (@Tienisto)
- 修正：receiving files 時的 memory leak，並可正確接收超過 available RAM 的 files (@Tienisto)
- 修正(android)：可將 files 儲存到 Download folder 之外 (@Tienisto)
- 修正(windows)：透過 autostart 啟動時使用正確 portable settings file (@Tienisto)
- 修正(windows)：installer 可在 arm64 運作 (@Tienisto)

## 1.15.1 (2024-07-18)

- 功能：web share 支援 Internet Explorer 8 (IE8) (@Tienisto)
- 功能：在 web share 切換 encryption mode 時儲存 auto accept state (@Tienisto)
- 功能：透過 keyboard shortcut paste 時切換到 "Send" tab (@Tienisto)
- 修正：web share 中正確計算 PIN tries (@Tienisto)
- 修正(android)：Android TV 上 picking files 或 folders 時 crash (@Tienisto)
- 修正(windows)：file sizes 總和大於 2 GB 時 crash (@Tienisto)
- 修正(windows)：bundle required DLL files，避免 app start 時 crash (@Tienisto)
- 修正(macos)：透過 App Store 安裝時隱藏 autostart option，因為此 switch 無法運作 (@Tienisto)

## 1.15.0 (2024-07-15)

- 功能：send tab 新增 clear button (@Caesarovich)
- 功能：將 text messages 存到 history (@Tienisto)
- 功能：保留 transferred files 的 timestamps (@Tienisto)
- 功能：sharing via link 時可要求 PIN (@Tienisto)
- 功能：receiving files 時可要求 PIN (@Tienisto)
- 功能：history 中新增 option，可開啟 received files 的 parent folder (@Tienisto)
- 功能：nearby devices list 中新增或移除 favorites 前先 confirm (@Tienisto)
- 功能：sharing via link 時新增 URL view，以較大字體顯示 URL (@harriseldon)
- 功能：新增 discovery timeout setting 給 advanced users (@o2e)
- 功能(android)：不再需要 MANAGE_EXTERNAL_STORAGE，改實作 Android SAF (@Tienisto)
- 功能(android)：透過 file picker 選取時不將 files 複製到 cache (@Tienisto)
- 功能(windows)：新增 context menu integration ("Send to") (@Tienisto)
- 功能(windows)：可在 app 內 toggle "start hidden"，不再導向 system settings (@Tienisto)
- 功能(desktop)：讓 auto start + start hidden 更穩定，現在 listen `--hidden` parameter 而不是 `autostart` (@Tienisto)
- 功能(desktop)：從 command line arguments 載入 initial files (@Tienisto)
- 功能(desktop)：在 taskbar 顯示 progress (@NightFeather0615)
- 功能(macos)：處理 dropped into app icon 的 files (@Tienisto)
- 修正：sanitize 含 invalid characters 的 file names (@Caesarovich)
- 修正：window height 太小時的 UI overflow (@CHUNG-HAO)
- 修正(ios)：讓 documents files 可被 Finder / AppleDevices app 看見 (@twinkles-twinstar)
- 修正(windows)：關閉 app 時正確 remove tray icon (@zpp0196)
- 修正(windows)：不要 keep file open (@NightFeather0615)
- 修正(linux)：與新版 libayatana versions 相容 (@ix5)
- 語系：新增 Serbian (@nebojsatomic)、Finnish (@jooapa)、Romanian (@UnifeGi)

## 1.14.0 (2024-02-26)

- 功能：sharing via link 時新增自動接受 requests 的 option (@MisterChangRay, @Tienisto)
- 功能：selection row 中所有 buttons 使用固定 button width，只有 Russian 較明顯 (@Tienisto)
- 修正：picking many files 不應 freeze UI (@Tienisto)
- 修正：sharing via link 時，不要為相同 IP 建立 new session (@MisterChangRay)
- 修正(android)：在 Android 10 或更舊版本可將 files 存到 SD card (@Tienisto)
- 語系：新增 Danish (@Limfjorden)

## 1.13.1 (2023-12-08)

- 功能："Auto Finish" 啟用時加入短暫 delay (@Tienisto)
- 功能：favorite devices 的 device name 若未被使用者改過，則自動更新 (@Tienisto)
- 功能：file picker buttons 的 button text 太長時展開 buttons (@Tienisto)
- 修正：將 Flutter 從 3.16 降到 3.13，以修正多種 crash issues (@Tienisto)

## 1.13.0 (2023-12-04)

- 功能：新增 successful transfer 後自動 finish 的 option (@Tienisto)
- 功能：device list 中若標記為 favorite，顯示 favorite name (@Tienisto)
- 功能：從 file picker 選取時忽略 duplicate files (@programmermager)
- 功能：新增 donation options (@Tienisto)
- 功能：新增 Yaru theme (@Tienisto)
- 功能(desktop)：若 executable 旁有 `settings.json`，portable mode 會使用該檔 (@Tienisto)
- 功能(windows)：讓 windows icon 更銳利 (@Tienisto, @sergd88)
- 功能(macos)：新增 Command+W shortcut 關閉 window (@Q1CHENL)
- 修正：OS 不支援 dynamic colors 時，也顯示 OLED color mode option (@dhruvanbhalara)
- 修正：點擊 sync button 後應立即 spin (@Tienisto)
- 修正(android)：儲存 files 到 downloads folder 之外時 request permission (@Tienisto)
- 修正(ios)：picking directory 時的 permission error (@Tienisto)
- 修正(ios)：從其他 app share file 時清除 cache (@Tienisto)
- 語系：新增 Greek (@multipetros)、Khmer (@nidexingg)

## 1.12.0 (2023-10-25)

- 功能：新增 favorites (@Tienisto)
- 功能：新增 OLED color mode (@Tienisto)
- 功能：清除 history 前顯示 dialog (@pantshaswat, @Tienisto)
- 功能：apk picker search bar 顯示 clear button (@Tienisto)
- 功能：settings 中的 toggle switches 使用更好的 colors (@gitstart)
- 功能：透過最佳化 spin animation，大幅改善 GPU usage (@Tienisto)
- 功能(desktop)：支援從 clipboard paste (@gitstart, @Tienisto)
- 功能(linux)：Wayland 上可停用 client side decorations (@I-Want-ToBelieve)
- 功能(android)：在部分 OnePlus 等鎖定 60 Hz 的 devices 上使用 high framerate (@Tienisto)
- 修正(desktop)：default downloads folder 不可用時 fallback 到 "$HOME/Downloads" (@Sqbika)
- 語系：新增 Vietnamese (@faea726)、Thai (@watchakorn-18k)、Basque (@xezpeleta)

## 1.11.1 (2023-09-04)

- 功能：不支援 dynamic colors 時隱藏 color setting (@Tienisto)
- 功能(linux)：linux tray 使用 white icon (@GaryElshaw, @Tienisto)
- 修正：可能造成 zero total files 的 race condition (@Tienisto)
- 修正(android)：Android 9 與更早版本的 navigation bar color (@Tienisto)
- 修正(android)：重新加入 `requestLegacyExternalStorage`，該項曾在 1.11.0 被移除 (@Tienisto)
- 修正(linux)：file picker 不再使用 zenity dependency (@Tienisto)

## 1.11.0 (2023-08-28)

- 功能：share via link 時可選擇啟用 HTTPS (encryption) (@Tienisto)
- 功能：settings 使用 switches 取代 dropdowns (@forecaster-cyber)
- 功能：點擊 scan button 會清除 found devices (@Tienisto)
- 功能：text message dialog 永遠為 multiline (@Tienisto)
- 功能：新增停用 animations 的 option (@Tienisto)
- 功能：新增不存到 history 的 option (@Tienisto)
- 功能：新增自訂 device model 的 option (@Tienisto)
- 功能(desktop)：綁定 "ESC" key 回到上一頁 (@RiverTwilight, @Tienisto)
- 功能(android, ios)：在新 browser tab 開啟 link (@Tienisto)
- 功能(linux)：啟用 autostart feature (@TheGB0077)
- 修正(android, ios)：儲存 GIFs 與 image metadata (@natsuk4ze)
- 修正(android, ios)：picking files 時處理 decline permission (@Tienisto)
- 修正(desktop)：hidden to tray 時的 GPU usage (@Tienisto)

## 1.10.0 (2023-06-02)

- 功能：dynamic colors (Material You) (@Tienisto)
- 功能(android)：sharing APKs 時 file name 包含 version (@Tienisto)
- 功能(windows)：恢復 Windows 7 support (@Tienisto)
- 功能(windows)：針對中文、日文與韓文使用 specialized fonts (@graphemecluster, @Tienisto)
- 修正：active file transfer 期間的 cancellation fixes (@SelaseKay)
- 修正(windows)：可能的 settings corruption (@TheGB0077, @Tienisto)
- 修正(android)：正確取得 downloads directory (@Tienisto)
- 修正(ios)：無法儲存 HEIC files (@Tienisto)

## 1.9.1 (2023-05-05)

- 功能：add folder 時應包含 folder 本身
- 修正：link share mode 中處理含 special characters 的 file names
- 修正(android)：picking media file 後的 status bar icon color
- 修正(linux)：將 libayatana-appindicator3-1 加入 AppImage dependencies (by @TheGB0077)

## 1.9.0 (2023-04-23)

- 功能：directory share
- 功能：share via browser link，供非 LocalSend users 使用
- 功能：file 無法開啟時，新增 "delete from history" button (by @TheGB0077)
- 功能：copied / opened link 後關閉 message request
- 功能：稍微改善 transfer speed
- 功能：實作 LocalSend protocol v2，並提供 v1 fallback
- 功能：network interfaces 數量 < 3 時，scan (sync) button 會自動掃描所有 network interfaces
- 功能(android, ios)：file receive options 中新增 "Save to gallery" setting button
- 功能(desktop)：將 troubleshoot 從 navigation 移到 send page
- 功能(desktop)：儲存 last window position (by @TheGB0077)
- 功能(android)：啟用 edge-to-edge mode
- 功能(android)：為 Android 13 新增 monochrome app icons (by @h9419)
- 功能(android)：設定 custom download path
- 功能(linux)：啟用 system tray (by @TheGB0077)
- 修正：multi-recipient mode 中 retry 會讓 recipient device 出現 "canceled by sender"
- 修正：finished message transfer 後 clear selection
- 修正(ios)：iOS 14+ 無法 scan local network (by @TheGB0077)
- 修正(android, ios)：asset picker strings fallback 到 English translation (by @TheGB0077)
- 修正(linux)：header bar glitches
- 語系：新增 fa

## 1.8.0 (2023-03-05)

- 功能：新增 send modes，包含 single recipient 與 multiple recipients
- 功能：finish 後預設清除 selection，這是 send modes feature 的一部分
- 功能：平行 share to multiple recipients
- 功能：新增 troubleshoot page
- 功能：receive history 新增 2 個 buttons：open folder 與 delete history
- 功能：清理 scan UI，將 multiple network interfaces 收進 scan button
- 功能：編輯 selected files 中的 text message
- 功能：透過 TCP 回答而不是 UDP，改善 device discovery
- 功能(ex. iOS)：在 progress page 按 destination directory 會開啟該 directory
- 功能(android)：share apk 與 install apk
- 功能(android)：Android TV support
- 功能(android)：picking large files 時顯示 loading indicator
- 功能(windows)：left click tray icon 會開啟 app
- 功能(linux)：新增 Control+Q shortcut 離開 app
- 修正：unencrypted mode 中的 handshake error
- 修正：按 subnet sync button 時也 scan multicast
- 修正(android)：Android 7 上 missing app icon
- 修正(android,ios)：save to gallery failed 時顯示 error message
- 語系：新增 bn、nl、uk

## 1.7.0 (2023-02-11)

- 功能：啟用 multicast 以改善 device discovery
- 功能：received files history
- 功能：manual IP input 中顯示 recent IP addresses
- 功能：分離 language settings page
- 功能：multiline 未選取時，message input 可水平 scroll
- 功能：QuickSave mode 中正常 open message，而不是存成 file
- 功能：改善 error handling，並可顯示 exact error message 方便 debugging
- 功能：新增 unencrypted HTTP mode，供 debugging 使用
- 功能(android)：儲存到 photos 時保留 file name
- 功能(desktop)：display 夠大時使用較大的 default window size
- 功能(windows)：Windows 使用更適合 Chinese characters 的 "Microsoft YaHei UI" font
- 修正：iOS cache cleanup
- 語系：新增 ar、es-ES、fr-FR、hu、in、it、iw、ja、ko、ne、pl、pt-BR、ru、sv、tr、zh-Hant-HK、zh-Hant-TW，感謝所有 contributors

## 1.6.2 (2023-01-28)

- 修正(desktop)：另一個 instance 已開啟時關閉 current instance
- 修正：啟用 Chinese language 時無法 receive files
- 修正(android, ios)：share 含非 English names 的 files

## 1.6.1 (2023-01-27)

- 修正(windows)：minimized to tray 時 app crashes
- 修正(android, ios)：share intent 有時無法運作
- 修正(android, ios)：從 share intent 進來時未 trigger scan
- 修正(android, ios)：share intent 在 transfer 完成後產生 duplicates

## 1.6.0 (2023-01-27)

- 功能：progress page 顯示 thumbnail
- 功能：改善 cache clearing mechanism
- 功能：hashtag input 現在會在給定 multiple subnets 時嘗試所有 combinations
- 功能(desktop)：adding files 時顯示 dialog 而非 bottom sheet
- 功能(windows, mac)：minimize to tray
- 功能(windows)：launch on login
- 功能：message input 新增 multiline toggle
- 修正：progress page 顯示正確 file count
- 修正：新增 self-discovering prevention
- 語系：新增 Simplified Chinese

## 1.5.2 (2023-01-14)

- F-Droid release

## 1.5.1 (2023-01-10)

- 修正(windows)：app start 時有時 crash

## 1.5.0 (2023-01-09)

- 功能：quick save mode
- 功能：accept requests partially
- 功能：accept phase 時設定 destination directory
- 功能：rename incoming files
- 功能：file transfer 期間 keep screen on
- 功能：sending 前 tap to open selected file

## 1.4.0 (2023-01-06)

- 功能：支援 multiple local IP addresses
- 功能：偵測 message 是否為 link，並加入開啟 link 的 button

## 1.3.1 (2023-01-03)

- 修正：local IP 有時找不到

## 1.3.0 (2023-01-03)

- 功能：輸入 custom target address
- 功能：tap to open received file
- 功能：responsive UI
- 功能(ios)：receive share intent
- 功能(windows)：設定 destination folder
- 修正：再次 scan 時更新 nearby device attributes

## 1.2.0 (2022-12-31)

- 功能：drag and drop files
- 功能：share plain messages
- 功能(android)：receive share intent

## 1.1.0 (2022-12-30)

- 功能(android)：新增 media picker
- 功能(ios)：合併 image 與 video 到 common media picker
- 修正(android)：missing internet permission

## 1.0.0 (2022-12-29)

- 初始 release
