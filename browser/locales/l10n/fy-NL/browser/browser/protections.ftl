# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } hat ôfrûne wike { $count } tracker blokkearre
       *[other] { -brand-short-name } hat ôfrûne wike { $count } trackers blokkearre
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> tracker blokkearre sûnt { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> trackers blokkearre sûnt { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } bliuwt trackers blokkearje yn priveefinsters, mar hâldt net by wat blokkearre is.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Trackers dy't { -brand-short-name } dizze wike blokkearre hat

protection-report-webpage-title = Befeiligingsdashboerd
protection-report-page-content-title = Befeiligingsdashboerd
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } kin efter de skermen jo privacy beskermje wylst jo sneupe. Dit is in personalisearre gearfetting fan dy beskerming, ynklusyf helpmiddelen om fet te krijen op jo online befeiliging.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } beskermet efter de skermen jo privacy wylst jo sneupe. Dit is in personalisearre gearfetting fan dy beskerming, ynklusyf helpmiddelen om fet te krijen op jo online befeiliging.

protection-report-settings-link = Jo privacy- en befeiligingsynstellingen beheare

etp-card-title-always = Ferbettere beskerming tsjin befeiliging: altyd oan
etp-card-title-custom-not-blocking = Ferbettere beskerming tsjin folgjen: ÚT
etp-card-content-description = { -brand-short-name } soarget der automatysk foar dat bedriuwen jo net stikem folgje op ynternet.
protection-report-etp-card-content-custom-not-blocking = Alle beskermingen binne op it stuit útskeakele. Kies hokker trackers jo blokkearje wolle troch jo { -brand-short-name } beskermingsynstellingen te behearen.
protection-report-manage-protections = Ynstellingen beheare

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Hjoed

# This string is used to describe the graph for screenreader users.
graph-legend-description = In grafyk fan it totale oantal trackers per type dy't dizze wike blokkearre binne.

social-tab-title = Sosjale-mediatrackers
social-tab-contant = Sosjale netwurken pleatse trackers op oare websites om te folgjen wat jo online dogge en besjogge. Hjirtroch kinne sosjale-mediabedriuwen mear oer jo leare dan wat jo diele op jo sosjale-mediaprofilen. <a data-l10n-name="learn-more-link">Mear ynfo</a>

cookie-tab-title = Cross-site-trackingcookies
cookie-tab-content = Dizze cookies folgje jo op ferskate websites om gegevens te sammeljen oer wat jo online dogge. Se wurde pleatst troch tredden, lykas advertearders en analysebedriuwen. Troch cross-sitetrackingcookies te blokkearjen, ferminderet it oantal advertinsjes dat jo folget. <a data-l10n-name="learn-more-link">Mear ynfo</a>

tracker-tab-title = Folchynhâld
tracker-tab-description = Websites kinne eksterne advertinsjes, fideo’s en oare ynhâld lade mei folchkoade. It blokkearjen fan folchynhâld kin websites helpe flugger te laden, mar guon knoppen, formulieren en oanmeldfjilden wurkje mooglik net. <a data-l10n-name="learn-more-link">Mear ynfo</a>

fingerprinter-tab-title = Fingerprinters
fingerprinter-tab-content = Fingerprinters sammelje ynstellingen fan jo browser en kompjûter om in profyl fan jo te meitsjen. Mei help fan dizze digitale fingerôfdruk kinne se jo op ferskate websites folgje. <a data-l10n-name="learn-more-link">Mear ynfo</a>

cryptominer-tab-title = Cryptominers
cryptominer-tab-content = Cryptominers brûke de rekkenkrêft fan jo systeem om digitale faluta te generearjen. Cryptominer-scripts lûke jo batterij leech, fertraagje jo kompjûter en kinne jo enerzjyrekkening omheech jeie. <a data-l10n-name="learn-more-link">Mear ynfo</a>

protections-close-button2 =
    .aria-label = Slute
    .title = Slute
  
