# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Будьте осторожны, а то лишитесь гарантии!
config-about-warning-text = Изменение этих настроек может привести к ухудшению стабильности, безопасности и производительности данного приложения. Вам следует изменять что-либо только в том случае, если вы уверены в том, что делаете.
config-about-warning-button =
    .label = Я принимаю на себя риск!
config-about-warning-checkbox =
    .label = Показывать это предупреждение в следующий раз

config-search-prefs =
    .value = Поиск:
    .accesskey = о

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Имя настройки
config-lock-column =
    .label = Состояние
config-type-column =
    .label = Тип
config-value-column =
    .label = Значение

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Нажмите для сортировки
config-column-chooser =
    .tooltip = Нажмите, чтобы выбрать колонки для отображения

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Копировать
    .accesskey = п

config-copy-name =
    .label = Копировать имя
    .accesskey = и

config-copy-value =
    .label = Копировать значение
    .accesskey = в

config-modify =
    .label = Изменить
    .accesskey = з

config-toggle =
    .label = Переключить
    .accesskey = л

config-reset =
    .label = Сбросить
    .accesskey = б

config-new =
    .label = Создать
    .accesskey = а

config-string =
    .label = Строка
    .accesskey = к

config-integer =
    .label = Целое
    .accesskey = е

config-boolean =
    .label = Логическое
    .accesskey = ч

config-default = по умолчанию
config-modified = изменено
config-locked = заблокировано

config-property-string = строка
config-property-int = целое
config-property-bool = логическое

config-new-prompt = Введите имя настройки

config-nan-title = Недействительное значение
config-nan-text = Введённый вами текст не является числом.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Новое значение ({ $type })

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Введите значение ({ $type })
