# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = Ingen upptäckt på denna sida
content-blocking-cookies-blocking-trackers-label = Globala spårningskakor
content-blocking-cookies-blocking-third-party-label = Kakor från tredje part
content-blocking-cookies-blocking-unvisited-label = Obesökta webbplatskakor
content-blocking-cookies-blocking-all-label = Alla kakor
content-blocking-cookies-view-first-party-label = Från den här webbplatsen
content-blocking-cookies-view-trackers-label = Globala spårningskakor
content-blocking-cookies-view-third-party-label = Kakor från tredje part
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = Tillåten
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = Blockerad
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = Rensa kakundantag för { $domain }
tracking-protection-icon-active = Blockering av sociala spårare, globala spårningskakor och fingeravtrycksspårare.
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = Förbättrat spårningsskydd är AV för den här webbplatsen.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = Inga kända spårare för { -brand-short-name } upptäcktes på den här sidan.
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = Skydd för { $host }
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = Inaktivera skydd för { $host }
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = Aktivera skydd för { $host }

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = Fingeravtrycksspårare blockerade
protections-blocking-cryptominers =
    .title = Kryptogrävare blockerade
protections-blocking-cookies-trackers =
    .title = Globlala spårningskakor blockerade
protections-blocking-cookies-third-party =
    .title = Kakor från tredje part blockerade
protections-blocking-cookies-all =
    .title = Alla kakor blockerade
protections-blocking-cookies-unvisited =
    .title = Kakor från obesökta webbplatser blockerade
protections-blocking-tracking-content =
    .title = Spårningsinnehåll blockerat
protections-blocking-social-media-trackers =
    .title = Sociala media-spårare blockerade
protections-not-blocking-fingerprinters =
    .title = Blockerar inte Fingeravtrycksspårare
protections-not-blocking-cryptominers =
    .title = Blockerar inte kryptogrävare
protections-not-blocking-cookies-third-party =
    .title = Blockerar inte kakor från tredje part
protections-not-blocking-cookies-all =
    .title = Blockerar inte kakor
protections-not-blocking-cross-site-tracking-cookies =
    .title = Blockerar inte globala spårningskakor
protections-not-blocking-tracking-content =
    .title = Blockerar inte spårningsinnehåll
protections-not-blocking-social-media-trackers =
    .title = Blockerar inte social media-spårare

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter =
    { $trackerCount ->
        [one] 1 blockerad
       *[other] { $trackerCount } blockerade
    }
    .tooltiptext = Sedan { DATETIME($date, year: "numeric", month: "long", day: "numeric") }
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone =
    { $trackerCount ->
        [one] { -brand-short-name } blockerade { $trackerCount } spårare sedan { DATETIME($date, year: "numeric", month: "long") }
       *[other] { -brand-short-name } blockerade över { $trackerCount } spårare sedan { DATETIME($date, year: "numeric", month: "long") }
    }
