# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = 이 사이트에서 감지되지 않음
content-blocking-cookies-blocking-trackers-label = 교차 사이트 추적 쿠키
content-blocking-cookies-blocking-third-party-label = 제3자 쿠키
content-blocking-cookies-blocking-unvisited-label = 방문하지 않은 사이트 쿠키
content-blocking-cookies-blocking-all-label = 모든 쿠키
content-blocking-cookies-view-first-party-label = 이 사이트에서
content-blocking-cookies-view-trackers-label = 교차 사이트 추적 쿠키
content-blocking-cookies-view-third-party-label = 제3자 쿠키
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = 허용
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = 차단
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = { $domain }에 대한 쿠키 예외 지우기
tracking-protection-icon-active = 소셜 미디어 추적기, 교차 사이트 추적 쿠키 및 디지털 지문을 차단합니다.
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = 이 사이트에 향상된 추적 방지 기능이 꺼져 있습니다.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = 이 페이지에서 { -brand-short-name }에 알려진 추적기가 감지되지 않았습니다.
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = { $host }에 대한 보호
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = { $host }에 대한 보호 비활성화
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = { $host }에 대한 보호 활성화

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = 디지털 지문 차단됨
protections-blocking-cryptominers =
    .title = 암호화폐 채굴기 차단됨
protections-blocking-cookies-trackers =
    .title = 교차 사이트 추적 쿠키 차단됨
protections-blocking-cookies-third-party =
    .title = 제3자 쿠키 차단됨
protections-blocking-cookies-all =
    .title = 모든 쿠키 차단됨
protections-blocking-cookies-unvisited =
    .title = 방문하지 않은 사이트 쿠키 차단됨
protections-blocking-tracking-content =
    .title = 추적 콘텐츠 차단됨
protections-blocking-social-media-trackers =
    .title = 소셜 미디어 추적기 차단됨
protections-not-blocking-fingerprinters =
    .title = 디지털 지문 차단하지 않음
protections-not-blocking-cryptominers =
    .title = 암호화폐 채굴기 차단하지 않음
protections-not-blocking-cookies-third-party =
    .title = 제3자 쿠키 차단 안 함
protections-not-blocking-cookies-all =
    .title = 쿠키 차단 안 함
protections-not-blocking-cross-site-tracking-cookies =
    .title = 교차 사이트 추적 쿠키 차단하지 않음
protections-not-blocking-tracking-content =
    .title = 추적 콘텐츠 차단하지 않음
protections-not-blocking-social-media-trackers =
    .title = 소셜 미디어 추적기 차단하지 않음

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter = { $trackerCount }개 차단됨
    .tooltiptext = { DATETIME($date, year: "numeric", month: "long", day: "numeric") } 이후
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone = { -brand-short-name }가 { DATETIME($date, year: "numeric", month: "long") } 이후 추적기 { $trackerCount }개 차단
