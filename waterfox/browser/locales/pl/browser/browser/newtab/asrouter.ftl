# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Polecane rozszerzenie
cfr-doorhanger-feature-heading = Polecana funkcja

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Dlaczego jest to wyświetlane?
cfr-doorhanger-extension-cancel-button = Nie teraz
    .accesskey = N
cfr-doorhanger-extension-ok-button = Dodaj
    .accesskey = D
cfr-doorhanger-extension-manage-settings-button = Ustawienia polecania
    .accesskey = U
cfr-doorhanger-extension-never-show-recommendation = Nie pokazuj więcej polecenia tego rozszerzenia
    .accesskey = e
cfr-doorhanger-extension-learn-more-link = Więcej informacji
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = Autor: { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Polecenie
cfr-doorhanger-extension-notification2 = Polecenie
    .tooltiptext = Polecenie rozszerzenia
    .a11y-announcement = Dostępne polecenie rozszerzenia
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Polecenie
    .tooltiptext = Polecenie funkcji
    .a11y-announcement = Dostępne polecenie funkcji

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } gwiazdka
            [few] { $total } gwiazdki
            [many] { $total } gwiazdek
           *[other] { $total } gwiazdki
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } użytkownik
        [few] { $total } użytkowników
        [many] { $total } użytkowników
       *[other] { $total } użytkowników
    }

## Waterfox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Synchronizuj zakładki na każdym urządzeniu.
cfr-doorhanger-bookmark-fxa-body = Wspaniałe odkrycie! Fajnie byłoby mieć tę zakładkę także na telefonie, prawda? Zacznij korzystać z { -fxaccount-brand-name(case: "gen", capitalization: "lower") }.
cfr-doorhanger-bookmark-fxa-link-text = Synchronizuj zakładki…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Przycisk zamknięcia
    .title = Zamknij

## Protections panel

cfr-protections-panel-header = Przeglądaj bez wścibskich oczu
cfr-protections-panel-body = Zachowaj prywatność swoich danych. { -brand-short-name } chroni Cię przed wieloma najczęściej występującymi elementami śledzącymi, które monitorują, co robisz w Internecie.
cfr-protections-panel-link-text = Więcej informacji

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nowa funkcja:
cfr-whatsnew-button =
    .label = Co nowego
    .tooltiptext = Co nowego
cfr-whatsnew-release-notes-link-text = Przeczytaj informacje o wydaniu

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
        [one] { -brand-short-name } od { DATETIME($date, month: "short", year: "numeric") } zablokował <b>{ $blockedCount }</b> element śledzący!
        [few] { -brand-short-name } od { DATETIME($date, month: "short", year: "numeric") } zablokował ponad <b>{ $blockedCount }</b> elementy śledzące!
       *[many] { -brand-short-name } od { DATETIME($date, month: "short", year: "numeric") } zablokował ponad <b>{ $blockedCount }</b> elementów śledzących!
    }
cfr-doorhanger-milestone-ok-button = Wyświetl wszystkie
    .accesskey = W
cfr-doorhanger-milestone-close-button = Zamknij
    .accesskey = Z

## DOH Message

cfr-doorhanger-doh-body = Twoja prywatność jest ważna. { -brand-short-name } teraz bezpiecznie przekierowuje Twoje żądania DNS do usługi partnerskiej, aby chronić Cię w czasie przeglądania Internetu.
cfr-doorhanger-doh-header = Bezpieczniejsze, zaszyfrowane wyszukiwania DNS
cfr-doorhanger-doh-primary-button-2 = OK
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Wyłącz
    .accesskey = W

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Twoja prywatność jest ważna. { -brand-short-name } izoluje teraz witryny od siebie, co utrudnia hakerom kradzież haseł, numerów kart płatniczych i innych prywatnych informacji.
cfr-doorhanger-fission-header = Izolacja witryn
cfr-doorhanger-fission-primary-button = OK
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Więcej informacji
    .accesskey = W

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Filmy na tej witrynie mogą nie być poprawnie odtwarzane w tej wersji przeglądarki { -brand-short-name }. Zaktualizuj ją, aby móc oglądać filmy.
cfr-doorhanger-video-support-header = Zaktualizuj przeglądarkę { -brand-short-name }, aby odtwarzać filmy
cfr-doorhanger-video-support-primary-button = Aktualizuj teraz
    .accesskey = k

## Spotlight modal shared strings

spotlight-learn-more-collapsed = Więcej informacji
    .title = Rozwiń, aby dowiedzieć się więcej o tej funkcji
spotlight-learn-more-expanded = Więcej informacji
    .title = Zamknij

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Wygląda na to, że korzystasz z publicznej sieci Wi-Fi
spotlight-public-wifi-vpn-body = Aby ukryć swoje położenie i działania w Internecie, pomyśl o wirtualnej sieci prywatnej. Pomoże Ci zapewnić ochronę podczas przeglądania w miejscach publicznych, takich jak lotniska czy kawiarnie.
spotlight-public-wifi-vpn-primary-button = Zachowaj prywatność dzięki { -mozilla-vpn-brand-name }
    .accesskey = V
spotlight-public-wifi-vpn-link = Nie teraz
    .accesskey = N

## Total Cookie Protection Rollout

# "Test pilot" is used as a verb. Possible alternatives: "Be the first to try",
# "Join an early experiment". This header text can be explicitly wrapped.
spotlight-total-cookie-protection-header =
    Przetestuj naszą najpotężniejszą
    funkcję ochrony prywatności w historii
spotlight-total-cookie-protection-body = Całkowita ochrona ciasteczek uniemożliwia elementom śledzącym używanie ciasteczek do śledzenia Cię w Internecie.
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch" as not everybody will get it yet.
spotlight-total-cookie-protection-expanded = { -brand-short-name } buduje płot wokół ciasteczek, ograniczając je do odwiedzanej witryny, aby elementy śledzące nie mogły ich używać do śledzenia Cię. Włączając tę funkcję przed innymi pomożesz ją zoptymalizować, abyśmy mogli kontynuować tworzenie lepszego Internetu dla wszystkich.
spotlight-total-cookie-protection-primary-button = Włącz całkowitą ochronę ciasteczek
spotlight-total-cookie-protection-secondary-button = Nie teraz
cfr-total-cookie-protection-header = Dzięki Tobie { -brand-short-name } jest teraz bardziej prywatny i bezpieczny niż kiedykolwiek
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch". Only those who received it and accepted are shown this message.
cfr-total-cookie-protection-body = Całkowita ochrona ciasteczek to jak dotąd nasza najsilniejsza funkcja ochrony prywatności – i jest teraz domyślnie włączona dla użytkowników przeglądarki { -brand-short-name } na całym świecie. Nie moglibyśmy tego osiągnąć bez uczestników testów takich jak Ty. Dziękujemy za pomoc w tworzeniu lepszego, bardziej prywatnego Internetu.

## Emotive Continuous Onboarding

spotlight-better-internet-header = Lepszy Internet zaczyna się od Ciebie
spotlight-better-internet-body = Kiedy używasz przeglądarki { -brand-short-name }, głosujesz na otwarty i dostępny Internet, który jest lepszy dla wszystkich.
spotlight-peace-mind-header = Możesz na nas liczyć
spotlight-peace-mind-body = Każdego miesiąca { -brand-short-name } blokuje średnio ponad 3000 elementów śledzących na użytkownika. Ponieważ nic, zwłaszcza psujące prywatność elementy śledzące, nie powinno stać między Tobą a dobrym Internetem.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] Zatrzymaj w Docku
       *[other] Przypnij do paska zadań
    }
spotlight-pin-secondary-button = Nie teraz
