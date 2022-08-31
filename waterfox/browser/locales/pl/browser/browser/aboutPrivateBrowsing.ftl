# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Otwórz okno w trybie prywatnym
    .accesskey = O
about-private-browsing-search-placeholder = Szukaj w Internecie
about-private-browsing-info-title = Okno w trybie prywatnym
about-private-browsing-search-btn =
    .title = Szukaj w Internecie
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Wprowadź adres lub szukaj w { $engine }
about-private-browsing-handoff-no-engine =
    .title = Wprowadź adres lub szukaj
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Wprowadź adres lub szukaj w { $engine }
about-private-browsing-handoff-text-no-engine = Wprowadź adres lub szukaj
about-private-browsing-not-private = Okno bez aktywnego trybu prywatnego.
about-private-browsing-info-description-private-window = Przeglądanie prywatne: { -brand-short-name } czyści historię wyszukiwania i przeglądania po zamknięciu wszystkich prywatnych okien. Nie czyni to użytkownika anonimowym.
about-private-browsing-info-description-simplified = { -brand-short-name } czyści historię wyszukiwania i przeglądania po zamknięciu wszystkich prywatnych okien, ale nie czyni to użytkownika anonimowym.
about-private-browsing-learn-more-link = Więcej informacji
about-private-browsing-hide-activity = Ukryj swoje działania i położenie wszędzie, gdzie przeglądasz
about-private-browsing-get-privacy = Zapewnij sobie ochronę prywatności wszędzie, gdzie przeglądasz
about-private-browsing-hide-activity-1 = Ukryj swoje działania w Internecie i położenie za pomocą { -mozilla-vpn-brand-name }. Jedno kliknięcie tworzy bezpieczne połączenie, nawet w publicznej sieci Wi-Fi.
about-private-browsing-prominent-cta = Zachowaj prywatność dzięki { -mozilla-vpn-brand-name }
about-private-browsing-focus-promo-cta = Pobierz { -focus-brand-name }
about-private-browsing-focus-promo-header = { -focus-brand-name }: prywatne przeglądanie także w drodze
about-private-browsing-focus-promo-text = Nasza wyspecjalizowana w prywatności przeglądarka na telefon czyści historię i ciasteczka za każdym razem.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = Przeglądaj prywatnie na telefonie
about-private-browsing-focus-promo-text-b = Używaj { -focus-brand-name } do tych prywatnych wyszukiwań, których główna przeglądarka na telefonie ma nie widzieć.
about-private-browsing-focus-promo-header-c = Prywatność wyższego poziomu na telefonie
about-private-browsing-focus-promo-text-c = { -focus-brand-name } czyści historię za każdym razem, a do tego blokuje reklamy i elementy śledzące.
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } to domyślna wyszukiwarka w prywatnych oknach
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] W <a data-l10n-name="link-options">opcjach</a> można wybrać inną wyszukiwarkę
       *[other] W <a data-l10n-name="link-options">preferencjach</a> można wybrać inną wyszukiwarkę
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Zamknij
about-private-browsing-promo-close-button =
    .title = Zamknij

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = Wolność trybu prywatnego pod jednym kliknięciem
about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] Zatrzymaj w Docku
       *[other] Przypnij do paska zadań
    }
about-private-browsing-pin-promo-title = Żadnych zapisanych ciasteczek ani historii, prosto z pulpitu. Przeglądaj, jak gdyby nikt nie patrzył.
