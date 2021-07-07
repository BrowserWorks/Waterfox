# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Domyślne narzędzia dla programistów

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Nieobsługiwane dla bieżącego celu narzędzi

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Narzędzia dla programistów zainstalowane przez dodatki

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Przyciski narzędzi dla programistów

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Motyw

## Inspector section

# The heading
options-context-inspector = Inspektor

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Wyświetlanie stylów przeglądarki
options-show-user-agent-styles-tooltip =
    .title = Włączenie tej opcji spowoduje wyświetlanie domyślnych stylów wczytywanych przez przeglądarkę

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Skracanie atrybutów DOM
options-collapse-attrs-tooltip =
    .title = Skraca długie nazwy atrybutów DOM w inspektorze

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Domyślny model przestrzeni barw
options-default-color-unit-authored = Jak w oryginale
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Nazwy kolorów

## Style Editor section

# The heading
options-styleeditor-label = Edytor stylów

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Automatyczne uzupełnianie CSS
options-stylesheet-autocompletion-tooltip =
    .title = Podczas pisania uzupełnia automatycznie wartości, własności i selektory CSS w edytorze stylów

## Screenshot section

# The heading
options-screenshot-label = Zapisywanie obrazu strony

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = Zachowywanie tylko w schowku
options-screenshot-clipboard-tooltip2 =
    .title = Zachowuje zrzut bezpośrednio w schowku

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Odgłos migawki
options-screenshot-audio-tooltip =
    .title = Odtwarza dźwięk podczas robienia zrzutu

## Editor section

# The heading
options-sourceeditor-label = Edytor

options-sourceeditor-detectindentation-tooltip =
    .title = Odgaduje głębokość wcięć w oparciu o treść źródła
options-sourceeditor-detectindentation-label = Wykrywanie wcięć
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Automatycznie wstawia znaki zamknięcia nawiasu
options-sourceeditor-autoclosebrackets-label = Domykanie nawiasów
options-sourceeditor-expandtab-tooltip =
    .title = Spacje zamiast znaków tabulacji
options-sourceeditor-expandtab-label = Wcinanie spacjami
options-sourceeditor-tabsize-label = Szerokość tabulacji:
options-sourceeditor-keybinding-label = Skróty klawiaturowe:
options-sourceeditor-keybinding-default-label = domyślne

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = Zaawansowane

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Wyłącz pamięć podręczną HTTP (gdy otworzone są narzędzia)
options-disable-http-cache-tooltip =
    .title = Wyłącza pamięć podręczną dla żądań HTTP we wszystkich kartach, dla których narzędzia są otwarte. To ustawienie nie ma wpływu na wątki usługowe.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Wyłącz JavaScript *
options-disable-javascript-tooltip =
    .title = Wyłącza JavaScript w bieżącej karcie. Jeśli karta lub narzędzia zostaną zamknięte, ustawienie zostanie zapomniane.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Narzędzia debugowania chrome przeglądarki i dodatków
options-enable-chrome-tooltip =
    .title = Włączenie tej opcji pozwoli na używanie wielu narzędzi dla programistów w kontekście przeglądarki (poprzez Narzędzia → Dla twórców witryn → Narzędzia przeglądarki) i debugowanie dodatków z menedżera dodatków

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Debugowanie zdalne
options-enable-remote-tooltip2 =
    .title = Włączenie tej opcji pozwoli na zdalne debugowanie tej instancji przeglądarki

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Wątki usługowe przez HTTP (gdy narzędzia są otwarte)
options-enable-service-workers-http-tooltip =
    .title = Kontroluje dostępność wątków usługowych przez HTTP w kartach z otwartymi narzędziami

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Mapy źródeł
options-source-maps-tooltip =
    .title = Po włączeniu tej funkcji, źródła będą mapowane w narzędziach

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Tylko bieżąca sesja, przeładowuje stronę

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Informacje platformy Gecko
options-show-platform-data-tooltip =
    .title = Po włączeniu tej opcji Profiler JavaScript będzie raportował symbole platformy Gecko
