# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } 用了無效的安全憑證。

cert-error-mitm-intro = 網站會透過憑證機構簽發的憑證來驗明正身。

cert-error-mitm-mozilla = { -brand-short-name } 是由非營利的 Mozilla 所提供支援的。Mozilla 管理一組完全開放的憑證機構（CA）儲存空間。該儲存空間可確保憑證機構遵循最佳的作業方式，以確保使用者的安全。

cert-error-mitm-connection = { -brand-short-name } 使用 Mozilla 的憑證機構儲存空間來檢查連線是否安全，而不使用使用者作業系統上的內建憑證。所以如果您的防毒軟體或網路使用不在 Mozilla 憑證機構清單當中的機構所簽發的憑證來攔截網路流量，連線就會被視為不安全。

cert-error-trust-unknown-issuer-intro = 有心人士可能正在嘗試將別的網站偽裝成您想造訪的網站，不應繼續開啟。

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = 網站會透過憑證來證明自己的身分。因為簽發者未知、憑證是自簽憑證，或伺服器並未送出正確的中介憑證的關係，{ -brand-short-name } 無法信任 { $hostname }。

cert-error-trust-cert-invalid = 該憑證未受信任，因為是由無效憑證機構的憑證簽發的。

cert-error-trust-untrusted-issuer = 該憑證未受信任，因為簽發者的憑證未被信任。

cert-error-trust-signature-algorithm-disabled = 由於未經安全的簽章演算法進行簽署，無法信任此憑證。

cert-error-trust-expired-issuer = 該憑證未受信任，因為簽發者的憑證已過期。

cert-error-trust-self-signed = 該憑證未受信任，因為憑證是自己簽署的憑證。

cert-error-trust-symantec = 由於憑證簽發組織過去未遵循安全的運作方式，由 GeoTrust、RapidSSL、Symantec、Thawte 及 VeriSign 簽發的憑證皆不再被信任。

cert-error-untrusted-default = 憑證不是來自受信任的來源。

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = 網站會透過憑證來證明自己的身分。因為伺服器送出不屬於 { $hostname } 的憑證的關係，{ -brand-short-name } 不信任這個網站。

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = 網站會透過憑證來證明自己的身分。因為伺服器送出不屬於 { $hostname } 的憑證的關係，{ -brand-short-name } 不信任這個網站。該憑證只對 <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a> 有效。

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = 網站會透過憑證來證明自己的身分。因為伺服器送出不屬於 { $hostname } 的憑證的關係，{ -brand-short-name } 不信任這個網站。該憑證只對 { $alt-name } 有效。

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = 網站會透過憑證來證明自己的身分。因為伺服器送出不屬於 { $hostname } 的憑證的關係，{ -brand-short-name } 不信任這個網站。該憑證僅對下列網域名稱有效: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = 網站會透過憑證來證明自己的身分。每一張憑證都有效期限制，而 { $hostname } 的憑證已於 { $not-after-local-time } 過期。

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = 網站會透過憑證來證明自己的身分。每一張憑證都有效期限制，而 { $hostname } 的憑證於 { $not-before-local-time } 之後才會生效。

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = 錯誤碼: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = 網站會透過憑證機構簽發的憑證來驗明正身。大多數瀏覽器已不再信任 GeoTrust、RapidSSL、Symantec、Thawte 及 VeriSign 所簽發的憑證。{ $hostname } 使用來自這些機構簽發的憑證，故無法確認該網站的身分。

cert-error-symantec-distrust-admin = 您可通知網站管理員這個問題。

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = 憑證鍊:

open-in-new-window-for-csp-or-xfo-error = 用新視窗開啟網站

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = 為了保護您的安全，{ $hostname } 不允許在被別的網站嵌入時，讓  { -brand-short-name } 顯示頁面內容。若要見到此頁面，請用新視窗開啟。

## Messages used for certificate error titles

connectionFailure-title = 連線失敗
deniedPortAccess-title = 此網址已被限制
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = 呃…找不到這個網站。
fileNotFound-title = 找不到檔案
fileAccessDenied-title = 對檔案的存取要求已被拒絕
generic-title = 噢！
captivePortal-title = 登入到網路
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = 呃…這個網址好像有錯。
netInterrupt-title = 連線中斷
notCached-title = 文件已過期
netOffline-title = 離線模式
contentEncodingError-title = 內容編碼錯誤
unsafeContentType-title = 不安全的檔案格式
netReset-title = 連線被重設
netTimeout-title = 連線已逾時
unknownProtocolFound-title = 無法理解的網址
proxyConnectFailure-title = Proxy 伺服器拒絕連線
proxyResolveFailure-title = 找不到 Proxy 伺服器
redirectLoop-title = 頁面重新導向不正確
unknownSocketType-title = 伺服器回應錯誤
nssFailure2-title = 安全連線失敗
csp-xfo-error-title = { -brand-short-name } 無法開啟此網頁
corruptedContentError-title = 內容毀損錯誤
remoteXUL-title = 遠端 XUL
sslv3Used-title = 無法安全地連線
inadequateSecurityError-title = 您的連線並不安全
blockedByPolicy-title = 已封鎖頁面
clockSkewError-title = 您的電腦時間錯誤
networkProtocolError-title = 網路通訊協定錯誤
nssBadCert-title = 警告: 本網站可能有安全性風險
nssBadCert-sts-title = 未連線: 潛在的安全性問題
certerror-mitm-title = 有軟體造成 { -brand-short-name } 無法與此網站建立安全連線
