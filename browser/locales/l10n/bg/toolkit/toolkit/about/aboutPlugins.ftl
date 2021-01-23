# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Относно приставките

installed-plugins-label = Инсталирани приставки
no-plugins-are-installed-label = Не са намерени инсталирани приставки

deprecation-description = Липсва ли нещо? Някои приставки вече не се поддържат. <a data-l10n-name="deprecation-link">Научете повече</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Файл:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Път:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Версия:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Състояние:</span> Включена
state-dd-enabled-block-list-state = <span data-l10n-name="state">Състояние:</span> Включена ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Състояние:</span> Изключена
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Състояние:</span> Изключена ({ $blockListState })

mime-type-label = MIME тип
description-label = Описание
suffixes-label = Наставки
