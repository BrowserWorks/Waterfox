# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Med pošiljanjem poročila je prišlo do napake. Poskusite znova kasneje.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Stran popravljena? Pošlji poročilo

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Strogo
    .label = Strogo
protections-popup-footer-protection-label-custom = Po meri
    .label = Po meri
protections-popup-footer-protection-label-standard = Običajno
    .label = Običajno

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Več o izboljšani zaščiti pred sledenjem

protections-panel-etp-on-header = Izboljšana zaščita pred sledenjem je VKLJUČENA za to stran
protections-panel-etp-off-header = Izboljšana zaščita pred sledenjem je IZKLJUČENA za to stran

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Stran ne deluje?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Stran ne deluje?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Zakaj?
protections-panel-not-blocking-why-etp-on-tooltip = Zavračanje te vsebine lahko povzroči nedelovanje nekaterih delov spletnih strani. Brez sledilcev nekateri gumbi, obrazci in polja za prijavo morda ne bodo delovali.
protections-panel-not-blocking-why-etp-off-tooltip = Naloženi so vsi sledilci na strani, ker so zaščite izklopljene.

##

protections-panel-no-trackers-found = { -brand-short-name } na strani ni zaznal znanih sledilcev.

protections-panel-content-blocking-tracking-protection = Sledilna vsebina

protections-panel-content-blocking-socialblock = Sledilci družbenih omrežij
protections-panel-content-blocking-cryptominers-label = Kriptorudarji
protections-panel-content-blocking-fingerprinters-label = Sledilci prstnih odtisov

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Zavrnjeno
protections-panel-not-blocking-label = Dovoljeno
protections-panel-not-found-label = Ni zaznanih

##

protections-panel-settings-label = Nastavitve zaščite
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Nadzorna plošča zaščit

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Izklopite zaščite, če imate težave:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = s polji za prijavo
protections-panel-site-not-working-view-issue-list-forms = z obrazci
protections-panel-site-not-working-view-issue-list-payments = s plačili
protections-panel-site-not-working-view-issue-list-comments = s komentarji
protections-panel-site-not-working-view-issue-list-videos = z videi

protections-panel-site-not-working-view-send-report = Pošlji poročilo

##

protections-panel-cross-site-tracking-cookies = Ti piškotki vas spremljajo po straneh in zbirajo podatke o tem, kaj počnete na spletu. Namestijo jih tretje strani, kot so oglaševalci in analitična podjetja.
protections-panel-cryptominers = Kriptorudarji izrabljajo zmogljivost vašega računalnika za rudarjenje digitalnega denarja. Rudarski skripti vam praznijo baterijo, upočasnjujejo računalnik in zasolijo račun za elektriko.
protections-panel-fingerprinters = Sledilci prstnih odtisov zbirajo nastavitve vašega brskalnika in računalnika, da si ustvarijo vaš profil. S pomočjo digitalnega prstnega odtisa vam lahko sledijo na različnih spletnih straneh.
protections-panel-tracking-content = Spletne strani lahko naložijo zunanje oglase, videoposnetke in drugo vsebino s kodo za sledenje. Zavračanje sledilne vsebine lahko pospeši nalaganje spletnih strani, vendar nekateri gumbi in obrazci morda ne bodo delovali.
protections-panel-social-media-trackers = Družbena omrežja postavljajo sledilce na druga spletna mesta, da bi spremljali, kaj počnete, vidite in gledate na spletu. To družbenim medijem omogoča, da o vas izvedo več kot le tisto, kar delite na svojih družbenih profilih.

protections-panel-content-blocking-manage-settings =
    .label = Upravljanje nastavitev zaščite
    .accesskey = U

protections-panel-content-blocking-breakage-report-view =
    .title = Prijavi nedelujočo stran
protections-panel-content-blocking-breakage-report-view-description = Zavračanje določenih sledilcev lahko povzroči težave z nekaterimi spletnimi stranmi. S prijavo težav pomagate izboljšati { -brand-short-name } za vse uporabnike. Mozilli bo poslan naslov spletne strani, kot tudi informacije o nastavitvah vašega brskalnika. <label data-l10n-name="learn-more">Več o tem</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Izbirno: Opišite težavo
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Izbirno: Opišite težavo
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Prekliči
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Pošlji poročilo
