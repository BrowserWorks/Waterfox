# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = O pluginima

installed-plugins-label = Instalirani plugini
no-plugins-are-installed-label = Nije pronađen niti jedan instalirani plugin

deprecation-description = Fali vam nešto? Neki plugini više nisu podržani. <a data-l10n-name="deprecation-link">Saznajte više.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Fajl:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Putanja:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Verzija:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Stanje:</span> Omogućeno
state-dd-enabled-block-list-state = <span data-l10n-name="state">Stanje:</span> Omogućeno ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Stanje:</span> Onemogućeno
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Stanje:</span> Onemogućeno ({ $blockListState })

mime-type-label = MIME tip
description-label = Opis
suffixes-label = Sufiksi
