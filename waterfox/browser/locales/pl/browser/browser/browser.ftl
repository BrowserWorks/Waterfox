# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS.
# .data-title-default and .data-title-private are used when the web content
# opened has no title:
#
# default - "Waterfox"
# private - "Waterfox (Private Browsing)"
#
# .data-content-title-default and .data-content-title-private are for use when
# there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-window-titles =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } — tryb prywatny
    .data-content-title-default = { $content-title } — { -brand-full-name }
    .data-content-title-private = { $content-title } — { -brand-full-name } — tryb prywatny
# These are the default window titles on macOS.
# .data-title-default and .data-title-private are used when the web content
# opened has no title:
#
#
# "default" - "Waterfox"
# "private" - "Waterfox — (Private Browsing)"
#
# .data-content-title-default and .data-content-title-private are for use when
# there *is* a content title.
# Do not use the brand name in these, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac-window-titles =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } — tryb prywatny
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } — tryb prywatny
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }
# The non-variable portion of this MUST match the translation of
# "PRIVATE_BROWSING_SHORTCUT_TITLE" in custom.properties
private-browsing-shortcut-text-2 = { -brand-shortcut-name } — tryb prywatny

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
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Zarządzaj udostępnianiem tej witrynie okien i ekranu
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Wyświetl zapytanie o przechowywanie danych offline
urlbar-password-notification-anchor =
    .tooltiptext = Określ, czy zachować hasło
urlbar-plugins-notification-anchor =
    .tooltiptext = Zarządzaj wtyczkami używanymi na tej stronie
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Zarządzaj udostępnianiem tej witrynie kamery i mikrofonu
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
urlbar-web-rtc-share-speaker-notification-anchor =
    .tooltiptext = Zarządzaj udostępnianiem tej witrynie innych głośników
urlbar-autoplay-notification-anchor =
    .tooltiptext = Wyświetl zapytanie o automatyczne odtwarzanie
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Przechowywanie danych na komputerze
urlbar-addons-notification-anchor =
    .tooltiptext = Wyświetl zapytanie o instalację dodatków
urlbar-tip-help-icon =
    .title = Pomoc
urlbar-search-tips-confirm = OK
urlbar-search-tips-confirm-short = OK
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Wskazówka:
urlbar-result-menu-button =
    .title = Otwórz menu
urlbar-result-menu-button-feedback = Opinia
    .title = Otwórz menu
urlbar-result-menu-learn-more =
    .label = Więcej informacji
    .accesskey = W
urlbar-result-menu-remove-from-history =
    .label = Usuń z historii
    .accesskey = U
urlbar-result-menu-tip-get-help =
    .label = Pomoc
    .accesskey = P

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Pisz mniej, wyszukuj więcej: szukaj w { $engineName } prosto z paska adresu
urlbar-search-tips-redirect-2 = Zacznij szukać na pasku adresu, aby uzyskać podpowiedzi od wyszukiwarki { $engineName } i wyniki na podstawie historii przeglądania
# Make sure to match the name of the Search panel in settings.
urlbar-search-tips-persist = Wyszukiwanie właśnie stało się prostsze. Możesz uściślić wyszukiwane słowa już na pasku adresu. Aby zamiast tego wyświetlać adres wyszukiwarki, otwórz ustawienia wyszukiwania.
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Kliknij ten skrót, aby szybciej znaleźć to, czego potrzebujesz

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Zakładki
urlbar-search-mode-tabs = Karty
urlbar-search-mode-history = Historia
urlbar-search-mode-actions = Działania

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

page-action-manage-extension2 =
    .label = Zarządzaj rozszerzeniem…
    .accesskey = Z
page-action-remove-extension2 =
    .label = Usuń rozszerzenie
    .accesskey = U

## Auto-hide Context Menu

full-screen-autohide =
    .label = Ukryj paski narzędzi
    .accesskey = U
full-screen-exit =
    .label = Opuść tryb pełnoekranowy
    .accesskey = O

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = Tym razem szukaj w:
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
# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = Dodaj „{ $engineName }”
    .tooltiptext = Dodaj wyszukiwarkę „{ $engineName }”
    .aria-label = Dodaj wyszukiwarkę „{ $engineName }”
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = Dodaj wyszukiwarkę

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
search-one-offs-actions =
    .tooltiptext = Działania ({ $restrict })

