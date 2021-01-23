# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } je blokirao  { $count } program za praćenje u zadnjih tjedan dana
        [few] { -brand-short-name } je blokirao  { $count } programa za praćenje u zadnjih tjedan dana
       *[other] { -brand-short-name } je blokirao  { $count } programa za praćenje u zadnjih tjedan dana
    }
# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> pratitelj blokiran od { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [few] <b>{ $count }</b> pratitelja blokirana od { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> pratitelja blokirano od { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }
# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } nastavlja blokirati programe za praćenje u privatnim prozorima, ali ne vodi evidenciju o tome što je blokirano.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Programi za praćenje, koje je { -brand-short-name } blokirao ovaj tjedan
protection-report-webpage-title = Nadzorna ploča zaštite
protection-report-page-content-title = Nadzorna ploča zaštite
protection-report-settings-link = Upravljaj svojim postavkama za privatnost i sigurnost
etp-card-title-always = Poboljšana zaštita od praćenja: uvijek uključeno
etp-card-title-custom-not-blocking = Poboljšana zaštita od praćenja: ISKLJUČENO
protection-report-etp-card-content-custom-not-blocking = Sve zaštite su trenutačno isključene. Upravljaj programima za praćenje koje želiš blokirati u { -brand-short-name } postavkama zaštite.
protection-report-manage-protections = Upravljaj postavkama
# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Danas
# This string is used to describe the graph for screenreader users.
graph-legend-description = Dijagram sadrži ukupni broj svake vrste programa za praćenje koji su ovaj tjedan bili blokirani.
social-tab-title = Programi za praćenje s društvenih mreža
social-tab-contant = Društvene mreže postavljaju programe za praćenje na druge web stranice kako bi pratili što radiš, vidiš i gledaš na mreži. To omogućava društvenim medijima saznati o tebi više od onoga što dijeliš na svojim profilima na društvenim mrežama. <a data-l10n-name="learn-more-link">Saznaj više</a>
cookie-tab-title = Kolačići za praćenje između web stranica
cookie-tab-content = Ovi kolačići te prate od web stranice do web stranice, kako bi prikupili podatke o tome što radiš na mreži. Postavljaju ih treće strane poput oglašivača i analitičkih tvrtki. Blokiranje kolačića za praćenje među web stranicama, smanjuje broj oglasa koji te prate. <a data-l10n-name="learn-more-link">Saznaj više</a>
tracker-tab-title = Praćenje sadržaja
tracker-tab-description = Web stranice mogu učitati vanjske reklame, video materijal i drugi sadržaj koji sadržava kod za praćenje. Blokiranje praćenja sadržaja može ubrzati učitavanje stranica, ali neke tipke, obrasci ili polja za prijavu možda neće raditi. <a data-l10n-name="learn-more-link">Saznaj više</a>
fingerprinter-tab-title = Čitači digitalnog otiska
fingerprinter-tab-content = Čitači digitalnog otiska prikupljaju postavke tvog preglednika i računala kako bi stvorili tvoj profil. Pomoću ovog digitalnog otiska mogu te pratiti na različitim web stranicama. <a data-l10n-name="learn-more-link">Saznaj više</a>
cryptominer-tab-title = Kripto rudari
cryptominer-tab-content = Krupto rudari koriste računalnu snagu tvog sustava kako bi rudarili digitalni novac. Skripte za kripto rudarenje troše bateriju, usporavaju računalo i povećavaju račun za struju. <a data-l10n-name="learn-more-link">Saznaj više</a>
protections-close-button2 =
    .aria-label = Zatvori
    .title = Zatvori
