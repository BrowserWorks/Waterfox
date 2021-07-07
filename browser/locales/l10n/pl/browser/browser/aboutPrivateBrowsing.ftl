# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Otwórz okno w trybie prywatnym
    .accesskey = O
about-private-browsing-search-placeholder = Szukaj w Internecie
about-private-browsing-info-title = Okno w trybie prywatnym
about-private-browsing-info-myths = Popularne mity na temat przeglądania prywatnego
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
about-private-browsing-info-description = { -brand-short-name } czyści historię wyszukiwania i przeglądania po wyłączeniu programu lub zamknięciu wszystkich kart i okien w trybie przeglądania prywatnego. Chociaż nie czyni to użytkownika anonimowym wobec stron internetowych ani dostawcy Internetu, to ułatwia zachowanie prywatności przed pozostałymi użytkownikami komputera.

about-private-browsing-need-more-privacy = Potrzebujesz więcej prywatności?
about-private-browsing-turn-on-vpn = Wypróbuj { -mozilla-vpn-brand-name }

about-private-browsing-info-description-simplified = { -brand-short-name } czyści historię wyszukiwania i przeglądania po zamknięciu wszystkich prywatnych okien, ale nie czyni to użytkownika anonimowym.
about-private-browsing-learn-more-link = Więcej informacji

about-private-browsing-hide-activity = Ukryj swoje działania i położenie wszędzie, gdzie przeglądasz
about-private-browsing-prominent-cta = Zachowaj prywatność dzięki { -mozilla-vpn-brand-name }

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
