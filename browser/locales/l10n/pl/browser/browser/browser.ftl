# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (tryb prywatny)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (tryb prywatny)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox - (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } - (tryb prywatny)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (tryb prywatny)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Wyświetl informacje o stronie

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Wyświetl zapytanie instalacji usługi
urlbar-web-notification-anchor =
    .tooltiptext = Określ, czy witryna ma prawo wyświetlać powiadomienia
urlbar-midi-notification-anchor =
    .tooltiptext = Otwórz panel MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Zarządzaj ustawieniami DRM
urlbar-web-authn-anchor =
    .tooltiptext = Otwórz panel Web Authentication
urlbar-canvas-notification-anchor =
    .tooltiptext = Zarządzaj uprawnieniami odczytu danych canvas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Zarządzaj udostępnianiem mikrofonu tej witrynie
urlbar-default-notification-anchor =
    .tooltiptext = Wyświetl powiadomienie
urlbar-geolocation-notification-anchor =
    .tooltiptext = Wyświetl zapytanie o położenie
urlbar-xr-notification-anchor =
    .tooltiptext = Zarządzaj uprawnieniami rzeczywistości wirtualnej
urlbar-storage-access-anchor =
    .tooltiptext = Zarządzaj uprawnieniami śledzenia aktywności przeglądania
urlbar-translate-notification-anchor =
    .tooltiptext = Przetłumacz tę stronę
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Zarządzaj udostępnianiem tej witrynie okien i ekranu
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Wyświetl zapytanie o przechowywanie danych offline
urlbar-password-notification-anchor =
    .tooltiptext = Określ, czy zachować hasło
urlbar-translated-notification-anchor =
    .tooltiptext = Zarządzaj ustawieniami tłumaczenia
urlbar-plugins-notification-anchor =
    .tooltiptext = Zarządzaj wtyczkami używanymi na tej stronie
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Zarządzaj udostępnianiem tej witrynie kamery i mikrofonu
urlbar-autoplay-notification-anchor =
    .tooltiptext = Wyświetl zapytanie o automatyczne odtwarzanie
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Przechowywanie danych na komputerze
urlbar-addons-notification-anchor =
    .tooltiptext = Wyświetl zapytanie o instalację dodatków
urlbar-tip-help-icon =
    .title = Pomoc
urlbar-search-tips-confirm = OK
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Wskazówka:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Pisz mniej, wyszukuj więcej: szukaj w { $engineName } prosto z paska adresu
urlbar-search-tips-redirect-2 = Zacznij szukać na pasku adresu, by uzyskać podpowiedzi od wyszukiwarki { $engineName } i wyniki na podstawie historii przeglądania

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Zakładki
urlbar-search-mode-tabs = Karty
urlbar-search-mode-history = Historia

##

urlbar-geolocation-blocked =
    .tooltiptext = Udostępnianie położenia tej witrynie zostało zablokowane
urlbar-xr-blocked =
    .tooltiptext = Dostęp do urządzenia rzeczywistości wirtualnej dla tej witryny został zablokowany
urlbar-web-notifications-blocked =
    .tooltiptext = Powiadomienia z tej witryny zostały zablokowane
urlbar-camera-blocked =
    .tooltiptext = Udostępnianie kamery tej witrynie zostało zablokowane
urlbar-microphone-blocked =
    .tooltiptext = Udostępnianie mikrofonu tej witrynie zostało zablokowane
urlbar-screen-blocked =
    .tooltiptext = Udostępnianie obrazu ekranu tej witrynie zostało zablokowane
urlbar-persistent-storage-blocked =
    .tooltiptext = Przechowywanie danych na komputerze przez tę witrynę zostało zablokowane
urlbar-popup-blocked =
    .tooltiptext = Wyskakujące okna na tej witrynie są blokowane
urlbar-autoplay-media-blocked =
    .tooltiptext = Automatyczne odtwarzanie treści z dźwiękiem przez tę witrynę zostało zablokowane
urlbar-canvas-blocked =
    .tooltiptext = Odczytywanie danych canvas przez witrynę zostało zablokowane
urlbar-midi-blocked =
    .tooltiptext = Dostęp do urządzeń MIDI dla tej witryny został zablokowany
