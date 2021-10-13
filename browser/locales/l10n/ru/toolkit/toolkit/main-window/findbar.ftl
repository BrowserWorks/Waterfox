# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Найти следующее вхождение фразы в текст
findbar-previous =
    .tooltiptext = Найти предыдущее вхождение фразы в текст

findbar-find-button-close =
    .tooltiptext = Закрыть панель поиска

findbar-highlight-all2 =
    .label = Подсветить все
    .accesskey =
        { PLATFORM() ->
            [macos] в
           *[other] в
        }
    .tooltiptext = Подсветить все вхождения фразы в текст

findbar-case-sensitive =
    .label = С учётом регистра
    .accesskey = е
    .tooltiptext = Поиск с учётом регистра

findbar-match-diacritics =
    .label = С учётом диакритических знаков
    .accesskey = к
    .tooltiptext = Искать с учётом различия между букв с акцентом и их базовых букв (например, при поиске «resume», «résumé» найдено не будет)

findbar-entire-word =
    .label = Только слова целиком
    .accesskey = о
    .tooltiptext = Поиск только целых слов
