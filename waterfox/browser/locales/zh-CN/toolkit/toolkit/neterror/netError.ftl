# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = 页面加载出错
certerror-page-title = 警告：面临潜在的安全风险
certerror-sts-page-title = 未连接：有安全风险
neterror-blocked-by-policy-page-title = 页面已封锁
neterror-captive-portal-page-title = 请登录网络
neterror-dns-not-found-title = 找不到服务器
neterror-malformed-uri-page-title = 无效网址

## Error page actions

neterror-advanced-button = 高级…
neterror-copy-to-clipboard-button = 复制文本到剪贴板
neterror-learn-more-link = 详细了解…
neterror-open-portal-login-page-button = 打开网络登录页面
neterror-override-exception-button = 接受风险并继续
neterror-pref-reset-button = 恢复默认设置
neterror-return-to-previous-page-button = 后退
neterror-return-to-previous-page-recommended-button = 返回上一页（推荐）
neterror-try-again-button = 重试
neterror-add-exception-button = 总是继续打开此网站
neterror-settings-button = 更改 DNS 设置
neterror-view-certificate-link = 查看证书
neterror-trr-continue-this-time = 此次仍继续
neterror-disable-native-feedback-warning = 总是继续打开

##

neterror-pref-reset = 看来可能是您的网络安全设置造成了此问题。您想还原到默认设置吗？
neterror-error-reporting-automatic = 报告此类错误，帮助 { -vendor-short-name } 识别与拦截恶意网站

## Specific error messages

neterror-generic-error = { -brand-short-name } 因某些不明原因无法加载此页面。
neterror-load-error-try-again = 此站点暂时无法使用或者太过忙碌。请过几分钟后再试。
neterror-load-error-connection = 如果您无法加载任何网页，请检查您计算机的网络连接状态。
neterror-load-error-firewall = 如果您的计算机或网络受到防火墙或者代理服务器的保护，请确认 { -brand-short-name } 已被授权访问网络。
neterror-captive-portal = 您必须先登录此网络才能访问互联网。
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = 您是要打开 <a data-l10n-name="website">{ $hostAndPath }</a> 吗？
neterror-dns-not-found-hint-header = <strong>若您确认输入的是正确网址，可以：</strong>
neterror-dns-not-found-hint-try-again = 稍后再试
neterror-dns-not-found-hint-check-network = 检查您的网络连接
neterror-dns-not-found-hint-firewall = 检查 { -brand-short-name } 是否有联网权限（可能已接入网络，但被防火墙阻止）

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = { -brand-short-name } 无法通过可信 DNS 解析器保护您对本网址的请求。原因如下：
neterror-dns-not-found-trr-third-party-warning2 = 您可以继续使用默认 DNS 解析器，但第三方将有可能得知您访问过哪些网站。
neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name } 无法连接到 { $trrDomain }。
neterror-dns-not-found-trr-only-timeout = 连接到 { $trrDomain } 的时间超过预期。
neterror-dns-not-found-trr-offline = 您未连接到互联网。
neterror-dns-not-found-trr-unknown-host2 = { $trrDomain } 找不到此网站。
neterror-dns-not-found-trr-server-problem = { $trrDomain } 出现问题。
neterror-dns-not-found-bad-trr-url = 无效网址。
neterror-dns-not-found-trr-unknown-problem = 未知问题。

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name } 无法通过可信 DNS 解析器保护您对本网址的请求。原因如下：
neterror-dns-not-found-native-fallback-heuristic = 您的网络已禁用基于 HTTPS 的 DNS。
neterror-dns-not-found-native-fallback-not-confirmed2 = { -brand-short-name } 无法连接至 { $trrDomain }。

##