urlbar-install-blocked =
    .tooltiptext = Instalacja dodatków przez tę witrynę została zablokowana
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Edytuj zakładkę ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Dodaj zakładkę do tej strony ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Dodaj do paska adresu
page-action-manage-extension =
    .label = Zarządzaj rozszerzeniem…
page-action-remove-from-urlbar =
    .label = Usuń z paska adresu
page-action-remove-extension =
    .label = Usuń rozszerzenie

## Auto-hide Context Menu

full-screen-autohide =
    .label = Ukryj paski narzędzi
    .accesskey = U
full-screen-exit =
    .label = Opuść tryb pełnoekranowy
    .accesskey = O

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Tym razem szukaj w:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Ustawienia wyszukiwania
search-one-offs-change-settings-compact-button =
    .tooltiptext = Zmień ustawienia wyszukiwania
search-one-offs-context-open-new-tab =
    .label = Szukaj w nowej karcie
    .accesskey = S
search-one-offs-context-set-as-default =
    .label = Ustaw jako domyślną wyszukiwarkę
    .accesskey = U
search-one-offs-context-set-as-default-private =
    .label = Ustaw jako domyślną wyszukiwarkę w prywatnych oknach
    .accesskey = w
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = Zakładki ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Karty ({ $restrict })
search-one-offs-history =
    .tooltiptext = Historia ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Wyświetlanie tego okna podczas dodawania
    .accesskey = W
bookmark-panel-done-button =
    .label = Gotowe
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 25em

## Identity Panel

identity-connection-not-secure = Niezabezpieczone połączenie
identity-connection-secure = Zabezpieczone połączenie
identity-connection-internal = To jest strona programu { -brand-short-name }.
identity-connection-file = Strona wczytana z tego komputera.
identity-extension-page = Ta strona została wczytana przez rozszerzenie.
identity-active-blocked = { -brand-short-name } zablokował elementy tej strony, które nie były przesłane w sposób bezpieczny.
identity-custom-root = Połączenie zweryfikowane przez wystawcę certyfikatu, który nie jest rozpoznawany przez Mozillę.
identity-passive-loaded = Niektóre elementy tej strony (np. obrazy) nie były przesłane w sposób bezpieczny.
identity-active-loaded = Ochrona na tej stronie została wyłączona przez użytkownika.
identity-weak-encryption = Strona używa słabego szyfrowania.
identity-insecure-login-forms = Dane logowania wprowadzone na tej stronie nie są chronione.
identity-permissions =
    .value = Uprawnienia
identity-permissions-reload-hint = Ponowne wczytanie strony może być konieczne, aby wprowadzone zmiany przyniosły skutek.
identity-permissions-empty = Witryna korzysta z domyślnych uprawnień.
identity-clear-site-data =
    .label = Wyczyść ciasteczka i dane stron…
identity-connection-not-secure-security-view = Połączenie z tą witryną nie jest zabezpieczone.
identity-connection-verified = Połączenie z tą witryną jest zabezpieczone.
identity-ev-owner-label = Certyfikat wystawiony dla:
identity-description-custom-root = Mozilla nie rozpoznaje tego wystawcy certyfikatu. Mógł zostać dodany przez system operacyjny lub administratora. <label data-l10n-name="link">Więcej informacji</label>
identity-remove-cert-exception =
    .label = Usuń wyjątek
    .accesskey = U
identity-description-insecure = Prywatność podczas łączenia się z tą witryną nie jest chroniona. Przesyłane informacje (np. hasła, wiadomości, numery kart) mogą być dostępne dla innych.
identity-description-insecure-login-forms = Dane logowania wprowadzone na tej stronie nie są bezpieczne i mogą być dostępne dla innych.
identity-description-weak-cipher-intro = Połączenie z tą witryną nie zapewnia prywatności, ponieważ szyfrowanie nie jest wystarczające.
identity-description-weak-cipher-risk = Informacje na witrynie mogą być dostępne dla innych, a jej działanie modyfikowane.
identity-description-active-blocked = { -brand-short-name } zablokował elementy tej strony, które nie były przesłane w sposób bezpieczny. <label data-l10n-name="link">Więcej informacji</label>
identity-description-passive-loaded = Połączenie z tą witryną nie zapewnia prywatności, a przesyłane informacje mogą być dostępne dla innych.
identity-description-passive-loaded-insecure = Niektóre elementy tej witryny (np. obrazy) nie były przesłane w sposób bezpieczny. <label data-l10n-name="link">Więcej informacji</label>
identity-description-passive-loaded-mixed = { -brand-short-name } zablokował niektóre elementy strony, mimo to nie wszystkie pozostałe elementy były przesłane w sposób bezpieczny (np. obrazy). <label data-l10n-name="link">Więcej informacji</label>
identity-description-active-loaded = Witryna zawiera elementy, które nie były przesłane w sposób bezpieczny (np. skrypty) i połączenie z nią nie zapewnia prywatności.
identity-description-active-loaded-insecure = Przesyłane informacje (np. hasła, wiadomości, numery kart) mogą być dostępne dla innych.
identity-learn-more =
    .value = Więcej informacji
