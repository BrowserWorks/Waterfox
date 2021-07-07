# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } 使用了无效的安全证书。
cert-error-mitm-intro = 各个网站通过证书证明自己的身份，而证书由受信任的数字证书颁发机构颁发。
cert-error-mitm-mozilla = { -brand-short-name } 由非营利的 Mozilla 提供支持。Mozilla 管理一组完全开放的数字证书认证机构（CA）存储库。该存储库帮助确保这些数字证书认证机构遵循最佳实践，以保障用户的安全。
cert-error-mitm-connection = { -brand-short-name } 使用 Mozilla 的数字证书认证机构存储库来验证连接是否安全，而非用户操作系统所提供的证书库。因此，如果您的防病毒软件或网络使用不在 Mozilla 数字证书认证机构列表中的机构所签发的证书来拦截网络流量，该连接被视为不安全。
cert-error-trust-unknown-issuer-intro = 可能有人试图冒充该网站，您不应该继续访问。
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = 各个网站通过证书证明自己的身份。{ -brand-short-name } 不信任 { $hostname }，因其证书颁发者未知、证书为自签名的，或者服务器未发送正确的中间证书。
cert-error-trust-cert-invalid = 该证书不被信任，因为它由无效的 CA 证书颁发者颁发。
cert-error-trust-untrusted-issuer = 该证书因为其颁发者证书不受信任而不被信任。
cert-error-trust-signature-algorithm-disabled = 该证书不被信任，因为证书签名所使用的签名算法因不安全已被禁用。
cert-error-trust-expired-issuer = 该证书因为其颁发者证书已过期而不被信任。
cert-error-trust-self-signed = 该证书因为其自签名而不被信任。
cert-error-trust-symantec = 由 GeoTrust、RapidSSL、Symantec、Thawte 以及 VeriSign 颁发的证书已不再被认为安全，因为这些证书颁发机构过往未遵循安全准则。
cert-error-untrusted-default = 该证书出自不受信任的来源。
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = 各个网站通过证书证明自己的身份。{ -brand-short-name } 不能信任此网站，因为它使用的证书对 { $hostname } 无效。
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = 各个网站通过证书证明自己的身份。{ -brand-short-name } 不能信任此网站，它使用的证书对 { $hostname } 无效。 此证书仅对 <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a> 有效。
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = 各个网站通过证书证明自己的身份。{ -brand-short-name } 不能信任此网站，它使用的证书对 { $hostname } 无效。 此证书仅对 { $alt-name } 有效。
# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = 各个网站通过证书证明自己的身份。{ -brand-short-name } 不能信任此网站，它使用的证书对 { $hostname } 无效。该证书只适用于下列名称： { $subject-alt-names }
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = 各个网站通过证书证明自己的身份，它们在设定的时间段内有效。{ $hostname } 的证书已于 { $not-after-local-time } 过期。
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = 各个网站通过证书证明自己的身份，它们在设定的时间段内有效。{ $hostname } 的证书将生效于 { $not-before-local-time }。
# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = 错误代码：<a data-l10n-name="error-code-link">{ $error }</a>
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = 各个网站通过证书证明自己的身份，而证书由受信任的数字证书颁发机构颁发。大多数浏览器已不再信任由 GeoTrust、RapidSSL、Symantec、Thawte 以及 VeriSign 颁发的证书。{ $hostname } 使用了由上述机构之一颁发的证书，因而网站身份无法证实。
cert-error-symantec-distrust-admin = 您可以向网站管理员反馈此问题。
# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP 严格传输安全（HSTS）：{ $hasHSTS }
# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP 公钥固定：{ $hasHPKP }
cert-error-details-cert-chain-label = 证书链：
open-in-new-window-for-csp-or-xfo-error = 在新窗口中打开网站
# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = 为了保护您的安全，{ $hostname } 将不允许 { -brand-short-name } 显示嵌入了其他网站的页面。要查看此页面，请在新窗口中打开。

## Messages used for certificate error titles

connectionFailure-title = 连接失败
deniedPortAccess-title = 此网址已被限制
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = 呃…找不到此网站。
fileNotFound-title = 找不到文件
fileAccessDenied-title = 对该文件的访问请求被拒绝
generic-title = 哎呀。
captivePortal-title = 请登录网络
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = 呃…这个网址好像有错。
netInterrupt-title = 连接中断
notCached-title = 文档已过期
netOffline-title = 脱机模式
contentEncodingError-title = 内容编码错误
unsafeContentType-title = 不安全的文件类型
netReset-title = 连接被重置
netTimeout-title = 连接超时
unknownProtocolFound-title = 无法理解该网址
proxyConnectFailure-title = 代理服务器拒绝连接
proxyResolveFailure-title = 无法找到代理服务器
redirectLoop-title = 此页面不能正确地重定向
unknownSocketType-title = 意外的服务器响应
nssFailure2-title = 建立安全连接失败
csp-xfo-error-title = { -brand-short-name } 无法打开此页面
corruptedContentError-title = 内容损坏错误
remoteXUL-title = 远程 XUL
sslv3Used-title = 无法安全地连接
inadequateSecurityError-title = 您的连接不安全
blockedByPolicy-title = 页面已封锁
clockSkewError-title = 您的计算机时间有误
networkProtocolError-title = 网络协议错误
nssBadCert-title = 警告：面临潜在的安全风险
nssBadCert-sts-title = 未连接：有潜在的安全问题
certerror-mitm-title = 有软件正在阻止 { -brand-short-name } 安全地连接至此网站
