# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } zablokował { $count } element śledzący w ciągu ostatniego tygodnia
        [few] { -brand-short-name } zablokował { $count } elementy śledzące w ciągu ostatniego tygodnia
       *[many] { -brand-short-name } zablokował { $count } elementów śledzących w ciągu ostatniego tygodnia
    }
# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] Od { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } zablokowano <b>{ $count }</b> element śledzący
        [few] Od { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } zablokowano <b>{ $count }</b> elementy śledzące
       *[many] Od { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } zablokowano <b>{ $count }</b> elementów śledzących
    }
# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } blokuje elementy śledzące w oknach prywatnych, ale nie zachowuje informacji o tym, co zostało zablokowane.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Elementy śledzące zablokowane przez przeglądarkę { -brand-short-name } w tym tygodniu
protection-report-webpage-title = Panel ochrony
protection-report-page-content-title = Panel ochrony
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } może po cichu chronić Twoją prywatność, kiedy Ty przeglądasz Internet. Poniżej znajduje się spersonalizowane podsumowanie ochrony, a także narzędzia do przejęcia kontroli nad własnym bezpieczeństwem w sieci.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } po cichu chroni Twoją prywatność, kiedy Ty przeglądasz Internet. Poniżej znajduje się spersonalizowane podsumowanie ochrony, a także narzędzia do przejęcia kontroli nad własnym bezpieczeństwem w sieci.
protection-report-settings-link = Otwórz ustawienia prywatności i bezpieczeństwa
etp-card-title-always = Wzmocniona ochrona przed śledzeniem: zawsze włączona
etp-card-title-custom-not-blocking = Wzmocniona ochrona przed śledzeniem: wyłączona
etp-card-content-description = { -brand-short-name } automatycznie uniemożliwia firmom potajemne śledzenie Cię w Internecie.
protection-report-etp-card-content-custom-not-blocking = Cała ochrona jest obecnie wyłączona. Wybierz, które elementy śledzące blokować w ustawieniach ochrony przeglądarki { -brand-short-name }.
protection-report-manage-protections = Zarządzaj ustawieniami
# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = dzisiaj
# This string is used to describe the graph for screenreader users.
graph-legend-description = Wykres zawierający całkowitą liczbę każdego typu elementów śledzących zablokowanych w tym tygodniu.
social-tab-title = Elementy śledzące serwisów społecznościowych
social-tab-contant = Serwisy społecznościowe umieszczają elementy śledzące na innych witrynach, aby śledzić co robisz, widzisz i oglądasz w Internecie. Dzięki temu ich właściciele wiedzą o Tobie więcej, niż udostępniasz w ich serwisach. <a data-l10n-name="learn-more-link">Więcej informacji</a>
cookie-tab-title = Ciasteczka śledzące między witrynami
cookie-tab-content = Te ciasteczka śledzą Cię od strony do strony w celu zbierania danych o tym, co robisz w Internecie. Są umieszczane przez zewnętrzne firmy, takie jak agencje reklamowe i firmy analityczne. Blokowanie tych ciasteczek zmniejsza liczbę reklam, które chodzą Twoim śladem. <a data-l10n-name="learn-more-link">Więcej informacji</a>
tracker-tab-title = Treści z elementami śledzącymi
tracker-tab-description = Witryny mogą wczytywać zewnętrzne reklamy, filmy i inne treści z elementami śledzącymi. Blokowanie ich może przyspieszyć wczytywanie stron, ale niektóre przyciski, formularze i pola logowania mogą działać niepoprawnie. <a data-l10n-name="learn-more-link">Więcej informacji</a>
fingerprinter-tab-title = Elementy śledzące przez zbieranie informacji o konfiguracji
fingerprinter-tab-content = Te elementy zbierają ustawienia przeglądarki i komputera, aby utworzyć profil użytkownika. Za pomocą tego cyfrowego odcisku palca mogą śledzić Cię między różnymi witrynami. <a data-l10n-name="learn-more-link">Więcej informacji</a>
cryptominer-tab-title = Elementy używające komputera użytkownika do generowania kryptowalut
cryptominer-tab-content = Te elementy wykorzystują moc obliczeniową Twojego komputera do generowania cyfrowych walut. Skrypty generujące kryptowaluty rozładowują baterię, spowalniają komputer i mogą zwiększyć rachunek za prąd. <a data-l10n-name="learn-more-link">Więcej informacji</a>
protections-close-button2 =
    .aria-label = Zamknij
    .title = Zamknij
