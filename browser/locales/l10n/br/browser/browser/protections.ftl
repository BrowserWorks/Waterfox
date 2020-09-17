# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { $count } heulier a zo bet stanket gant { -brand-short-name } ar sizhun tremenet
        [two] { $count } heulier a zo bet stanket gant { -brand-short-name } ar sizhun tremenet
        [few] { $count } heulier a zo bet stanket gant { -brand-short-name } ar sizhun tremenet
        [many] { $count } a heulierien a zo bet stanket gant { -brand-short-name } ar sizhun tremenet
       *[other] { $count } heulier a zo bet stanket gant { -brand-short-name } ar sizhun tremenet
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> heulier stanket abaoe { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [two] <b>{ $count }</b> heulier stanket abaoe { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [few] <b>{ $count }</b> heulier stanket abaoe { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [many] <b>{ $count }</b> a heulierien stanket abaoe { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> heulier stanket abaoe { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } a gendalc'h da stankañ heulierien er merdeiñ prevez, met ne zalc'h ket soñj eus ar pezh vez stanket.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Heulierien stanket gant { -brand-short-name } ar sizhun-mañ

protection-report-webpage-title = Taolenn-stur ar gwarezioù
protection-report-page-content-title = Taolenn-stur ar gwarezioù
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } a c'hall gwareziñ ho puhez prevez diouzh an drekleur p'emaoc'h o verdeiñ. Un diverradenn personelaet deus ar gwarezioù-se eo, gant binviji evit kontrollañ ho surentez enlinenn.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } a warez ho puhez prevez diouzh an drekleur p'emaoc'h o verdeiñ. Un diverradenn personelaet deus ar gwarezioù-se eo, gant binviji evit kontrollañ ho surentez enlinenn.

protection-report-settings-link = Merañ hoc’h arventennoù prevezded ha surentez

etp-card-title-always = Gwarez heuliañ araokaet : bepred gweredekaet
etp-card-title-custom-not-blocking = Gwarez heuliañ araokaet : DIWEREDEKAET
etp-card-content-description = { -brand-short-name } a vir ouzh an embregerezhioù, en un doare emgefreek, d'ho heuliañ war ar web dre-guzh.
protection-report-etp-card-content-custom-not-blocking = Diweredekaet eo an holl warezioù. Dibabit pe heulier a fell deoc'h stankañ en ur verañ hoc'h arventennoù buhez prevez { -brand-short-name }.
protection-report-manage-protections = Merañ an arventennoù

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Hiziv

# This string is used to describe the graph for screenreader users.
graph-legend-description = Ur c'hevregad gant an niver hollek a zoareoù heulierien stanket ar sizhun-mañ ennañ.

social-tab-title = Heulierien Media kevredadel
social-tab-contant = Gant ar rouedadoù kevredadel e vez lakaet heulierien evit gallout gwelet war al lec'hiennoù all ar pezh a sellit hag a rit enlinenn. Evel-se e c'hall an embregerezhioù media kevredadel deskiñ hiroc'h diwar ar pezh a rannit war hoc'h aeladoù media kevredadel. <a data-l10n-name="learn-more-link">Gouzout hiroc'h</a>

cookie-tab-title = Toupinoù heuliañ etre al lec'hiennoù
cookie-tab-content = An toupinoù-se a heuilh ac'hanoc'h a lec'hien da lec'hienn evit dastum roadennoù diwar-benn ar pezh a rit enlinenn. Lakaet int gant tredeoù brudañ ha dielfennañ. Stankañ an toupinoù etre-lec'hiennoù a ziskenn an niver a vruderezh a c'hall hoc'h heuliañ. <a data-l10n-name="learn-more-link">Gouzout hiroc'h</a>

tracker-tab-title = Endalc'had heuliañ
tracker-tab-description = Gallout a ra al lec'hiennoù kargañ bruderezh, videoioù pe traoù diavaez all gant ur boneg heuliañ. Stankañ an endalc'hadoù heuliañ a c'hall herrekaat al lec'hiennoù met gallout a ra lod eus an afelloù, furmskridoù pe maeziennoù kennaskañ chom hep mont en-dro. <a data-l10n-name="learn-more-link">Gouzout hiroc'h</a>

fingerprinter-tab-title = Dinoerien roudoù niverel
fingerprinter-tab-content = An dinoerien roudoù niverel a zastum arventennoù ho merdeer hag hoc'h urzhiataer evit sevel un aelad diwar ho penn. En ur implij ar roudoù-se e c'hall heuliañ ac'hanoc'h war veur a lec'hienn. <a data-l10n-name="learn-more-link">Gouzout hiroc'h</a>

cryptominer-tab-title = Kriptogleuzerien
cryptominer-tab-content = Gant ar c'hriptogleuzerien e vez implijet gallout jediñ ho reizhiad evit kleuziañ arc'hant niverel. Skriptoù kriptogleuziañ a implij kalz ho patiri, a c'horreka hoc'h urzhiataer hag a lak ho fakturenn tredan da vezañ keroc'h. <a data-l10n-name="learn-more-link">Gouzout hiroc'h</a>

protections-close-button2 =
    .aria-label = Serriñ
    .title = Serriñ
  
mobile-app-title = Stankañ an heulierien bruderezh war meur a ardivink
mobile-app-links = { -brand-product-name } Merdeer evit <a data-l10n-name="android-mobile-inline-link">Android</a> ha <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Na zisoñjit biken ken ur ger-tremen
lockwise-title-logged-in2 = Merañ ar gerioù-tremen
lockwise-header-content = { -lockwise-brand-name } a zalc'h diogelet ho kerioù-tremen en ho merdeer.
lockwise-header-content-logged-in = Kadavit ha goubredit ho kerioù-tremen etre ho holl drevnadoù en un doare diogel.
protection-report-save-passwords-button = Enrollañ ar gerioù-tremen
    .title = Enrollañ ar gerioù-tremen e-barzh { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Merañ ar gerioù-tremen
    .title = Merañ ar gerioù-tremen e-barzh{ -lockwise-brand-short-name }
lockwise-mobile-app-title = Tapit ho kerioù-tremen ganeoc'h e pep lec'h
lockwise-no-logins-card-content = Implijit ar gerioù-tremen enrollet e { -brand-short-name } war kement trevnad.
lockwise-app-links = { -lockwise-brand-name } evit <a data-l10n-name="lockwise-android-inline-link">Android</a> hag <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

lockwise-how-it-works-link = Penaos ez a en-dro

turn-on-sync = Gweredekaat { -sync-brand-short-name }…
    .title = Mont d'ar gwellvezioù goubredañ

monitor-title = Diwallit diouzh ar fuadurioù roadennoù
monitor-link = Penaos ec'h a en-dro
monitor-header-content-no-account = Gwiriekait { -monitor-brand-name } evit gwelout mard oc'h bet tizhet gant ur fuadur roadennoù, ha resevit galvoù-diwall a-zivout fuadurioù nevez.
monitor-header-content-signed-in = { -monitor-brand-name } a c'halv ac'hanoc'h ma vez ho titouroù en ur fuadur roadennoù.
auto-scan = Gwiriekaet hiziv ent emgefreek

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

