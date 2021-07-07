# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Polecane rozszerzenie
cfr-doorhanger-feature-heading = Polecana funkcja
cfr-doorhanger-pintab-heading = Wypróbuj przypinanie kart

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Dlaczego jest to wyświetlane?
cfr-doorhanger-extension-cancel-button = Nie teraz
    .accesskey = N
cfr-doorhanger-extension-ok-button = Dodaj
    .accesskey = D
cfr-doorhanger-pintab-ok-button = Przypnij tę kartę
    .accesskey = P
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
cfr-doorhanger-pintab-description = Łatwy dostęp do najczęściej używanych stron dzięki kartom otwartym na stałe (nawet po ponownym uruchomieniu).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Kliknij prawym przyciskiem</b> kartę, którą chcesz przypiąć.
cfr-doorhanger-pintab-step2 = Wybierz <b>Przypnij kartę</b> z menu.
cfr-doorhanger-pintab-step3 = Strony z aktualizacjami mają niebieską kropkę na przypiętej karcie.
cfr-doorhanger-pintab-animation-pause = Wstrzymaj
cfr-doorhanger-pintab-animation-resume = Wznów

## Firefox Accounts Message

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
cfr-whatsnew-panel-header = Co nowego
cfr-whatsnew-release-notes-link-text = Przeczytaj informacje o wydaniu
cfr-whatsnew-fx70-title = { -brand-short-name } walczy teraz o Twoją prywatność
cfr-whatsnew-fx70-body =
    Najnowsza aktualizacja wzmacnia ochronę przed śledzeniem i sprawia,
    że generowanie bezpiecznych haseł dla każdej witryny jest łatwiejsze niż kiedykolwiek.
cfr-whatsnew-tracking-protect-title = Zabezpiecz się przed elementami śledzącymi
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } blokuje wiele najczęściej występujących elementów śledzących serwisów społecznościowych
    oraz śledzących między witrynami, które monitorują, co robisz w Internecie.
cfr-whatsnew-tracking-protect-link-text = Wyświetl raport
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Zablokowany element śledzący
        [few] Zablokowane elementy śledzące
       *[many] Zablokowane elementy śledzące
    }
