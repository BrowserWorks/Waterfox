# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Numatytosios saityno kūrėjų priemonės
# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Nepalaikoma su esama įrankinės paskirtimi
# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Priedų įdiegtos saityno kūrėjų priemonės
# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Rodomi įrankinės mygtukai
# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Grafiniai apvalkalai

## Inspector section

# The heading
options-context-inspector = Tyriklis
# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Rodyti naršyklės stilius
options-show-user-agent-styles-tooltip =
    .title = Rodyti naršyklės naudojamus vidinius numatytuosius stilius.
# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Trumpinti DOM atributus
options-collapse-attrs-tooltip =
    .title = Trumpinti ilgus atributus tyriklyje

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Numatytasis spalvų žymėjimas
options-default-color-unit-authored = kaip nurodyta
options-default-color-unit-hex = Šešioliktainiai kodai
options-default-color-unit-hsl = AGŠ(A) (HSL(A))
options-default-color-unit-rgb = RŽM(A) (RGB(A))
options-default-color-unit-name = Spalvų vardai

## Style Editor section

# The heading
options-styleeditor-label = Stilių rengyklė
# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Automatiškai užbaigti CSS leksemas
options-stylesheet-autocompletion-tooltip =
    .title = Automatiškai užbaigti renkamus CSS savybių vardus, reikšmes ir selektorius stilių rengyklėje

## Screenshot section

# The heading
options-screenshot-label = Ekrano nuotraukų nuostatos
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Įrašyti į iškarpinę
options-screenshot-clipboard-tooltip =
    .title = Įrašo ekrano nuotrauką tiesiai į kompiuterio iškarpinę
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = Įrašyti nuotrauką tik į iškarpinę
options-screenshot-clipboard-tooltip2 =
    .title = Įrašo ekrano nuotrauką tiesiai į kompiuterio iškarpinę
# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Sugroti fotoaparato užrakto garsą
options-screenshot-audio-tooltip =
    .title = Įjungia fotoaparato garsą darant ekrano nuotrauką

## Editor section

# The heading
options-sourceeditor-label = Tekstų rengyklės nuostatos
options-sourceeditor-detectindentation-tooltip =
    .title = Nuspėti reikiamą įtrauką pagal pirminio teksto struktūrą
options-sourceeditor-detectindentation-label = Aptikti įtrauką
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Automatiškai pridėti užveriantįjį skliaustą, įvedus atveriantįjį
options-sourceeditor-autoclosebrackets-label = Automatiškai poruoti skliaustus
options-sourceeditor-expandtab-tooltip =
    .title = Naudoti ne tabuliavimo, o tarpo simbolius
options-sourceeditor-expandtab-label = Įtraukai naudoti tarpus
options-sourceeditor-tabsize-label = Tabuliavimo žingsnis
options-sourceeditor-keybinding-label = Klavišų susiejimai
options-sourceeditor-keybinding-default-label = Numatytieji

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = Sudėtingesnės nuostatos
# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Išjungti HTTP podėlį (kol atverta įrankinė)
options-disable-http-cache-tooltip =
    .title = Įjungę šią nuostatą, išjungsite HTTP podėlį visoms kortelėms, kurios kuri atvirą įrankinę. Aptarnavimo scenarijams ši nuostata įtakos neturi.
# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Išjungti „JavaScript“ *
options-disable-javascript-tooltip =
    .title = Pažymėję šią parinktį, išjungsite „JavaScript“ vykdymą šioje kortelėje. Užvėrus kortelę arba įrankinę, ši nuostata bus užmiršta.
# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Įjungti naršyklės sąsajos bei priedų derinimo įrankines
options-enable-chrome-tooltip =
    .title = Įjungę šia parinktį galėsite naudotis įvairiomis saityno kūrėjų priemonėmis naršyklėje (per „Priemonės“ > „Saityno kūrėjams“ > „Naršyklės įrankinė“) bei derinti priedus per priedų tvarkytuvę.
# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Įgalinti nuotolinį derinimą
options-enable-remote-tooltip2 =
    .title = Įjungus šią parinktį, bus galima per nuotolį derinti šią naršyklę
# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Įgalinti aptarnavimo scenarijus per HTTP (kai atverta įrankinė)
options-enable-service-workers-http-tooltip =
    .title = Įjungę šią parinktį įgalinsite aptarnavimo scenarijus per HTTP visoms kortelėms, kuriose yra atverta įrankinė.
# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Įgalinti ištekliaus žemėlapius
options-source-maps-tooltip =
    .title = Įjungus šią parinktį, ištekliai bus atvaizduojami priemonėse.
# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Galioja tik šią sesiją, įkelia tinklalapį iš naujo
# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Rodyti „Gecko“ platformos duomenis
options-show-platform-data-tooltip =
    .title = Įjungus šią parinktį, į „JavaScript“ profiliuoklės ataskaitas bus įtraukti „Gecko“ platformos simboliai
