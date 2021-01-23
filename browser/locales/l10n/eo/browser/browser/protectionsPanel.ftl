# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Okazis eraro dum sendo de raporto. Bonvolu provi denove poste.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Ĉu la retejo nun funkcias? Bonvolu sendi raporton

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Rigora
    .label = Rigora
protections-popup-footer-protection-label-custom = Personecigita
    .label = Personecigita
protections-popup-footer-protection-label-standard = Norma
    .label = Norma

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Pli da informo pri la plibonigita protekto kontraŭ spurado

protections-panel-etp-on-header = La plibonigita protekto kontraŭ spurado estas AKTIVA por tiu ĉi retejo
protections-panel-etp-off-header = La plibonigita protekto kontraŭ spurado estas MALAKTIVA por tiu ĉi retejo

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Ĉu la retejo ne funkcias?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Ĉu la retejo ne funkcias?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Kial?
protections-panel-not-blocking-why-etp-on-tooltip = Blokado de tiuj ĉi elementoj povas misfunkciigi kelkajn retejojn. Sen spuriloj, kelkaj butonoj, formularoj, kaj legitimilaj kampoj, povus ne funkcii.
protections-panel-not-blocking-why-etp-off-tooltip = Ĉiuj spuriloj en tiu ĉi retejo estis ŝargitaj ĉar protektoj estas malaktivaj.

##

protections-panel-no-trackers-found = Neniu spurilo, konata de { -brand-short-name }, estis trovita en tiu ĉi paĝo.

protections-panel-content-blocking-tracking-protection = Spurila enhavo

protections-panel-content-blocking-socialblock = Sociretaj spuriloj
protections-panel-content-blocking-cryptominers-label = Miniloj de ĉifromono
protections-panel-content-blocking-fingerprinters-label = Identigiloj de ciferecaj spuroj

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Blokita
protections-panel-not-blocking-label = Permesata
protections-panel-not-found-label = Neniu eltrovita

##

protections-panel-settings-label = Agordoj de protekto
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Panelo de protektoj

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Malŝaltu protektojn se vi havas problemojn kun:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Legitimilaj kampoj
protections-panel-site-not-working-view-issue-list-forms = Formularoj
protections-panel-site-not-working-view-issue-list-payments = Pagoj
protections-panel-site-not-working-view-issue-list-comments = Komentoj
protections-panel-site-not-working-view-issue-list-videos = Filmetoj

protections-panel-site-not-working-view-send-report = Sendi raporton

##

protections-panel-cross-site-tracking-cookies = Tiuj ĉi kuketoj sekvas vin inter retejoj por kolekti informon pri via retumo. Ili estas difinitaj de aliaj, ekzemple de reklamistoj kaj retumanalizaj entreprenoj.
protections-panel-cryptominers = La miniloj de ĉifromono uzas la kalkulpovon de via komputilo por mini ciferecan monon. Minado de ĉifromono eluzas vian baterion, malrapidigas vian komputilon kaj povas konsumi pli da elekto, kiun vi devos pagi.
protections-panel-fingerprinters = La identigiloj de ciferecaj spuroj kolektas agordojn de via retumilo kaj komputilo por krei profilon de vi. Per tiu cifereca spuro, ili povas sekvi vin tra malsamaj retejoj.
protections-panel-tracking-content = Retejoj povas ŝargi eksterajn reklamojn, filmetojn kaj aliajn enhavojn, kiuj kunportas spurilojn. Blokado de spurila enhavo povas helpi rapidgi la ŝargadon de retejoj, sed kelkaj butonoj, formularoj kaj legitimilaj kampoj povus ne funkcii.
protections-panel-social-media-trackers = Socia retoj aldonas spurilojn en aliaj retejoj por sekvi vin kaj scii kion vi vidas kaj faras dum retumo. Tiu permesas al sociretaj entreprenoj havi informon pri vi, kiun vi ne dividas per viaj sociretaj profiloj.

protections-panel-content-blocking-manage-settings =
    .label = Administri agordojn de protekto
    .accesskey = R

protections-panel-content-blocking-breakage-report-view =
    .title = Raporti ne bone funkciantan retejon
protections-panel-content-blocking-breakage-report-view-description = Blokado de kelkaj spuriloj povas misfunkciigi retejojn. Raportado de tiuj ĉi problemoj helpas plibonigi { -brand-short-name } por ĉiuj. Sendo de tiu ĉi raporto al Mozilla estos akompanata de retadreso kaj informo pri viaj retumilaj agordoj. <label data-l10n-name="learn-more">Pli da informo</label>
protections-panel-content-blocking-breakage-report-view-collection-url = Retadreso
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = Retadreso
protections-panel-content-blocking-breakage-report-view-collection-comments = Nedeviga: priskribi la problemon
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Nedeviga: priskribi la problemon
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Nuligi
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Sendi raporton
