# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Über Plugins

installed-plugins-label = Installierte Plugins
no-plugins-are-installed-label = Keine installierten Plugins gefunden

deprecation-description = Fehlt etwas? Einige Plugins werden nicht mehr unterstützt. <a data-l10n-name="deprecation-link">Weitere Informationen</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Datei:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Pfad:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Version:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Status:</span> Aktiviert
state-dd-enabled-block-list-state = <span data-l10n-name="state">Status:</span> Aktiviert ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Status:</span> Deaktiviert
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Status:</span> Deaktiviert ({ $blockListState })

mime-type-label = MIME-Typ
description-label = Beschreibung
suffixes-label = Endungen
