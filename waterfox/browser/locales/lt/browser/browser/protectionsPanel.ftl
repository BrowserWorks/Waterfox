# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Klaida pateikiant pranešimą. Prašome pabandyti vėliau.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Svetainė sutvarkyta? Praneškite

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Griežta
    .label = Griežta
protections-popup-footer-protection-label-custom = Kita
    .label = Kita
protections-popup-footer-protection-label-standard = Įprastinė
    .label = Įprastinė

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Daugiau informacijos apie išplėstą apsaugą nuo stebėjimo

protections-panel-etp-on-header = Išplėsta apsauga nuo stebėjimo šioje svetainėje įjungta
protections-panel-etp-off-header = Išplėsta apsauga nuo stebėjimo šioje svetainėje išjungta

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Neveikia svetainė?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Neveikia svetainė?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Kodėl?
protections-panel-not-blocking-why-etp-on-tooltip = Šių dalykų blokavimas gali sutrikdyti elementų, esančių svetainėse, veikimą. Be stebėjimo elementų, gali neveikti kai kurie mygtukai, formos, prisijungimo laukai.
protections-panel-not-blocking-why-etp-off-tooltip = Buvo įkelti visi šioje svetainėje esantys stebėjimo elementai, nes apsaugos yra išjungtos.

##

protections-panel-no-trackers-found = Tinklalapyje nerasta „{ -brand-short-name }“ žinomų stebėjimo elementų.

protections-panel-content-blocking-tracking-protection = Stebėjimui naudojamas turinys

protections-panel-content-blocking-socialblock = Socialinių tinklų stebėjimo elementai
protections-panel-content-blocking-cryptominers-label = Kriptovaliutų kasėjai
protections-panel-content-blocking-fingerprinters-label = Skaitmeninių atspaudų stebėjimas

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Blokuojama
protections-panel-not-blocking-label = Leidžiama
protections-panel-not-found-label = Neaptikta jokių

##

protections-panel-settings-label = Apsaugos nuostatos
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Apsaugos skydelis

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Išjunkite apsaugas, jeigu patiriate problemų su:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Prisijungimų laukais
protections-panel-site-not-working-view-issue-list-forms = Formomis
protections-panel-site-not-working-view-issue-list-payments = Mokėjimais
protections-panel-site-not-working-view-issue-list-comments = Komentarais
protections-panel-site-not-working-view-issue-list-videos = Vaizdo įrašais

protections-panel-site-not-working-view-send-report = Siųsti pranešimą

##

protections-panel-cross-site-tracking-cookies = Šie slapukai seka jus tarp skirtingų svetainių, rinkdami informaciją, ką veikiate naršydami. Jie yra valdomi trečiųjų šalių, pvz., reklamų kūrėjų arba analitikos kompanijų.
protections-panel-cryptominers = Kriptovaliutų kasėjai naudoja jūsų kompiuterio resursus, kad iškastų skaitmeninių pinigų. Šis procesas eikvoja jūsų bateriją, lėtina kompiuterio veikimą, ir gali padidinti sąskaitą už elektrą.
protections-panel-fingerprinters = Skaitmeninių atspaudų stebėjimo metu surenkama informacija apie jūsų naršyklės ir kompiuterio parametrus, kad būtų sudarytas jūsų profilis. Jį turint, jus galima sekti tarp skirtingų svetainių.
protections-panel-tracking-content = Svetainės gali įkelti išorines reklamas, vaizdo įrašus, ir kitą turinį su stebimo kodu. Tokio turinio blokavimas gali leisti gerčiau įkelti svetaines, tačiau kartu gali neveikti dalis mygtukų, formų, prisijungimo laukų.
protections-panel-social-media-trackers = Socialiniai tinklai deda stebėjimo elementus kitose svetainėse, kad galėtų sekti ką veikiate, matote, žiūrite naršydami. Tai leidžia kompanijoms sužinoti apie jus žymiai daugiau, negu dalinatės savo socialinių tinklų profiliuose.

protections-panel-description-shim-allowed = Kai kurie žemiau pažymėti stebėjimo elementai yra dalinai neblokuojami šiame tinklalapyje, nes su jais atlikote veiksmų.
protections-panel-description-shim-allowed-learn-more = Sužinoti daugiau
protections-panel-shim-allowed-indicator =
    .tooltiptext = Stebėjimo elementas dalinai neblokuojamas

protections-panel-content-blocking-manage-settings =
    .label = Tvarkyti apsaugos nuostatas
    .accesskey = T

protections-panel-content-blocking-breakage-report-view =
    .title = Pranešti apie neveikiančią svetainę
protections-panel-content-blocking-breakage-report-view-description = Stebėjimo elementų blokavimas gali sutrikdyti kai kurių svetainių veikimą. Pranešdami apie problemas, padėsite tobulinti „{ -brand-short-name }“. Išsiuntus šį pranešimą, „Waterfoxi“ bus perduotas svetainės adresas bei informacija apie jūsų naršyklės nuostatas. <label data-l10n-name="learn-more">Sužinoti daugiau</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Neprivaloma: aprašykite problemą
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Neprivaloma: aprašykite problemą
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Atsisakyti
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Siųsti pranešimą