mobile-app-title = Blokiraj oglase koji te prate na više uređaja
mobile-app-card-content = Koristi mobilni preglednik s ugrađenom zaštitom od praćenja.
mobile-app-links = { -brand-product-name } preglednik za <a data-l10n-name="android-mobile-inline-link">Android</a> i <a data-l10n-name="ios-mobile-inline-link">iOS</a>
lockwise-title = Ne zaboravi lozinku nikad više
lockwise-title-logged-in2 = Upravljanje lozinkama
lockwise-header-content = { -lockwise-brand-name } sigurno sprema tvoje lozinke u pregledniku.
lockwise-header-content-logged-in = Spremaj i sinkroniziraj lozinke na svim svojim uređajima na siguran način.
protection-report-save-passwords-button = Spremi lozinke
    .title = Spremi lozinke u { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Upravljanje lozinkama
    .title = Upravljanje lozinkama s { -lockwise-brand-short-name }
lockwise-mobile-app-title = Ponesi svoje lozinke sa sobom
lockwise-no-logins-card-content = Koristi lozinke koje su spremljene u { -brand-short-name }u na bilo kojem uređaju.
lockwise-app-links = { -lockwise-brand-name } za <a data-l10n-name="lockwise-android-inline-link">Android</a> i <a data-l10n-name="lockwise-ios-inline-link">iOS</a>
# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] { $count } lozinka je možda izložena curenju podataka.
        [few] { $count } lozinke su možda izložene curenju podataka.
       *[other] { $count } lozinki je možda izloženo curenju podataka.
    }
# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] Jedna lozinka sigurno je pohranjena.
        [few] Tvoje lozinke sigurno su pohranjene.
       *[other] Tvoje lozinke sigurno su pohranjene.
    }
lockwise-how-it-works-link = Kako ovo funkcionira
turn-on-sync = Uključi { -sync-brand-short-name } …
    .title = Prijeđi na postavke sinkronizacije
monitor-title = Pazi na curenje podataka
monitor-link = Kako funkcionira
monitor-header-content-no-account = Koristi { -monitor-brand-name } i provjeri, je li se tvoji podaci nalaze u poznatom curenja podataka te dobivaj obavijesti o novim curenjima podataka.
monitor-header-content-signed-in = { -monitor-brand-name } te upozorava ukoliko su se tvoji podaci pojavili u curenju podataka.
auto-scan = Danas automatski pretraženo
monitor-emails-tooltip =
    .title = Pogledaj praćene e-adrese na { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Pogledaj poznata curenja podataka na { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Pogledaj izložene lozinke na { -monitor-brand-short-name }
# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Adresa e-pošte se nadgleda
        [few] Adrese e-pošte se nadgledaju
       *[other] Adresa e-pošte se nadgleda
    }
# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] poznato curenje podataka je izložilo tvoje informacije
        [few] poznata curenja podataka su izložila tvoje informacije
       *[other] poznatih curenja podataka je izložilo tvoje informacije
    }
# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] lozinka je izložena u curenja podataka
        [few] lozinke su izložene u curenju podataka
       *[other] lozinki je izloženo u curenju podataka
    }
monitor-no-breaches-title = Dobre vijesti!
# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved } % gotovo
monitor-partial-breaches-motivation-title-start = Odličan početak!
monitor-partial-breaches-motivation-title-middle = Samo tako nastavi!
monitor-partial-breaches-motivation-title-end = Skoro gotovo! Samo tako nastavi.

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Programi za praćenje s društvenih mreža
    .aria-label =
        { $count ->
            [one] { $count } program za praćenje s društvenih mreža { $percentage }
            [few] { $count } programa za praćenje s društvenih mreža { $percentage }
           *[other] { $count } programa za praćenje s društvenih mreža { $percentage }
        }
bar-tooltip-cookie =
    .title = Kolačići za praćenje među web lokacijama
    .aria-label =
        { $count ->
            [one] { $count } kolačić za praćenje među web lokacijama ({ $percentage }%)
            [few] { $count } kolačića za praćenje među web lokacijama ({ $percentage }%)
           *[other] { $count } kolačića za praćenje među web lokacijama ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Praćenje sadržaja
    .aria-label =
        { $count ->
            [one] { $count } praćenje sadržaja { $percentage }
            [few] { $count } praćenja sadržaja { $percentage }
           *[other] { $count } praćenja sadržaja { $percentage }
        }
bar-tooltip-fingerprinter =
    .title = Čitači digitalnog otiska
    .aria-label =
        { $count ->
            [one] { $count } čitač digitalnog otiska ({ $percentage }%)
            [few] { $count } čitača digitalnog otiska ({ $percentage }%)
           *[other] { $count } čitača digitalnog otiska ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Kripto rudari
    .aria-label =
        { $count ->
            [one] { $count } kripto rudar ({ $percentage }%)
            [few] { $count } kripto rudara ({ $percentage }%)
           *[other] { $count } kripto rudara ({ $percentage }%)
        }