## QuickActions are shown in the urlbar as the user types a matching string
## The -cmd- strings are comma separated list of keywords that will match
## the action.

# Opens the about:addons page in the home / recommendations section
quickactions-addons = Wyświetl dodatki
quickactions-cmd-addons2 = dodatki
# Opens the bookmarks library window
quickactions-bookmarks2 = Zarządzaj zakładkami
quickactions-cmd-bookmarks = zakładki, ulubione
# Opens a SUMO article explaining how to clear history
quickactions-clearhistory = Wyczyść historię
quickactions-cmd-clearhistory = wyczyść historię, usuń historię
# Opens about:downloads page
quickactions-downloads2 = Wyświetl listę pobranych plików
quickactions-cmd-downloads = pobrane pliki, pobrane, pobierane, pobieranie
# Opens about:addons page in the extensions section
quickactions-extensions = Zarządzaj rozszerzeniami
quickactions-cmd-extensions = rozszerzenia
# Opens the devtools web inspector
quickactions-inspector2 = Otwórz narzędzia dla programistów
quickactions-cmd-inspector = inspektor, narzędzia dla programistów, narzędzia dla deweloperów, narzędzia dla twórców witryn, devtools
# Opens about:logins
quickactions-logins2 = Zarządzaj hasłami
quickactions-cmd-logins = dane logowania, loginy, hasła
# Opens about:addons page in the plugins section
quickactions-plugins = Zarządzaj wtyczkami
quickactions-cmd-plugins = wtyczki
# Opens the print dialog
quickactions-print2 = Drukuj stronę
quickactions-cmd-print = drukuj, wydrukuj
# Opens a new private browsing window
quickactions-private2 = Otwórz okno prywatne
quickactions-cmd-private = tryb prywatny, przeglądanie prywatne, okno prywatne, incognito, tryb incognito
# Opens a SUMO article explaining how to refresh
quickactions-refresh = Odśwież { -brand-short-name(case: "acc") }
quickactions-cmd-refresh = odśwież, odnów
# Restarts the browser
quickactions-restart = Uruchom { -brand-short-name(case: "acc") } ponownie
quickactions-cmd-restart = uruchom ponownie, ponowne uruchomienie, zrestartuj, restart
# Opens the screenshot tool
quickactions-screenshot3 = Wykonaj zrzut ekranu
quickactions-cmd-screenshot = zrzut ekranu, screenshot, skrin
# Opens about:preferences
quickactions-settings2 = Zarządzaj ustawieniami
quickactions-cmd-settings = ustawienia, preferencje, opcje
# Opens about:addons page in the themes section
quickactions-themes = Zarządzaj motywami
quickactions-cmd-themes = motywy
# Opens a SUMO article explaining how to update the browser
quickactions-update = Uaktualnij { -brand-short-name(case: "acc") }
quickactions-cmd-update = uaktualnij, uaktualnienie, zaktualizuj, aktualizuj, aktualizacja, apdejt
# Opens the view-source UI with current pages source
quickactions-viewsource2 = Pokaż źródło strony
quickactions-cmd-viewsource = pokaż źródło, źródło, wyświetl źródło
# Tooltip text for the help button shown in the result.
quickactions-learn-more =
    .title = Więcej informacji o szybkich działaniach

## Bookmark Panel

bookmarks-add-bookmark = Dodaj zakładkę
bookmarks-edit-bookmark = Edytuj zakładkę
bookmark-panel-cancel =
    .label = Anuluj
    .accesskey = A
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label =
        { $count ->
            [one] Usuń zakładkę
            [few] Usuń { $count } zakładki
           *[many] Usuń { $count } zakładek
        }
    .accesskey = U
bookmark-panel-show-editor-checkbox =
    .label = Wyświetlanie tego okna podczas dodawania
    .accesskey = W
