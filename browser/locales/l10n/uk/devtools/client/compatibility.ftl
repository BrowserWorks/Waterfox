# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Вибраний елемент
compatibility-all-elements-header = Всі проблеми

## Message used as labels for the type of issue

compatibility-issue-deprecated = (застаріле)
compatibility-issue-experimental = (експериментальне)
compatibility-issue-prefixneeded = (потрібен префікс)
compatibility-issue-deprecated-experimental = (застаріле, експериментальне)

compatibility-issue-deprecated-prefixneeded = (застаріле, потрібен префікс)
compatibility-issue-experimental-prefixneeded = (експериментальне, потрібен префікс)
compatibility-issue-deprecated-experimental-prefixneeded = (застаріле, експериментальне, потрібен префікс)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Налаштування
compatibility-settings-button-title =
    .title = Налаштування
compatibility-feedback-button-label = Зворотній зв'язок
compatibility-feedback-button-title =
    .title = Зворотній зв'язок

## Messages used as headers in settings pane

compatibility-settings-header = Налаштування
compatibility-target-browsers-header = Цільові браузери

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } випадок
        [few] { $number } випадки
       *[many] { $number } випадків
    }

compatibility-no-issues-found = Не знайдено проблем із сумісністю.
compatibility-close-settings-button =
    .title = Закрити налаштування
