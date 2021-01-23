# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = A prepaus dels moduls

installed-plugins-label = Plugins activats
no-plugins-are-installed-label = Cap de plugin activat pas trobat

deprecation-description = Vos manca quicòm ? Unes plugins son pas mai preses en carga. <a data-l10n-name="deprecation-link">Ne saber mai.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Fichièr :</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Camin :</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Version :</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Estat :</span> Activat
state-dd-enabled-block-list-state = <span data-l10n-name="state">Estat :</span> Activat ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Estat :</span> Desactivat
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Estat :</span> Desactivat ({ $blockListState })

mime-type-label = Tipe MIME
description-label = Descripcion
suffixes-label = Sufixes
