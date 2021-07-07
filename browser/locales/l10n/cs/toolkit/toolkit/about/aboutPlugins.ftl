# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = O zásuvných modulech

installed-plugins-label = Nainstalované zásuvné moduly
no-plugins-are-installed-label = Nenalezeny žádné zásuvné moduly

deprecation-description = Něco chybí? Některé zásuvné moduly už nejsou podporovány. <a data-l10n-name="deprecation-link">Zjistit více.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Soubor</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Cesta:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Verze:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Stav:</span> Povolen
state-dd-enabled-block-list-state = <span data-l10n-name="state">Stav:</span> Povolen ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Stav:</span> Zakázán
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Stav:</span> Zakázán ({ $blockListState })

mime-type-label = Typ MIME
description-label = Popis
suffixes-label = Přípony