bookmark-panel-save-button =
    .label = Zachowaj
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 25em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = Informacje o „{ $host }”
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = Bezpieczeństwo połączenia z „{ $host }”
identity-connection-not-secure = Niezabezpieczone połączenie
identity-connection-secure = Zabezpieczone połączenie
identity-connection-failure = Błąd połączenia
identity-connection-internal = To jest bezpieczna strona { -brand-short-name(case: "gen") }.
identity-connection-file = Strona wczytana z tego komputera.
identity-extension-page = Ta strona została wczytana przez rozszerzenie.
identity-active-blocked = { -brand-short-name } zablokował elementy tej strony, które nie były przesłane w sposób bezpieczny.
identity-custom-root = Połączenie zweryfikowane przez wystawcę certyfikatu, który nie jest rozpoznawany przez Mozillę.
identity-passive-loaded = Niektóre elementy tej strony (np. obrazy) nie były przesłane w sposób bezpieczny.
identity-active-loaded = Ochrona na tej stronie została wyłączona przez użytkownika.
identity-weak-encryption = Strona używa słabego szyfrowania.
identity-insecure-login-forms = Dane logowania wprowadzone na tej stronie nie są chronione.
identity-https-only-connection-upgraded = (przełączono na protokół HTTPS)
identity-https-only-label = Tryb używania wyłącznie protokołu HTTPS
identity-https-only-label2 = Automatycznie przełączaj tę witrynę na zabezpieczone połączenie
identity-https-only-dropdown-on =
    .label = Włączony
identity-https-only-dropdown-off =
    .label = Wyłączony
identity-https-only-dropdown-off-temporarily =
    .label = Tymczasowo wyłączony
identity-https-only-info-turn-on2 = Włącz tryb używania wyłącznie protokołu HTTPS dla tej witryny, jeśli chcesz, aby { -brand-short-name } przełączał na zabezpieczone połączenie, kiedy to możliwe.
identity-https-only-info-turn-off2 = Jeśli strona wydaje się niepoprawnie działać, możesz wyłączyć tryb używania wyłącznie protokołu HTTPS dla tej witryny, aby odświeżyć ją za pomocą niezabezpieczonego protokołu HTTP.
identity-https-only-info-turn-on3 = Włącz przełączanie na protokół HTTPS dla tej witryny, jeśli chcesz, aby { -brand-short-name } przełączał na zabezpieczone połączenie, kiedy to możliwe.
identity-https-only-info-turn-off3 = Jeśli strona wydaje się niepoprawnie działać, możesz wyłączyć przełączanie na protokół HTTPS dla tej witryny, aby odświeżyć ją za pomocą niezabezpieczonego protokołu HTTP.
identity-https-only-info-no-upgrade = Nie można przełączyć połączenia z protokołu HTTP.
identity-permissions-storage-access-header = Ciasteczka między witrynami
identity-permissions-storage-access-hint = Te strony mogą używać ciasteczek i danych między witrynami, kiedy jesteś na tej witrynie.
identity-permissions-storage-access-learn-more = Więcej informacji
identity-permissions-reload-hint = Ponowne wczytanie strony może być konieczne, aby wprowadzone zmiany przyniosły skutek.
identity-clear-site-data =
    .label = Wyczyść ciasteczka i dane witryny…
identity-connection-not-secure-security-view = Połączenie z tą witryną nie jest zabezpieczone.
identity-connection-verified = Połączenie z tą witryną jest zabezpieczone.
identity-ev-owner-label = Certyfikat wystawiony dla:
identity-description-custom-root2 = BrowserWorks nie rozpoznaje tego wystawcy certyfikatu. Mógł zostać dodany przez system operacyjny lub administratora.
identity-remove-cert-exception =
    .label = Usuń wyjątek
    .accesskey = U
identity-description-insecure = Prywatność podczas łączenia się z tą witryną nie jest chroniona. Przesyłane informacje (np. hasła, wiadomości, numery kart) mogą być dostępne dla innych.
identity-description-insecure-login-forms = Dane logowania wprowadzone na tej stronie nie są bezpieczne i mogą być dostępne dla innych.
identity-description-weak-cipher-intro = Połączenie z tą witryną nie zapewnia prywatności, ponieważ szyfrowanie nie jest wystarczające.
identity-description-weak-cipher-risk = Informacje na witrynie mogą być dostępne dla innych, a jej działanie modyfikowane.
identity-description-active-blocked2 = { -brand-short-name } zablokował elementy tej strony, które nie były przesłane w sposób bezpieczny.
identity-description-passive-loaded = Połączenie z tą witryną nie zapewnia prywatności, a przesyłane informacje mogą być dostępne dla innych.
identity-description-passive-loaded-insecure2 = Niektóre elementy tej witryny (np. obrazy) nie były przesłane w sposób bezpieczny.
identity-description-passive-loaded-mixed2 = { -brand-short-name } zablokował niektóre elementy strony, mimo to nie wszystkie pozostałe elementy były przesłane w sposób bezpieczny (np. obrazy).
identity-description-active-loaded = Witryna zawiera elementy, które nie były przesłane w sposób bezpieczny (np. skrypty) i połączenie z nią nie zapewnia prywatności.
identity-description-active-loaded-insecure = Przesyłane informacje (np. hasła, wiadomości, numery kart) mogą być dostępne dla innych.
identity-disable-mixed-content-blocking =
    .label = Tymczasowo wyłącz ochronę
    .accesskey = T
