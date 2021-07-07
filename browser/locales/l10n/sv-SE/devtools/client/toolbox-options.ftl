# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Standard utvecklarverktyg
# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Stöds inte för aktuellt mål för verktygen
# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Utvecklarverktyg installerade av tillägg
# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Tillgängliga verktygsknappar
# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Teman

## Inspector section

# The heading
options-context-inspector = Inspektör
# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Visa webbläsarstilar
options-show-user-agent-styles-tooltip =
    .title = Slå på detta kommer att visa standard stilar som är laddade av webbläsaren.
# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Trunkera DOM-attribut
options-collapse-attrs-tooltip =
    .title = Trunkera långa attribut i inspektören

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Standardfärgvärde
options-default-color-unit-authored = Som författat
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Färgnamn

## Style Editor section

# The heading
options-styleeditor-label = Stileditor
# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Autokomplettera CSS
options-stylesheet-autocompletion-tooltip =
    .title = Autokomplettera CSS-egenskaper, värden och selektorer när du skriver i stileditorn

## Screenshot section

# The heading
options-screenshot-label = Beteende för skärmdump
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Skärmdump till Urklipp
options-screenshot-clipboard-tooltip =
    .title = Sparar skärmdump direkt till Urklipp
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = Skärmdump endast till urklipp
options-screenshot-clipboard-tooltip2 =
    .title = Sparar skärmdump direkt till urklipp
# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Spela slutarljud för kamera
options-screenshot-audio-tooltip =
    .title = Aktiverar kameraljudet när du tar skärmdump

## Editor section

# The heading
options-sourceeditor-label = Redigerarinställningar
options-sourceeditor-detectindentation-tooltip =
    .title = Gissa indentering baserad på källinnehåll
options-sourceeditor-detectindentation-label = Känn av indentering
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Infoga avslutande hakparenteser automatiskt
options-sourceeditor-autoclosebrackets-label = Avsluta hakparenteser automatiskt
options-sourceeditor-expandtab-tooltip =
    .title = Använd mellanslag istället för tab-tecknet
options-sourceeditor-expandtab-label = Indentera med mellanslag
options-sourceeditor-tabsize-label = Tabbstorlek
options-sourceeditor-keybinding-label = Snabbtangenter
options-sourceeditor-keybinding-default-label = Standard

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = Avancerade inställningar
# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Inaktivera HTTP Cache (när verktygslådan är öppen)
options-disable-http-cache-tooltip =
    .title = Aktivera det här alternativet inaktiverar HTTP-cache för alla flikar som har verktygslådan öppen. Service Workers påverkas inte av det här alternativet.
# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Inaktivera JavaScript *
options-disable-javascript-tooltip =
    .title = Väljer du det här alternativet kommer JavaScript att inaktiveras för den aktuella fliken. Om fliken eller verktygslådan stängs kommer inställningen att glömmas.
# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Aktivera webbläsare chrome och felsökningsverktyg för tillägg
options-enable-chrome-tooltip =
    .title = Med det här alternativet kan du använda olika utvecklingsverktyg i webbläsaren (via Verktyg> Webbutvecklare> Webbläsarverktyg) och felsöka tillägg från tilläggshanteraren.
# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Aktivera fjärrfelsökning
options-enable-remote-tooltip2 =
    .title = Om du slår på det här alternativet kan du felsöka den här webbläsarinstansen på distans
# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Aktivera Service Workers över HTTP (när verktygslådan är öppen)
options-enable-service-workers-http-tooltip =
    .title = Med det här alternativet kan du aktivera service workers över HTTP för alla flikar som har verktygslådan öppen.
# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Aktivera källmappning
options-source-maps-tooltip =
    .title = Om du aktiverar det här alternativet kommer källor att mappas i verktygen.
# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Endast aktuell session, laddar om sidan
# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Visa Geckos plattformsdata
options-show-platform-data-tooltip =
    .title = Om du aktiverar denna inställning kommer JavaScript-profilerarens rapporter att inkludera plattformssymboler för Gecko
