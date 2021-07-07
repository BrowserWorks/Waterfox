# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Выбранный элемент
compatibility-all-elements-header = Все проблемы

## Message used as labels for the type of issue

compatibility-issue-deprecated = (устарело)
compatibility-issue-experimental = (эксперимент)
compatibility-issue-prefixneeded = (нужен префикс)
compatibility-issue-deprecated-experimental = (устарело, эксперимент)

compatibility-issue-deprecated-prefixneeded = (устарело, нужен префикс)
compatibility-issue-experimental-prefixneeded = (эксперимент, нужен префикс)
compatibility-issue-deprecated-experimental-prefixneeded = (устарело, эксперимент, нужен префикс)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Настройки
compatibility-settings-button-title =
    .title = Настройки
compatibility-feedback-button-label = Обратная связь
compatibility-feedback-button-title =
    .title = Обратная связь

## Messages used as headers in settings pane

compatibility-settings-header = Настройки
compatibility-target-browsers-header = Целевые браузеры

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } проблема
        [few] { $number } проблемы
       *[many] { $number } проблем
    }

compatibility-no-issues-found = Проблем с совместимостью не найдено.
compatibility-close-settings-button =
    .title = Закрыть настройки