mobile-app-title = Blokkearje advertinsjetrackers op mear apparaten
mobile-app-card-content = Brûk de mobile browser mei ynboude beskerming tsjin advertinsjetrackers.
mobile-app-links = { -brand-product-name } Browser foar <a data-l10n-name="android-mobile-inline-link">Android</a> en <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Ferjit nea mear in wachtwurd
lockwise-title-logged-in2 = Wachtwurdbehear
lockwise-header-content = { -lockwise-brand-name } bewarret jo wachtwurden feilich yn jo browser.
lockwise-header-content-logged-in = Bewarje en syngronisearje jo wachtwurden feilich op al jo apparaten.
protection-report-save-passwords-button = Wachtwurden bewarje
    .title = Wachtwurden bewarje yn { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Wachtwurden beheare
    .title = Wachtwurden beheare yn { -lockwise-brand-short-name }
lockwise-mobile-app-title = Nim jo wachtwurden oeral mei hinne
lockwise-no-logins-card-content = Brûk yn { -brand-short-name } bewarre wachtwurden op elk apparaat.
lockwise-app-links = { -lockwise-brand-name } foar <a data-l10n-name="lockwise-android-inline-link">Android</a> en <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] Der is mooglik in wachtwurd lekt yn in datalek.
       *[other] Der binne mooglik { $count } wachtwurden lekt yn in datalek.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] In wachtwurd is feilich bewarre.
       *[other] Jo wachtwurden wurde feilich bewarre.
    }
lockwise-how-it-works-link = Hoe't it wurket

turn-on-sync = { -sync-brand-short-name } ynskeakelje…
    .title = Nei syngronisaasjefoarkarren

monitor-title = Let op datalekken
monitor-link = Hoe't it wurket
monitor-header-content-no-account = Sjoch op { -monitor-brand-name } om te sjen oft jo troffen binne troch in bekend datalek en ûntfang warskôgingen oer nije datalekken.
monitor-header-content-signed-in = { -monitor-brand-name } warskôget jo as jo gegevens foarkomme yn in bekend datalek
monitor-sign-up-link = Ynskriuwe foar warskôgingen oer datalekken
    .title = Ynskriuwe foar warskôgingen oer datalekken op { -monitor-brand-name }
auto-scan = Hjoed automatysk scand

monitor-emails-tooltip =
    .title = Besjoch kontrolearre e-mailadressen op { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Besjoch bekende datalekken op { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Besjoch lekte wachtwurden op { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] e-mailadres wurdt bewekke
       *[other] e-mailadressen wurde bewekke
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] bekend datalek hat jo gegevens lekt
       *[other] bekende datalekken hawwe jo gegevens lekt
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Bekend datalek as oplost markearre
       *[other] Bekende datalekken as oplost markearre
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] wachtwurd lekt yn alle datalekken
       *[other] wachtwurden lekt yn alle datalekken
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Wachtwurd lekt yn net oploste datalekken
       *[other] Wachtwurden lekt yn net oploste datalekken
    }

monitor-no-breaches-title = Goed nijs!
monitor-no-breaches-description = Jo binne net troch bekende datalekken troffen. As dit wiziget, dan litten wy it jo witte.
monitor-view-report-link = Rapport besjen
    .title = Datalekken oplosse op { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Jo datalekken oplosse
monitor-breaches-unresolved-description = Neidat jo de details oer in datalek besjoen hawwe en stappen om jo gegevens te beskermjen nommen hawwe, kinne jo lekken as oplost markearje.
monitor-manage-breaches-link = Datalekken beheare
    .title = Datalekken beheare op { -monitor-brand-short-name }
monitor-breaches-resolved-title = Kreas! Jo hawwe alle bekende datalekken oplost.
monitor-breaches-resolved-description = As jo e-mailadres foarkomt yn nije datalekken, dan litten wy jo dat witte.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } fan { $numBreaches } lek as oplost markearre
       *[other] { $numBreachesResolved } fan { $numBreaches } lekken as oplost markearre
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% foltôge

monitor-partial-breaches-motivation-title-start = Prima begjin!
monitor-partial-breaches-motivation-title-middle = Gean sa troch!
monitor-partial-breaches-motivation-title-end = Hast klear! Gean sa troch.
monitor-partial-breaches-motivation-description = Los de rest fan jo lekken op op { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Datalekken oplosse
    .title = Datalekken oplosse op { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Sosjale-mediatrackers
    .aria-label =
        { $count ->
            [one] { $count } sosjale-mediatracker ({ $percentage }%)
           *[other] { $count } sosjale-mediatrackers ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Cross-site-trackingcookies
    .aria-label =
        { $count ->
            [one] { $count } cross-site-trackingcookie ({ $percentage }%)
           *[other] { $count } cross-site-trackingcookies ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Folchynhâld
    .aria-label =
        { $count ->
            [one] { $count } folchynhâlditem ({ $percentage }%)
           *[other] { $count } folchynhâlditems ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Fingerprinters
    .aria-label =
        { $count ->
            [one] { $count } fingerprinter ({ $percentage }%)
           *[other] { $count } fingerprinters ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Cryptominers
    .aria-label =
        { $count ->
            [one] { $count } cryptominer ({ $percentage }%)
           *[other] { $count } cryptominers ({ $percentage }%)
        }
