# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] Per pastarąją savaitę „{ -brand-short-name }“ užblokavo { $count } stebėjimo elementą
        [few] Per pastarąją savaitę „{ -brand-short-name }“ užblokavo { $count } stebėjimo elementus
       *[other] Per pastarąją savaitę „{ -brand-short-name }“ užblokavo { $count } stebėjimo elementų
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] Nuo { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } buvo užblokuotas <b>{ $count }</b> stebėjimo elementas
        [few] Nuo { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } buvo užblokuoti <b>{ $count }</b> stebėjimo elementai
       *[other] Nuo { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } buvo užblokuota <b>{ $count }</b> stebėjimo elementų
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = „{ -brand-short-name }“ ir toliau blokuoja stebėjimo elementus privačiojo naršymo languose, tačiau nefiksuoja, kas buvo užblokuota.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Šią savaitę „{ -brand-short-name }“ užblokuoti stebėjimo elementai

protection-report-webpage-title = Apsaugos skydelis
protection-report-page-content-title = Apsaugos skydelis
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = „{ -brand-short-name }“ gali saugoti jūsų privatumą jums naršant. Čia pateikiama asmeninė šios apsaugos santrauka, kartu su įrankiais, kurie leidžia tai valdyti.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = „{ -brand-short-name }“ saugo jūsų privatumą jums naršant. Čia pateikiama asmeninė šios apsaugos santrauka, kartu su įrankiais, kurie leidžia tai valdyti.

protection-report-settings-link = Tvarkykite savo privatumo ir saugumo nuostatas

etp-card-title-always = Išplėsta apsauga nuo stebėjimo: visada įjungta
etp-card-title-custom-not-blocking = Išplėsta apsauga nuo stebėjimo: išjungta
etp-card-content-description = „{ -brand-short-name }“ automatiškai blokuoja kompanijų bandymus sekti jūsų veiklą internete.
protection-report-etp-card-content-custom-not-blocking = Šiuo metu visos apsaugos yra išjungtos. Pasirinkite, ką norite blokuoti, per savo „{ -brand-short-name }“ apsaugų nuostatas.
protection-report-manage-protections = Keisti nuostatas

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Šiandien

# This string is used to describe the graph for screenreader users.
graph-legend-description = Grafikas, kuriame pavaizduotas bendras kiekvieno per šia savaitę užblokuoto stebėjimo lementų tipo skaičius.

social-tab-title = Socialinių tinklų stebėjimo elementai
social-tab-contant = Socialiniai tinklai deda stebėjimo elementus kitose svetainėse, kad galėtų sekti ką veikiate, matote, žiūrite naršydami. Tai leidžia kompanijoms sužinoti apie jus žymiai daugiau, negu dalinatės savo socialinių tinklų profiliuose. <a data-l10n-name="learn-more-link">Sužinoti daugiau</a>

cookie-tab-title = Tarp svetainių veikiantys stebėjimo slapukai
cookie-tab-content = Šie slapukai seka jus tarp skirtingų svetainių, rinkdami informaciją, ką veikiate naršydami. Jie yra valdomi trečiųjų šalių, pvz., reklamų kūrėjų arba analitikos kompanijų. Juos blokuodami sumažinsite jus sekančių reklamų kiekį. <a data-l10n-name="learn-more-link">Sužinoti daugiau</a>

tracker-tab-title = Stebėjimui naudojamas turinys
tracker-tab-description = Svetainės gali įkelti išorines reklamas, vaizdo įrašus, ir kitą turinį su stebėjimo kodu. Tokio turinio blokavimas gali leisti gerčiau įkelti svetaines, tačiau kartu gali neveikti dalis mygtukų, formų, prisijungimo laukų. <a data-l10n-name="learn-more-link">Sužinoti daugiau</a>

fingerprinter-tab-title = Skaitmeninių atspaudų stebėjimas
fingerprinter-tab-content = Skaitmeninių atspaudų stebėjimo metu surenkama informacija apie jūsų naršyklės ir kompiuterio parametrus, kad būtų sudarytas jūsų profilis. Jį turint, jus galima sekti tarp skirtingų svetainių. <a data-l10n-name="learn-more-link">Sužinoti daugiau</a>

