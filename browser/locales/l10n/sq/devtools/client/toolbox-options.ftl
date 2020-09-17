# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Mjete Parazgjedhje Zhvilluesi

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * I pambuluar për objektin e tanishëm të grupit të mjeteve

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Mjete Zhvilluesi të instaluara nga shtesa

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Butona të Gatshëm Grupi Mjetesh

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Tema

## Inspector section

# The heading
options-context-inspector = Mbikëqyrës

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Shfaqni Stile Shfletuesi
options-show-user-agent-styles-tooltip =
    .title = Aktivizimi i kësaj do të bëjë të shfaqen stilet parazgjedhje që janë ngarkuar nga shfletuesi.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Cungo atribute DOM
options-collapse-attrs-tooltip =
    .title = Cungo te mbikëqyrësi atribute të gjatë

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Njësi parazgjedhje ngjyrash
options-default-color-unit-authored = Si e Autorit
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Emra Ngjyrash

## Style Editor section

# The heading
options-styleeditor-label = Përpunues Stilesh

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Vetëplotëso CSS
options-stylesheet-autocompletion-tooltip =
    .title = Vetëplotëso te Përpunues Stilesh veti, vlera dhë përzgjedhës CSS-je, në shkrim e sipër

## Screenshot section

# The heading
options-screenshot-label = Sjellje e Fotove të Ekranit

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Foto ekrani në të papastër
options-screenshot-clipboard-tooltip =
    .title = E ruan foton e ekranit drejt e në të papastër

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Prodho tingull shkrepjeje të kamerës
options-screenshot-audio-tooltip =
    .title = Aktivizon tingullin e kamerës kur bëhen foto ekrani

## Editor section

# The heading
options-sourceeditor-label = Parapëlqime Mbi Përpunuesin

options-sourceeditor-detectindentation-tooltip =
    .title = Hamendëso zhvendosje bazuar në lëndën burim
options-sourceeditor-detectindentation-label = Zbulo zhvendosje
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Fut vetvetiu kllapa të mbyllura
options-sourceeditor-autoclosebrackets-label = Vetëmbylli kllapat
options-sourceeditor-expandtab-tooltip =
    .title = Përdor hapësira, në vend se shenja tab
options-sourceeditor-expandtab-label = Zhvendos duke përdorur hapësira
options-sourceeditor-tabsize-label = Madhësi tabulacioni
options-sourceeditor-keybinding-label = Shkurtore
options-sourceeditor-keybinding-default-label = Parazgjedhje

## Advanced section

# The heading
options-context-advanced-settings = Rregullime të mëtejshme

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Çaktivizo Fshehtinën HTTP (kur grupi i mjeteve është i hapur)
options-disable-http-cache-tooltip =
    .title = Vënia në punë e kësaj mundësie do të çaktivizojë fshehtinën HTTP për krejt skedat që e kanë grupin e mjeteve hapur. Workers Shërbimetsh nuk preken nga kjo mundësi.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Çaktivizoni JavaScript-in *
options-disable-javascript-tooltip =
    .title = Aktivizimi i kësaj mundësie do të çaktivizojë JavaScript-in për skedën e atëçastshme. Nëse skeda ose grupi i mjeteve mbyllen, ky rregullim e humbet fuqinë.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Aktivizoni grupe mjetesh diagnostikimi chrome-sh dhe shtesash shfletuesi
options-enable-chrome-tooltip =
    .title = Aktivizimi i kësaj mundësie do t'ju lejojë të përdorni mjete të ndryshme zhvilluesi brenda kontekstit të një shfletuesi (përmes Mjete > Zhvillues Web > Grup Mjetesh Shfletuesi) dhe të diagnostikoni shtesa që prej Përgjegjësit të Shtesave

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Aktivizoni diagnostikim të largët
options-enable-remote-tooltip2 =
    .title = Aktivizimi i kësaj mundësie do të lejojë diagnostikimin së largëti të kësaj instance shfletuesi

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Aktivizoni Service Workers përmes HTTP-je (kur grupi i mjeteve është hapur)
options-enable-service-workers-http-tooltip =
    .title = Aktivizimi i kësaj mundësie do të aktivizojë service workers përmes HTTP-je për krejt skedat që e kanë të hapur grupin e mjeteve.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Aktivizo Harta Burimesh
options-source-maps-tooltip =
    .title = Nëse e aktivizoni këtë mundësi, burimet do të pasqyrohen te mjetet.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Vetëm për sesionin e tanishëm, ringarkon faqen

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Shfaqni të dhëna paltforme Gecko
options-show-platform-data-tooltip =
    .title = Nëse e aktivizoni këtë mundësi raportet e Profilizuesit JavaScript do të përfshijnë symbole të platformës Gecko
