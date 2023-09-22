# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = 此网站上未检出
content-blocking-cookies-blocking-trackers-label = 跨站跟踪性 Cookie
content-blocking-cookies-blocking-third-party-label = 第三方 Cookie
content-blocking-cookies-blocking-unvisited-label = 未访问网站 Cookie
content-blocking-cookies-blocking-all-label = 所有 Cookie
content-blocking-cookies-view-first-party-label = 来自此网站
content-blocking-cookies-view-trackers-label = 跨站跟踪性 Cookie
content-blocking-cookies-view-third-party-label = 第三方 Cookie
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = 已允许
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = 已拦截
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = 清除对 { $domain } 的 Cookie 例外
tracking-protection-icon-active = 拦截社交媒体跟踪器、跨站跟踪性 Cookie 和数字指纹跟踪程序。
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = 已关闭此网站上的增强型跟踪保护。
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = 此页面上未检测到 { -brand-short-name } 已知的跟踪器。
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = 保护状态：{ $host }
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = 禁用对 { $host } 的保护
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = 启用对 { $host } 的保护

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = 已拦截数字指纹跟踪程序
protections-blocking-cryptominers =
    .title = 已拦截加密货币挖矿程序
protections-blocking-cookies-trackers =
    .title = 已拦截跨站跟踪性 Cookie
protections-blocking-cookies-third-party =
    .title = 已拦截第三方 Cookie
protections-blocking-cookies-all =
    .title = 已拦截所有 Cookie
protections-blocking-cookies-unvisited =
    .title = 已拦截未访问网站 Cookie
protections-blocking-tracking-content =
    .title = 已拦截跟踪性内容
protections-blocking-social-media-trackers =
    .title = 已拦截社交媒体跟踪器
protections-not-blocking-fingerprinters =
    .title = 未拦截数字指纹跟踪程序
protections-not-blocking-cryptominers =
    .title = 未拦截加密货币挖矿程序
protections-not-blocking-cookies-third-party =
    .title = 未拦截第三方 Cookie
protections-not-blocking-cookies-all =
    .title = 未拦截 Cookie
protections-not-blocking-cross-site-tracking-cookies =
    .title = 未拦截跨站跟踪性 Cookie
protections-not-blocking-tracking-content =
    .title = 未拦截跟踪性内容
protections-not-blocking-social-media-trackers =
    .title = 未拦截社交媒体跟踪器

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter = 已拦截 { $trackerCount } 个
    .tooltiptext = 自{ DATETIME($date, year: "numeric", month: "long", day: "numeric") }起
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone = 自{ DATETIME($date, year: "numeric", month: "long") }起，{ -brand-short-name } 拦截了超过 { $trackerCount } 个跟踪器
