# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = Nenhum detetado neste site
content-blocking-cookies-blocking-trackers-label = Cookies de monitorização entre sites
content-blocking-cookies-blocking-third-party-label = Cookies de terceiros
content-blocking-cookies-blocking-unvisited-label = Cookies de sites não visitados
content-blocking-cookies-blocking-all-label = Todos os cookies
content-blocking-cookies-view-first-party-label = Deste site
content-blocking-cookies-view-trackers-label = Cookies de monitorização entre sites
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
    .tooltiptext = Limpar exceção de cookies para { $domain }
tracking-protection-icon-active = Bloqueio de rastreadores de redes sociais, cookies de monitorização entre sites e identificadores.
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = A proteção contra monitorização melhorada está DESLIGADA para este site.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = Nenhum rastreador conhecido pelo { -brand-short-name } foi detetado nesta página.
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = Proteções para { $host }
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = Desativar proteções para { $host }
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = Ativar proteções para { $host }

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = Identificadores bloqueados
protections-blocking-cryptominers =
    .title = Cripto-mineradores bloqueados
protections-blocking-cookies-trackers =
    .title = Cookies de monitorização entre sites bloqueadas
protections-blocking-cookies-third-party =
    .title = Cookies de terceiros bloqueadas
protections-blocking-cookies-all =
    .title = Todas as cookies bloqueadas
protections-blocking-cookies-unvisited =
    .title = Cookies de sites não visitados bloqueados
protections-blocking-tracking-content =
    .title = Conteúdo de monitorização bloqueado
protections-blocking-social-media-trackers =
    .title = Rastreadores de redes sociais bloqueados
protections-not-blocking-fingerprinters =
    .title = Sem bloqueio de identificadores
protections-not-blocking-cryptominers =
    .title = Sem bloqueio de cripto-mineradores
protections-not-blocking-cookies-third-party =
    .title = Não está a bloquear cookies de terceiros
protections-not-blocking-cookies-all =
    .title = Não está a bloquear cookies
protections-not-blocking-cross-site-tracking-cookies =
    .title = A não bloquear Cookies de monitorização entre sites
protections-not-blocking-tracking-content =
    .title = A não bloquear Conteúdo de monitorização
protections-not-blocking-social-media-trackers =
    .title = Não está a bloquear rastreadores de redes sociais

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter =
    { $trackerCount ->
        [one] 1 bloqueado
       *[other] { $trackerCount } bloqueados
    }
    .tooltiptext = Desde { DATETIME($date, year: "numeric", month: "long", day: "numeric") }
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone =
    { $trackerCount ->
        [one] O { -brand-short-name } bloqueou { $trackerCount } rastreador desde { DATETIME($date, year: "numeric", month: "long") }
       *[other] O { -brand-short-name } bloqueou { $trackerCount } rastreadores desde { DATETIME($date, year: "numeric", month: "long") }
    }
