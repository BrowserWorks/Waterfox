# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Det uppstod ett fel då rapporten skulle skickas in. Försök igen senare.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Webbplats fixad? Skicka rapport

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Strikt
    .label = Strikt
protections-popup-footer-protection-label-custom = Anpassad
    .label = Anpassad
protections-popup-footer-protection-label-standard = Standard
    .label = Standard

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Mer information om Förbättrat spårningsskydd

protections-panel-etp-on-header = Förbättrat spårningsskydd är PÅ för den här webbplatsen
protections-panel-etp-off-header = Förbättrat spårningsskydd är AV för den här webbplatsen

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Fungerar inte webbplatsen?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Fungerar inte webbplatsen?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Varför?
protections-panel-not-blocking-why-etp-on-tooltip = Blockering av dessa kan förstöra delar av vissa webbplatser. Utan spårare fungerar kanske inte vissa knappar, formulär och inloggningsfält.
protections-panel-not-blocking-why-etp-off-tooltip = Alla spårare på denna webbplats har laddats eftersom skyddet är avstängt.

##

protections-panel-no-trackers-found = Inga kända spårare för { -brand-short-name } upptäcktes på den här sidan.

protections-panel-content-blocking-tracking-protection = Spårningsinnehåll

protections-panel-content-blocking-socialblock = Sociala media-spårare
protections-panel-content-blocking-cryptominers-label = Kryptogrävare
protections-panel-content-blocking-fingerprinters-label = Fingeravtrycksspårare

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Blockerad
protections-panel-not-blocking-label = Tillåten
protections-panel-not-found-label = Ingen upptäckt

##

protections-panel-settings-label = Skyddsinställningar
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Säkerhetsöversikt

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Stäng av skydd om du har problem med:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Inloggningsfält
protections-panel-site-not-working-view-issue-list-forms = Formulär
protections-panel-site-not-working-view-issue-list-payments = Betalningar
protections-panel-site-not-working-view-issue-list-comments = Kommentarer
protections-panel-site-not-working-view-issue-list-videos = Videor

protections-panel-site-not-working-view-send-report = Skicka in en rapport

##

protections-panel-cross-site-tracking-cookies = Dessa kakor följer dig från sida till sida för att samla in data om vad du gör online. De anges av tredje part som annonsörer och analysföretag.
protections-panel-cryptominers = Kryptogrävare använder ditt systems datakraft för att utvinna digitala pengar. Kryptogrävar-skript tömmer ditt batteri, slöar ner din dator och kan öka energiräkningen.
protections-panel-fingerprinters = Fingeravtrycksspårare samlar inställningar från din webbläsare och dator för att skapa en profil av dig. Med det här digitala fingeravtrycket kan de spåra dig på olika webbplatser.
protections-panel-tracking-content = Webbplatser kan ladda externa annonser, videor och annat innehåll som innehåller spårningskod. Blockering av spårningsinnehåll kan hjälpa webbplatser att ladda snabbare, men vissa knappar, formulär och inloggningsfält kanske inte fungerar.
protections-panel-social-media-trackers = Sociala nätverk placerar spårare på andra webbplatser för att följa vad du gör, ser och tittar på online. Detta gör att sociala medieföretag kan lära sig mer om dig utöver vad du delar i dina sociala medieprofiler.

protections-panel-description-shim-allowed = Vissa spårare markerade nedan har delvis blivit avblockerade på den här sidan eftersom du interagerade med dem.
protections-panel-description-shim-allowed-learn-more = Läs mer
protections-panel-shim-allowed-indicator =
    .tooltiptext = Spårare delvis avblockerad

protections-panel-content-blocking-manage-settings =
    .label = Hantera skyddsinställningar
    .accesskey = H

protections-panel-content-blocking-breakage-report-view =
    .title = Rapportera en trasig webbplats
protections-panel-content-blocking-breakage-report-view-description = Blockering av vissa spårare kan orsaka problem med vissa webbplatser. Att rapportera dessa problem hjälper till att göra { -brand-short-name } bättre för alla. Genom att skicka in den här rapporten skickas en URL och information om dina webbläsarinställningar till Waterfox. <label data-l10n-name="learn-more">Läs mer</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Valfritt: Beskriv problemet
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Valfritt: Beskriv problemet
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Avbryt
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Skicka rapport
