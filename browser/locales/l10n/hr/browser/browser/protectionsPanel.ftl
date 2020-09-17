# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Došlo je do greške prilikom slanja izvještaja. Pokušaj ponovo kasnije.
# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Stranica je ispravljena? Pošalji izvještaj

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Strogo
    .label = Strogo
protections-popup-footer-protection-label-custom = Prilagođeno
    .label = Prilagođeno
protections-popup-footer-protection-label-standard = Standardno
    .label = Standardno

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Više informacija o poboljšanoj zaštiti od praćenja
protections-panel-etp-on-header = Pojačana zaštita od praćenja je UKLJUČENA za ovu stranicu
protections-panel-etp-off-header = Pojačana zaštita od praćenja je ISKLJUČENA za ovu stranicu
# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Stranica ne radi?
# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Stranica ne radi?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Zašto?
protections-panel-not-blocking-why-etp-on-tooltip = Blokiranjem ovih elemenata mogu se pokvariti elementi nekih web stranica. Bez programa za praćenje, neki gumbi, obrasci i polja za prijavu možda neće funkcionirati.
protections-panel-not-blocking-why-etp-off-tooltip = Svi pratitelji na ovoj stranici su učitani iz razloga što su zaštite isključene.

##

protections-panel-no-trackers-found = Programi za praćenje koji su poznati { -brand-short-name }u nisu otkriveni na ovoj stranici.
protections-panel-content-blocking-tracking-protection = Praćenje sadržaja
protections-panel-content-blocking-socialblock = Programi za praćenje s društvenih mreža
protections-panel-content-blocking-cryptominers-label = Kripto rudari
protections-panel-content-blocking-fingerprinters-label = Jedinstveni otisci

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Blokirano
protections-panel-not-blocking-label = Dozvoljeno
protections-panel-not-found-label = Ništa otkriveno

##

protections-panel-settings-label = Postavke zaštite
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Nadzorna ploča zaštite

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Isključi zaštite ukoliko imaš problema s:
# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Poljem za prijavu
protections-panel-site-not-working-view-issue-list-forms = Obrascima
protections-panel-site-not-working-view-issue-list-payments = Plaćanjima
protections-panel-site-not-working-view-issue-list-comments = Komentarima
protections-panel-site-not-working-view-issue-list-videos = Videom
protections-panel-site-not-working-view-send-report = Pošaljite izvještaj

##

protections-panel-cross-site-tracking-cookies = Ovi kolačići te prate od stranice do stranice i prikupljaju podatke o tome što radiš na Internetu. Postavljeni su od trećih strana kao što su oglašivači i analitičke tvrtke.
protections-panel-cryptominers = Kripto rudari koriste računalnu snagu tvog sustava kako bi rudarili digitalni novac. Skripte za kripto rudarenje troše bateriju, usporavaju računalo i povećavaju račun za struju.
protections-panel-fingerprinters = Čitači digitalnih otisaka prikupljaju postavke tvog preglednika i računala kako bi stvorili tvoj jedinstveni profil. Koristeći ovaj digitalni otisak, mogu te pratiti diljem raznih web stranica.
protections-panel-tracking-content = Web stranice mogu učitati vanjske reklame, video materijal i drugi sadržaj koji sadržava kȏd za praćenje. Blokiranje praćenja sadržaja može ubrzati učitavanje stranica, ali neke tipke, obrasci ili polja za prijavu možda neće raditi.
protections-panel-social-media-trackers = Društvene mreže postavljaju programe za praćenje na druge web stranice kako bi pratili što radiš, pregledavaš i vidiš na Internetu. Ovo omogućava tvrtkama društvenih mreža o tebi saznati više od onoga što dijeliš na svom profilu.
protections-panel-content-blocking-manage-settings =
    .label = Upravljaj postavkama zaštite
    .accesskey = U
protections-panel-content-blocking-breakage-report-view =
    .title = Prijavi neispravnu web stranicu
protections-panel-content-blocking-breakage-report-view-description = Blokiranje određenih programa za praćenje može uzrokovati probleme s nekim web stranicama. Prijavljivanjem ovih problema pomoći ćeš unaprijediti { -brand-short-name } za sve korisnike. Kad pošalješ ove prijavu, Mozilli ćeš poslati URL stranice i informacije o postavkama preglednika. <label data-l10n-name="learn-more">Saznaj više</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Neobavezno: opišite problem
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Neobavezno: opišite problem
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Otkaži
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Pošalji izvještaj
