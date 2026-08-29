# 程式碼簽章政策

Code signing 由 [SignPath.io](https://signpath.io/) 免費提供，certificate 由 [SignPath Foundation](https://signpath.org/) 提供。

官方 Windows release artifacts，也就是 portable ZIP、EXE installer 與 MSIX helper，會使用 GitHub Actions ([release workflow](.github/workflows/release.yml)) 從 [LocalSend repository](https://github.com/localsend/localsend) 的 source code 自動建置，並透過 SignPath 簽章。每一次 signing request 都會由下列 approver 手動核准。

只有 LocalSend 建置出的 binaries 會被簽章。與 app 一起打包的第三方 binaries 會依照其 upstream projects 提供的形式散布，不會另外套用 LocalSend signing。

已簽章的 Windows files 會顯示 **SignPath Foundation** 為 publisher，因為 certificate 屬於該 foundation，而不是 LocalSend project。

## 團隊角色

- Committers 與 reviewers: [@Tienisto](https://github.com/Tienisto)
- Approvers: [@Tienisto](https://github.com/Tienisto)

## 隱私

LocalSend 的 privacy policy 可在 [localsend.org/privacy](https://localsend.org/privacy) 查看。
