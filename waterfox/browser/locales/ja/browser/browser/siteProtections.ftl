# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = このサイトでは未検出
content-blocking-cookies-blocking-trackers-label = クロスサイトトラッキング Cookie
content-blocking-cookies-blocking-third-party-label = サードパーティ Cookie
content-blocking-cookies-blocking-unvisited-label = 未訪問サイトの Cookie
content-blocking-cookies-blocking-all-label = すべての Cookie
content-blocking-cookies-view-first-party-label = このサイトから
content-blocking-cookies-view-trackers-label = クロスサイトトラッキング Cookie
content-blocking-cookies-view-third-party-label = サードパーティ Cookie
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = 許可済み
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = ブロック済み
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = { $domain } の Cookie 例外を消去します
tracking-protection-icon-active = ソーシャルメディアトラッカー、クロスサイトトラッキング Cookie、フィンガープリント採取をブロック中です。
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = 強化型トラッキング防止機能はこのサイトでオフです。
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = このページで { -brand-short-name } に検出されたトラッカーはありません。
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = { $host } の保護状況

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = ブロックしたフィンガープリント採取
protections-blocking-cryptominers =
    .title = ブロックした暗号通貨マイニング
protections-blocking-cookies-trackers =
    .title = ブロックしたクロスサイトトラッキング Cookie
protections-blocking-cookies-third-party =
    .title = ブロックしたサードパーティ Cookie
protections-blocking-cookies-all =
    .title = ブロックしたすべての Cookie
protections-blocking-cookies-unvisited =
    .title = ブロックした未訪問サイトの Cookie
protections-blocking-tracking-content =
    .title = ブロックしたトラッキングコンテンツ
protections-blocking-social-media-trackers =
    .title = ブロックしたソーシャルメディアトラッカー
protections-not-blocking-fingerprinters =
    .title = 未ブロックのフィンガープリント採取
protections-not-blocking-cryptominers =
    .title = 未ブロックの暗号通貨マイニング
protections-not-blocking-cookies-third-party =
    .title = 未ブロックのサードパーティ Cookie
protections-not-blocking-cookies-all =
    .title = 未ブロックの Cookie
protections-not-blocking-cross-site-tracking-cookies =
    .title = 未ブロックのクロスサイトトラッキング Cookie
protections-not-blocking-tracking-content =
    .title = 未ブロックのトラッキングコンテンツ
protections-not-blocking-social-media-trackers =
    .title = 未ブロックのソーシャルメディアトラッカー

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter = { $trackerCount } 個ブロック
    .tooltiptext = { DATETIME($date, year: "numeric", month: "long", day: "numeric") } から
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone = { DATETIME($date, year: "numeric", month: "long") } 以降、{ -brand-short-name } は { $trackerCount } 個以上のトラッカーをブロックしました
