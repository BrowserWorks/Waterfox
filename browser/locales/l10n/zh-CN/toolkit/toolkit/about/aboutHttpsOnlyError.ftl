# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-httpsonly-insecure-title = 安全连接不可用
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-insecure-explanation-unavailable = 您正在以 HTTPS-Only 模式浏览，但 <em>{ $websiteUrl }</em> 无法提供安全的 HTTPS 版本。
about-httpsonly-insecure-explanation-reasons = 该网站很可能不支持 HTTPS，但也有可能是攻击者拦截了 HTTPS 版本。
about-httpsonly-insecure-explanation-exception = 虽然安全风险较低，但若您还是决定访问此网站的 HTTP 版本，则不应输入密码、邮箱或信用卡号等敏感信息。
about-httpsonly-button-make-exception = 接受风险并继续前往网站
about-httpsonly-title-alert = HTTPS-Only 模式警告
about-httpsonly-title-connection-not-available = 安全连接不可用
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-explanation-unavailable2 = 为增强安全性，您已启用 HTTPS-Only 模式，但 <em>{ $websiteUrl }</em> 的 HTTPS 版本不可用。
about-httpsonly-explanation-question = 可能是什么原因造成的？
about-httpsonly-explanation-nosupport = 该网站很可能根本不支持 HTTPS。
about-httpsonly-explanation-risk = 也可能是有人正企图攻击您。若您还是决定访问此网站的 HTTP 版本，则不应在网站中输入密码、邮箱或信用卡号等敏感信息。
about-httpsonly-explanation-continue = 若继续，将暂时对此网站关闭 HTTPS-Only 模式。
about-httpsonly-button-continue-to-site = 继续前往 HTTP 网站
about-httpsonly-button-go-back = 返回
about-httpsonly-link-learn-more = 详细了解…

## Suggestion Box that only shows up if a secure connection to www can be established
## Variables:
##   $websiteUrl (String) - Url of the website that can be securely loded with these alternatives. Example: example.com

about-httpsonly-suggestion-box-header = 可能另有网址
about-httpsonly-suggestion-box-www-text = 此网站存在安全版本：<em>www.{ $websiteUrl }</em>。您可以选择访问此网页，而非 <em>{ $websiteUrl }</em>。
about-httpsonly-suggestion-box-www-button = 前往 www.{ $websiteUrl }