mobile-app-title = Blokuj śledzące reklamy na wszystkich urządzeniach
mobile-app-card-content = Używaj przeglądarki na telefon z wbudowaną ochroną przed śledzącymi Cię reklamami.
mobile-app-links = Przeglądarka { -brand-product-name } na <a data-l10n-name="android-mobile-inline-link">Androida</a> i <a data-l10n-name="ios-mobile-inline-link">iOS</a>
lockwise-title = Już nigdy nie zapomnij żadnego hasła
lockwise-title-logged-in2 = Zarządzanie hasłami
lockwise-header-content = { -lockwise-brand-name } bezpiecznie przechowuje Twoje hasła w przeglądarce.
lockwise-header-content-logged-in = Bezpiecznie przechowuj i synchronizuj hasła na wszystkich urządzeniach.
protection-report-save-passwords-button = Zachowuj hasła
    .title = Zachowuj hasła w { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Zarządzaj hasłami
    .title = Zarządzaj hasłami za pomocą { -lockwise-brand-short-name }
lockwise-mobile-app-title = Miej hasła zawsze przy sobie
lockwise-no-logins-card-content = Używaj haseł zachowanych w przeglądarce { -brand-short-name } na każdym urządzeniu.
lockwise-app-links = { -lockwise-brand-name } na <a data-l10n-name="lockwise-android-inline-link">Androida</a> i <a data-l10n-name="lockwise-ios-inline-link">iOS</a>
# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] Twoje hasło mogło zostać ujawnione w wycieku danych.
        [few] { $count } hasła mogły zostać ujawnione w wycieku danych.
       *[many] { $count } haseł mogło zostać ujawnionych w wycieku danych.
    }
# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] Twoje hasło jest bezpiecznie przechowywane.
        [few] Twoje hasła są bezpiecznie przechowywane.
       *[many] Twoje hasła są bezpiecznie przechowywane.
    }
lockwise-how-it-works-link = Jak to działa
turn-on-sync = Włącz { -sync-brand-short-name(case: "acc", capitalization: "lower") }…
    .title = Otwórz preferencje synchronizacji
monitor-title = Miej oko na wycieki danych
monitor-link = Jak to działa
monitor-header-content-no-account = Wypróbuj { -monitor-brand-name }, aby sprawdzić, czy Twoje dane nie wyciekły i otrzymywać powiadomienia o nowych wyciekach danych.
monitor-header-content-signed-in = { -monitor-brand-name } ostrzega, jeśli Twoje dane pojawiły się w znanym wycieku.
monitor-sign-up-link = Subskrybuj powiadomienia o wyciekach danych
    .title = Subskrybuj powiadomienia o wyciekach danych w serwisie { -monitor-brand-name }
auto-scan = Automatycznie przeskanowano dzisiaj
monitor-emails-tooltip =
    .title = Wyświetl monitorowane adresy e-mail w serwisie { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Wyświetl znane wycieki danych w serwisie { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Wyświetl ujawnione hasła w serwisie { -monitor-brand-short-name }
# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] monitorowany adres e-mail
        [few] monitorowane adresy e-mail
       *[many] monitorowanych adresów e-mail
    }
# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] znany wyciek ujawnił Twoje dane
        [few] znane wycieki ujawniły Twoje dane
       *[many] znanych wycieków ujawniło Twoje dane
    }
# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] znany wyciek danych oznaczony jako rozwiązany
        [few] znane wycieki danych oznaczone jako rozwiązane
       *[many] znanych wycieków danych oznaczonych jako rozwiązane
    }
# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] hasło zostało ujawnione we wszystkich wyciekach
        [few] hasła zostały ujawnione we wszystkich wyciekach
       *[many] haseł zostało ujawnionych we wszystkich wyciekach
    }
# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] hasło zostało ujawnione w nierozwiązanych wyciekach
        [few] hasła zostały ujawnione w nierozwiązanych wyciekach
       *[many] haseł zostało ujawnionych w nierozwiązanych wyciekach
    }
monitor-no-breaches-title = Dobre wieści!
monitor-no-breaches-description = Nie masz żadnych znanych wycieków danych. Damy Ci znać, jeśli to się zmieni.
monitor-view-report-link = Wyświetl raport
    .title = Rozwiąż wycieki danych w serwisie { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Rozwiąż swoje wycieki danych
monitor-breaches-unresolved-description = Po sprawdzeniu informacji o wycieku i podjęciu kroków w celu ochrony swoich danych, możesz oznaczyć wyciek jako rozwiązany.
monitor-manage-breaches-link = Zarządzaj wyciekami danych
    .title = Zarządzaj wyciekami danych w serwisie { -monitor-brand-short-name }
monitor-breaches-resolved-title = Nieźle! Rozwiązano wszystkie znane wycieki danych.
monitor-breaches-resolved-description = Damy Ci znać, jeśli Twój adres e-mail pojawi się w nowych wyciekach danych.
# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreachesResolved ->
        [one] { $numBreachesResolved } wyciek jest oznaczony jako rozwiązany
        [few] { $numBreachesResolved } z { $numBreaches } wycieków są oznaczone jako rozwiązane
       *[many] { $numBreachesResolved } z { $numBreaches } wycieków jest oznaczonych jako rozwiązane
    }
# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = Rozwiązano { $percentageResolved }%
monitor-partial-breaches-motivation-title-start = Świetny początek!
monitor-partial-breaches-motivation-title-middle = Tak trzymaj!
monitor-partial-breaches-motivation-title-end = Prawie gotowe! Tak trzymaj.
monitor-partial-breaches-motivation-description = Rozwiąż pozostałe wycieki danych w serwisie { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Rozwiąż wycieki danych
    .title = Rozwiąż wycieki danych w serwisie { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Elementy śledzące serwisów społecznościowych
    .aria-label =
        { $count ->
            [one] { $count } element śledzący serwisów społecznościowych ({ $percentage }%)
            [few] { $count } elementy śledzące serwisów społecznościowych ({ $percentage }%)
           *[many] { $count } elementów śledzących serwisów społecznościowych ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Ciasteczka śledzące między witrynami
    .aria-label =
        { $count ->
            [one] { $count } ciasteczko śledzące między witrynami ({ $percentage }%)
            [few] { $count } ciasteczka śledzące między witrynami ({ $percentage }%)
           *[many] { $count } ciasteczek śledzących między witrynami ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Treści z elementami śledzącymi
    .aria-label =
        { $count ->
            [one] { $count } treść z elementami śledzącymi ({ $percentage }%)
            [few] { $count } treści z elementami śledzącymi ({ $percentage }%)
           *[many] { $count } treści z elementami śledzącymi ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Elementy śledzące przez zbieranie informacji o konfiguracji
    .aria-label =
        { $count ->
            [one] { $count } element śledzący przez zbieranie informacji o konfiguracji ({ $percentage }%)
            [few] { $count } elementy śledzące przez zbieranie informacji o konfiguracji ({ $percentage }%)
           *[many] { $count } elementów śledzących przez zbieranie informacji o konfiguracji ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Elementy używające komputera użytkownika do generowania kryptowalut
    .aria-label =
        { $count ->
            [one] { $count } element używający komputera użytkownika do generowania kryptowalut ({ $percentage }%)
            [few] { $count } elementy używające komputera użytkownika do generowania kryptowalut ({ $percentage }%)
           *[many] { $count } elementów używających komputera użytkownika do generowania kryptowalut ({ $percentage }%)
        }
