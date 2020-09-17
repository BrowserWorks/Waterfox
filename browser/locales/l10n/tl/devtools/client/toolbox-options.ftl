# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Mga Default Developer Tool

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Hindi suportado para sa kasalukuyang toolbox target

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Mga Developer Tool na ikinabit ng mga add-on

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Mga Magagamit na Toolbox Button

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Mga Tema

## Inspector section

# The heading
options-context-inspector = Inspector

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Ipakita ang mga Browser Style
options-show-user-agent-styles-tooltip =
    .title = Ang pagbukas nito ay magpapakita ng mga default style na na-load ng browser.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Truncate DOM attributes
options-collapse-attrs-tooltip =
    .title = Truncate long attributes in the inspector

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Default color unit
options-default-color-unit-authored = As Authored
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Mga Ngalan ng Kulay

## Style Editor section

# The heading
options-styleeditor-label = Style Editor

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Autocomplete CSS
options-stylesheet-autocompletion-tooltip =
    .title = Mag-autocomplete ng mga CSS property, value at selector sa Style Editor habang nagta-type ka

## Screenshot section

# The heading
options-screenshot-label = Screenshot Behavior

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = I-screenshot pa-clipboard
options-screenshot-clipboard-tooltip =
    .title = Sine-save ang screenshot direkta sa clipboard

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Magpatunog ng camera shutter
options-screenshot-audio-tooltip =
    .title = Pinatutunog ang camera audio kapag kumuha ng screenshot

## Editor section

# The heading
options-sourceeditor-label = Mga Editor Preference

options-sourceeditor-detectindentation-tooltip =
    .title = Hulaan ang indentation base sa source content
options-sourceeditor-detectindentation-label = Mag-detect ng indentation
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Kusang maglagay ng mga closing bracket
options-sourceeditor-autoclosebrackets-label = I-autoclose ang mga bracket
options-sourceeditor-expandtab-tooltip =
    .title = Gumamit ng space sa halip na tab character
options-sourceeditor-expandtab-label = Mga-indent gamit ang space
options-sourceeditor-tabsize-label = Sukat ng tab
options-sourceeditor-keybinding-label = Keybindings
options-sourceeditor-keybinding-default-label = Default

## Advanced section

# The heading
options-context-advanced-settings = Mga advanced na setting

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = I-disable ang HTTP Cache (kapag nakabukas ang toolbox)
options-disable-http-cache-tooltip =
    .title = Ang pagbukas sa option na ito ay magdi-disable sa HTTP cache para sa lahat ng mga tab kung saan nakabukas ang toolbox. Hindi apektado ang mga Service Worker sa option na ito.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = I-disable ang JavaScript *
options-disable-javascript-tooltip =
    .title = Ang pagbukas sa option na ito ay magdi-disable ng JavaScript para sa kasalukuyang tab. Kapag isinara ang tab o toolbox, makakalimutan ang setting na ito.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = I-enable ang browser chrome at mga add-on debugging toolbox
options-enable-chrome-tooltip =
    .title = Kapag binuksan ang option na ito, magagamit mo ang mga developer tool sa browser context (sa pamamagitan ng Mga Kagamitan > Web Developer > Browser Toolbox) at mag-debug ng mga add-on mula sa Add-on Manager

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = I-enable ang remote debugging

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = I-enable ang mga Service Worker over HTTP (kapag nakabukas ang toolbox)
options-enable-service-workers-http-tooltip =
    .title = Ang pagbukas sa option na ito ay mag-e-enable sa mga service worker over HTTP para sa lahat ng mga tab kung saan nakabukas ang toolbox.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = I-enable ang mga Source Map
options-source-maps-tooltip =
    .title = Kapag inenable ang option na ito, ang mga source ay ima-map sa mga tool.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Kasalukuyang session lamang, nirereload ang pahina

##

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Ipakita ang Gecko Platform Data
options-show-platform-data-tooltip =
    .title = Kapag inenable ang option na ito, ang mga JavaScript profiler report ay magsasama ng mga Gecko platform symbol