neterror-file-not-found-filename = 请检查文件名是否大小写输错，或者有其他输入错误。
neterror-file-not-found-moved = 请检查文件是否已被移动，重命名或删除。
neterror-access-denied = 文件可能已被删除、移动，或者因文件权限问题被拒绝访问。
neterror-unknown-protocol = 您可能需要安装其他软件才能打开此网址。
neterror-redirect-loop = 有时候禁用或拒绝接受 Cookie 会导致此问题。
neterror-unknown-socket-type-psm-installed = 请检查您的系统是否安装了个人安全管理器（PSM）。
neterror-unknown-socket-type-server-config = 这可能是由服务器端的非标准配置所致。
neterror-not-cached-intro = 您请求的文档已无法在 { -brand-short-name } 的缓存中找到。
neterror-not-cached-sensitive = 出于安全考虑，{ -brand-short-name } 不会自动重新获取敏感文档。
neterror-not-cached-try-again = 您可以点击“重试”来重新请求从网站获取该文档。
neterror-net-offline = 请按“重试”切换到联网模式并重新加载此页面。
neterror-proxy-resolve-failure-settings = 请检查浏览器的代理服务器设置是否正确。
neterror-proxy-resolve-failure-connection = 请检查确认您的计算机能正常连上网。
neterror-proxy-resolve-failure-firewall = 如果您的计算机或网络受到防火墙或者代理服务器的保护，请确认 { -brand-short-name } 已被授权访问网络。
neterror-proxy-connect-failure-settings = 请检查浏览器的代理服务器设置是否正确。
neterror-proxy-connect-failure-contact-admin = 请联系您的网络管理员以确认代理服务器工作正常。
neterror-content-encoding-error = 建议向此网站的管理员反馈这个问题。
neterror-unsafe-content-type = 建议向此网站的管理员反馈这个问题。
neterror-nss-failure-not-verified = 由于不能验证所收到的数据是否可信，无法显示您想要查看的页面。
neterror-nss-failure-contact-website = 建议向此网站的管理员反馈这个问题。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = { -brand-short-name } 检测到潜在的安全威胁，因此没有继续访问 <b>{ $hostname }</b>。若您访问此网站，攻击者可能会尝试窃取您的密码、电子邮件、信用卡等信息。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = { -brand-short-name } 检测到潜在的安全威胁，并因 <b>{ $hostname }</b> 要求安全连接而没有继续。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = { -brand-short-name } 检测到问题而没有继续连接 <b>{ $hostname }</b>。可能是该网站配置有误，或者您的计算机时钟设置有误。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> 很像是一个安全（连接加密）的网站，但我们未能与它建立安全连接。这个问题是由 <b>{ $mitm }</b> 所造成，它是您的计算机或您所在网络中的软件。
neterror-corrupted-content-intro = 由于检测到在数据传输过程中存在错误，无法显示您正要查看的页面。
neterror-corrupted-content-contact-website = 建议向此网站的管理员反馈这个问题。
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = 高级信息: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> 使用了过时的安全技术，较容易遭受攻击。攻击者可以轻易窃取您的信息。该网站的管理员修正服务器后您才能访问该网站。
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = 错误代码：NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = 您计算机上的时间是 { DATETIME($now, dateStyle: "medium") }，{ -brand-short-name } 无法在这个设定的时间下进行安全连接。要访问 <b>{ $hostname }</b>，请在您的系统设置中确认当前的日期、时间、时区设置是否正确，然后重新加载 <b>{ $hostname }</b>。
neterror-network-protocol-error-intro = 您尝试查看的页面无法显示，因为检测到了网络协议中的错误。
neterror-network-protocol-error-contact-website = 建议向此网站的管理员反馈这个问题。
certerror-expired-cert-second-para = 很可能该网站的证书已过期，因而阻碍 { -brand-short-name } 安全地连接。如果您继续访问该网站，攻击者可能尝试窃取您的密码、电子邮件或信用卡等信息。
certerror-expired-cert-sts-second-para = 很可能该网站的证书已过期，因而阻碍 { -brand-short-name } 安全地连接。
certerror-what-can-you-do-about-it-title = 您可以做什么？
certerror-unknown-issuer-what-can-you-do-about-it-website = 这个问题大多与网站有关，无法通过您的操作解决。
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = 如果您是在使用公司网络或某些防病毒软件时遇到此问题，可考虑联系客服（技术支持）以寻求帮助。您也可以向网站管理员告知此问题。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = 您的计算机时钟目前设置为 { DATETIME($now, dateStyle: "medium") }。请确保您的计算机在系统设置中已设置了正确的日期、时间和时区，然后刷新 <b>{ $hostname }</b>。
certerror-expired-cert-what-can-you-do-about-it-contact-website = 如果您的时钟已设置正确的时间，则此网站可能存在配置错误，您无法解决此问题。您可以向网站管理员反馈该问题。
certerror-bad-cert-domain-what-can-you-do-about-it = 这个问题大多与网站有关，无法通过您的操作解决。您可以向此网站的管理者反馈此问题。
certerror-mitm-what-can-you-do-about-it-antivirus = 如果您的防病毒软件包含扫描加密连接的功能（名称通常为“Web 扫描”或“HTTPS 扫描”），您该考虑禁用该功能。若上述操作无效，您可以尝试卸载并重新安装该防病毒软件。
certerror-mitm-what-can-you-do-about-it-corporate = 如果您在使用公司网络，可以联系您的 IT 部门以寻求帮助。
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = 如果您并不熟悉 <b>{ $mitm }</b>，这可能是一起攻击，您不应该继续访问该网站。
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = 如果您并不熟悉 <b>{ $mitm }</b>，这可能是一起攻击，无法通过您的操作来访问此网站。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> 启用了被称为 HTTP 严格传输安全（HSTS）的安全策略，{ -brand-short-name } 只能与其建立安全连接。您无法为此网站添加例外，以访问此网站。
