# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = Šioje svetainėje nerasta
content-blocking-cookies-blocking-trackers-label = Tarp svetainių veikiantys stebėjimo slapukai
content-blocking-cookies-blocking-third-party-label = Trečiųjų šalių slapukai
content-blocking-cookies-blocking-unvisited-label = Neaplankytų svetainių slapukai
content-blocking-cookies-blocking-all-label = Visi slapukai
content-blocking-cookies-view-first-party-label = Iš šios svetainės
content-blocking-cookies-view-trackers-label = Tarp svetainių veikiantys stebėjimo slapukai
content-blocking-cookies-view-third-party-label = Trečiųjų šalių slapukai
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = Leisti
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = Blokuoti
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = Išvalyti { $domain } slapukų išimtį
tracking-protection-icon-active = Blokuojami socialinių tinklų stebėjimo elementai, tarp svetainių veikiantys stebėjimo slapukai, ir skaitmeninių atspaudų stebėjimas.
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = Išplėsta apsauga nuo stebėjimo šioje svetainėje išjungta.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = Tinklalapyje nerasta „{ -brand-short-name }“ žinomų stebėjimo elementų.
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = { $host } apsaugos
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = Išjungti apsaugą esant { $host }
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = Įjungti apsaugą esant { $host }

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = Skaitmeninių atspaudų stebėjimas blokuojamas
protections-blocking-cryptominers =
    .title = Kriptovaliutų kasėjai blokuoajmi
protections-blocking-cookies-trackers =
    .title = Tarp svetainių veikiantys stebėjimo slapukai blokuojami
protections-blocking-cookies-third-party =
    .title = Trečiųjų šalių slapukai blokuojami
protections-blocking-cookies-all =
    .title = Visi slapukai blokuojami
protections-blocking-cookies-unvisited =
    .title = Neaplankytų svetainių slapukai blokuojami
protections-blocking-tracking-content =
    .title = Stebėjimui naudojamas turinys blokuojamas
protections-blocking-social-media-trackers =
    .title = Socialinių tinklų stebėjimo elementai blokuojami
protections-not-blocking-fingerprinters =
    .title = Skaitmeninių atspaudų stebėjimas neblokuojamas
protections-not-blocking-cryptominers =
    .title = Kriptovaliutų kasėjai neblokuojami
protections-not-blocking-cookies-third-party =
    .title = Trečiųjų šalių slapukai neblokuojami
protections-not-blocking-cookies-all =
    .title = Slapukai neblokuojami
protections-not-blocking-cross-site-tracking-cookies =
    .title = Tarp svetainių veikiantys stebėjimo slapukai neblokuojami
protections-not-blocking-tracking-content =
    .title = Stebėjimui naudojamas turinys neblokuojamas
protections-not-blocking-social-media-trackers =
    .title = Socialinių tinklų stebėjimo elementai neblokuojami

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter =
    { $trackerCount ->
        [one] 1 užblokuotas
        [few] { $trackerCount } užblokuotų
       *[other] { $trackerCount } užblokuoti
    }
    .tooltiptext = Nuo { DATETIME($date, year: "numeric", month: "long", day: "numeric") }
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone =
    { $trackerCount ->
        [one] „{ -brand-short-name }“ užblokavo { $trackerCount } stebėjimo elementą nuo { DATETIME($date, year: "numeric", month: "long") }
        [few] „{ -brand-short-name }“ užblokavo virš { $trackerCount } stebėjimo elementų nuo { DATETIME($date, year: "numeric", month: "long") }
       *[other] „{ -brand-short-name }“ užblokavo virš { $trackerCount } stebėjimo elementų nuo { DATETIME($date, year: "numeric", month: "long") }
    }