cfr-whatsnew-tracking-blocked-subtitle = Od { DATETIME($earliestDate, month: "short", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Wyświetl raport
cfr-whatsnew-lockwise-backup-title = Utwórz kopię zapasową haseł
cfr-whatsnew-lockwise-backup-body = Teraz generuj bezpiecznie hasła, do których masz dostęp wszędzie, gdzie się zalogujesz.
cfr-whatsnew-lockwise-backup-link-text = Włącz kopię zapasową
cfr-whatsnew-lockwise-take-title = Miej hasła zawsze przy sobie
cfr-whatsnew-lockwise-take-body =
    Aplikacja { -lockwise-brand-short-name } na telefon daje bezpieczny dostęp
    do haseł zachowanych w kopii zapasowej z dowolnego miejsca.
cfr-whatsnew-lockwise-take-link-text = Pobierz aplikację

## Search Bar

cfr-whatsnew-searchbar-title = Pisz mniej, znajdź więcej za pomocą paska adresu
cfr-whatsnew-searchbar-body-topsites = Teraz wystarczy kliknąć pasek adresu, a pojawią się odnośniki do najczęściej odwiedzanych stron.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = Ikona lupy

## Picture-in-Picture

cfr-whatsnew-pip-header = Oglądaj filmy podczas przeglądania
cfr-whatsnew-pip-body = Funkcja obraz w obrazie umożliwia wyświetlanie filmu w ruchomym okienku, dzięki czemu można oglądać w czasie pracy w innych kartach.
cfr-whatsnew-pip-cta = Więcej informacji

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Mniej irytujących wyskakujących okien
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } uniemożliwia teraz witrynom automatyczne pytanie o zgodę na wyświetlanie powiadomień.
cfr-whatsnew-permission-prompt-cta = Więcej informacji

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Zablokowany element śledzący przez zbieranie informacji o konfiguracji
        [few] Zablokowane elementy śledzące przez zbieranie informacji o konfiguracji
       *[many] Zablokowane elementy śledzące przez zbieranie informacji o konfiguracji
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } blokuje wiele elementów, które potajemnie zbierają informacje o Twoim urządzeniu i działaniach w celu utworzenia Twojego profilu reklamowego.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Elementy śledzące przez zbieranie informacji o konfiguracji
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } może blokować elementy, które potajemnie zbierają informacje o Twoim urządzeniu i działaniach w celu utworzenia Twojego profilu reklamowego.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Przenieś tę zakładkę na telefon
cfr-doorhanger-sync-bookmarks-body = Zabierz swoje zakładki, hasła, historię i nie tylko wszędzie, gdzie korzystasz z przeglądarki { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Włącz { -sync-brand-short-name(case: "acc", capitalization: "lower") }
    .accesskey = W

## Login Sync

cfr-doorhanger-sync-logins-header = Już nigdy nie zgub żadnego hasła
cfr-doorhanger-sync-logins-body = Bezpiecznie przechowuj i synchronizuj hasła na wszystkich urządzeniach.
cfr-doorhanger-sync-logins-ok-button = Włącz { -sync-brand-short-name(case: "acc", capitalization: "lower") }
    .accesskey = W

## Send Tab

cfr-doorhanger-send-tab-header = Przeczytaj to w podróży
cfr-doorhanger-send-tab-recipe-header = Zabierz ten przepis do kuchni
cfr-doorhanger-send-tab-body = Funkcja przesyłania kart umożliwia łatwe wysłanie tego odnośnika na telefon lub wszędzie, gdzie korzystasz z przeglądarki { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Wypróbuj przesyłanie kart
    .accesskey = W

## Firefox Send

cfr-doorhanger-firefox-send-header = Bezpiecznie udostępnij ten plik PDF
cfr-doorhanger-firefox-send-body = Chroń swoje poufne dokumenty przed wścibskimi oczami dzięki szyfrowaniu typu „end-to-end” i odnośnikowi, który znika po użyciu.
cfr-doorhanger-firefox-send-ok-button = Wypróbuj { -send-brand-name }
    .accesskey = W

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Wyświetl ochronę
    .accesskey = o
cfr-doorhanger-socialtracking-close-button = Zamknij
    .accesskey = Z
cfr-doorhanger-socialtracking-dont-show-again = Nie pokazuj więcej takich komunikatów
    .accesskey = N
cfr-doorhanger-socialtracking-heading = { -brand-short-name } powstrzymał serwis społecznościowy przed śledzeniem Cię na tej witrynie
cfr-doorhanger-socialtracking-description = Twoja prywatność jest ważna. { -brand-short-name } blokuje teraz najczęściej występujące elementy śledzące serwisów społecznościowych, ograniczając ilość danych, które mogą zebrać na temat Twoich działań w Internecie.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } zablokował na tej witrynie element śledzący przez zbieranie informacji o konfiguracji
cfr-doorhanger-fingerprinters-description = Twoja prywatność jest ważna. { -brand-short-name } blokuje teraz elementy zbierające jednoznacznie identyfikowalne informacje o używanym urządzeniu, aby Cię śledzić.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } zablokował na tej witrynie element używający komputera użytkownika do generowania kryptowalut
cfr-doorhanger-cryptominers-description = Twoja prywatność jest ważna. { -brand-short-name } blokuje teraz elementy wykorzystujące moc obliczeniową Twojego komputera do generowania cyfrowych walut.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } od { $date } zablokował <b>{ $blockedCount }</b> element śledzący!
        [few] { -brand-short-name } od { $date } zablokował ponad <b>{ $blockedCount }</b> elementy śledzące!
       *[many] { -brand-short-name } od { $date } zablokował ponad <b>{ $blockedCount }</b> elementów śledzących!
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
        [one] { -brand-short-name } od { DATETIME($date, month: "long", year: "numeric") } zablokował <b>{ $blockedCount }</b> element śledzący!
        [few] { -brand-short-name } od { DATETIME($date, month: "long", year: "numeric") } zablokował ponad <b>{ $blockedCount }</b> elementy śledzące!
       *[many] { -brand-short-name } od { DATETIME($date, month: "long", year: "numeric") } zablokował ponad <b>{ $blockedCount }</b> elementów śledzących!
    }
