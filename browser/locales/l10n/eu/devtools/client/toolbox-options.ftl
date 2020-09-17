# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Garatzaile-tresna lehenetsiak

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Ez da onartzen tresna-kutxaren uneko helbururako

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Gehigarriek instalatutako garatzaile-tresnak

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Tresna-kutxako botoi erabilgarriak

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Itxurak

## Inspector section

# The heading
options-context-inspector = Ikuskatzailea

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Erakutsi nabigatzaile-estiloak
options-show-user-agent-styles-tooltip =
    .title = Ezarrita badago, nabigatzaileak kargatzen dituen estilo lehenetsiak erakutsiko dira.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Moztu DOM atributuak
options-collapse-attrs-tooltip =
    .title = Moztu ikuskatzaileko atributu luzeak

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Koloreen unitate lehenetsia
options-default-color-unit-authored = Sortu bezala
options-default-color-unit-hex = Hamaseitarra
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Koloreen izenak

## Style Editor section

# The heading
options-styleeditor-label = Estilo-editorea

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = CSSaren osatze automatikoa
options-stylesheet-autocompletion-tooltip =
    .title = Osatu automatikoki idatzi ahala CSS propietateak, balioak eta hautatzaileak estiloen editorean

## Screenshot section

# The heading
options-screenshot-label = Pantaila-argazkiaren portaera

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Pantaila-argazkia arbelera
options-screenshot-clipboard-tooltip =
    .title = Pantaila-argazkia zuzenean arbelean gordetzen du

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Erreproduzitu kamera-obturadorearen soinua
options-screenshot-audio-tooltip =
    .title = Kameraren audio-soinua gaitzen du pantaila-argazkia hartzerakoan

## Editor section

# The heading
options-sourceeditor-label = Editorearen hobespenak

options-sourceeditor-detectindentation-tooltip =
    .title = Saiatu koska igartzen iturburuaren edukian oinarrituta
options-sourceeditor-detectindentation-label = Detektatu koska
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Txertatu automatikoki ixteko kortxeteak
options-sourceeditor-autoclosebrackets-label = Autoitxi kortxeteak
options-sourceeditor-expandtab-tooltip =
    .title = Erabili zuriune-karaktereak tabulazio-karakterearen ordez
options-sourceeditor-expandtab-label = Koska zuriuneak erabiliz
options-sourceeditor-tabsize-label = Tabulazioaren tamaina
options-sourceeditor-keybinding-label = Tekla-konbinazioak
options-sourceeditor-keybinding-default-label = Lehenetsia

## Advanced section

# The heading
options-context-advanced-settings = Ezarpen aurreratuak

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Desgaitu HTTP cachea (tresna-kutxa irekita dagoenean)
options-disable-http-cache-tooltip =
    .title = Ezarrita badago, Ezarrita badago, HTTP cachea desgaitu egingo da tresna-kutxa zabalik duten fitxa guztietan. Aukera honek ez die zerbitzu-langileei eragiten.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Desgaitu JavaScript *
options-disable-javascript-tooltip =
    .title = Ezarrita badago, JavaScript desgaituko da uneko fitxan. Fitxa edo tresna-kutxa itxita badaude, ezarpen hau ahaztu egingo da.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Gaitu nabigatzailearen interfazea eta gehigarriak arazteko tresna-kutxak
options-enable-chrome-tooltip =
    .title = Ezarrita badago, hainbat garatzaile-tresna nabigatzailearen testuinguruan erabili (Tresnak > Web garapena > Nabigatzailearen tresna-kutxa bidez) eta gehigarrien kudeatzailetik araztu ahal izango dituzu

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Gaitu urruneko arazketa

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Gaitu zerbitzu-langileak HTTP bidez (tresna-kutxa irekita dagoenean)
options-enable-service-workers-http-tooltip =
    .title = Ezarrita badago, zerbitzu-langileak HTTP bidez erabilgarri egongo dira tresna-kutxa zabalik duten fitxa guztietan.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Gaitu iturburu-mapak
options-source-maps-tooltip =
    .title = Aukera hau gaituz gero, iturburuak mapeatu egingo dira tresnetan.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Uneko saioa soilik, orria berritzen du

##

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Erakutsi Gecko plataformaren datuak
options-show-platform-data-tooltip =
    .title = Aukera hau gaituz gero, JavaScript analizatzailearen txostenek Gecko plataformaren sinboloak izango dituzte
