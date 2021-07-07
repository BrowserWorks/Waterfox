# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Informazioni sui plugin

installed-plugins-label = Plugin installati
no-plugins-are-installed-label = Nessun plugin installato

deprecation-description = Manca qualcosa? Alcuni plugin non sono più supportati. <a data-l10n-name="deprecation-link">Ulteriori informazioni.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">File:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Percorso:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Versione:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Stato:</span> attivo
state-dd-enabled-block-list-state = <span data-l10n-name="state">Stato:</span> attivo ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Stato:</span> disattivato
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Stato:</span> disattivato ({ $blockListState })

mime-type-label = Tipo MIME
description-label = Descrizione
suffixes-label = Estensione
