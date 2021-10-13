# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Om plugins

installed-plugins-label = Installerede plugins
no-plugins-are-installed-label = Ingen installerede plugins fundet

deprecation-description = Mangler du noget? Nogle plugins er ikke længere understøttet. <a data-l10n-name="deprecation-link">Læs mere.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Fil:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Sti:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Version:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Tilstand:</span> Aktiveret
state-dd-enabled-block-list-state = <span data-l10n-name="state">Tilstand:</span> Aktiveret ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Tilstand:</span> Deaktiveret
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Tilstand:</span> Deaktiveret ({ $blockListState })

mime-type-label = MIME Type
description-label = Beskrivelse
suffixes-label = Endelser
