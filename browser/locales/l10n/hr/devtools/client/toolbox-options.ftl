# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Standardni programerski alati

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Nije podržano za trenutačni cilj alatne trake

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Programerski alati koje su instalirali dodaci

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Dostupne tipke alatne trake

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Teme

## Inspector section

# The heading
options-context-inspector = Inspektor

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Prikaz stilova preglednika
options-show-user-agent-styles-tooltip =
    .title = Uključivanjem ove opcije prikazat će se standardni stilovi koje učitava preglednik.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Skrati DOM atribute
options-collapse-attrs-tooltip =
    .title = Skrati duge atribute u inspektoru

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Standardna jedinica boje
options-default-color-unit-authored = Autor
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Nazivi boja

## Style Editor section

# The heading
options-styleeditor-label = Uređivač stilova

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Automatsko dovršavanje CSS-a
options-stylesheet-autocompletion-tooltip =
    .title = Automaski dovršava CSS svojstva, vrijednosti i selektore u editoru stilova za vrijeme tipkanja

## Screenshot section

# The heading
options-screenshot-label = Način rada snimke ekrana

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Snimka ekrana u međuspremnik
options-screenshot-clipboard-tooltip =
    .title = Sprema snimku ekrana izravno u međuspremnik

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Pokreni zvuk okidača kamere
options-screenshot-audio-tooltip =
    .title = Omogućava zvuk okidača kamere pri snimanju ekrana

## Editor section

# The heading
options-sourceeditor-label = Postavke uređivača

options-sourceeditor-detectindentation-tooltip =
    .title = Pogodi uvlake na temelju sadržaja izvora
options-sourceeditor-detectindentation-label = Prepoznaj uvlake
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Automatski dodaj zatvarajuće zagrade
options-sourceeditor-autoclosebrackets-label = Automatsko zatvaranje zagrada
options-sourceeditor-expandtab-tooltip =
    .title = Koristi razmake umjesto tabulatora
options-sourceeditor-expandtab-label = Uvlake sa razmakom
options-sourceeditor-tabsize-label = Veličina tabulatora
options-sourceeditor-keybinding-label = Tipkovnički prečaci
options-sourceeditor-keybinding-default-label = Standardno

## Advanced section

# The heading
options-context-advanced-settings = Napredne postavke

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Onemogući HTTP predmemoriju (kad je otvorena alatna kutija)
options-disable-http-cache-tooltip =
    .title = Uključivanjem ove opcije, onemogućit će se HTTP predmemorija za sve kartice na kojima su otvoreni alati. Ova opcije nema utjecaja ne radne procese.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Onemogući JavaScript *
options-disable-javascript-tooltip =
    .title = Isključivanje ove opcije će onemogućiti JavaScript za trenutačnu karticu. Ako se kartica ili alatna traka zatvore, ova će se postavka zaboraviti.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Omogući chrome preglednika i alate za otklanjanje grešaka u dodacima
options-enable-chrome-tooltip =
    .title = Uključivanje ove opcije će omogućiti korištenje raznih razvojnih alata u kontekstu preglednika (putem Alati > Web programer > Alati preglednika) i otklanjanje grešaka u dodacima putem upravljača dodataka.

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Omogući udaljeno ispravljanje grešaka

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Uključi radne procese usluge putem HTTP-a (kad je alatna traka otvorena)
options-enable-service-workers-http-tooltip =
    .title = Uključivanje ove opcije omogućit će korištenje radne procese usluge putem HTTP-a za sve kartice koje imaju otvorenu alatnu traku.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Aktiviraj mapiranja izvora
options-source-maps-tooltip =
    .title = Ako aktiviraš ovu opciju, izvori će se mapirati u alatima.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Samo trenutačna sesija, ponovo učitava stranicu

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Prikaži podatke Gecko platforme
options-show-platform-data-tooltip =
    .title = Ako omogućite ovu opciju, izvještaji JavaScript profilera će uključivati simbole Gecko platforme
