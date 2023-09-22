# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = Не обнаружены на этом сайте
content-blocking-cookies-blocking-trackers-label = Межсайтовые отслеживающие куки
content-blocking-cookies-blocking-third-party-label = Сторонние куки
content-blocking-cookies-blocking-unvisited-label = Куки с непосещённых сайтов
content-blocking-cookies-blocking-all-label = Все куки
content-blocking-cookies-view-first-party-label = С этого сайта
content-blocking-cookies-view-trackers-label = Межсайтовые отслеживающие куки
content-blocking-cookies-view-third-party-label = Сторонние куки
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = Разрешен
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = Заблокирован
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = Удалить исключение для кук с { $domain }
tracking-protection-icon-active = Блокируются трекеры соцсетей, межсайтовые отслеживающие куки, а также сборщики цифровых отпечатков.
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = Улучшенная защита от отслеживания на этом сайте ОТКЛЮЧЕНА.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = На этой странице не обнаружено ни одного известного { -brand-short-name } трекера.
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = Защита на { $host }
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = Отключить защиту на { $host }
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = Включить защиту на { $host }

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = Сборщиков цифровых отпечатков заблокировано
protections-blocking-cryptominers =
    .title = Криптомайнеров заблокировано
protections-blocking-cookies-trackers =
    .title = Межсайтовых отслеживающих куков заблокировано
protections-blocking-cookies-third-party =
    .title = Сторонних куков заблокировано
protections-blocking-cookies-all =
    .title = Всего куков заблокировано
protections-blocking-cookies-unvisited =
    .title = Куков с непосещённых сайтов заблокировано
protections-blocking-tracking-content =
    .title = Отслеживающего содержимого заблокировано
protections-blocking-social-media-trackers =
    .title = Трекеров социальных сетей заблокировано
protections-not-blocking-fingerprinters =
    .title = Нет блокируемых сборщиков цифровых отпечатков
protections-not-blocking-cryptominers =
    .title = Нет блокируемых криптомайнеров
protections-not-blocking-cookies-third-party =
    .title = Нет блокируемых сторонних кук
protections-not-blocking-cookies-all =
    .title = Нет блокируемых кук
protections-not-blocking-cross-site-tracking-cookies =
    .title = Нет блокируемых межсайтовых отслеживающих кук
protections-not-blocking-tracking-content =
    .title = Нет блокируемого отслеживающего содержимого
protections-not-blocking-social-media-trackers =
    .title = Нет блокируемых трекеров социальных сетей

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter =
    { $trackerCount ->
        [one] { $trackerCount } заблокирован
        [few] { $trackerCount } заблокировано
       *[many] { $trackerCount } заблокировано
    }
    .tooltiptext = Начиная с { DATETIME($date, year: "numeric", month: "long", day: "numeric") }
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone =
    { $trackerCount ->
        [one] С { DATETIME($date, year: "numeric", month: "long") } { -brand-short-name } заблокировал более { $trackerCount } трекера
        [few] С { DATETIME($date, year: "numeric", month: "long") } { -brand-short-name } заблокировал более { $trackerCount } трекеров
       *[many] С { DATETIME($date, year: "numeric", month: "long") } { -brand-short-name } заблокировал более { $trackerCount } трекеров
    }
