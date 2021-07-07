# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Инструменты разработчика по умолчанию

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Не поддерживается для текущей цели инструмента

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Инструменты разработчика установленные дополнениями

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Доступные кнопки инструментов

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Темы

## Inspector section

# The heading
options-context-inspector = Инспектор

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Отображать стили браузера
options-show-user-agent-styles-tooltip =
    .title = Включение приведёт к отображению стилей по умолчанию, применяемых браузером.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Обрезать атрибуты DOM
options-collapse-attrs-tooltip =
    .title = Обрезать в инспекторе длинные атрибуты

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Единицы задания цвета по умолчанию
options-default-color-unit-authored = Как в оригинале
options-default-color-unit-hex = 16-ричные числа
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Названия цветов

## Style Editor section

# The heading
options-styleeditor-label = Редактор стилей

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Автодополнение CSS
options-stylesheet-autocompletion-tooltip =
    .title = Автодополнение свойств, значений и селекторов CSS в Редакторе Стилей по мере набора

## Screenshot section

# The heading
options-screenshot-label = Настройки снятия скриншотов

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = Скриншот только в буфер обмена
options-screenshot-clipboard-tooltip2 =
    .title = Сохранять скриншот прямо в буфер обмена

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Проигрывать звук затвора камеры
options-screenshot-audio-tooltip =
    .title = Проигрывать звук щелчка затвора камеры при снятии скриншота

## Editor section

# The heading
options-sourceeditor-label = Настройки редактора

options-sourceeditor-detectindentation-tooltip =
    .title = Угадывать стиль отступов на основе содержимого исходников
options-sourceeditor-detectindentation-label = Определять стиль отступов
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Автоматически вставлять закрывающие скобки
options-sourceeditor-autoclosebrackets-label = Автозакрытие скобок
options-sourceeditor-expandtab-tooltip =
    .title = Использовать пробелы вместо символа табуляции
options-sourceeditor-expandtab-label = Отступ с помощью пробелов
options-sourceeditor-tabsize-label = Ширина табуляции
options-sourceeditor-keybinding-label = Сочетания клавиш
options-sourceeditor-keybinding-default-label = По умолчанию

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = Дополнительные параметры

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Отключить HTTP-кэш (когда открыта панель инструментов)
options-disable-http-cache-tooltip =
    .title = Включение этой опции отключит HTTP-кэш для всех вкладок, в которых открыта панель инструментов. Эта опция не влияет на Service Worker'ы.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Отключить JavaScript *
options-disable-javascript-tooltip =
    .title = Включение этой опции приведёт к отключению JavaScript для текущей вкладки. Если вкладка или панель инструментов будут закрыты, то этот параметр будет сброшен.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Включить инструменты отладки browser chrome и дополнений
options-enable-chrome-tooltip =
    .title = Включение этой опции позволит вам использовать различные инструменты разработчика в контексте браузера (через Инструменты > Веб-разработка > Инструменты браузера) и отлаживать дополнения из окна Управления дополнениями

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Включить удалённую отладку
options-enable-remote-tooltip2 =
    .title = Включение этой опции позволит удалённо отлаживать этот экземпляр браузера

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Включить Service Worker'ы поверх HTTP (когда открыта панель инструментов)
options-enable-service-workers-http-tooltip =
    .title = Включение этой опции включит service worker'ы поверх HTTP для всех вкладок, в которых открыта панель инструментов.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Включить Карты Исходников
options-source-maps-tooltip =
    .title = Если вы включите эту настройку, исходники будут картированы в инструментах.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Только текущая сессия, перезагружает страницу

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Отображать данные платформы Gecko
options-show-platform-data-tooltip =
    .title = Если вы включите эту настройку, то отчеты Профайлера JavaScript будут включать символы платформы Gecko
