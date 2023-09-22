# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = 未在此網站上偵測到
content-blocking-cookies-blocking-trackers-label = 跨網站追蹤 Cookie
content-blocking-cookies-blocking-third-party-label = 第三方 Cookie
content-blocking-cookies-blocking-unvisited-label = 未造訪過網站的 Cookie
content-blocking-cookies-blocking-all-label = 所有 Cookie
content-blocking-cookies-view-first-party-label = 來自此網站
content-blocking-cookies-view-trackers-label = 跨網站追蹤 Cookie
content-blocking-cookies-view-third-party-label = 第三方 Cookie
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = 已允許
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = 已封鎖
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = 清除 { $domain } 的 cookie 例外規則
tracking-protection-icon-active = 封鎖社交媒體追蹤器、跨網站追蹤 Cookie 及數位指紋追蹤程式。
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = 已關閉針對此網站的加強型追蹤保護功能。
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = { -brand-short-name } 未在此頁面偵測到已知的追蹤元素。
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = 對 { $host } 的保護措施
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = 關閉 { $host } 的保護
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = 開啟 { $host } 的保護

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = 封鎖數位指紋追蹤程式
protections-blocking-cryptominers =
    .title = 封鎖加密貨幣採礦程式
protections-blocking-cookies-trackers =
    .title = 封鎖跨網站追蹤 Cookie
protections-blocking-cookies-third-party =
    .title = 封鎖第三方 Cookie
protections-blocking-cookies-all =
    .title = 封鎖所有 Cookie
protections-blocking-cookies-unvisited =
    .title = 封鎖來自未造訪過網站的 Cookie
protections-blocking-tracking-content =
    .title = 封鎖追蹤用內容
protections-blocking-social-media-trackers =
    .title = 封鎖社交媒體追蹤器
protections-not-blocking-fingerprinters =
    .title = 不封鎖數位指紋追蹤程式
protections-not-blocking-cryptominers =
    .title = 不封鎖加密貨幣採礦程式
protections-not-blocking-cookies-third-party =
    .title = 不封鎖第三方 Cookie
protections-not-blocking-cookies-all =
    .title = 不封鎖 Cookie
protections-not-blocking-cross-site-tracking-cookies =
    .title = 不封鎖跨網站追蹤 Cookie
protections-not-blocking-tracking-content =
    .title = 不封鎖追蹤用內容
protections-not-blocking-social-media-trackers =
    .title = 不封鎖社交媒體追蹤器

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter = 已封鎖 { $trackerCount } 個
    .tooltiptext = 自 { DATETIME($date, year: "numeric", month: "long", day: "numeric") } 起
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone = 自 { DATETIME($date, year: "numeric", month: "long") }起，{ -brand-short-name } 已封鎖超過 { $trackerCount } 組追蹤器
