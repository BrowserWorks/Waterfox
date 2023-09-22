# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = 頁面載入發生問題
certerror-page-title = 警告: 本網站可能有安全性風險
certerror-sts-page-title = 未連線: 潛在的安全性問題
neterror-blocked-by-policy-page-title = 已封鎖頁面
neterror-captive-portal-page-title = 登入到網路
neterror-dns-not-found-title = 找不到伺服器
neterror-malformed-uri-page-title = 網址無效

## Error page actions

neterror-advanced-button = 進階…
neterror-copy-to-clipboard-button = 將文字複製到剪貼簿
neterror-learn-more-link = 更多資訊…
neterror-open-portal-login-page-button = 開啟網路登入頁面
neterror-override-exception-button = 接受風險並繼續
neterror-pref-reset-button = 還原預設設定
neterror-return-to-previous-page-button = 返回
neterror-return-to-previous-page-recommended-button = 返回上一頁（建議）
neterror-try-again-button = 重試
neterror-add-exception-button = 總是繼續開啟此網站
neterror-settings-button = 更改 DNS 設定
neterror-view-certificate-link = 檢視憑證
neterror-trr-continue-this-time = 這次先繼續
neterror-disable-native-feedback-warning = 總是繼續

##

neterror-pref-reset = 看來可能是您的網路安全設定造成此問題，您是否要恢復預設設定值？
neterror-error-reporting-automatic = 回報這類的錯誤，幫助 { -vendor-short-name } 找出並封鎖惡意網站

## Specific error messages

neterror-generic-error = { -brand-short-name } 因為某些原因無法載入此網頁。
neterror-load-error-try-again = 該網站可能暫時無法使用或太過忙碌，請過幾分鐘後再試試。
neterror-load-error-connection = 若無法載入任何網站，請檢查您的網路連線狀態。
neterror-load-error-firewall = 若電腦或網路被防火牆或 Proxy 保護，請確定 { -brand-short-name } 被允許存取網路。
neterror-captive-portal = 您必須先登入才能存取網際網路。
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = 您的意思是要開啟 <a data-l10n-name="website">{ $hostAndPath }</a> 嗎？
neterror-dns-not-found-hint-header = <strong>若您確認輸入的網址是正確的，可以：</strong>
neterror-dns-not-found-hint-try-again = 稍後再試
neterror-dns-not-found-hint-check-network = 檢查網際網路連線是否正常
neterror-dns-not-found-hint-firewall = 檢查 { -brand-short-name } 是否有權限開啟網頁（可能已經連上網路，但被防火牆阻擋）

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = { -brand-short-name } 無法透過信任的 DNS 解析器保護您對本網址的瀏覽請求。原因如下：
neterror-dns-not-found-trr-third-party-warning2 = 您可以繼續使用預設 DNS 解析器，但第三方仍可能得知您造訪過哪些網站。
neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name } 無法連線到 { $trrDomain }。
neterror-dns-not-found-trr-only-timeout = 連線到 { $trrDomain } 的時間比預期得久。
neterror-dns-not-found-trr-offline = 您未連線到網際網路。
neterror-dns-not-found-trr-unknown-host2 = { $trrDomain } 找不到此網站。
neterror-dns-not-found-trr-server-problem = { $trrDomain } 發生問題。
neterror-dns-not-found-bad-trr-url = 網址無效。
neterror-dns-not-found-trr-unknown-problem = 發生未預期的問題。

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name } 無法透過信任的 DNS 解析器保護您對本網址的瀏覽請求。原因如下：
neterror-dns-not-found-native-fallback-heuristic = 您的網路已停用 DNS over HTTPS。
neterror-dns-not-found-native-fallback-not-confirmed2 = { -brand-short-name } 無法連線到 { $trrDomain }。

##

