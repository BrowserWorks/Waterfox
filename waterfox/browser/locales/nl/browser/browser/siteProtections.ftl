# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = Geen trackers op deze website gedetecteerd
content-blocking-cookies-blocking-trackers-label = Cross-site-trackingcookies
content-blocking-cookies-blocking-third-party-label = Cookies van derden
content-blocking-cookies-blocking-unvisited-label = Niet-bezochte-websitecookies
content-blocking-cookies-blocking-all-label = Alle cookies
content-blocking-cookies-view-first-party-label = Van deze website
content-blocking-cookies-view-trackers-label = Cross-site-trackingcookies
content-blocking-cookies-view-third-party-label = Cookies van derden
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = Toegestaan
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = Geblokkeerd
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = Cookie-uitzondering voor { $domain } wissen
tracking-protection-icon-active = Blokkering van sociale-mediatrackers, cross-site-trackingcookies en fingerprinters.
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = Verbeterde bescherming tegen volgen staat UIT voor deze website.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = Op deze pagina zijn geen bij { -brand-short-name } bekende trackers aangetroffen.
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = Beschermingen voor { $host }
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = Beschermingen voor { $host } uitschakelen
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = Beschermingen voor { $host } inschakelen

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = Fingerprinters geblokkeerd
protections-blocking-cryptominers =
    .title = Cryptominers geblokkeerd
protections-blocking-cookies-trackers =
    .title = Cross-site-trackingcookies geblokkeerd
protections-blocking-cookies-third-party =
    .title = Cookies van derden geblokkeerd
protections-blocking-cookies-all =
    .title = Alle cookies geblokkeerd
protections-blocking-cookies-unvisited =
    .title = Niet-bezochte-websitecookies geblokkeerd
protections-blocking-tracking-content =
    .title = Volginhoud geblokkeerd
protections-blocking-social-media-trackers =
    .title = Sociale-mediatrackers geblokkeerd
protections-not-blocking-fingerprinters =
    .title = Fingerprinters worden niet geblokkeerd
protections-not-blocking-cryptominers =
    .title = Cryptominers worden niet geblokkeerd
protections-not-blocking-cookies-third-party =
    .title = Blokkeert cookies van derden niet
protections-not-blocking-cookies-all =
    .title = Blokkeert cookies niet
protections-not-blocking-cross-site-tracking-cookies =
    .title = Cross-site-trackingcookies worden niet geblokkeerd
protections-not-blocking-tracking-content =
    .title = Volginhoud wordt niet geblokkeerd
protections-not-blocking-social-media-trackers =
    .title = Sociale-mediatrackers worden niet geblokkeerd

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter =
    { $trackerCount ->
        [one] 1 geblokkeerd
       *[other] { $trackerCount } geblokkeerd
    }
    .tooltiptext = Sinds { DATETIME($date, year: "numeric", month: "long", day: "numeric") }
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone =
    { $trackerCount ->
        [one] { -brand-short-name } heeft { $trackerCount } tracker geblokkeerd sinds { DATETIME($date, year: "numeric", month: "long") }
       *[other] { -brand-short-name } heeft meer dan { $trackerCount } trackers geblokkeerd sinds { DATETIME($date, year: "numeric", month: "long") }
    }
