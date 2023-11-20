# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

styleeditor-new-button =
    .tooltiptext = Создание и добавление к документу новой таблицы стилей
    .accesskey = о
styleeditor-import-button =
    .tooltiptext = Импорт и добавление к документу существующей таблицы стилей
    .accesskey = м
styleeditor-filter-input =
    .placeholder = Фильтр таблиц стилей
styleeditor-visibility-toggle =
    .tooltiptext = Включить/выключить видимость таблицы стилей
    .accesskey = х
styleeditor-visibility-toggle-system =
    .tooltiptext = Системные таблицы стилей не могут быть отключены
styleeditor-save-button = Сохранить
    .tooltiptext = Сохранить эту таблицу стилей в файл
    .accesskey = х
styleeditor-options-button =
    .tooltiptext = Настройки Редактора Стилей
styleeditor-at-rules = At-правила
styleeditor-editor-textbox =
    .data-placeholder = Набирайте CSS здесь.
styleeditor-no-stylesheet = У этой страницы нет таблицы стилей.
styleeditor-no-stylesheet-tip = Возможно вы хотите <a data-l10n-name="append-new-stylesheet">добавить новую таблицу стилей</a>?
styleeditor-open-link-new-tab =
    .label = Открыть ссылку в новой вкладке
styleeditor-copy-url =
    .label = Скопировать URL
styleeditor-find =
    .label = Найти
    .accesskey = а
styleeditor-find-again =
    .label = Найти следующее
    .accesskey = й
styleeditor-go-to-line =
    .label = Перейти к строке…
    .accesskey = е
# Label displayed when searching a term that is not found in any stylesheet path
styleeditor-stylesheet-all-filtered = Подходящая таблица стилей не найдена.

# This string is shown in the style sheets list
# Variables:
#   $ruleCount (Integer) - The number of rules in the stylesheet.
styleeditor-stylesheet-rule-count =
    { $ruleCount ->
        [one] { $ruleCount } правило
        [few] { $ruleCount } правила
       *[many] { $ruleCount } правил
    }
