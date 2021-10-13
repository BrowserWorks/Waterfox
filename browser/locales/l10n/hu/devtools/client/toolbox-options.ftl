# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Alapértelmezett fejlesztői eszközök

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Nem támogatott a jelenlegi eszközkészlet célhoz

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Kiegészítők által telepített fejlesztői eszközök

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Elérhető eszközkészletgombok

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Témák

## Inspector section

# The heading
options-context-inspector = Vizsgáló

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Böngészőstílusok megjelenítése
options-show-user-agent-styles-tooltip =
    .title = A böngésző által betöltött alapértelmezett stílusok megjelenítése.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = DOM attribútumok csonkítása
options-collapse-attrs-tooltip =
    .title = Hosszú attribútumok csonkítása a vizsgálóban

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Alapértelmezett színegység
options-default-color-unit-authored = Ahogy elkészült
options-default-color-unit-hex = Hexa
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Színnevek

## Style Editor section

# The heading
options-styleeditor-label = Stílusszerkesztő

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = CSS automatikus kiegészítése
options-stylesheet-autocompletion-tooltip =
    .title = CSS tulajdonságok, értékek és szelektorok automatikus kiegészítése a Stílusszerkesztőben gépelés közben

## Screenshot section

# The heading
options-screenshot-label = Képernyőkép viselkedése

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = Képernyőkép csak a vágólapra helyezése
options-screenshot-clipboard-tooltip2 =
    .title = A képernyőképet közvetlenül a vágólapra menti

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Exponáló hang lejátszása
options-screenshot-audio-tooltip =
    .title = Engedélyezi a fényképező hangot a képernyőkép készítésekor

## Editor section

# The heading
options-sourceeditor-label = Szerkesztőbeállítások

options-sourceeditor-detectindentation-tooltip =
    .title = A behúzás felismerése a forrástartalom alapján
options-sourceeditor-detectindentation-label = Behúzás felismerése
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Záró zárójelek automatikus beszúrása
options-sourceeditor-autoclosebrackets-label = Zárójelek automatikus lezárása
options-sourceeditor-expandtab-tooltip =
    .title = Szóközök használata a tab karakter helyett
options-sourceeditor-expandtab-label = Behúzás szóközökkel
options-sourceeditor-tabsize-label = Tab méret
options-sourceeditor-keybinding-label = Keybindings
options-sourceeditor-keybinding-default-label = Default

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = Speciális beállítások

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = HTTP gyorsítótár ki (ha az eszközkészlet nyitva van)
options-disable-http-cache-tooltip =
    .title = Ezzel kikapcsolható a HTTP gyorsítótár minden lapon, amelyen az eszközkészlet nyitva van. A Service Workerekre ez nincs hatással.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = JavaScript kikapcsolása *
options-disable-javascript-tooltip =
    .title = Ezen beállítás bekapcsolásakor a JavaScript ki lesz kapcsolva az aktuális lapon. A lap vagy az eszközkészlet bezárásakor ez a beállítás el lesz felejtve.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = A böngésző chrome és kiegészítő hibakeresési eszköztárak be
options-enable-chrome-tooltip =
    .title = Különböző fejlesztői eszközök használata a böngésző kontextusában (az Eszközök -> Webfejlesztő -> Böngésző eszköztárán keresztül) és kiegészítők hibakeresése a Kiegészítőkezelőből

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Távoli hibakeresés be/ki
options-enable-remote-tooltip2 =
    .title = A beállítás bekapcsolásával engedélyezi a böngészőpéldány távoli hibakeresését.

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = A Service Workers bekapcsolása HTTP-n (ha az eszköztár nyitva van)
options-enable-service-workers-http-tooltip =
    .title = A Service Workers bekapcsolása HTTP-n minden laphoz, amelyeken az eszköztár nyitva van.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Forrástérképek engedélyezése
options-source-maps-tooltip =
    .title = Ha engedélyezi ezt a beállítást, akkor a források le lesznek képezve az eszközökben.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Csak ez a munkamenet, újratölti az oldalt

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = A Gecko platform adatainak megjelenítése
options-show-platform-data-tooltip =
    .title = A JavaScript profilozó jelentései tartalmazni fogják a Gecko platform szimbólumait is
