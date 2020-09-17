# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Privzeta razvojna orodja

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Ni podprto za trenutno tarčo razvojnih orodij

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Razvojna orodja, nameščena kot dodatki

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Razpoložljivi gumbi razvojnih orodij

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Teme

## Inspector section

# The heading
options-context-inspector = Pregledovalnik

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Prikaži sloge brskalnika
options-show-user-agent-styles-tooltip =
    .title = Če vključite to možnost, boste prikazali privzete sloge, ki jih naloži brskalnik.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Skrajšaj atribute DOM
options-collapse-attrs-tooltip =
    .title = Skrajšaj dolge atribute v pregledovalniku

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Privzeta enota barve
options-default-color-unit-authored = Izvirno
options-default-color-unit-hex = Šestnajstiško
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Imena barv

## Style Editor section

# The heading
options-styleeditor-label = Urejevalnik sloga

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Samodokončaj CSS
options-stylesheet-autocompletion-tooltip =
    .title = Med pisanjem v Urejevalniku sloga samodejno dokončaj lastnosti, vrednosti in izbirnike CSS

## Screenshot section

# The heading
options-screenshot-label = Posnetki zaslona

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Shrani v odložišče
options-screenshot-clipboard-tooltip =
    .title = Shrani posnetek zaslona v odložišče

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Predvajaj zvok zaslonke kamere
options-screenshot-audio-tooltip =
    .title = Ob zajemanju posnetka zaslona omogoči zvok kamere

## Editor section

# The heading
options-sourceeditor-label = Nastavitve urejevalnika

options-sourceeditor-detectindentation-tooltip =
    .title = Ugani zamik na podlagi izvorne vsebine
options-sourceeditor-detectindentation-label = Zaznaj zamik
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Samodejno vstavi zaklepaje
options-sourceeditor-autoclosebrackets-label = Samodopolni oklepaje
options-sourceeditor-expandtab-tooltip =
    .title = Uporabi presledke namesto tabulatorja
options-sourceeditor-expandtab-label = Zamik s presledki
options-sourceeditor-tabsize-label = Velikost tabulatorja
options-sourceeditor-keybinding-label = Bližnjice tipk
options-sourceeditor-keybinding-default-label = Privzeto

## Advanced section

# The heading
options-context-advanced-settings = Napredne nastavitve

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Onemogoči predpomnilnik HTTP (ko so razvojna orodja odprta)
options-disable-http-cache-tooltip =
    .title = Vklop te možnosti bo onemogočil predpomnilnik HTTP za vse zavihke, ki imajo odrta razvojna orodja. Ta možnost ne vpliva na Service Workerje.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Onemogoči JavaScript *
options-disable-javascript-tooltip =
    .title = Če vključite to možnost, boste onemogočili JavaScript v trenutnem zavihku. Če zaprete zavihek ali razvojna orodja, bo nastavitev pozabljena.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Omogoči orodja za razhroščevanje brskalnika in dodatkov
options-enable-chrome-tooltip =
    .title = Če vključite to možnost, boste omogočili uporabo razvojnih orodij v oknu brskalnika (meni Orodja > Spletni razvoj > Razvojna orodja brskalnika) in razhroščevanje dodatkov iz Upravitelja dodatkov

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Omogoči oddaljeno razhroščevanje

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Omogoči Service Workerje preko HTTP (ko so razvojna orodja odprta)
options-enable-service-workers-http-tooltip =
    .title = Če vključite to možnost, boste omogočili Service Workerje preko HTTP v vseh zavihkih, ki imajo odprta razvojna orodja.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Omogoči preslikave virov
options-source-maps-tooltip =
    .title = Če omogočite to možnost, bodo viri v orodjih preslikani.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Samo za to sejo, ponovno naloži stran

##

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Prikaži podatke platforme Gecko
options-show-platform-data-tooltip =
    .title =
        Če vključite to možnost, bodo poročila o delovanju JavaScripta vsebovala
        simbole platforme Gecko