identity-enable-mixed-content-blocking =
    .label = Włącz ochronę
    .accesskey = W
identity-more-info-link-text =
    .label = Więcej informacji

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimalizuj
browser-window-maximize-button =
    .tooltiptext = Maksymalizuj
browser-window-restore-down-button =
    .tooltiptext = Przywróć w dół
browser-window-close-button =
    .tooltiptext = Zamknij

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = ODTWARZANIE
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = WYCISZONE
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = ZABLOKOWANO AUTOODTWARZANIE
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = OBRAZ W OBRAZIE

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] WYCISZ KARTĘ
        [one] WYCISZ { $count } KARTĘ
        [few] WYCISZ { $count } KARTY
       *[many] WYCISZ { $count } KART
    }
browser-tab-unmute =
    { $count ->
        [1] WŁĄCZ DŹWIĘK
        [one] WŁĄCZ DŹWIĘK W { $count } KARCIE
        [few] WŁĄCZ DŹWIĘK W { $count } KARTACH
       *[many] WŁĄCZ DŹWIĘK W { $count } KARTACH
    }
browser-tab-unblock =
    { $count ->
        [1] ODTWARZAJ
        [one] ODTWARZAJ W { $count } KARCIE
        [few] ODTWARZAJ W { $count } KARTACH
       *[many] ODTWARZAJ W { $count } KARTACH
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = Importuj zakładki…
    .tooltiptext = Zaimportuj zakładki z innej przeglądarki do przeglądarki { -brand-short-name }
bookmarks-toolbar-empty-message = Umieść swoje zakładki na tym pasku zakładek, aby mieć do nich szybki dostęp. <a data-l10n-name="manage-bookmarks">Zarządzaj zakładkami…</a>

## WebRTC Pop-up notifications

popup-select-camera-device =
    .value = Kamera:
    .accesskey = K
popup-select-camera-icon =
    .tooltiptext = Kamera
popup-select-microphone-device =
    .value = Mikrofon:
    .accesskey = M
popup-select-microphone-icon =
    .tooltiptext = Mikrofon
popup-select-speaker-icon =
    .tooltiptext = Głośniki
popup-select-window-or-screen =
    .label = Okno lub ekran:
    .accesskey = O
popup-all-windows-shared = Wszystkie widoczne na ekranie okna zostaną udostępnione.

## WebRTC window or screen share tab switch warning

sharing-warning-window = { -brand-short-name } jest udostępniany. Inni będą widzieć, że przechodzisz do nowej karty.
sharing-warning-screen = Cały ekran jest udostępniany. Inni będą widzieć, że przechodzisz do nowej karty.
sharing-warning-proceed-to-tab =
    .label = Przejdź do karty
sharing-warning-disable-for-session =
    .label = Wyłącz ochronę udostępniania na czas tej sesji

## DevTools F12 popup

enable-devtools-popup-description2 = Aby móc użyć skrótu F12, najpierw otwórz narzędzia dla twórców witryn w menu „Narzędzia przeglądarki”.

## URL Bar

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
# This placeholder is used when searching quick actions.
urlbar-placeholder-search-mode-other-actions =
    .placeholder = Szukaj
    .aria-label = Szukaj działań
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Wprowadź adres lub szukaj w { $name }
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = Przeglądarka jest zdalnie zarządzana (przez: { $component })
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

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = szukaj w { $engine } w prywatnym oknie
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = szukaj w prywatnym oknie
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = szukaj w { $engine }
urlbar-result-action-sponsored = sponsorowane
urlbar-result-action-switch-tab = przełącz na kartę
urlbar-result-action-visit = otwórz stronę
# Allows the user to visit a URL that was previously copied to the clipboard.
urlbar-result-action-visit-from-your-clipboard = otwórz stronę ze schowka
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = naciśnij Tab, aby szukać w { $engine }
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = naciśnij Tab, aby szukać na witrynie { $engine }
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = szukaj w { $engine } prosto z paska adresu
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = szukaj na witrynie { $engine } prosto z paska adresu
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = kopiuj
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = szukaj w zakładkach
urlbar-result-action-search-history = szukaj w historii
urlbar-result-action-search-tabs = szukaj w kartach
urlbar-result-action-search-actions = szukaj w działaniach

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
    .label = { -firefox-suggest-brand-name }
# A label shown above the search suggestions group in the urlbar results. It
# should use sentence case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
    .label = Podpowiedzi { $engine }
# A label shown above Quick Actions in the urlbar results.
urlbar-group-quickactions =
    .label = Szybkie działania

## Reader View toolbar buttons

# This should match menu-view-enter-readerview in menubar.ftl
reader-view-enter-button =
    .aria-label = Popraw czytelność
# This should match menu-view-close-readerview in menubar.ftl
reader-view-close-button =
    .aria-label = Wygląd oryginalny

## Picture-in-Picture urlbar button
## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

picture-in-picture-urlbar-button-open =
    .tooltiptext = Otwórz „Obraz w obrazie” ({ $shortcut })
picture-in-picture-urlbar-button-close =
    .tooltiptext = Zamknij „Obraz w obrazie” ({ $shortcut })
picture-in-picture-panel-header = Obraz w obrazie
picture-in-picture-panel-headline = Ta witryna nie zaleca korzystania z funkcji „Obraz w obrazie”
picture-in-picture-panel-body = W trybie „Obraz w obrazie” filmy mogą nie wyświetlać się tak, jak przewidział to autor witryny.
picture-in-picture-enable-toggle =
    .label = Włącz mimo to

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
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> kontroluje teraz kursor. Naciśnij klawisz Esc, aby przejąć nad nim kontrolę.
pointerlock-warning-no-domain = Dokument kontroluje teraz kursor. Naciśnij klawisz Esc, aby przejąć nad nim kontrolę.

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = Zarządzaj zakładkami
bookmarks-recent-bookmarks-panel-subheader = Ostatnio dodane zakładki
bookmarks-toolbar-chevron =
    .tooltiptext = Wyświetl więcej zakładek
bookmarks-sidebar-content =
    .aria-label = Zakładki
bookmarks-menu-button =
    .label = Menu zakładki
bookmarks-other-bookmarks-menu =
    .label = Pozostałe zakładki
bookmarks-mobile-bookmarks-menu =
    .label = Zakładki z telefonu

## Variables:
##   $isVisible (boolean): if the specific element (e.g. bookmarks sidebar,
##                         bookmarks toolbar, etc.) is visible or not.

bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] Ukryj panel zakładek
           *[other] Wyświetl panel zakładek
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] Ukryj pasek zakładek
           *[other] Wyświetl pasek zakładek
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] Ukryj pasek zakładek
           *[other] Wyświetl pasek zakładek
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] Usuń menu Zakładki z paska narzędzi
           *[other] Dodaj menu Zakładki do paska narzędzi
        }

