# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = Nie wykryto na tej stronie
content-blocking-cookies-blocking-trackers-label = Ciasteczka śledzące między witrynami
content-blocking-cookies-blocking-third-party-label = Ciasteczka zewnętrznych witryn
content-blocking-cookies-blocking-unvisited-label = Ciasteczka z nieodwiedzonych witryn
content-blocking-cookies-blocking-all-label = Wszystkie ciasteczka
content-blocking-cookies-view-first-party-label = Ta witryna
content-blocking-cookies-view-trackers-label = Ciasteczka śledzące między witrynami
content-blocking-cookies-view-third-party-label = Ciasteczka zewnętrznych witryn
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = Dopuszczono
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = Zablokowano
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = Usuń wyjątek dla ciasteczek z witryny „{ $domain }”.
tracking-protection-icon-active = Blokowanie elementów śledzących serwisów społecznościowych, ciasteczek śledzących między witrynami i elementów śledzących przez zbieranie informacji o konfiguracji.
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = Wzmocniona ochrona przed śledzeniem jest wyłączona na tej witrynie.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = { -brand-short-name } nie wykrył na tej stronie znanych elementów śledzących.
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = Ochrona witryny { $host }
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = Wyłącz ochronę na witrynie { $host }
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = Włącz ochronę na witrynie { $host }

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = Zablokowane elementy śledzące przez zbieranie informacji o konfiguracji
protections-blocking-cryptominers =
    .title = Zablokowane elementy używające komputera użytkownika do generowania kryptowalut
protections-blocking-cookies-trackers =
    .title = Zablokowane ciasteczka śledzące między witrynami
protections-blocking-cookies-third-party =
    .title = Zablokowane ciasteczka zewnętrznych witryn
protections-blocking-cookies-all =
    .title = Zablokowane wszystkie ciasteczka
protections-blocking-cookies-unvisited =
    .title = Zablokowane ciasteczka z nieodwiedzonych witryn
protections-blocking-tracking-content =
    .title = Zablokowane treści z elementami śledzącymi
protections-blocking-social-media-trackers =
    .title = Zablokowane elementy śledzące serwisów społecznościowych
protections-not-blocking-fingerprinters =
    .title = Nieblokowane elementy śledzące przez zbieranie informacji o konfiguracji
protections-not-blocking-cryptominers =
    .title = Nieblokowane elementy używające komputera użytkownika do generowania kryptowalut
protections-not-blocking-cookies-third-party =
    .title = Nieblokowane ciasteczka zewnętrznych witryn
protections-not-blocking-cookies-all =
    .title = Nieblokowane ciasteczka
protections-not-blocking-cross-site-tracking-cookies =
    .title = Nieblokowane ciasteczka śledzące między witrynami
protections-not-blocking-tracking-content =
    .title = Nieblokowane treści z elementami śledzącymi
protections-not-blocking-social-media-trackers =
    .title = Nieblokowane elementy śledzące serwisów społecznościowych

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter =
    { $trackerCount ->
        [one] 1 zablokowany element
        [few] { $trackerCount } zablokowane elementy
       *[many] { $trackerCount } zablokowanych elementów
    }
    .tooltiptext = Od { DATETIME($date, year: "numeric", month: "long", day: "numeric") }
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone =
    { $trackerCount ->
        [one] { -brand-short-name } od { DATETIME($date, year: "numeric", month: "long") } zablokował { $trackerCount } element śledzący
        [few] { -brand-short-name } od { DATETIME($date, year: "numeric", month: "long") } zablokował ponad { $trackerCount } elementy śledzące
       *[many] { -brand-short-name } od { DATETIME($date, year: "numeric", month: "long") } zablokował ponad { $trackerCount } elementów śledzących
    }
