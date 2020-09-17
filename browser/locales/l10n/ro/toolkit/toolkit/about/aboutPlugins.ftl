# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Despre pluginuri

installed-plugins-label = Pluginuri instalate
no-plugins-are-installed-label = Niciun plugin instalat găsit

deprecation-description = Lipsește ceva? Unele pluginuri nu mai sunt suportate. <a data-l10n-name="deprecation-link">Află mai multe.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Fișier:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Cale:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Versiune:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Stare:</span> Activat
state-dd-enabled-block-list-state = <span data-l10n-name="state">Stare:</span> Activat ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Stare:</span> Dezactivat
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Stare:</span> Dezactivat ({ $blockListState })

mime-type-label = Tip MIME
description-label = Descriere
suffixes-label = Sufixe
