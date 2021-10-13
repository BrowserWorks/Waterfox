# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-httpsonly-title-alert = 純 HTTPS 模式警示
about-httpsonly-title-connection-not-available = 無法進行安全連線
about-httpsonly-title-site-not-available = 無法使用安全網站
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-explanation-unavailable2 = 為了加強安全性，您開啟了純 HTTPS 模式，但 <em>{ $websiteUrl }</em> 的 HTTPS 版本無法使用。
about-httpsonly-explanation-question = 可能是什麼原因造成的？
about-httpsonly-explanation-nosupport = 很有可能只是網站不支援 HTTPS。
about-httpsonly-explanation-risk = 也可能是有人正打算攻擊您。若您還是要開啟此網站，就不該在網站中輸入密碼、E-Mail 帳號、信用卡資料等敏感性資訊。
about-httpsonly-explanation-continue = 若繼續，將暫時針對此網站關閉純 HTTPS 模式。
about-httpsonly-button-continue-to-site = 繼續前往 HTTP 網站
about-httpsonly-button-go-back = 回上一頁
about-httpsonly-link-learn-more = 了解更多…

## Suggestion Box that only shows up if a secure connection to www can be established
## Variables:
##   $websiteUrl (String) - Url of the website that can be securely loded with these alternatives. Example: example.com

about-httpsonly-suggestion-box-header = 可能有不同網址
about-httpsonly-suggestion-box-www-text = 此網站有個安全加密版本位於 <em>www.{ $websiteUrl }</em>，您可以改造訪此網頁，而不是目前的開啟的 <em>{ $websiteUrl }</em>。
about-httpsonly-suggestion-box-www-button = 前往 www.{ $websiteUrl }
