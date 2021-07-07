# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = О плагинах

installed-plugins-label = Установленные плагины
no-plugins-are-installed-label = Установленных плагинов не найдено

deprecation-description = Что-то отсутствует? Некоторые плагины больше не поддерживаются. <a data-l10n-name="deprecation-link">Подробнее.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Файл:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Путь:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Версия:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Состояние:</span> Включён
state-dd-enabled-block-list-state = <span data-l10n-name="state">Состояние:</span> Включён ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Состояние:</span> Отключён
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Состояние:</span> Отключён ({ $blockListState })

mime-type-label = MIME-тип
description-label = Описание
suffixes-label = Суффиксы
