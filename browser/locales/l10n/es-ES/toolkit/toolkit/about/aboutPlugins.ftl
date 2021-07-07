# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Acerca de los plugins

installed-plugins-label = Plugins instalados
no-plugins-are-installed-label = No se han encontrado plugins instalados

deprecation-description = ¿Echa algo en falta? Algunos plugins ya no están admitidos. <a data-l10n-name="deprecation-link">Saber más.</a>

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

state-dd-enabled = <span data-l10n-name="state">Estado:</span> Habilitado
state-dd-enabled-block-list-state = <span data-l10n-name="state">Estado:</span> Habilitado ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Estado:</span> Deshabilitado
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Estado:</span> Deshabilitado ({ $blockListState })

mime-type-label = Tipo MIME
description-label = Descripción
suffixes-label = Sufijos
