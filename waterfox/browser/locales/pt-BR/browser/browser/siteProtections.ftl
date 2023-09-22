# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = Nenhum detectado neste site
content-blocking-cookies-blocking-trackers-label = Cookies de rastreamento entre sites
content-blocking-cookies-blocking-third-party-label = Cookies de terceiros
content-blocking-cookies-blocking-unvisited-label = Cookies de sites não visitados
content-blocking-cookies-blocking-all-label = Todos os cookies
content-blocking-cookies-view-first-party-label = Cookies deste site
content-blocking-cookies-view-trackers-label = Cookies de rastreamento entre sites
content-blocking-cookies-view-third-party-label = Cookies de terceiros
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = Permitido
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = Bloqueado
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = Limpar exceção de cookies de { $domain }
tracking-protection-icon-active = Bloqueando rastreadores de mídias sociais, cookies de rastreamento entre sites e fingerprinters.
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = A proteção aprimorada contra rastreamento está DESATIVADA neste site.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = Nenhum rastreador conhecido pelo { -brand-short-name } foi detectado nesta página.
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = Proteções em { $host }
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = Desativar proteções de { $host }
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = Ativar proteções de { $host }

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = Fingerprinters bloqueados
protections-blocking-cryptominers =
    .title = Criptomineradores bloqueados
protections-blocking-cookies-trackers =
    .title = Cookies de rastreamento entre sites bloqueados
protections-blocking-cookies-third-party =
    .title = Cookies de terceiros bloqueados
protections-blocking-cookies-all =
    .title = Todos os cookies bloqueados
protections-blocking-cookies-unvisited =
    .title = Cookies de sites não visitados bloqueados
protections-blocking-tracking-content =
    .title = Conteúdo com rastreamento bloqueado
protections-blocking-social-media-trackers =
    .title = Rastreadores de mídias sociais bloqueados
protections-not-blocking-fingerprinters =
    .title = Não está bloqueando fingerprinters
protections-not-blocking-cryptominers =
    .title = Não está bloqueando criptomineradores
protections-not-blocking-cookies-third-party =
    .title = Não bloqueando cookies de terceiros
protections-not-blocking-cookies-all =
    .title = Não bloqueando cookies
protections-not-blocking-cross-site-tracking-cookies =
    .title = Não está bloqueando cookies de rastreamento entre sites
protections-not-blocking-tracking-content =
    .title = Não está bloqueando conteúdo com rastreamento
protections-not-blocking-social-media-trackers =
    .title = Não está bloqueando rastreadores de mídias sociais

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter =
    { $trackerCount ->
        [one] { $trackerCount } bloqueio
       *[other] { $trackerCount } bloqueios
    }
    .tooltiptext = Desde { DATETIME($date, year: "numeric", month: "long", day: "numeric") }
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone =
    { $trackerCount ->
        [one] O { -brand-short-name } bloqueou { $trackerCount } rastreador desde { DATETIME($date, year: "numeric", month: "long") }
       *[other] O { -brand-short-name } bloqueou mais de { $trackerCount } rastreadores desde { DATETIME($date, year: "numeric", month: "long") }
    }
