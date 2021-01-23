# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Pri kromprogramoj

installed-plugins-label = Instalitaj kromprogramoj
no-plugins-are-installed-label = Neniu instalita kromprogramo estis trovita

deprecation-description = Ĉu io mankas? Kelkaj kromprogramoj ne plu estas subtenataj. <a data-l10n-name="deprecation-link">Pli da informo.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Dosiero:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Vojo:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Versio:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Stato:</span> Aktiva
state-dd-enabled-block-list-state = <span data-l10n-name="state">Stato:</span> Aktiva ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Stato:</span> Malaktiva
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Stato:</span> Malaktiva ({ $blockListState })

mime-type-label = MIME Tipo
description-label = Priskribo
suffixes-label = Sufiksoj
