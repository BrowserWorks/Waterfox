# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = En feil oppstod ved innsending av rapporten. Prøv igjen senere.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Nettstedet fikset? Send rapport

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Streng
    .label = Streng
protections-popup-footer-protection-label-custom = Tilpasset
    .label = Tilpasset
protections-popup-footer-protection-label-standard = Standard
    .label = Standard

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Mer informasjon om utvidet sporingsbeskyttelse

protections-panel-etp-on-header = Utvidet sporingsbeskyttelse er slått PÅ for dette nettstedet
protections-panel-etp-off-header = Utvidet sporingsbeskyttelse er slått AV for dette nettstedet

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Fungerer ikke nettstedet?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Fungerer ikke nettstedet?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Hvorfor?
protections-panel-not-blocking-why-etp-on-tooltip = Blokkering av disse kan føre til feil med elementer på noen nettsteder. Uten sporere fungerer kanskje ikke noen knapper, skjemaer og innloggingsfelt.
protections-panel-not-blocking-why-etp-off-tooltip = Alle sporere på dette nettstedet er lastet fordi sporingsbeskyttelsen er slått av.

##

protections-panel-no-trackers-found = Ingen sporere kjent for { -brand-short-name } ble oppdaget på denne siden.

protections-panel-content-blocking-tracking-protection = Sporings-innhold

protections-panel-content-blocking-socialblock = Sporing via sosiale medier
protections-panel-content-blocking-cryptominers-label = Kryptoutvinnere
protections-panel-content-blocking-fingerprinters-label = Fingerprinters

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Blokkert
protections-panel-not-blocking-label = Tillatt
protections-panel-not-found-label = Ingen oppdaget

##

protections-panel-settings-label = Innstillinger for beskyttelse
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Sikkerhetsoversikt

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Slå av beskyttelsen hvis du har problemer med:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Innloggingsfelt
protections-panel-site-not-working-view-issue-list-forms = Skjemaer
protections-panel-site-not-working-view-issue-list-payments = Betalinger
protections-panel-site-not-working-view-issue-list-comments = Kommentarer
protections-panel-site-not-working-view-issue-list-videos = Videoer

protections-panel-site-not-working-view-send-report = Send inn en rapport

##

protections-panel-cross-site-tracking-cookies = Disse infokapslene følger deg fra side til side for å samle inn data om hva du gjør på nettet. De er satt av tredjeparter som annonsører og analyseselskaper.
protections-panel-cryptominers = Kryptoutvinnere bruker systemets datakraft for å utvinne digitale penger. Kryptoutvinningsskript tapper batteriet, gjør datamaskinen tregere og kan øke strømregningen.
protections-panel-fingerprinters = Fingerprinters samler innstillinger fra nettleseren din og datamaskinen for å opprette en profil av deg. Ved hjelp av dette digitale fingeravtrykket kan de spore deg på forskjellige nettsteder.
protections-panel-tracking-content = Nettsteder kan laste inn eksterne annonser, videoer og annet innhold med sporingskode. Blokkering av sporingsinnhold kan hjelpe nettsteder å laste raskere, men noen knapper, skjemaer og innloggingsfelt fungerer kanskje ikke.
protections-panel-social-media-trackers = Sosiale nettverk plasserer sporere på andre nettsteder for å følge det du gjør og ser på nettet. Dette gjør at sosiale media-selskaper kan lære mer om deg utover det du deler på profilene dine på sosiale medier.

protections-panel-content-blocking-manage-settings =
    .label = Behandle beskyttelsesinnstillinger
    .accesskey = n

protections-panel-content-blocking-breakage-report-view =
    .title = Rapporter problem med et nettsted
protections-panel-content-blocking-breakage-report-view-description = Blokkering av visse sporere kan føre til problemer med enkelte nettsteder. Rapportering av disse problemene er med på å gjøre { -brand-short-name } bedre for alle. Ved sending av denne rapporten vil du sende en URL og informasjon om nettleserinnstillingene dine, til Mozilla. <label data-l10n-name="learn-more">Les mer</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL-adresse
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL-adresse
protections-panel-content-blocking-breakage-report-view-collection-comments = Valgfritt: Beskriv problemet
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Valgfritt: Beskriv problemet
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Avbryt
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Send rapport
