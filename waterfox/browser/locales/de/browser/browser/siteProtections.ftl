# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = Keine erkannt auf dieser Website
content-blocking-cookies-blocking-trackers-label = Cookies zur seitenübergreifenden Aktivitätenverfolgung
content-blocking-cookies-blocking-third-party-label = Cookies von Drittanbietern
content-blocking-cookies-blocking-unvisited-label = Cookies von nicht besuchten Websites
content-blocking-cookies-blocking-all-label = Alle Cookies
content-blocking-cookies-view-first-party-label = Von dieser Website
content-blocking-cookies-view-trackers-label = Cookies zur seitenübergreifenden Aktivitätenverfolgung
content-blocking-cookies-view-third-party-label = Cookies von Drittanbietern
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = Erlaubt
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = Blockiert
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = Löschen der Cookie-Ausnahme für { $domain }
tracking-protection-icon-active = Blockiert: Skripte zur Aktivitätenverfolgung durch soziale Netzwerke, Cookies zur seitenübergreifenden Aktivitätenverfolgung und Identifizierer (Fingerprinter)
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = Verbesserter Schutz vor Aktivitätenverfolgung ist auf dieser Website DEAKTIVIERT.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = { -brand-short-name } erkannte keine Skripte zur Aktivitätenverfolgung auf dieser Seite.
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = Schutzmaßnahmen für { $host }
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = Schutzmaßnahmen deaktivieren für { $host }
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = Schutzmaßnahmen aktivieren für { $host }

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = Identifizierer (Fingerprinter) blockiert
protections-blocking-cryptominers =
    .title = Heimliche Digitalwährungsberechner (Krypto-Miner) blockiert
protections-blocking-cookies-trackers =
    .title = Cookies zur seitenübergreifenden Aktivitätenverfolgung blockiert
protections-blocking-cookies-third-party =
    .title = Cookies von Drittanbietern blockiert
protections-blocking-cookies-all =
    .title = Alle Cookies blockiert
protections-blocking-cookies-unvisited =
    .title = Cookies von nicht besuchten Websites blockiert
protections-blocking-tracking-content =
    .title = Inhalte zur Aktivitätenverfolgung blockiert
protections-blocking-social-media-trackers =
    .title = Skripte zur Aktivitätenverfolgung durch soziale Netzwerke blockiert
protections-not-blocking-fingerprinters =
    .title = Identifizierer (Fingerprinter) nicht blockiert
protections-not-blocking-cryptominers =
    .title = Heimliche Digitalwährungsberechner (Krypto-Miner) nicht blockiert
protections-not-blocking-cookies-third-party =
    .title = Cookies von Drittanbietern werden nicht blockiert
protections-not-blocking-cookies-all =
    .title = Cookies werden nicht blockiert
protections-not-blocking-cross-site-tracking-cookies =
    .title = Cookies zur seitenübergreifenden Aktivitätenverfolgung nicht blockiert
protections-not-blocking-tracking-content =
    .title = Inhalte zur Aktivitätenverfolgung nicht blockiert
protections-not-blocking-social-media-trackers =
    .title = Skripte zur Aktivitätenverfolgung durch soziale Netzwerke nicht blockiert

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter =
    { $trackerCount ->
        [one] 1 blockiert
       *[other] { $trackerCount } blockiert
    }
    .tooltiptext = Seit { DATETIME($date, year: "numeric", month: "long", day: "numeric") }
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone =
    { $trackerCount ->
        [one] { -brand-short-name } blockierte { $trackerCount } Element zur Aktivitätenverfolgung seit { DATETIME($date, year: "numeric", month: "long") }
       *[other] { -brand-short-name } blockierte { $trackerCount } Elemente zur Aktivitätenverfolgung seit { DATETIME($date, year: "numeric", month: "long") }
    }
