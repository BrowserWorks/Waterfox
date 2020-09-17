# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Tungkol sa Mga Plugin

installed-plugins-label = Mga nakakabit na plugin
no-plugins-are-installed-label = Walang makitang nakakabit na plugin

deprecation-description = Nawawala ang isang bagay? Ang ilang mga plugin ay hindi na suportado. <a data-l10n-name="deprecation-link">Matuto ng Higit pa.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">File:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Path:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Bersyon:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Estado:</span> Pinagana
state-dd-enabled-block-list-state = <span data-l10n-name="state">Estado:</span> Pinagana ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Estado:</span> Hindi pinagana
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Estado:</span> Hindi pinagana ({ $blockListState })

mime-type-label = MIME Uri
description-label = Paglalarawan
suffixes-label = Suffixes