##

bookmarks-search =
    .label = Szukaj w zakładkach
bookmarks-tools =
    .label = Narzędzia zakładek
bookmarks-subview-edit-bookmark =
    .label = Edytuj zakładkę…
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = Pasek zakładek
    .accesskey = z
    .aria-label = Zakładki
bookmarks-toolbar-menu =
    .label = Pasek zakładek
bookmarks-toolbar-placeholder =
    .title = Elementy paska zakładek
bookmarks-toolbar-placeholder-button =
    .label = Elementy paska zakładek
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-subview-bookmark-tab =
    .label = Dodaj zakładkę do tej karty…

## Library Panel items

library-bookmarks-menu =
    .label = Zakładki
library-recent-activity-title =
    .value = Ostatnia aktywność

## Pocket toolbar button

save-to-pocket-button =
    .label = Wyślij do { -pocket-brand-name }
    .tooltiptext = Wyślij do { -pocket-brand-name }

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = Napraw kodowanie tekstu
    .tooltiptext = Spróbuj wykryć właściwe kodowanie tekstu na podstawie treści strony

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Ustawienia
    .tooltiptext =
        { PLATFORM() ->
            [macos] Otwórz ustawienia ({ $shortcut })
           *[other] Otwórz ustawienia
        }
toolbar-overflow-customize-button =
    .label = Dostosuj pasek narzędzi…
    .accesskey = D
