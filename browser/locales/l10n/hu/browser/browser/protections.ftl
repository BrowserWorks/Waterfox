# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] A { -brand-short-name } { $count } nyomkövetőt blokkolt az elmúlt héten
       *[other] A { -brand-short-name } { $count } nyomkövetőt blokkolt az elmúlt héten
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> nyomkövető blokkolva { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } óta
       *[other] <b>{ $count }</b> nyomkövető blokkolva { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } óta
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = A { -brand-short-name } továbbra is blokkolja a nyomkövetőket a privát ablakokban, de nem tárolja, hogy mi lett blokkolva.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Követők, melyet a { -brand-short-name } blokkolt a héten

protection-report-webpage-title = Védelmi vezérlőpult
protection-report-page-content-title = Védelmi vezérlőpult
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = Amíg Ön böngészik, a { -brand-short-name } a színfalak mögött gondoskodik az adatvédelméről. Ez ezen védelmek személyre szabott összefoglalója, olyan eszközökkel, melyekkel átveheti az irányítást az online biztonsága felett.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = Amíg Ön böngészik, a { -brand-short-name } a színfalak mögött gondoskodik az adatvédelméről. Ez ezen védelmek személyre szabott összefoglalója, olyan eszközökkel, melyekkel átveheti az irányítást az online biztonsága felett.

protection-report-settings-link = Kezelje az adatvédelmi és biztonsági beállításait

etp-card-title-always = Fokozott követés elleni védelem: Mindig bekapcsolva
etp-card-title-custom-not-blocking = Fokozott követés elleni védelem: KI
etp-card-content-description = A { -brand-short-name } automatikusan megakadályozza, hogy a cégek titokban kövessék Önt a weben.
protection-report-etp-card-content-custom-not-blocking = Jelenleg minden védelem ki van kapcsolva. A { -brand-short-name } védelmi beállításainak kezelésével válassza ki, mely nyomkövetőket blokkolja.
protection-report-manage-protections = Beállítások kezelése

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Ma

# This string is used to describe the graph for screenreader users.
graph-legend-description = Grafikon, amely típusonként tartalmazza a héten blokkolt nyomkövetők számát.

social-tab-title = Közösségimédia-követők
social-tab-contant = A közösségi hálózatok nyomkövetőket helyeznek el más weboldalakon, hogy kövessék mit tesz, lát és néz online. Így a közösségi médiával foglalkozó cégek többet tudhatnak meg Önről, mint amit megoszt a közösségimédia-profiljaiban. <a data-l10n-name="learn-more-link">További tudnivalók</a>

cookie-tab-title = Webhelyek közötti nyomkövető sütik
cookie-tab-content = Ezek a sütik követik a webhelyek között, és információkat gyűjtenek az online tevékenységéről. Ezeket harmadik felek, például hirdető és elemző cégek állítják be. A webhelyek közötti nyomkövető sütik blokkolása csökkenti azon hirdetések számát, amelyek követik Önt. <a data-l10n-name="learn-more-link">További tudnivalók</a>

tracker-tab-title = Nyomkövető tartalom
tracker-tab-description = A weboldalak külső hirdetéseket, videókat és más nyomkövető kódot tartalmazó tartalmat tölthetnek be. A nyomkövető tartalmak blokkolása az oldalak gyorsabb betöltését eredményezheti, de egyes gombok, űrlapok és bejelentkezési mezők lehet, hogy nem fognak működni. <a data-l10n-name="learn-more-link">További tudnivalók</a>

fingerprinter-tab-title = Ujjlenyomat-készítők
fingerprinter-tab-content = A ujjlenyomat-készítők beállításokat gyűjtenek a böngészőjéből és számítógépéből, hogy profilt hozzanak létre Önről. A digitális ujjlenyomat használatával követhetik Ön a különböző webhelyek között. <a data-l10n-name="learn-more-link">További tudnivalók</a>

cryptominer-tab-title = Kriptobányászok
cryptominer-tab-content = A kriptobányászok az Ön rendszerének erőforrásait használják digitális pénzek bányászatához. A kriptobányászok lemerítik az akkumulátort, lelassítják a számítógépét és növelhetik a villanyszámláját. <a data-l10n-name="learn-more-link">További tudnivalók</a>

protections-close-button2 =
    .aria-label = Bezárás
    .title = Bezárás
  
mobile-app-title = Blokkolja a hirdetéskövetőket több eszközön
mobile-app-card-content = Használja a beépített hirdetéskövetés elleni védelemmel ellátott mobilböngészőt.
mobile-app-links = { -brand-product-name } Böngésző <a data-l10n-name="android-mobile-inline-link">Androidra</a> és <a data-l10n-name="ios-mobile-inline-link">iOS-re</a>

