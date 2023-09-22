# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = Không phát hiện trên trang web này
content-blocking-cookies-blocking-trackers-label = Cookie theo dõi trên nhiều trang web
content-blocking-cookies-blocking-third-party-label = Cookie của bên thứ ba
content-blocking-cookies-blocking-unvisited-label = Cookie trang web chưa truy cập
content-blocking-cookies-blocking-all-label = Tất cả các cookie
content-blocking-cookies-view-first-party-label = Từ trang web này
content-blocking-cookies-view-trackers-label = Cookie theo dõi trên nhiều trang web
content-blocking-cookies-view-third-party-label = Cookie của bên thứ ba
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = Đã cho phép
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = Đã chặn
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = Xóa ngoại lệ cookie cho { $domain }
tracking-protection-icon-active = Chặn trình theo dõi phương tiện truyền thông xã hội, cookie theo dõi trên nhiều trang web và dấu vết.
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = Trình chống theo dõi nâng cao đã bị TẮT cho trang này.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = { -brand-short-name } không phát hiện ra trình theo dõi đã biết trên trang này.
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = Trạng thái bảo vệ cho { $host }
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = Tắt bảo vệ cho { $host }
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = Bật bảo vệ cho { $host }

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = Đã chặn dấu vết
protections-blocking-cryptominers =
    .title = Đã chặn tiền điện tử
protections-blocking-cookies-trackers =
    .title = Đã chặn cookie theo dõi trên nhiều trang web
protections-blocking-cookies-third-party =
    .title = Đã chặn cookie của bên thứ ba
protections-blocking-cookies-all =
    .title = Đã chặn tất cả cookie
protections-blocking-cookies-unvisited =
    .title = Đã cookie trang web chưa truy cập
protections-blocking-tracking-content =
    .title = Đã chặn trình theo dõi nội dung
protections-blocking-social-media-trackers =
    .title = Đã chặn trình theo dõi truyền thông xã hội
protections-not-blocking-fingerprinters =
    .title = Không chặn dấu vết
protections-not-blocking-cryptominers =
    .title = Không chặn tiền điện tử
protections-not-blocking-cookies-third-party =
    .title = Không chặn cookie của bên thứ ba
protections-not-blocking-cookies-all =
    .title = Không chặn cookie
protections-not-blocking-cross-site-tracking-cookies =
    .title = Không chặn cookie theo dõi trên nhiều trang web
protections-not-blocking-tracking-content =
    .title = Không chặn trình theo dõi nội dung
protections-not-blocking-social-media-trackers =
    .title = Không chặn trình theo dõi truyền thông xã hội

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter = { $trackerCount } đã chặn
    .tooltiptext = Từ { DATETIME($date, year: "numeric", month: "long", day: "numeric") }
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone = { -brand-short-name } đã chặn { $trackerCount } trình theo dõi từ { DATETIME($date, year: "numeric", month: "long") }
