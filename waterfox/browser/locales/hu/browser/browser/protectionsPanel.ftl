# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Hiba történt a jelentés beküldésekor. Próbálja újra később.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = A webhely javítva lett? Jelentés küldése

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Szigorú
    .label = Szigorú
protections-popup-footer-protection-label-custom = Egyéni
    .label = Egyéni
protections-popup-footer-protection-label-standard = Szokásos
    .label = Szokásos

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = További információk a fokozott követés elleni védelemről

protections-panel-etp-on-header = A fokozott követés elleni védelem BE van kapcsolva ezen a webhelyen
protections-panel-etp-off-header = A fokozott követés elleni védelem KI van kapcsolva ezen a webhelyen

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Nem működik az oldal?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Nem működik az oldal?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Miért?
protections-panel-not-blocking-why-etp-on-tooltip = Ezek blokkolása egyes webhelyek elemeinek hibáit okozhatja. A nyomkövetők nélkül egyes gombok, űrlapok és bejelentkezési mezők lehet, hogy nem fognak működni.
protections-panel-not-blocking-why-etp-off-tooltip = A webhely összes nyomkövetője be lett töltve, mert a védelem ki van kapcsolva.

##

protections-panel-no-trackers-found = Egyetlen ismert nyomkövetőt sem észlelt a { -brand-short-name } ezen az oldalon.

protections-panel-content-blocking-tracking-protection = Nyomkövető tartalom

protections-panel-content-blocking-socialblock = Közösségimédia-követők
protections-panel-content-blocking-cryptominers-label = Kriptobányászok
protections-panel-content-blocking-fingerprinters-label = Ujjlenyomat-készítők

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Blokkolva
protections-panel-not-blocking-label = Engedélyezve
protections-panel-not-found-label = Nincs észlelve

##

protections-panel-settings-label = Védelmi beállítások
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Védelmi vezérlőpult

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Kapcsolja ki a védelmet, ha problémái vannak a következőkkel:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Bejelentkezési mezők
protections-panel-site-not-working-view-issue-list-forms = Űrlapok
protections-panel-site-not-working-view-issue-list-payments = Fizetések
protections-panel-site-not-working-view-issue-list-comments = Megjegyzések
protections-panel-site-not-working-view-issue-list-videos = Videók

protections-panel-site-not-working-view-send-report = Jelentés küldése

##

protections-panel-cross-site-tracking-cookies = Ezek a sütik követik Ön oldalról oldalra, és adatokat gyűjtenek az online tevékenységéről. Ezeket olyan harmadik felek állítják be, mint a hirdetők és az elemző cégek.
protections-panel-cryptominers = A kriptobányászok az Ön rendszerének erőforrásait használják digitális pénzek bányászatához. A kriptobányászok lemerítik az akkumulátort, lelassítják a számítógépét és növelhetik a villanyszámláját.
protections-panel-fingerprinters = A ujjlenyomat-készítők beállításokat gyűjtenek a böngészőjéből és számítógépéből, hogy profilt hozzanak létre Önről. A digitális ujjlenyomat használatával követhetik Ön a különböző webhelyek között.
protections-panel-tracking-content = A weboldalak külső hirdetéseket, videókat és más követési kódot tartalmazó tartalmakat tölthetnek be. A nyomkövető tartalmak blokkolása az oldalak gyorsabb betöltését eredményezheti, de egyes gombok, űrlapok és bejelentkezési mezők lehet, hogy nem fognak működni.
protections-panel-social-media-trackers = A közösségi hálózatok nyomkövetőket helyeznek el más weboldalakon, hogy kövessék mit tesz, lát és néz online. Így a közösségi médiával foglalkozó cégek többet tudhatnak meg Önről, mint amit megoszt a közösségimédia-profiljaiban.

protections-panel-description-shim-allowed = Egyes lent jelzett nyomkövetők részleges feloldásra kerültek, mert interakcióba lépett velük.
protections-panel-description-shim-allowed-learn-more = További tudnivalók
protections-panel-shim-allowed-indicator =
    .tooltiptext = Nyomkövető részlegesen feloldva

protections-panel-content-blocking-manage-settings =
    .label = Védelmi beállítások kezelése
    .accesskey = k

protections-panel-content-blocking-breakage-report-view =
    .title = Hibás webhely bejelentése
protections-panel-content-blocking-breakage-report-view-description = Egyes nyomkövetők blokkolása problémákat okozhat néhány weboldalon. Ezen problémák bejelentése segít jobbá tenni a { -brand-short-name } böngészőt mindenki számára. A jelentés elküldi az URL-t és a böngészőbeállításait a Mozillának. <label data-l10n-name="learn-more">További tudnivalók</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Nem kötelező: Írja le a problémát
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Nem kötelező: Írja le a problémát
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Mégse
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Jelentés küldése
