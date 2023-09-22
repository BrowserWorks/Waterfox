# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = Egy sem észlelhető ezen az oldalon
content-blocking-cookies-blocking-trackers-label = Webhelyek közötti nyomkövető sütik
content-blocking-cookies-blocking-third-party-label = Harmadik féltől származó sütik
content-blocking-cookies-blocking-unvisited-label = Nem felkeresett oldalak sütijei
content-blocking-cookies-blocking-all-label = Az összes süti
content-blocking-cookies-view-first-party-label = Erről az oldalról
content-blocking-cookies-view-trackers-label = Webhelyek közötti nyomkövető sütik
content-blocking-cookies-view-third-party-label = Harmadik féltől származó sütik
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = Engedélyezve
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = Blokkolva
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = Süti kivétel törlése ennél: { $domain }
tracking-protection-icon-active = A közösségimédia-követők, a webhelyek közötti nyomkövető sütik és az ujjlenyomat-készítők blokkolása.
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = A fokozott követés elleni védelem KI van kapcsolva ezen a webhelyen.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = Egyetlen ismert nyomkövetőt sem észlelt a { -brand-short-name } ezen az oldalon.
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = A(z) { $host } webhelyen használt védelmek
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = Védelem kikapcsolása ennél: { $host }
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = Védelem bekapcsolása ennél: { $host }

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = Ujjlenyomat-készítők blokkolva
protections-blocking-cryptominers =
    .title = Kriptobányászok blokkolva
protections-blocking-cookies-trackers =
    .title = Webhelyek közötti nyomkövető sütik blokkolva
protections-blocking-cookies-third-party =
    .title = Harmadik féltől származó sütik blokkolva
protections-blocking-cookies-all =
    .title = Összes süti blokkolva
protections-blocking-cookies-unvisited =
    .title = Nem felkeresett oldalak sütijei blokkolva
protections-blocking-tracking-content =
    .title = Nyomkövető tartalom blokkolva
protections-blocking-social-media-trackers =
    .title = Közösségimédia-követők blokkolva
protections-not-blocking-fingerprinters =
    .title = Nem blokkolja az ujjlenyomatok-készítőket
protections-not-blocking-cryptominers =
    .title = Nem blokkolja a kriptobányászokat
protections-not-blocking-cookies-third-party =
    .title = Nem blokkolja a harmadik féltől származó sütiket
protections-not-blocking-cookies-all =
    .title = Nem blokkolja a sütiket
protections-not-blocking-cross-site-tracking-cookies =
    .title = Nem blokkolja a webhelyek közötti nyomkövető sütiket
protections-not-blocking-tracking-content =
    .title = Nem blokkolja a nyomkövető tartalmakat
protections-not-blocking-social-media-trackers =
    .title = Nem blokkolja a közösségimédia-követőket

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter =
    { $trackerCount ->
        [one] 1 blokkolva
       *[other] { $trackerCount } blokkolva
    }
    .tooltiptext = { DATETIME($date, year: "numeric", month: "long", day: "numeric") } óta
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone =
    { $trackerCount ->
        [one] A { -brand-short-name } { DATETIME($date, year: "numeric", month: "long") } óta { $trackerCount } nyomkövetőt blokkolt
       *[other] A { -brand-short-name } { DATETIME($date, year: "numeric", month: "long") } óta { $trackerCount } nyomkövetőt blokkolt
    }