toolbar-button-email-link =
    .label = ­Wyślij odnośnik
    .tooltiptext = Wyślij odnośnik do tej strony
toolbar-button-logins =
    .label = Hasła
    .tooltiptext = Wyświetl i zarządzaj zachowanymi hasłami
# Variables:
#  $shortcut (String): keyboard shortcut to save a copy of the page
toolbar-button-save-page =
    .label = ­Zapisz stronę
    .tooltiptext = Zapisz tę stronę ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open a local file
toolbar-button-open-file =
    .label = Otwórz plik
    .tooltiptext = Otwórz plik ({ $shortcut })
toolbar-button-synced-tabs =
    .label = Karty z innych urządzeń
    .tooltiptext = Wyświetl karty z innych urządzeń
# Variables
# $shortcut (string) - Keyboard shortcut to open a new private browsing window
toolbar-button-new-private-window =
    .label = Nowe okno prywatne
    .tooltiptext = Otwórz nowe okno w trybie prywatnym ({ $shortcut })

## EME notification panel

eme-notifications-drm-content-playing = Dźwięk lub obraz na tej stronie używają oprogramowania DRM, które może ograniczać możliwości oferowane przez { -brand-short-name(case: "acc") }.
eme-notifications-drm-content-playing-manage = Zarządzaj ustawieniami
eme-notifications-drm-content-playing-manage-accesskey = u
eme-notifications-drm-content-playing-dismiss = Zamknij
eme-notifications-drm-content-playing-dismiss-accesskey = Z

## Password save/update panel

panel-save-update-username = Nazwa użytkownika
panel-save-update-password = Hasło

##

# "More" item in macOS share menu
menu-share-more =
    .label = Więcej…
ui-tour-info-panel-close =
    .tooltiptext = Zamknij

## Variables:
##  $uriHost (String): URI host for which the popup was allowed or blocked.

popups-infobar-allow =
    .label = Pozwól { $uriHost } otwierać wyskakujące okna
    .accesskey = w
popups-infobar-block =
    .label = Blokuj wyskakujące okna z { $uriHost }
    .accesskey = B

##

popups-infobar-dont-show-message =
    .label = Nie pokazuj tej wiadomości, kiedy wyskakujące okna są blokowane
    .accesskey = N
edit-popup-settings =
    .label = Zarządzaj ustawieniami wyskakujących okien…
    .accesskey = Z
picture-in-picture-hide-toggle =
    .label = Ukryj przycisk „Obraz w obrazie”
    .accesskey = U

## Since the default position for PiP controls does not change for RTL layout,
## right-to-left languages should use "Left" and "Right" as in the English strings,

picture-in-picture-move-toggle-right =
    .label = Przenieś przycisk „Obraz w obrazie” na prawą stronę
    .accesskey = P
picture-in-picture-move-toggle-left =
    .label = Przenieś przycisk „Obraz w obrazie” na lewą stronę
    .accesskey = O

##


# Navigator Toolbox

# This string is a spoken label that should not include
# the word "toolbar" or such, because screen readers already know that
# this container is a toolbar. This avoids double-speaking.
navbar-accessible =
    .aria-label = Nawigacja
navbar-downloads =
    .label = Pobieranie plików
navbar-overflow =
    .tooltiptext = Więcej narzędzi…
# Variables:
#   $shortcut (String): keyboard shortcut to print the page
navbar-print =
    .label = Drukuj
    .tooltiptext = Wydrukuj tę stronę… ({ $shortcut })
navbar-home =
    .label = Strona startowa
    .tooltiptext = Przejdź do strony startowej { -brand-short-name(case: "gen") }
navbar-library =
    .label = Biblioteka
    .tooltiptext = Wyświetl historię, zachowane zakładki i jeszcze więcej
navbar-search =
    .title = Znajdź
# Name for the tabs toolbar as spoken by screen readers. The word
# "toolbar" is appended automatically and should not be included in
# in the string
tabs-toolbar =
    .aria-label = Karty przeglądarki
tabs-toolbar-new-tab =
    .label = Nowa karta
tabs-toolbar-list-all-tabs =
    .label = Pokaż wszystkie karty
    .tooltiptext = Pokaż wszystkie karty

