# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = Ingen fundet på dette websted
content-blocking-cookies-blocking-trackers-label = Sporings-cookies på tværs af websteder
content-blocking-cookies-blocking-third-party-label = Tredjeparts-cookies
content-blocking-cookies-blocking-unvisited-label = Cookies fra ikke-besøgte websteder
content-blocking-cookies-blocking-all-label = Alle cookies
content-blocking-cookies-view-first-party-label = Fra dette websted
content-blocking-cookies-view-trackers-label = Sporings-cookies på tværs af websteder
content-blocking-cookies-view-third-party-label = Tredjeparts-cookies
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = Tilladt
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = Blokeret
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = Ryd cookie-undtagelser for { $domain }
tracking-protection-icon-active = Blokerer sporing fra sociale medier, sporing på tværs af websteder og fingerprinters.
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = Udvidet beskyttelse mod sporing er SLÅET FRA på dette websted.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = { -brand-short-name } fandt ikke kendte sporings-mekanismer på denne side.
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = Beskyttelse for { $host }
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = Deaktiver beskyttelse for { $host }
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = Aktivér beskyttelse for { $host }

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = Fingerprinters blokeret
protections-blocking-cryptominers =
    .title = Cryptominers blokeret
protections-blocking-cookies-trackers =
    .title = Sporings-cookies på tværs af websteder blokeret
protections-blocking-cookies-third-party =
    .title = Tredjeparts-cookies blokeret
protections-blocking-cookies-all =
    .title = Alle cookies blokeret
protections-blocking-cookies-unvisited =
    .title = Cookies fra ikke-besøgte websteder blokeret
protections-blocking-tracking-content =
    .title = Sporings-indhold blokeret
protections-blocking-social-media-trackers =
    .title = Sporing via sociale medier blokeret
protections-not-blocking-fingerprinters =
    .title = Blokerer ikke fingerprinters
protections-not-blocking-cryptominers =
    .title = Blokerer ikke cryptominers
protections-not-blocking-cookies-third-party =
    .title = Blokerer ikke tredjeparts-cookies
protections-not-blocking-cookies-all =
    .title = Blokerer ikke cookies
protections-not-blocking-cross-site-tracking-cookies =
    .title = Blokerer ikke sporings-cookies på tværs af websteder
protections-not-blocking-tracking-content =
    .title = Blokerer ikke sporings-indhold
protections-not-blocking-social-media-trackers =
    .title = Blokerer ikke sporing via sociale medier

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter =
    { $trackerCount ->
        [one] 1 blokeret
       *[other] { $trackerCount } blokeret
    }
    .tooltiptext = siden { DATETIME($date, year: "numeric", month: "long", day: "numeric") }
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone =
    { $trackerCount ->
        [one] { -brand-short-name } har blokeret { $trackerCount } sporings-mekanisme siden { DATETIME($date, year: "numeric", month: "long") }
       *[other] { -brand-short-name } har blokeret flere end { $trackerCount } sporings-mekanismer siden { DATETIME($date, year: "numeric", month: "long") }
    }
