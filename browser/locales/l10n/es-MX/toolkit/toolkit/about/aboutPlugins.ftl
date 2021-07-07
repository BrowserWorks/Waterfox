# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Acerca de los Plugins

installed-plugins-label = Plugins instalados
no-plugins-are-installed-label = No hay plugins instalados

deprecation-description = ¿Te falta algo? Algunos complementos ya no son soportados. <a data-l10n-name="deprecation-link">Aprender más.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Archivo:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Ruta:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Versión:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">State:</span> Activar
state-dd-enabled-block-list-state = <span data-l10n-name="state">State:</span> Activar ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">State:</span> Deshabilitado
state-dd-Disabled-block-list-state = <span data-l10n-name="state">State:</span> Deshabilitado ({ $blockListState })

mime-type-label = Tipo MIME
description-label = Descripción
suffixes-label = Sufijos
