# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Ein feil oppstod ved innsending av rapporten. Prøv igjen seinare.
# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Fungerer nettstaden no? Send rapport

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Streng
    .label = Streng
protections-popup-footer-protection-label-custom = Tilpassa
    .label = Tilpassa
protections-popup-footer-protection-label-standard = Standard
    .label = Standard

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Meir informasjon om utvida sporingsvern
protections-panel-etp-on-header = Utvida sporingsvern er slått PÅ for denne nettstaden
protections-panel-etp-off-header = Utvida sporingsvern er slått AV for denne nettstaden
# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Fungerer ikkje nettstaden?
# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Fungerer ikkje nettstaden?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Kvifor?
protections-panel-not-blocking-why-etp-on-tooltip = Blokkering av desse kan føre til feil med element på nokre nettstadar. Utan sporarar fungerer kanskje ikkje nokre knappar, skjema og innloggingsfelt.
protections-panel-not-blocking-why-etp-off-tooltip = Alle sporarar på denne nettstaden er lasta fordi sporingsvernet er slått av.

##

protections-panel-no-trackers-found = Ingen sporarar kjende for { -brand-short-name } vart oppdaga på denne sida.
protections-panel-content-blocking-tracking-protection = Sporingsinnhald
protections-panel-content-blocking-socialblock = Sporing via sosiale medium
protections-panel-content-blocking-cryptominers-label = Kryptoutvinnarar
protections-panel-content-blocking-fingerprinters-label = Nettlesaravtrykk

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Blokkert
protections-panel-not-blocking-label = Tillate
protections-panel-not-found-label = Ingen oppdaga

##

protections-panel-settings-label = Innstillingar for vern
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Tryggingsoversyn

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Slå av vern om du har problem med:
# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Innloggingsfelt
protections-panel-site-not-working-view-issue-list-forms = Skjema
protections-panel-site-not-working-view-issue-list-payments = Betalingar
protections-panel-site-not-working-view-issue-list-comments = Kommentarar
protections-panel-site-not-working-view-issue-list-videos = Videoar
protections-panel-site-not-working-view-send-report = Send inn ein rapport

##

protections-panel-cross-site-tracking-cookies = Desse infokapslane følgjer deg frå side til side for å samle inn data om kva du gjer på nettet. Dei kjem frå tredjepartar som annonsørar og analyseselskap.
protections-panel-cryptominers = Kryptoutvinnarar brukar datakrafta til systemet for å utvinne digitale pengar. Kryptoutvinningsskript tappar batteriet, gjer datamaskina tregare og kan auke straumrekninga.
protections-panel-fingerprinters = Fingerprinters samlar innstillingar frå nettlesaren din og datamaskina for å opprette ein profil av deg. Ved hjelp av dette digitale fingeravtrykket kan dei spore deg på ulike nettstadar.
protections-panel-tracking-content = Nettstadar kan laste eksterne annonsar, videoar og annna innhald med sporingskode. Blokkering av sporingsinnhald kan gjere at nettstadar lastar raskare, men det kan hende at nokre knappar, skjema og innloggingsfelt ikkje fungerer.
protections-panel-social-media-trackers = Sosiale nettverk plasserer sporarar på andre nettstadar for å følgje det du gjer og ser på nettet. Dette gjer at sosiale mediaselskap kan lære meir om deg utover det du deler på profilane dine på sosiale medium.
protections-panel-description-shim-allowed = Nokre sporarar som er merkte nedanfor, er delvis blitt avblokkerte på denne sida fordi du samhandla med dei.
protections-panel-description-shim-allowed-learn-more = Les meir
protections-panel-shim-allowed-indicator =
    .tooltiptext = Sporing delvis avblokkert
protections-panel-content-blocking-manage-settings =
    .label = Handter instillingar for vern
    .accesskey = n
protections-panel-content-blocking-breakage-report-view =
    .title = Rapporter problem med ein nettstad
protections-panel-content-blocking-breakage-report-view-description = Blokkering av visse sporarar kan føre til problem med enkelte nettstadar. Rapportering av desse problema er med på å gjere { -brand-short-name } betre for alle. Ved sending av denne rapporten vil du sende ein URL og informasjon om nettlesarinnstillingane dine, til Mozilla. <label data-l10n-name="learn-more">Les meir</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL-adresse
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL-adresse
protections-panel-content-blocking-breakage-report-view-collection-comments = Valfritt: Beskriv problemet
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Valfritt: Beskriv problemet
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Avbryt
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Send rapport
