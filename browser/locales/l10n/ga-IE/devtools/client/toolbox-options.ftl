# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Uirlisí Réamhshocraithe Forbartha

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Gan tacaíocht i sprioc reatha an bhosca uirlisí

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Uirlisí Forbartha a shuiteáil breiseáin

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Cnaipí Bosca Uirlisí atá ar fáil

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Téamaí

## Inspector section

# The heading
options-context-inspector = Scrúdaitheoir

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Taispeáin Stíleanna Brabhsálaí
options-show-user-agent-styles-tooltip =
    .title = Leis an rogha seo, taispeánfar stíleanna réamhshocraithe a lódálann an brabhsálaí.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Teasc aitreabúidí DOM
options-collapse-attrs-tooltip =
    .title = Teasc aitreabúid fhada sa scrúdaitheoir

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Aonad réamhshocraithe datha
options-default-color-unit-authored = Mar a scríobhadh é
options-default-color-unit-hex = Heics
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Ainmneacha Dathanna

## Style Editor section

# The heading
options-styleeditor-label = Eagarthóir Stíle

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = CSS a uathlíonadh
options-stylesheet-autocompletion-tooltip =
    .title = Déan uathlíonadh beo d'airíonna, luachanna, agus roghnóirí CSS san Eagarthóir Stíle

## Screenshot section

# The heading
options-screenshot-label = Láimhseáil Seatanna den Scáileán

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Cóipeáil sa ghearrthaisce
options-screenshot-clipboard-tooltip =
    .title = Sábhálfar seat den scáileán go díreach sa ghearrthaisce

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Seinn fuaim an chomhla
options-screenshot-audio-tooltip =
    .title = Cumasaíonn seo fuaim cheamara agus seat den scáileán á thógáil

## Editor section

# The heading
options-sourceeditor-label = Sainroghanna an Eagarthóra

options-sourceeditor-detectindentation-tooltip =
    .title = Tomhais an stíl eangaithe bunaithe ar inneachar na foinse
options-sourceeditor-detectindentation-label = Braith an stíl eangaithe
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Cuir lúibíní deiridh isteach go huathoibríoch
options-sourceeditor-autoclosebrackets-label = Dún lúibíní go huathoibríoch
options-sourceeditor-expandtab-tooltip =
    .title = Úsáid spásanna in ionad táb
options-sourceeditor-expandtab-label = Eangaigh le spásanna
options-sourceeditor-tabsize-label = Méid táib
options-sourceeditor-keybinding-label = Aicearraí
options-sourceeditor-keybinding-default-label = Réamhshocrú

## Advanced section

# The heading
options-context-advanced-settings = Ardsocruithe

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Díchumasaigh an Taisce HTTP (nuair a bhíonn an bosca uirlisí oscailte)
options-disable-http-cache-tooltip =
    .title = Díchumasaíonn an rogha seo an taisce HTTP do chluaisíní a bhfuil an bosca uirlisí oscailte iontu. Ní théann an rogha seo i bhfeidhm ar Oibrithe Seirbhíse.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Díchumasaigh JavaScript *
options-disable-javascript-tooltip =
    .title = Díchumasóidh an rogha seo JavaScript sa chluaisín reatha. Dá ndúnfaí an cluaisín nó an bosca uirlisí, dhéanfaí dearmad ar an socrú seo.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Cumasaigh boscaí uirlisí do chrome agus dífhabhtú breiseán
options-enable-chrome-tooltip =
    .title = Leis an rogha seo, is féidir leat uirlisí éagsúla forbartha a úsáid i gcomhthéacs an bhrabhsálaí (via Uirlisí > Forbróir Gréasáin > Bosca Uirlisí an Bhrabhsálaí) agus breiseáin a dhífhabhtú i mBainisteoir na mBreiseán

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Cumasaigh cian-dífhabhtú

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Cumasaigh Oibrithe Seirbhíse thar HTTP (nuair a bhíonn an bosca uirlisí oscailte)
options-enable-service-workers-http-tooltip =
    .title = Cumasaíonn an rogha seo na hoibrithe seirbhíse thar HTTP i gcluaisíní a bhfuil an bosca uirlisí oscailte iontu.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Cumasaigh Mapaí Foinse

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * An seisiún seo amháin; athlódálann sé an leathanach

##

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Taispeáin sonraí faoin ardán Gecko
options-show-platform-data-tooltip =
    .title = Leis an rogha seo, cuirfidh an próifíleoir JavaScript siombailí ardáin Gecko  san áireamh
