# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Standard-udviklerværktøj

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Understøttes ikke af værktøjernes nuværende destination.

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Udviklerværktøj installeret af tilføjelser

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Tilgængelige værktøjsknapper

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Temaer

## Inspector section

# The heading
options-context-inspector = Inspektør

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Vis browser-styles
options-show-user-agent-styles-tooltip =
    .title = Aktivering af dette vil vise de standard-styles, som indlæses af browseren.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Afkort DOM-attributter
options-collapse-attrs-tooltip =
    .title = Afkort lange attributter i inspektør

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Standard-farveenhed
options-default-color-unit-authored = Som angivet
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Farvenavne

## Style Editor section

# The heading
options-styleeditor-label = Rediger CSS

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Autofuldfør CSS
options-stylesheet-autocompletion-tooltip =
    .title = Autofuldfør CSS-egenskaber, -værdier og -selektorer, mens du skriver i CSS-editoren

## Screenshot section

# The heading
options-screenshot-label = Indstillinger for skærmbilleder

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = Gem kun skærmbilleder til udklipsholder
options-screenshot-clipboard-tooltip2 =
    .title = Gem skærmbilledet direkte til udklipsholderen

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Afspil lyd
options-screenshot-audio-tooltip =
    .title = Aktiverer afspilning af en lyd, når der tages et skærmbillede

## Editor section

# The heading
options-sourceeditor-label = Indstillinger for editor

options-sourceeditor-detectindentation-tooltip =
    .title = Gæt indrykning baseret på kildens indhold
options-sourceeditor-detectindentation-label = Detekter indrykning
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Indsæt automatisk afsluttende parenteser
options-sourceeditor-autoclosebrackets-label = Luk automatisk parenteser
options-sourceeditor-expandtab-tooltip =
    .title = Brug mellemrum i stedet for tabulatortegn
options-sourceeditor-expandtab-label = Indryk med mellemrum
options-sourceeditor-tabsize-label = Tabulator-størrelse
options-sourceeditor-keybinding-label = Genvejstaster
options-sourceeditor-keybinding-default-label = Standard

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = Avancerede indstillinger

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Slå HTTP-cache fra (når Værktøj er åben)
options-disable-http-cache-tooltip =
    .title = Denne indstilling slår HTTP-cache fra for alle faneblade, der har Udviklerværktøj åbne. Service workers er ikke påvirket af denne indstilling.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Slå JavaScript fra *
options-disable-javascript-tooltip =
    .title = Denne indstilling slår JavaScript fra i det aktuelle faneblad. Indstillingen vil blive glemt, når fanebladet eller Værktøj lukkes.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Slå chrome- og tilføjelses-debuggingsværktøjer til
options-enable-chrome-tooltip =
    .title = Aktiverer du denne funktion, kan du bruge diverse udviklerværktøj i en browser-kontekst (via Funktioner > Webudvikler > Browserværktøj) og debugge tilføjelser fra fanebladet Tilføjelser

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Slå remote debugging til
options-enable-remote-tooltip2 =
    .title = Tillader at fjern-debugge denne instans af browseren.

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Aktiver service workers over HTTP (når værktøjerne er åbnet)
options-enable-service-workers-http-tooltip =
    .title = Aktiverer du denne funktion, vil du aktivere service workers over HTTP i alle faneblade, hvor værktøjerne er åbnet.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Aktiver Source-maps
options-source-maps-tooltip =
    .title = Hvis du aktiverer denne indstilling, vil sources blive mappet i værktøjerne.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Kun nuværende session, genindlæser siden

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Vis Gecko-platformsdata
options-show-platform-data-tooltip =
    .title =
        Hvis du slår denne indstilling til vil rapporterne fra JavaScript-profileringsværktøjet indeholde
        Gecko-platformssymboler
