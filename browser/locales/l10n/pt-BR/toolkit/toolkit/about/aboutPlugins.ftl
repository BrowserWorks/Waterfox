# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Sobre os plugins

installed-plugins-label = Plugins instalados
no-plugins-are-installed-label = Nenhum plugin instalado

deprecation-description = Faltando alguma coisa? Alguns plugins não são mais suportados. <a data-l10n-name="deprecation-link">Saiba mais.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Arquivo:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Caminho:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Versão:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Status:</span> Ativado
state-dd-enabled-block-list-state = <span data-l10n-name="state">Status:</span> Ativado ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Status:</span> Desativado
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Status:</span> Desativado ({ $blockListState })

mime-type-label = Tipo MIME
description-label = Descrição
suffixes-label = Sufixos
