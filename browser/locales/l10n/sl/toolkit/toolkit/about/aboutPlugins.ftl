# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = O vtičnikih

installed-plugins-label = Nameščeni vtičniki
no-plugins-are-installed-label = Ni nameščenih vtičnikov

deprecation-description = Pogrešate kaj? Nekateri vtičniki niso več podprti. <a data-l10n-name="deprecation-link">Več o tem.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Datoteka:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Pot:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Različica:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Stanje:</span> Omogočeno
state-dd-enabled-block-list-state = <span data-l10n-name="state">Stanje:</span> Omogočeno ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Stanje:</span> Onemogočeno
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Stanje:</span> Onemogočeno ({ $blockListState })

mime-type-label = Vrsta MIME
description-label = Opis
suffixes-label = Končnice
