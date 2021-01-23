# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Noklusētie izstrādātāju rīki

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Netiek atbalstīts konkrētajam rīkam

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Papildinājumu instalētie izstrādātāju rīki

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Pieejamās rīku pogas

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Tēmas

## Inspector section

# The heading
options-context-inspector = Pārraugs

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Rādīt pārlūka stilus
options-show-user-agent-styles-tooltip =
    .title = Šīs iespējas ieslēgšana parādīs noklusētos stilus, kas ir ielādēti pārlūkā

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Apgriezt DOM atribūtus
options-collapse-attrs-tooltip =
    .title = Apgriezt garus atribūtus inspektorā

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Noklusētā krāsu vienība
options-default-color-unit-authored = Kā norādīts
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Krāsu nosaukumi

## Style Editor section

# The heading
options-styleeditor-label = Stila redaktors

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Automātiski pabeigt CSS
options-stylesheet-autocompletion-tooltip =
    .title = Rakstos automātiski pabeigt CSS likumus, to vērtības un selektorus

## Screenshot section

# The heading
options-screenshot-label = Ekrānattēla uzvedība

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Ekrānattēls uz starpliktuvi
options-screenshot-clipboard-tooltip =
    .title = Saglabā ekrānattēlu starpliktuvē (datora atmiņā)

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Atskaņot fotografēšanas skaņu
options-screenshot-audio-tooltip =
    .title = Ļauj kamerai atskaņot skaņu uzņemot ekrānattēlu

## Editor section

# The heading
options-sourceeditor-label = Redaktora iestatījumi

options-sourceeditor-detectindentation-tooltip =
    .title = Minēt atkāpes atkarībā no koda konteksta
options-sourceeditor-detectindentation-label = Noteikt atkāpes
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Automātiski likt aizverošās iekavas
options-sourceeditor-autoclosebrackets-label = Automātiski likt aizverošās iekavas
options-sourceeditor-expandtab-tooltip =
    .title = Izmantot atstarpes tabulācijas simbola vietā
options-sourceeditor-expandtab-label = Veidot atkāpes ar atstarpēm
options-sourceeditor-tabsize-label = Atkāpes izmērs
options-sourceeditor-keybinding-label = Taustiņu saites
options-sourceeditor-keybinding-default-label = Noklusētā

## Advanced section

# The heading
options-context-advanced-settings = Papildu iestatījumi

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Deaktivēt HTTP kešatmiņu (ja ir atvērti izstrādātāju rīki)
options-disable-http-cache-tooltip =
    .title = Šīs iespējas ieslēgšana deaktivēs HTTP kešatmiņu visām cilnēm, kurām ir atvērta šo rīku josla. Pakalpojumu darbiniekus šī konfigurācijas iespēja neietekmē.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Deaktivēt JavaScript *
options-disable-javascript-tooltip =
    .title = Šī iestatījuma ieslēgšana deaktivēs JavaScript aktīvajā cilnē. Aizverot cilni vai rīku joslu šis iestatījums netiks saglabāts.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Aktivizēt pārlūka un papildinājumu atkļūdošanas rīkus
options-enable-chrome-tooltip =
    .title = Šīs iespējas aktivizēšana ļaus izmantot dažādus rīkus pārlūka kontekstā (Rīki > Izstrādātāju rīki > Pārlūka rīki) un ļaus atkļūdot papildinājumus

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Aktivēt attālināto atkļūdošanu

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Aktivizēt pakalpojumu darbiniekus pa HTTP (kad rīks ir atvērts)
options-enable-service-workers-http-tooltip =
    .title = Šīs iespējas aktivizēšana ļaus aktivizēt pakalpojumu darbiniekus pa HTTP visās cilnēs, kurās ir atvērts šis rīks.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Aktivizēt koda kartes
options-source-maps-tooltip =
    .title = Ja aktivēsiet šo iespēju kodi tika kartēti rīkos.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Tikai šo sesiju, pārlādē lapu

##

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Rādīt Gecko platformas datus
options-show-platform-data-tooltip =
    .title = Ja aktivizēsiet šo iespēju, JavaScript profilatora ziņojumos būs iekļauti arī Gecko platformas simboli
