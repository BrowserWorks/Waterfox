# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Výchozí nástroje pro vývojáře

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Není podporován pro aktuální kontext

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Nástroje pro vývojáře instalované doplňkem

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Dostupná tlačítka nástrojů

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Motivy vzhledu

## Inspector section

# The heading
options-context-inspector = Průzkumník

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Zobrazit styly prohlížeče
options-show-user-agent-styles-tooltip =
    .title = Zapnutím zobrazíte výchozí styly, které jsou načítány prohlížečem.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Zkrátit DOM atributy
options-collapse-attrs-tooltip =
    .title = Zkrátit dlouhé atributy v průzkumníku

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Výchozí jednotka pro barvy
options-default-color-unit-authored = Jak je napsáno
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Názvy barev

## Style Editor section

# The heading
options-styleeditor-label = Editor stylů

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Automatické doplňování CSS
options-stylesheet-autocompletion-tooltip =
    .title = Automatické doplňování při psaní vlastností CSS, hodnot a selektorů v Editoru stylů

## Screenshot section

# The heading
options-screenshot-label = Chování snímku obrazovky

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Přehrát zvuk spouště fotoaparátu
options-screenshot-audio-tooltip =
    .title = Umožňuje zvuk fotoaparátu při pořizování snímku obrazovky

## Editor section

# The heading
options-sourceeditor-label = Předvolby editoru

options-sourceeditor-detectindentation-tooltip =
    .title = Rozpozná odsazení na základě obsahu zdrojového kódu
options-sourceeditor-detectindentation-label = Automatické odsazování
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Zajistí automatické vkládání ukončovacích závorek
options-sourceeditor-autoclosebrackets-label = Automaticky uzavírat závorky
options-sourceeditor-expandtab-tooltip =
    .title = Použije mezery namísto tabulátorů
options-sourceeditor-expandtab-label = Odsazení pomocí mezer
options-sourceeditor-tabsize-label = Velikost tabulátoru
options-sourceeditor-keybinding-label = Klávesové zkratky
options-sourceeditor-keybinding-default-label = Výchozí

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = Rozšířené nastavení

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Zakázat mezipaměť (když jsou nástroje otevřeny)
options-disable-http-cache-tooltip =
    .title = Zapnutím této volby bude mezipaměť HTTP vypnuta pro všechny panely, které mají otevřené nástroje. Service Workers nejsou touto volbou ovlivněny.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Zakázat JavaScript *
options-disable-javascript-tooltip =
    .title = Přepnutí této volby zakáže pro aktuální panel JavaScript. Jakmile bude panel nebo nástroje uzavřeny, bude nastavení zapomenuto.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Povolit nástroje ladění pro chrome a doplňky
options-enable-chrome-tooltip =
    .title = Zapnutí umožní použít nástroje pro vývojáře v kontextu prohlížeče (přes Nástroje > Nástroje pro vývojáře > Nástroje prohlížeče) nebo pro ladění doplňků ze Správce doplňků

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Povolit vzdálené ladění
options-enable-remote-tooltip2 =
    .title = Zapnutí umožní vzdálené ladění této instance prohlížeče

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Povolit Service Workers přes HTTP (když jsou nástroje otevřeny)
options-enable-service-workers-http-tooltip =
    .title = Zapnutí této volby umožní Service Workers přes HTTP pro všechny panely, které mají panel nástrojů otevřen.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Povolit zdrojové mapy
options-source-maps-tooltip =
    .title = Pokud tuto volbu zapnete, zdroje voleb budou mapované v nástrojích.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Pouze aktuální relace, znovu načte stránku

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Zobrazit data platformy Gecko
options-show-platform-data-tooltip =
    .title = Pokud povolíte tuto volbu, bude report Profileru JavaScriptu zahrnovat symboly platformy Gecko
