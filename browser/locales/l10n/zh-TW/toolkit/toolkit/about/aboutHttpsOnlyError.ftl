# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-httpsonly-insecure-title = 無法進行安全連線
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-insecure-explanation-unavailable = 您正在以純 HTTPS 模式上網，但 <em>{ $websiteUrl }</em> 無法提供安全的 HTTPS 版本。
about-httpsonly-insecure-explanation-reasons = 最有可能是此網站並不支援 HTTPS，但也有可能是有其它攻擊者封鎖了 HTTPS 版本。
about-httpsonly-insecure-explanation-exception = 雖然安全性風險並不高，但若您還是想要開啟此網站的 HTTP 版本，就不該輸入密碼、E-Mail 帳號、信用卡資料等敏感資料。
about-httpsonly-button-make-exception = 接受風險並繼續前往網站
about-httpsonly-title-alert = 純 HTTPS 模式警示
about-httpsonly-title-connection-not-available = 無法進行安全連線
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
