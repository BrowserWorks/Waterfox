# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Predvolené vývojárske nástroje

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * nie je podporované pre aktuálny kontext

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Vývojárske nástroje nainštalované doplnkami

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Dostupné tlačidlá Vývojárskych nástrojov

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Témy vzhľadu

## Inspector section

# The heading
options-context-inspector = Prieskumník

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Zobraziť štýly prehliadača
options-show-user-agent-styles-tooltip =
    .title = Povolením tejto možnosti zobrazíte predvolené štýly, ktoré sú načítavané prehliadačom

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Skrátené DOM atribúty
options-collapse-attrs-tooltip =
    .title = Skrátené dlhé atribúty v prieskumníkovi

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Predvolená jednotka farieb
options-default-color-unit-authored = Podľa autora
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Názov farby

## Style Editor section

# The heading
options-styleeditor-label = Editor štýlov

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Automatické dokončovanie CSS
options-stylesheet-autocompletion-tooltip =
    .title = Počas písania v okne Editora štýlov automaticky dokončuje vlastnosti CSS, hodnoty a selektory

## Screenshot section

# The heading
options-screenshot-label = Snímky obrazovky

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Uložiť snímku obrazovky do schránky
options-screenshot-clipboard-tooltip =
    .title = Uloží snímku obrazovky priamo do schránky

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Prehrať zvuk spúšte fotoaparátu
options-screenshot-audio-tooltip =
    .title = Povolí zvuk fotoaparátu pri tvorbe snímok obrazovky

## Editor section

# The heading
options-sourceeditor-label = Nastavenia editora

options-sourceeditor-detectindentation-tooltip =
    .title = Odhadnúť odsadenie na základe obsahu zdroja
options-sourceeditor-detectindentation-label = Zisťovať odsadenie
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Automaticky vkladať ukončovacie zátvorky
options-sourceeditor-autoclosebrackets-label = Automaticky ukončovať zátvorky
options-sourceeditor-expandtab-tooltip =
    .title = Používať medzery namiesto znaku tabulátora
options-sourceeditor-expandtab-label = Odsadenie pomocou medzier
options-sourceeditor-tabsize-label = Veľkosť tabulátora
options-sourceeditor-keybinding-label = Klávesové skratky
options-sourceeditor-keybinding-default-label = Predvolené

## Advanced section

# The heading
options-context-advanced-settings = Rozšírené nastavenia

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Zakázať vyrovnávaciu pamäť HTTP (ak sú otvorené vývojárske nástroje)
options-disable-http-cache-tooltip =
    .title = Zapnutím tejto voľby bude vyrovnávacia pamäť HTTP vypnutá pre všetky karty, ktoré majú otvorené nástroje. Service Workery nebudú touto voľbou ovplyvnené.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Zakázať JavaScript *
options-disable-javascript-tooltip =
    .title = Označením tejto voľby zakážete používanie JavaScriptu na aktuálnej karte. Po zatvorení karty alebo ukončení vývojárskych nástrojov bude táto voľba automaticky prepnutá späť

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Povoliť nástroje ladenia chrome prehliadača a doplnkov
options-enable-chrome-tooltip =
    .title = Zapnutie tejto voľby vám umožní ladiť doplnky z okna Správcu doplnkov a používať rôzne vývojárske nástroje aj pre kontext prehliadača (Nástroje > Webový vývojár > Nástroje prehliadača)

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Povoliť vzdialené ladenie
options-enable-remote-tooltip2 =
    .title = Zapnutím tejto možnosti umožníte ladenie tejto inštancie prehliadača na diaľku

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Povoliť Service Workery cez HTTP (ak sú vývojárske nástroje otvorené)
options-enable-service-workers-http-tooltip =
    .title = Zapnutie tejto voľby povolí service workers cez HTTP pre všetky karty, ktoré majú otvorené vývojárske nástroje

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Povoliť zdrojové mapy
options-source-maps-tooltip =
    .title = Ak túto voľbu zapnete, zdroje budú mapované v nástrojoch.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Len pre aktuálnu reláciu, opäť načíta obsah stránky

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Zobrazovať údaje platformy Gecko
options-show-platform-data-tooltip =
    .title = Ak povolíte túto možnosť, správy Nástroja na profilovanie JavaScriptu budú obsahovať symboly platformy Gecko
