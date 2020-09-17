# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Arredol d'os plugins

installed-plugins-label = Plugins instalaus
no-plugins-are-installed-label = No s'ha trobau garra plugin instalau

deprecation-description = Falta cosa? Bells plugins ya han deixau d'estar soportaus. <a data-l10n-name="deprecation-link">Saber-ne mas</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Fichero:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Camín:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Versión:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Estau:</span> Activau
state-dd-enabled-block-list-state = <span data-l10n-name="state">Estau:</span> Activau ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Estau:</span> Desactivau
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Estau:</span> Desactivau ({ $blockListState })

mime-type-label = Tipo MIME
description-label = Descripción
suffixes-label = Sufixos
