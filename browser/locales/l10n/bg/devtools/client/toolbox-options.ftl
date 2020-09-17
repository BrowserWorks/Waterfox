# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Стандартни развойни инструменти

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Не се поддържа от назначението на текущата кутия с инструменти

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Развойни инструменти, инсталирани от добавки

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Бутони за лентата с инструменти

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Теми

## Inspector section

# The heading
options-context-inspector = Инспектор

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Показване и стиловете на четеца
options-show-user-agent-styles-tooltip =
    .title = Ако е включено ще бъдат показвани и стандартните стилове, зареждани от четеца.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Изрязване на атрибутите на DOM
options-collapse-attrs-tooltip =
    .title = Изрязване на дългите атрибути от инспектора

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Стандартна единица за цвят
options-default-color-unit-authored = Авторски
options-default-color-unit-hex = Шестнадесетична
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Имена на цветове

## Style Editor section

# The heading
options-styleeditor-label = Стилове

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Автоматично довършване на CSS
options-stylesheet-autocompletion-tooltip =
    .title = Автоматично довършване, докато пишете, на свойствата, стойностите и селекторите на CSS в стиловия редактор

## Screenshot section

# The heading
options-screenshot-label = Снимка на екрана

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Запазване в системния буфер
options-screenshot-clipboard-tooltip =
    .title = Запазва снимката на екрана директно в системния буфер

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Звук от затвора на фотоапарат
options-screenshot-audio-tooltip =
    .title = Включва звук от затвора на фотоапарат при правене на снимка на екрана

## Editor section

# The heading
options-sourceeditor-label = Настройки на редактора

options-sourceeditor-detectindentation-tooltip =
    .title = Предугаждане на използвания отстъп, чрез изследване на кода
options-sourceeditor-detectindentation-label = Разпознаване на отстъп
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Автоматично вмъкване на затваряща скоба
options-sourceeditor-autoclosebrackets-label = Автоматично затваряне на скоби
options-sourceeditor-expandtab-tooltip =
    .title = Използване на интервали вместо табулатор
options-sourceeditor-expandtab-label = Интервали за отстъп
options-sourceeditor-tabsize-label = Размер на табулатора
options-sourceeditor-keybinding-label = Клавишни комбинации
options-sourceeditor-keybinding-default-label = Стандартни

## Advanced section

# The heading
options-context-advanced-settings = Настройки за напреднали

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Изключване на буфера на HTTP (при отворена кутия с инструменти)
options-disable-http-cache-tooltip =
    .title = Когато е избрана тази отметка буферът на HTTP, за всички раздели с отворена кутия с инструменти, ще бъде изключен. Обслужващи нишки не се влияят от тази настройка.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Изключване на JavaScript *
options-disable-javascript-tooltip =
    .title = Включването на тази настройка ще изключи JavaScript в текущия раздел. Ако той или кутията с инструменти бъдат затворени, тази настройка ще бъде забравена.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Включване на кутията с инструменти за отстраняване на дефекти от хрома на четеца и добавките
options-enable-chrome-tooltip =
    .title = Отмятането на тази настройка ще ви позволи да използвате различни развойни инструменти в контекста на четеца (чрез Инструменти > Разработчик > Кутия с инструменти) и за отстраняване на дефекти на добавки от управлението на добавки

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Отдалечено дебъгване

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Включване на обслужващите нишки през HTTP (при отворена кутия с инструменти)
options-enable-service-workers-http-tooltip =
    .title = Отмятането на тази настройка ще включи обслужващите нишки през HTTP за всички раздели, които имат отворена кутия с инструменти.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Включване на Source Maps
options-source-maps-tooltip =
    .title = Ако е отметнато source maps ще бъдат използвани в инструментите.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Само за текущата сесия, презарежда страницата

##

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Показване на данните от платформата Gecko
options-show-platform-data-tooltip =
    .title = Ако е отметнато докладите на профилаторът на JavaScript ще включват символи от платформата Gecko
