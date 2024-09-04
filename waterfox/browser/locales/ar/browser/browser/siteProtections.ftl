# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = لم يُكتشف شيء في الصفحة
content-blocking-cookies-blocking-trackers-label = كعكات تتعقّبك بين المواقع
content-blocking-cookies-blocking-third-party-label = كعكات الأطراف الثالثة
content-blocking-cookies-blocking-unvisited-label = كعكات المواقع غير المُزارة
content-blocking-cookies-blocking-all-label = كل الكعكات
content-blocking-cookies-view-first-party-label = من هذا الموقع
content-blocking-cookies-view-trackers-label = كعكات تتعقّبك بين المواقع
content-blocking-cookies-view-third-party-label = كعكات الأطراف الثالثة
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = مسموح بها
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = حُجبت
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = امسح استثناء الكعكات في { $domain }
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = عُطّلت الحماية الموسّعة من التعقب في هذا الموقع.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = لم تُكتشف في هذه الصفحة أي متعقّبات يعرفها { -brand-short-name }.
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = مستويات الحماية من { $host }
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = عطّل الحماية على { $host }
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = فعّل الحماية على { $host }

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = مسجّلات البصمات - محجوبة
protections-blocking-cryptominers =
    .title = المُعدّنات المعمّاة - محجوبة
protections-blocking-cookies-trackers =
    .title = الكعكات التي تتعقّبك بين المواقع - محجوبة
protections-blocking-cookies-third-party =
    .title = كعكات الأطراف الثالثة - محجوبة
protections-blocking-cookies-all =
    .title = كل الكعكات - محجوبة
protections-blocking-cookies-unvisited =
    .title = كعكات المواقع غير المُزارة - محجوبة
protections-blocking-tracking-content =
    .title = المحتوى الذي يتعقّبك - محجوب
protections-blocking-social-media-trackers =
    .title = متعقبات مواقع التواصل الاجتماعي - محجوبة
protections-not-blocking-fingerprinters =
    .title = مسجّلات البصمات - غير محجوبة
protections-not-blocking-cryptominers =
    .title = المُعدّنات المعمّاة - غير محجوبة
protections-not-blocking-cookies-third-party =
    .title = كعكات الأطراف الثالثة - غير محجوبة
protections-not-blocking-cookies-all =
    .title = الكعكات المتعقِّبة - غير محجوبة
protections-not-blocking-cross-site-tracking-cookies =
    .title = الكعكات التي تتعقّبك بين المواقع - غير محجوبة
protections-not-blocking-tracking-content =
    .title = المحتوى الذي يتعقّبك - غير محجوب
protections-not-blocking-social-media-trackers =
    .title = متعقّبات المواقع الاجتماعية - غير محجوبة

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter =
    { $trackerCount ->
        [zero] لم يُحجب شيء
        [one] حُجب 1
        [two] حُجب { $trackerCount }
        [few] حُجبت { $trackerCount }
        [many] حُجب { $trackerCount }
       *[other] حُجب { $trackerCount }
    }
    .tooltiptext = منذ { DATETIME($date, year: "numeric", month: "long", day: "numeric") }
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone =
    { $trackerCount ->
        [zero] لم يحجب { -brand-short-name } أيّ متعقّب منذ { DATETIME($date, year: "numeric", month: "long") }
        [one] حجب { -brand-short-name } متعقّبًا واحدًا منذ { DATETIME($date, year: "numeric", month: "long") }
        [two] حجب { -brand-short-name } متعقّبين اثنين منذ { DATETIME($date, year: "numeric", month: "long") }
        [few] حجب { -brand-short-name } ما يزيد على { $trackerCount } متعقّبات منذ { DATETIME($date, year: "numeric", month: "long") }
        [many] حجب { -brand-short-name } ما يزيد على { $trackerCount } متعقّبًا منذ { DATETIME($date, year: "numeric", month: "long") }
       *[other] حجب { -brand-short-name } ما يزيد على { $trackerCount } متعقّبا منذ { DATETIME($date, year: "numeric", month: "long") }
    }