identity-disable-mixed-content-blocking =
    .label = Tymczasowo wyłącz ochronę
    .accesskey = T
identity-enable-mixed-content-blocking =
    .label = Włącz ochronę
    .accesskey = W
identity-more-info-link-text =
    .label = Więcej informacji…

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimalizuj
browser-window-maximize-button =
    .tooltiptext = Maksymalizuj
browser-window-restore-down-button =
    .tooltiptext = Przywróć w dół
browser-window-close-button =
    .tooltiptext = Zamknij

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Kamera do udostępnienia:
    .accesskey = K
popup-select-microphone =
    .value = Mikrofon do udostępnienia:
    .accesskey = M
popup-all-windows-shared = Wszystkie widoczne na ekranie okna zostaną udostępnione.
popup-screen-sharing-not-now =
    .label = Nie teraz
    .accesskey = N
popup-screen-sharing-never =
    .label = Nigdy nie pozwalaj
    .accesskey = d
popup-silence-notifications-checkbox = Wyłącz powiadomienia przeglądarki { -brand-short-name } podczas udostępniania
popup-silence-notifications-checkbox-warning = { -brand-short-name } nie będzie wyświetlał powiadomień w trakcie udostępniania.

## WebRTC window or screen share tab switch warning

sharing-warning-window = { -brand-short-name } jest udostępniany. Inni będą widzieć, że przechodzisz do nowej karty.
sharing-warning-screen = Cały ekran jest udostępniany. Inni będą widzieć, że przechodzisz do nowej karty.
sharing-warning-proceed-to-tab =
    .label = Przejdź do karty
sharing-warning-disable-for-session =
    .label = Wyłącz ochronę udostępniania na czas tej sesji

## DevTools F12 popup

enable-devtools-popup-description = Aby móc użyć skrótu F12, najpierw otwórz narzędzia dla programistów w menu „Dla twórców witryn”.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Wprowadź adres lub szukaj
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Wprowadź adres lub szukaj
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Szukaj w Internecie
    .aria-label = Szukaj w { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Szukaj
    .aria-label = Szukaj na witrynie { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Szukaj
    .aria-label = Szukaj zakładek
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Szukaj
    .aria-label = Szukaj w historii
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Szukaj
    .aria-label = Szukaj kart
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Wprowadź adres lub szukaj w { $name }
urlbar-remote-control-notification-anchor =
    .tooltiptext = Przeglądarka jest zdalnie zarządzana
urlbar-permissions-granted =
    .tooltiptext = Witryna korzysta z dodatkowych uprawnień.
urlbar-switch-to-tab =
    .value = Przełącz na kartę:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Rozszerzenie:
urlbar-go-button =
    .tooltiptext = Przejdź do strony o podanym adresie
urlbar-page-action-button =
    .tooltiptext = Interakcje
urlbar-pocket-button =
    .tooltiptext = Wyślij do { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> jest teraz w trybie pełnoekranowym
fullscreen-warning-no-domain = Dokument jest teraz wyświetlany w trybie pełnoekranowym
fullscreen-exit-button = Opuść tryb pełnoekranowy (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Opuść tryb pełnoekranowy (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> kontroluje teraz kursor. Użyj klawisza Esc, aby przejąć nad nim kontrolę.
pointerlock-warning-no-domain = Dokument kontroluje teraz kursor. Użyj klawisza Esc, aby przejąć nad nim kontrolę.