cfr-doorhanger-milestone-ok-button = Wyświetl wszystkie
    .accesskey = W

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Z łatwością generuj bezpieczne hasła
cfr-whatsnew-lockwise-body = Wymyślenie unikalnego, bezpiecznego hasła dla każdego konta nie jest łatwe. Podczas wpisywania nowego hasła kliknij pole hasła, aby użyć bezpiecznego, automatycznie wygenerowanego hasła od przeglądarki { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Ikona { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Otrzymuj powiadomienia o potencjalnie niebezpiecznych hasłach
cfr-whatsnew-passwords-body = Hakerzy wiedzą, że niejedna osoba używa tego samego hasła na wielu stronach. Jeśli tak robisz i jedna z tych stron była ofiarą wycieku danych, to zobaczysz powiadomienie w { -lockwise-brand-short-name }, aby zmienić na nich swoje hasła.
cfr-whatsnew-passwords-icon-alt = Ikona potencjalnie niebezpiecznego hasła

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Przełącz obraz w obrazie na pełny ekran
cfr-whatsnew-pip-fullscreen-body = Po wyciągnięciu wideo do ruchomego okienka można teraz kliknąć je podwójnie, aby włączyć tryb pełnoekranowy.
cfr-whatsnew-pip-fullscreen-icon-alt = Ikona obrazu w obrazie

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = Zamknij
    .accesskey = Z

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = Ochrona w pigułce
cfr-whatsnew-protections-body = Panel ochrony zawiera podsumowanie informacji o wyciekach danych i zarządzaniu hasłami. Można teraz śledzić, ile wycieków danych rozwiązano, a także zobaczyć, czy któreś z zachowanych haseł mogło paść ofiarą wycieku.
cfr-whatsnew-protections-cta-link = Otwórz panel ochrony
cfr-whatsnew-protections-icon-alt = Ikona tarczy

## Better PDF message

cfr-whatsnew-better-pdf-header = Lepsza obsługa plików PDF
cfr-whatsnew-better-pdf-body = Dokumenty PDF są teraz otwierane bezpośrednio w przeglądarce { -brand-short-name }, ułatwiając z nimi pracę.

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

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Automatyczna ochrona przed podstępnymi metodami śledzenia
cfr-whatsnew-clear-cookies-body = Niektóre elementy śledzące przekierowują Cię do innych witryn, które potajemnie ustawiają ciasteczka. { -brand-short-name } teraz automatycznie usuwa te ciasteczka, aby nie mogły za Tobą chodzić.
cfr-whatsnew-clear-cookies-image-alt = Rysunek zablokowanego ciasteczka

## What's new: Media controls message

cfr-whatsnew-media-keys-header = Więcej możliwości sterowania odtwarzaniem
cfr-whatsnew-media-keys-body = Odtwarzaj i wstrzymuj dźwięk lub film prosto z klawiatury lub zestawu słuchawkowego, dzięki czemu możesz sterować multimediami podczas korzystania z innej karty, programu lub nawet wtedy, gdy ekran komputera jest zablokowany. Możesz także przechodzić między utworami za pomocą odpowiednich klawiszy.
cfr-whatsnew-media-keys-button = Więcej informacji

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = Skróty wyszukiwania na pasku adresu
cfr-whatsnew-search-shortcuts-body = Od teraz kiedy na pasku adresu wpiszesz nazwę wyszukiwarki lub konkretnej witryny, w podpowiedziach wyszukiwania poniżej pojawi się niebieski skrót. Kliknij ten skrót, aby dokończyć wyszukiwanie bezpośrednio z paska adresu.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = Ochrona przed złośliwymi superciasteczkami
cfr-whatsnew-supercookies-body = Strony internetowe mogą potajemnie dołączyć do przeglądarki „superciasteczko”, które jest w stanie śledzić Cię w Internecie nawet po wyczyszczeniu ciasteczek. { -brand-short-name } zapewnia teraz silną ochronę przed superciasteczkami, uniemożliwiając używanie ich do śledzenia Twoich ruchów w sieci z jednej witryny na drugą.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = Lepsza obsługa zakładek
cfr-whatsnew-bookmarking-body = Zarządzanie ulubionymi stronami jest łatwiejsze. { -brand-short-name } pamięta teraz preferowane miejsce zachowywania zakładek, domyślnie wyświetla pasek zakładek w nowych kartach i zapewnia łatwy dostęp do pozostałych zakładek za pomocą folderu na pasku zakładek.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = Kompleksowa ochrona przed śledzeniem za pomocą ciasteczek między witrynami
cfr-whatsnew-cross-site-tracking-body = Można teraz opcjonalnie włączyć lepszą ochronę przed śledzeniem za pomocą ciasteczek. { -brand-short-name } może izolować Twoje działania i dane w obecnie przeglądanej witrynie, dzięki czemu informacje przechowywane w przeglądarce nie są dzielone między witrynami.

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Filmy na tej witrynie mogą nie być poprawnie odtwarzane w tej wersji przeglądarki { -brand-short-name }. Zaktualizuj ją, aby móc oglądać filmy.
cfr-doorhanger-video-support-header = Zaktualizuj przeglądarkę { -brand-short-name }, aby odtwarzać filmy
cfr-doorhanger-video-support-primary-button = Aktualizuj teraz
    .accesskey = k