cryptominer-tab-title = Kriptovaliutų kasėjai
cryptominer-tab-content = Kriptovaliutų kasėjai naudoja jūsų kompiuterio resursus, kad iškastų skaitmeninių pinigų. Šis procesas eikvoja jūsų bateriją, lėtina kompiuterio veikimą, ir gali padidinti sąskaitą už elektrą. <a data-l10n-name="learn-more-link">Sužinoti daugiau</a>

protections-close-button2 =
    .aria-label = Užverti
    .title = Užverti
  
mobile-app-title = Blokuokite reklaminius elementus ir kituose įrenginiuose
mobile-app-card-content = Naudokite mobiliąją naršyklę su integruota apsauga nuo reklaminių stebėjimo elementų.
mobile-app-links = „{ -brand-product-name }“ naršyklė, skirta <a data-l10n-name="android-mobile-inline-link">„Android“</a> ir <a data-l10n-name="ios-mobile-inline-link">„iOS“</a>

lockwise-title = Daugiau nepamirškite nė vieno slaptažodžio
lockwise-title-logged-in2 = Slaptažodžių tvarkymas
lockwise-header-content = „{ -lockwise-brand-name }“ saugiai įrašo slaptažodžius į jūsų naršyklę.
lockwise-header-content-logged-in = Saugiai laikykite ir sinchronizuokite slaptažodžius tarp visų savo įrenginių.
protection-report-save-passwords-button = Laikyti slaptažodžius
    .title = Laikyti slaptažodžius su „{ -lockwise-brand-short-name }“
protection-report-manage-passwords-button = Tvarkyti slaptažodžius
    .title = Tvarkyti slaptažodžius su „{ -lockwise-brand-short-name }“
lockwise-mobile-app-title = Turėkite savo slaptažodžius visur
lockwise-no-logins-card-content = Slaptažodžius, esančius „{ -brand-short-name }“, galite naudoti bet kuriame įrenginyje.
lockwise-app-links = „{ -lockwise-brand-name }“, skirta „<a data-l10n-name="lockwise-android-inline-link">„Android“</a> ir <a data-l10n-name="lockwise-ios-inline-link">„iOS“</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 slaptažodis galėjo patekti tarp nutekėjusių duomenų.
        [few] { $count } slaptažodžiai galėjo patekti tarp nutekėjusių duomenų.
       *[other] { $count } slaptažodžių galėjo patekti tarp nutekėjusių duomenų.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 saugiai laikomas slaptažodis.
        [few] Jūsų slaptažodžiai laikomi saugiai.
       *[other] Jūsų slaptažodžiai laikomi saugiai.
    }
lockwise-how-it-works-link = Kaip tai veikia

turn-on-sync = Įjungti „{ -sync-brand-short-name }“…
    .title = Eiti į sinchronizavimo nuostatas

monitor-title = Būkite informuoti apie duomenų pažeidimus
monitor-link = Kaip tai veikia
monitor-header-content-no-account = „{ -monitor-brand-name }“ pateikia informaciją apie tai, ar jūsų duomenys yra patekę tarp nutekėjusių, ir gali pranešti apie naujus pažeidimus.
monitor-header-content-signed-in = „{ -monitor-brand-name }“ perspėja, kai jūsų duomenys pasirodo žinomuose duomenų nutekėjimuose.
monitor-sign-up-link = Gauti įspėjimus apie duomenų nutekėjimus
    .title = Gauti įspėjimus apie duomenų nutekėjimus su „{ -monitor-brand-name }“
auto-scan = Automatiškai skenuota šiandien

monitor-emails-tooltip =
    .title = Peržiūrėti stebimus el. pašto adresus per „{ -monitor-brand-short-name }“
monitor-breaches-tooltip =
    .title = Peržiūrėti žinomus duomenų nutekėjimus per „{ -monitor-brand-short-name }“
