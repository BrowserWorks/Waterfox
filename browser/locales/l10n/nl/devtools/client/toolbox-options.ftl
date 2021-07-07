# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Standaard ontwikkelaarshulpmiddelen

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Niet ondersteund voor huidige doel van werkset

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Door add-ons geïnstalleerde ontwikkelaarshulpmiddelen

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Beschikbare werksetknoppen

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Thema’s

## Inspector section

# The heading
options-context-inspector = Inspector

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Browserstijlen tonen
options-show-user-agent-styles-tooltip =
    .title = Aanzetten hiervan toont standaardstijlen die door de browser worden geladen.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = DOM-attributen afkappen
options-collapse-attrs-tooltip =
    .title = Lange attributen in de inspector afkappen

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Standaardkleureenheid
options-default-color-unit-authored = Zoals opgesteld
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Kleurnamen

## Style Editor section

# The heading
options-styleeditor-label = Stijleditor

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = CSS automatisch aanvullen
options-stylesheet-autocompletion-tooltip =
    .title = CSS-eigenschappen, -waarden en -selectors in de Stijleditor automatisch aanvullen terwijl u typt

## Screenshot section

# The heading
options-screenshot-label = Schermafbeeldingsgedrag

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = Schermafbeelding alleen naar klembord
options-screenshot-clipboard-tooltip2 =
    .title = Slaat de schermafbeelding rechtstreeks op naar het klembord

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Camerasluitergeluid afspelen
options-screenshot-audio-tooltip =
    .title = Schakelt het camerageluid bij het maken van schermafbeeldingen in

## Editor section

# The heading
options-sourceeditor-label = Editorvoorkeuren

options-sourceeditor-detectindentation-tooltip =
    .title = Inspringing raden op basis van broninhoud
options-sourceeditor-detectindentation-label = Inspringing detecteren
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Automatisch sluithaakjes invoegen
options-sourceeditor-autoclosebrackets-label = Automatisch haakjes sluiten
options-sourceeditor-expandtab-tooltip =
    .title = Spaties gebruiken in plaats van het tabteken
options-sourceeditor-expandtab-label = Inspringen met behulp van spaties
options-sourceeditor-tabsize-label = Tabgrootte
options-sourceeditor-keybinding-label = Sneltoetsen
options-sourceeditor-keybinding-default-label = Standaard

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = Geavanceerde instellingen

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = HTTP-buffer uitschakelen (als werkset is geopend)
options-disable-http-cache-tooltip =
    .title = Door deze optie aan te zetten, wordt de HTTP-buffer voor alle tabbladen die de werkset hebben geopend uitgeschakeld. Service Workers worden niet door deze optie beïnvloed.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = JavaScript uitschakelen *
options-disable-javascript-tooltip =
    .title = Door deze optie aan te zetten, wordt JavaScript voor het huidige tabblad uitgeschakeld. Als het tabblad of de werkset wordt gesloten, wordt deze instelling vergeten.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Browserchrome- en add-on-debugging-werksets inschakelen
options-enable-chrome-tooltip =
    .title = Door deze optie aan te zetten, kunt u diverse ontwikkelaarshulpmiddelen in browsercontext gebruiken (via Extra > Webontwikkelaar > Browserwerkset) en fouten in add-ons van de add-onbeheerder opsporen

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Remote debugging inschakelen
options-enable-remote-tooltip2 =
    .title = Door deze optie in te schakelen kunt u deze browserinstallatie op afstand debuggen

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Service Workers over HTTP inschakelen (als werkset is geopend)
options-enable-service-workers-http-tooltip =
    .title = Door deze optie aan te zetten, worden de service workers over HTTP voor alle tabbladen die de werkset hebben geopend ingeschakeld.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Brontoewijzingen inschakelen
options-source-maps-tooltip =
    .title = Als u deze optie inschakelt, zullen bronnen in de hulpmiddelen worden toegewezen.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Alleen huidige sessie, vernieuwt de pagina

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Gecko-platformgegevens tonen
options-show-platform-data-tooltip =
    .title = Als u deze optie inschakelt, zullen de JavaScript-profilerrapporten Gecko-platformsymbolen bevatten