## Infobar shown at startup to suggest session-restore

# <img data-l10n-name="icon"/> will be replaced by the application menu icon
restore-session-startup-suggestion-message = <strong>Otworzyć poprzednie karty?</strong> Możesz przywrócić poprzednią sesję w menu aplikacji { -brand-short-name } <img data-l10n-name="icon"/>, w sekcji Historia.
restore-session-startup-suggestion-button = Pokaż, jak to zrobić

## BrowserWorks data reporting notification (Telemetry, Waterfox Health Report, etc)

data-reporting-notification-message = { -brand-short-name } automatycznie przesyła pewne dane do { -vendor-short-name(case: "gen") } w celu ulepszenia przeglądarki.
data-reporting-notification-button =
    .label = Wybierz, co udostępniać
    .accesskey = W
# Label for the indicator shown in the private browsing window titlebar.
private-browsing-indicator-label = Tryb prywatny

## Unified extensions (toolbar) button

unified-extensions-button =
    .label = Rozszerzenia
    .tooltiptext = Rozszerzenia

## Unified extensions button when permission(s) are needed.
## Note that the new line is intentionally part of the tooltip.

unified-extensions-button-permissions-needed =
    .label = Rozszerzenia
    .tooltiptext =
        Rozszerzenia
        Wymagane uprawnienia

## Unified extensions button when some extensions are quarantined.
## Note that the new line is intentionally part of the tooltip.

unified-extensions-button-quarantined =
    .label = Rozszerzenia
    .tooltiptext =
        Rozszerzenia
        Część rozszerzeń jest niedozwolona

## Autorefresh blocker

refresh-blocked-refresh-label = { -brand-short-name } uniemożliwił tej stronie automatycznie odświeżyć stronę.
refresh-blocked-redirect-label = { -brand-short-name } uniemożliwił tej stronie automatycznie przekierować do innej strony.
refresh-blocked-allow =
    .label = Zezwól
    .accesskey = Z

## Waterfox Relay integration

firefox-relay-offer-why-to-use-relay = Nasze bezpieczne, łatwe w użyciu maski chronią Twoją tożsamość i zapobiegają spamowi, ukrywając Twój adres e-mail.
# Variables:
#  $useremail (String): user email that will receive messages
firefox-relay-offer-what-relay-provides = Wszystkie wiadomości wysłane na Twoje maski będą przekazywane na adres <strong>{ $useremail }</strong> (chyba że zdecydujesz się je zablokować).
firefox-relay-offer-legal-notice = Klikając „Użyj maski dla adresu e-mail”, wyrażasz zgodę na <label data-l10n-name="tos-url">regulamin usługi</label> i <label data-l10n-name="privacy-url">zasady ochrony prywatności</label>.

## Add-on Pop-up Notifications

popup-notification-addon-install-unsigned =
    .value = (niezweryfikowany)
popup-notification-xpinstall-prompt-learn-more = Więcej informacji o bezpiecznym instalowaniu dodatków

## Pop-up warning

# Variables:
#   $popupCount (Number): the number of pop-ups blocked.
popup-warning-message =
    { $popupCount ->
        [one] { -brand-short-name } uniemożliwił tej witrynie otwarcie wyskakującego okna.
        [few] { -brand-short-name } uniemożliwił tej witrynie otwarcie { $popupCount } wyskakujących okien.
       *[many] { -brand-short-name } uniemożliwił tej witrynie otwarcie { $popupCount } wyskakujących okien.
    }
# The singular form is left out for English, since the number of blocked pop-ups is always greater than 1.
# Variables:
#   $popupCount (Number): the number of pop-ups blocked.
popup-warning-exceeded-message =
    { $popupCount ->
        [one] { -brand-short-name } uniemożliwił tej witrynie otwarcie wyskakującego okna.
        [few] { -brand-short-name } uniemożliwił tej witrynie otwarcie więcej niż { $popupCount } wyskakujących okien.
       *[many] { -brand-short-name } uniemożliwił tej witrynie otwarcie więcej niż { $popupCount } wyskakujących okien.
    }
popup-warning-button =
    .label =
        { PLATFORM() ->
            [windows] Opcje
           *[other] Preferencje
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
# Variables:
#   $popupURI (String): the URI for the pop-up window
popup-show-popup-menuitem =
    .label = Wyświetl „{ $popupURI }”