monitor-passwords-tooltip =
    .title = Peržiūrėti nutekėjusius slaptažodžius per „{ -monitor-brand-short-name }“

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] stebimas el. pašto adresas
        [few] stebimi el. pašto adresai
       *[other] stebimų el. pašto adresų
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] žinomas duomenų nutekėjimas atskleidė jūsų informaciją
        [few] žinomi duomenų nutekėjimai atskleidė jūsų informaciją
       *[other] žinomų duomenų nutekėjimų atskleidė jūsų informaciją
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] patikrintas žinomas duomenų nutekėjimas
        [few] patikrinti žinomi duomenų nutekėjimai
       *[other] patikrintų žinomų duomenų nutekėjimų
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] atskleistas slaptažodis tarp visų nutekėjimų
        [few] atskleisti slaptažodžiai tarp visų nutekėjimų
       *[other] atskleistų slaptažodžių tarp visų nutekėjimų
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] nepatikrintas nutekėjęs slaptažodis
        [few] nepatikrinti nutekėję slaptažodžiai
       *[other] nepatikrintų nutekėjusių slaptažodžių
    }

monitor-no-breaches-title = Geros žinios!
monitor-no-breaches-description = Neturite jokių žinomų duomenų nutekėjimų. Jei tai pasikeis, jums pranešime.
monitor-view-report-link = Peržiūrėti ataskaitą
    .title = Patikrinti nutekėjimus su „{ -monitor-brand-short-name }“
monitor-breaches-unresolved-title = Patikrinkite savo nutekėjimus
monitor-breaches-unresolved-description = Peržiūrėję nutekėjimų informaciją ir apsaugoję savo duomenis, galite pažymėti nutekėjimus kaip patikrintus.
monitor-manage-breaches-link = Tvarkyti nutekėjimus
    .title = Tvarkyti nutekėjimus su „{ -monitor-brand-short-name }“
monitor-breaches-resolved-title = Puiku! Patikrinote visus žinomus nutekėjimus.
monitor-breaches-resolved-description = Jei jūsų el. paštas pasirodys naujuose nutekėjimuose, jums pranešime.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] Patikrintas { $numBreachesResolved } iš { $numBreaches } nutekėjimų
        [few] Patikrinti { $numBreachesResolved } iš { $numBreaches } nutekėjimų
       *[other] Patikrinta { $numBreachesResolved } iš { $numBreaches } nutekėjimų
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = Užbaigta { $percentageResolved }%

monitor-partial-breaches-motivation-title-start = Puiki pradžia!
monitor-partial-breaches-motivation-title-middle = Tęskite toliau!
monitor-partial-breaches-motivation-title-end = Beveik baigta! Tęskite toliau.
monitor-partial-breaches-motivation-description = Patikrinkite savo likusius nutekėjimus su „{ -monitor-brand-short-name }“.
monitor-resolve-breaches-link = Patikrinti nutekėjimus
    .title = Patikrinti nutekėjimus su „{ -monitor-brand-short-name }“

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Socialinių tinklų stebėjimo elementai
    .aria-label =
        { $count ->
            [one] { $count } socialinių tinklų stebėjimo elementas ({ $percentage }%)
            [few] { $count } socialinių tinklų stebėjimo elementai ({ $percentage }%)
           *[other] { $count } socialinių tinklų stebėjimo elementų ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Tarp svetainių veikiantys stebėjimo slapukai
    .aria-label =
        { $count ->
            [one] { $count } tarp svetainių veikiantis stebėjimo slapukas ({ $percentage }%)
            [few] { $count } tarp svetainių veikiantys stebėjimo slapukai ({ $percentage }%)
           *[other] { $count } tarp svetainių veikiančių stebėjimo slapukų ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Stebėjimui naudojamas turinys
    .aria-label =
        { $count ->
            [one] { $count } stebėjimui naudojamas turinys ({ $percentage }%)
            [few] { $count } stebėjimui naudojami turiniai ({ $percentage }%)
           *[other] { $count } stebėjimui naudojamų turinių ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Skaitmeninių atspaudų stebėjimas
    .aria-label =
        { $count ->
            [one] { $count } skaitmeninių atspaudų stebėjimas ({ $percentage }%)
            [few] { $count } skaitmeninių atspaudų stebėjimai ({ $percentage }%)
           *[other] { $count } skaitmeninių atspaudų stebėjimų ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Kriptovaliutų kasėjai
    .aria-label =
        { $count ->
            [one] { $count } kriptovaliutų kasėjas ({ $percentage }%)
            [few] { $count } kriptovaliutų kasėjai ({ $percentage }%)
           *[other] { $count } kriptovaliutų kasėjų ({ $percentage }%)
        }
