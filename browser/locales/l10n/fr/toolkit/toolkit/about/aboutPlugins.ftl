# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = À propos des plugins

installed-plugins-label = Plugins installés
no-plugins-are-installed-label = Aucun plugin installé n’a été trouvé

deprecation-description = Quelque chose semble manquer ? Certains plugins ne sont plus pris en charge. <a data-l10n-name="deprecation-link">En savoir plus.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Fichier :</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Chemin :</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Version :</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">État :</span> Activé
state-dd-enabled-block-list-state = <span data-l10n-name="state">État :</span> Activé ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">État :</span> Désactivé
state-dd-Disabled-block-list-state = <span data-l10n-name="state">État :</span> Désactivé ({ $blockListState })

mime-type-label = Type MIME
description-label = Description
suffixes-label = Suffixes