neterror-file-not-found-filename = 請檢查檔名是否有大小寫錯誤、拼錯字。
neterror-file-not-found-moved = 請檢查檔案是否已被移動、改名或刪除。
neterror-access-denied = 可能是檔案被移走、移除，或存取權限不正確，造成無法存取。
neterror-unknown-protocol = 您可能需要安裝其他軟體才能開啟此網址。
neterror-redirect-loop = 有時候停用或拒絕接受 Cookie 會造成此問題。
neterror-unknown-socket-type-psm-installed = 請確定電腦已安裝個人安全管理員 (Personal Security Manager)。
neterror-unknown-socket-type-server-config = 可能是伺服器上的非標準設定所造成的。
neterror-not-cached-intro = 您所請求的文件已不存在於 { -brand-short-name } 的快取當中。
neterror-not-cached-sensitive = 為了您的安全，{ -brand-short-name } 將不會自動重新請求敏感文件。
neterror-not-cached-try-again = 請點下重試以重新向網站請求取得文件。
neterror-net-offline = 請按下「重試」以切換到連線模式並重新載入頁面。
neterror-proxy-resolve-failure-settings = 請檢查 Proxy 設定是否正確。
neterror-proxy-resolve-failure-connection = 請檢查您的網路連線狀態。
neterror-proxy-resolve-failure-firewall = 若電腦或網路被防火牆或 Proxy 保護，請確定 { -brand-short-name } 被允許存取網路。
neterror-proxy-connect-failure-settings = 請檢查 Proxy 設定是否正確。
neterror-proxy-connect-failure-contact-admin = 與您的網路管理員聯絡，確定 Proxy 伺服器正常運作。
neterror-content-encoding-error = 請向網站擁有者回報此問題。
neterror-unsafe-content-type = 請向網站擁有者回報此問題。
neterror-nss-failure-not-verified = 因為無法驗證已接收資料的真實性，無法顯示您嘗試檢視的頁面。
neterror-nss-failure-contact-website = 請向網站擁有者回報此問題。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = { -brand-short-name } 偵測到可能有安全性風險，並未連線至 <b>{ $hostname }</b>。若繼續造訪此網站，攻擊者可能會嘗試偷走您的密碼、電子郵件或信用卡資料等個資。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = { -brand-short-name } 偵測到潛在的安全性威脅，並未連線到 <b>{ $hostname }</b>。此網站必須使用安全性連線。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = { -brand-short-name } 偵測到潛在的安全性威脅，並未連線到 <b>{ $hostname }</b>。此網站可能有設定問題，或您的電腦上的時間不正確。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> 應該是一個安全的網站，但無法建立安全連線。這個問題是由 <b>{ $mitm }</b> 造成的，可能是來自您的電腦或您的所在網路中的軟體。
neterror-corrupted-content-intro = 因為在資料傳輸過程當中偵測到錯誤，無法顯示您正要檢視的頁面。
neterror-corrupted-content-contact-website = 請通知網站管理者以讓他們知道這個問題。
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = 進階資訊: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> 使用過時的安全性技術，容易遭受攻擊。攻擊者可以簡單地得知您認為安全的資訊。網站管理員修正伺服器設定後您才能連線至此網站。
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = 錯誤代碼: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = 您的電腦認為目前時間為 { DATETIME($now, dateStyle: "medium") }，不讓 { -brand-short-name } 建立安全連線。若要造訪 <b>{ $hostname }</b>，請到系統設定中確認日期、時間、時區設定是否正確，然後重新載入 <b>{ $hostname }</b>。
neterror-network-protocol-error-intro = 因為偵測到網路通訊協定中的問題，無法顯示您嘗試檢視的頁面。
neterror-network-protocol-error-contact-website = 請聯絡網站管理員來解決這個問題。
certerror-expired-cert-second-para = 可能是網站的憑證已經過期，讓 { -brand-short-name } 無法安全地連線。若您造訪此網站，攻擊者可能嘗試偷走您的密碼、電子郵件、信用卡資料等個人資訊。
certerror-expired-cert-sts-second-para = 可能是網站的憑證已經過期，讓 { -brand-short-name } 無法安全地連線。
certerror-what-can-you-do-about-it-title = 您可以做什麼？
certerror-unknown-issuer-what-can-you-do-about-it-website = 這個問題最有可能是由於網站端的設定不正確，無法由您調整設定解決。
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = 若目前連線到企業內部網路，或有使用防毒軟體，請洽詢技術支援團隊。也可以通知網站管理員處理這個問題。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = 您目前的電腦時間設定為 { DATETIME($now, dateStyle: "medium") }。請到系統設定中確認此日期、時間、時區是否正確，然後重新載入 <b>{ $hostname }</b>。
certerror-expired-cert-what-can-you-do-about-it-contact-website = 若您的時間是正確的，可能是網站伺服器設定有誤，沒有辦法由您解決這個問題，請通知網站管理員這個問題。
certerror-bad-cert-domain-what-can-you-do-about-it = 這個問題最有可能是由於網站端的設定不正確，無法由您調整設定解決。請通知網站管理員處理。
certerror-mitm-what-can-you-do-about-it-antivirus = 若您的防毒軟體包含掃描加密連線（或稱為「網頁掃描」、「HTTPS 掃描」），請關閉該功能。若這樣做仍然無效，您可以試著移除並重新安裝防毒軟體。
certerror-mitm-what-can-you-do-about-it-corporate = 若您在公司網路中，請聯絡您的 IT 部門。
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = 若您不了解 <b>{ $mitm }</b>，這可能是一場攻擊，您不該繼續前往該網站。
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = 若您不了解 <b>{ $mitm }</b>，這可能是一場攻擊，您無法再做什麼以前往該網站。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> 有一條稱為 HTTP Strict Transport Security (HSTS) 的安全性政策，讓 { -brand-short-name } 僅能與其進行安全連線。您無法加入例外，手動排除此政策。
