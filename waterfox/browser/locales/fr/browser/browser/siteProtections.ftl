# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = Aucun détecté sur ce site
content-blocking-cookies-blocking-trackers-label = Cookies de pistage intersites
content-blocking-cookies-blocking-third-party-label = Cookies tiers
content-blocking-cookies-blocking-unvisited-label = Cookies de sites non visités
content-blocking-cookies-blocking-all-label = Tous les cookies
content-blocking-cookies-view-first-party-label = Depuis ce site
content-blocking-cookies-view-trackers-label = Cookies de pistage intersites
content-blocking-cookies-view-third-party-label = Cookies tiers
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = Autorisé
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = Bloqué
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = Effacer les exceptions de cookies pour { $domain }
tracking-protection-icon-active = Blocage des traqueurs de réseaux sociaux, des cookies de pistage intersites et des détecteurs d’empreinte numérique.
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = La protection renforcée contre le pistage est DÉSACTIVÉE pour ce site.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = Aucun traqueur connu par { -brand-short-name } n’a été détecté sur cette page.
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = Protections pour { $host }
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = Désactiver les protections pour { $host }
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = Activer les protections pour { $host }

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = Blocage des détecteurs d’empreinte numérique
protections-blocking-cryptominers =
    .title = Blocage des mineurs de cryptomonnaie
protections-blocking-cookies-trackers =
    .title = Blocage des cookies de pistage intersites
protections-blocking-cookies-third-party =
    .title = Blocage des cookies tiers
protections-blocking-cookies-all =
    .title = Blocage de tous les cookies
protections-blocking-cookies-unvisited =
    .title = Blocage des cookies de sites non visités
protections-blocking-tracking-content =
    .title = Blocage du contenu utilisé pour le pistage
protections-blocking-social-media-trackers =
    .title = Blocage des traqueurs de réseaux sociaux
protections-not-blocking-fingerprinters =
    .title = Pas de blocage des détecteurs d’empreinte numérique
protections-not-blocking-cryptominers =
    .title = Pas de blocage des mineurs de cryptomonnaie
protections-not-blocking-cookies-third-party =
    .title = Pas de blocage des cookies tiers
protections-not-blocking-cookies-all =
    .title = Pas de blocage des cookies
protections-not-blocking-cross-site-tracking-cookies =
    .title = Pas de blocage des cookies de pistage intersites
protections-not-blocking-tracking-content =
    .title = Pas de blocage du contenu utilisé pour le pistage
protections-not-blocking-social-media-trackers =
    .title = Pas de blocage des traqueurs de réseaux sociaux

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter =
    { $trackerCount ->
        [one] 1 blocage
       *[other] { $trackerCount } blocages
    }
    .tooltiptext = Depuis le { DATETIME($date, year: "numeric", month: "long", day: "numeric") }
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone =
    { $trackerCount ->
        [one] { -brand-short-name } a bloqué { $trackerCount } traqueur depuis { DATETIME($date, year: "numeric", month: "long") }
       *[other] { -brand-short-name } a bloqué plus de { $trackerCount } traqueurs depuis { DATETIME($date, year: "numeric", month: "long") }
    }
