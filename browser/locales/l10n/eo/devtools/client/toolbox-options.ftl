# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Normaj iloj por programistoj

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Ne subtenata por la nuna celo de la ilujo

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Iloj por programistoj instalitaj de aldonaĵoj

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Haveblaj butonoj de ilujo

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Etosoj

## Inspector section

# The heading
options-context-inspector = Inspektilo

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Montri stilojn de retumilo
options-show-user-agent-styles-tooltip =
    .title = Se tio ĉi estas ŝaltita, la normaj stiloj ŝargitaj de la retumilo estos montritaj.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Trunki atributojn de DOM
options-collapse-attrs-tooltip =
    .title = Trunki longajn atributojn en la inspektilo

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Norma unuo de koloro
options-default-color-unit-authored = Originala unuo
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Nomoj de koloroj

## Style Editor section

# The heading
options-styleeditor-label = Redaktilo de stiloj

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Aŭtomate kompletigi CSS
options-stylesheet-autocompletion-tooltip =
    .title = Dum vi tajpas, aŭtomate kompletigi atributojn, valorojn kaj elektilojn de CSS en la Redaktilo de stiloj kaj Inspektilo

## Screenshot section

# The heading
options-screenshot-label = Konduto de ekrankopio

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Ekrankopio al tondujo
options-screenshot-clipboard-tooltip =
    .title = Tio ĉi konservas la ekrankopion rekte en la tondujo

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Ludi la sonon de obturilo de filmilo
options-screenshot-audio-tooltip =
    .title = Tio ĉi aktivigas la sonon de la filmilo, kiam oni faras ekrankopion.

## Editor section

# The heading
options-sourceeditor-label = Preferoj de redaktilo

options-sourceeditor-detectindentation-tooltip =
    .title = Diveni krommarĝenon surbaze de la enhavo de fonto
options-sourceeditor-detectindentation-label = Eltrovi krommarĝenon
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Aŭtomate enmeti fermajn krampojn
options-sourceeditor-autoclosebrackets-label = Aŭtomate fermi krampojn
options-sourceeditor-expandtab-tooltip =
    .title = Uzi spacojn anstataŭ tabojn
options-sourceeditor-expandtab-label = Krei krommarĝenojn per spacoj
options-sourceeditor-tabsize-label = Spacoj po tabo
options-sourceeditor-keybinding-label = Klavkombinoj
options-sourceeditor-keybinding-default-label = Normaj

## Advanced section

# The heading
options-context-advanced-settings = Spertulaj agordoj

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Malaktivigi la staplon de HTTP (kiam la ilujo estas malfermita)
options-disable-http-cache-tooltip =
    .title = Ŝalto de tiu ĉi elekteblo malaktivigos la staplon de HTTP por ĉiuj langetoj, kiuj havas la ilujon malfermita. Tio ne koncernas la Service Workers.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Malŝalti JavaScript *
options-disable-javascript-tooltip =
    .title = Ŝalto de tiu elekteblo malaktivigos JavaScript en la nuna langeto. Se la langeton aŭ la ilujon oni fermas, tiu agordo estos forgesita.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Aktivigi la senerarigan ilujon por la retumila chrome kaj por la aldonaĵoj
options-enable-chrome-tooltip =
    .title = Ŝalto de tiu ĉi elekteblo permesos al vi uzi plurajn ilojn por programistoj en la kunteksto de la retumilo (Iloj > Teksaĵa programistoj > Retumila ilujo) kaj uzi senerarigajn aldonaĵojn el la administro de aldonaĵoj

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Ebligi foran senerarigon
options-enable-remote-tooltip2 =
    .title = Ŝalto de tiu ĉi eblo prefero permesos la foran senerarigon de tiu ĉi nuna programo

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Aktivigi Service Workers sur HTTP (kiam la ilujo estas malfermita)
options-enable-service-workers-http-tooltip =
    .title = Ŝalto de tiu ĉi elekteblo aktivigos la service workers su HTTP por ĉiuj langetoj kiuj havas la ilujon malfermita.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Aktivigi mapojn de fontoj
options-source-maps-tooltip =
    .title = Se vi aktivigas tiun ĉi elekteblon, fontoj estos mapitaj en la iloj.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Nur en la nuna seanco, tio reŝargas la paĝon

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Montri datumojn de la soklo de Gecko
options-show-platform-data-tooltip =
    .title = Se vi aktivigas tiun elekteblon, la raportoj de la rulanalizilo de JavaScript enhavos simbolojn de la soklo de Gecko.
