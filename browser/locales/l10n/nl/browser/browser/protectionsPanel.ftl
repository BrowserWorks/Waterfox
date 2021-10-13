# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Er is een fout opgetreden bij het verzenden van het rapport. Probeer het later nog eens.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Website gerepareerd? Verzend rapport

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Streng
    .label = Streng
protections-popup-footer-protection-label-custom = Aangepast
    .label = Aangepast
protections-popup-footer-protection-label-standard = Standaard
    .label = Standaard

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Meer informatie over Verbeterde bescherming tegen volgen

protections-panel-etp-on-header = Verbeterde bescherming tegen volgen is AAN voor deze website
protections-panel-etp-off-header = Verbeterde bescherming tegen volgen is UIT voor deze website

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Werkt de website niet?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Werkt de website niet?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Waarom?
protections-panel-not-blocking-why-etp-on-tooltip = Door deze te blokkeren werken elementen van sommige websites mogelijk niet. Zonder trackers werken sommige knoppen, formulieren en aanmeldvelden mogelijk niet.
protections-panel-not-blocking-why-etp-off-tooltip = Alle trackers op deze website zijn geladen omdat beschermingen zijn uitgeschakeld.

##

protections-panel-no-trackers-found = Op deze pagina zijn geen bij { -brand-short-name } bekende trackers aangetroffen.

protections-panel-content-blocking-tracking-protection = Volginhoud

protections-panel-content-blocking-socialblock = Sociale-mediatrackers
protections-panel-content-blocking-cryptominers-label = Cryptominers
protections-panel-content-blocking-fingerprinters-label = Fingerprinters

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Geblokkeerd
protections-panel-not-blocking-label = Toegestaan
protections-panel-not-found-label = Geen gedetecteerd

##

protections-panel-settings-label = Beschermingsinstellingen
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Beveiligingsdashboard

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Schakel beschermingen uit als u problemen hebt met:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Aanmeldvelden
protections-panel-site-not-working-view-issue-list-forms = Formulieren
protections-panel-site-not-working-view-issue-list-payments = Betalingen
protections-panel-site-not-working-view-issue-list-comments = Opmerkingen
protections-panel-site-not-working-view-issue-list-videos = Video’s

protections-panel-site-not-working-view-send-report = Rapport verzenden

##

protections-panel-cross-site-tracking-cookies = Deze cookies volgen u van website naar website om gegevens over wat u online doet te verzamelen. Ze worden geplaatst door derden, zoals advertentiebureaus en analysebedrijven.
protections-panel-cryptominers = Cryptominers gebruiken de rekenkracht van uw systeem om digitale valuta te genereren. Cryptominer-scripts trekken uw accu leeg, vertragen uw computer en kunnen uw energierekening omhoog jagen.
protections-panel-fingerprinters = Fingerprinters verzamelen instellingen van uw browser en computer om een profiel van u te maken. Met behulp van deze digitale vingerafdruk kunnen ze u op verschillende websites volgen.
protections-panel-tracking-content = Websites kunnen externe advertenties, video’s en andere inhoud laden met volgcode. Het blokkeren van volginhoud kan websites helpen sneller te laden, maar sommige knoppen, formulieren en aanmeldvelden werken mogelijk niet.
protections-panel-social-media-trackers = Sociale netwerken plaatsen trackers op andere websites om te volgen wat u online doet, ziet en bekijkt. Hierdoor kunnen sociale-mediabedrijven meer over u leren dan wat u deelt op uw sociale-mediaprofielen.

protections-panel-description-shim-allowed = Sommige hieronder gelabelde trackers zijn op deze pagina deels gedeblokkeerd, omdat u er interactie mee hebt gehad.
protections-panel-description-shim-allowed-learn-more = Meer info
protections-panel-shim-allowed-indicator =
    .tooltiptext = Tracker deels gedeblokkeerd

protections-panel-content-blocking-manage-settings =
    .label = Beschermingsinstellingen beheren
    .accesskey = B

protections-panel-content-blocking-breakage-report-view =
    .title = Niet-werkende website melden
protections-panel-content-blocking-breakage-report-view-description = Het blokkeren van bepaalde trackers kan problemen met bepaalde websites veroorzaken. Door deze problemen te melden, helpt u { -brand-short-name } voor iedereen te verbeteren. Als u dit rapport verzendt, wordt zowel een URL als informatie over uw browserinstellingen naar Waterfox verzonden. <label data-l10n-name="learn-more">Meer info</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Optioneel: beschrijf het probleem
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Optioneel: beschrijf het probleem
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Annuleren
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Rapport verzenden