lockwise-title = Ne felejtsen el egyetlen jelszót sem
lockwise-title-logged-in2 = Jelszókezelés
lockwise-header-content = A { -lockwise-brand-name } biztonságosan tárolja a jelszavait a böngészőjében.
lockwise-header-content-logged-in = Tárolja biztonságosan, és szinkronizálja a jelszavait az összes eszközén.
protection-report-save-passwords-button = Jelszavak mentése
    .title = Jelszavak mentése ezzel: { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Jelszavak kezelése
    .title = Jelszavak kezelése ezzel: { -lockwise-brand-short-name }
lockwise-mobile-app-title = Vigye magával a jelszavait bárhová
lockwise-no-logins-card-content = Használja a { -brand-short-name }ban mentett jelszavait bármely eszközön.
lockwise-app-links = { -lockwise-brand-name } <a data-l10n-name="lockwise-android-inline-link">Androidra</a> és <a data-l10n-name="lockwise-ios-inline-link">iOS-re</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 jelszó adatsértésben lehet érintett.
       *[other] { $count } jelszó adatsértésben lehet érintett.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 jelszó biztonságosan tárolva.
       *[other] Jelszavait biztonságosan tárolja.
    }
lockwise-how-it-works-link = Hogyan működik

turn-on-sync = { -sync-brand-short-name } bekapcsolása…
    .title = Ugrás a szinkronizálási beállításokhoz

monitor-title = Legyen résen az adatsértések miatt.
monitor-link = Hogyan működik
monitor-header-content-no-account = Ellenőrizze a { -monitor-brand-name } oldalt, és nézze meg, hogy szerepelt-e valamilyen ismert adatsértésben, és kapjon értesítést az új adatsértésekről.
monitor-header-content-signed-in = A { -monitor-brand-name } figyelmezteti, ha az adatai új adatsértésben jelennek meg.
monitor-sign-up-link = Iratkozzon fel az adatsértési figyelmeztetésekre
    .title = Iratkozzon fel az adatsértési figyelmeztetésekre a { -monitor-brand-name }on
auto-scan = Automatikusan ellenőrizve ma

monitor-emails-tooltip =
    .title = Megfigyelt e-mail címek megtekintése a { -monitor-brand-short-name }on
monitor-breaches-tooltip =
    .title = Ismert adatsértések megtekintése a { -monitor-brand-short-name }on
monitor-passwords-tooltip =
    .title = Kikerült jelszavak megtekintése a { -monitor-brand-short-name }on

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Figyelt e-mail cím
       *[other] Figyelt e-mail címek
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Ismert adatsértésben kerültek ki az információi
       *[other] Ismert adatsértésben kerültek ki az információi
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Megoldottként megjelölt adatsértés
       *[other] Megoldottként megjelölt adatsértések
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Adatsértés során kikerült jelszó
       *[other] Adatsértések során kikerült jelszavak
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Megoldatlan adatsértésekben kikerült jelszó
       *[other] Megoldatlan adatsértésekben kikerült jelszavak
    }

monitor-no-breaches-title = Jó hírek!
monitor-no-breaches-description = Nincs ismert adatsértés. Ha ez megváltozik, tájékoztatni fogjuk.
monitor-view-report-link = Jelentés megtekintése
    .title = Adatsértések megoldása a { -monitor-brand-short-name }on
monitor-breaches-unresolved-title = Oldja meg az adatsértéseit
monitor-breaches-unresolved-description = Az adatsértés részleteinek áttekintése és az adatvédelmi lépések megtétele után megoldottnak jelölheti az adatsértéseket.
monitor-manage-breaches-link = Adatsértések kezelése
    .title = Adatsértések kezelése a { -monitor-brand-short-name }on
monitor-breaches-resolved-title = Szép! Megoldotta az összes ismert adatsértést.
monitor-breaches-resolved-description = Ha az e-mail címe új adatsértésben jelenik meg, értesíteni fogjuk.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
       *[other] { $numBreachesResolved } / { $numBreaches } adatsértés megjelölve megoldottként
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% kész

monitor-partial-breaches-motivation-title-start = Nagyszerű kezdés!
monitor-partial-breaches-motivation-title-middle = Csak így tovább!
monitor-partial-breaches-motivation-title-end = Majdnem kész! Csak így tovább.
monitor-partial-breaches-motivation-description = Oldja meg a többi adatsértését a { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Adatsértések megoldása
    .title = Adatsértések megoldása a { -monitor-brand-short-name }on

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Közösségimédia-követők
    .aria-label =
        { $count ->
            [one] { $count } közösségimédia-követő ({ $percentage }%)
           *[other] { $count } közösségimédia-követő ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Webhelyek közötti nyomkövető sütik
    .aria-label =
        { $count ->
            [one] { $count } webhelyek közötti nyomkövető ({ $percentage }%)
           *[other] { $count } webhelyek közötti nyomkövető ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Nyomkövető tartalom
    .aria-label =
        { $count ->
            [one] { $count } nyomkövető tartalom ({ $percentage }%)
           *[other] { $count } nyomkövető tartalom ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Ujjlenyomat-készítők
    .aria-label =
        { $count ->
            [one] { $count } ujjlenyomat-készítő ({ $percentage }%)
           *[other] { $count } ujjlenyomat-készítő ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Kriptobányászok
    .aria-label =
        { $count ->
            [one] { $count } kriptobányász ({ $percentage }%)
           *[other] { $count } kriptobányász ({ $percentage }%)
        }
