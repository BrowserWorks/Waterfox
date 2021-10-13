# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Om programtillegg

installed-plugins-label = Installerte programtillegg
no-plugins-are-installed-label = Fann ingen installerte programtillegg

deprecation-description = Saknar du noko? Nokre program er ikkje lenger støtta. <a data-l10n-name="deprecation-link">Les meir.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Fil:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Sti:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Versjon:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Tilstand:</span> Påslått
state-dd-enabled-block-list-state = <span data-l10n-name="state">Tilstand:</span> Påslått ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Tilstand:</span> Avslått
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Tilstand:</span> Avslått ({ $blockListState })

mime-type-label = MIME-type
description-label = Skildring
suffixes-label = Filtypar
