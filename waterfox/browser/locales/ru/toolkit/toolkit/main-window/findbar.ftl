# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Найти следующее вхождение фразы в текст
findbar-previous =
    .tooltiptext = Найти предыдущее вхождение фразы в текст

findbar-find-button-close =
    .tooltiptext = Закрыть строку поиска

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

findbar-not-found = Фраза не найдена

findbar-wrapped-to-top = Достигнут низ страницы, продолжено сверху
findbar-wrapped-to-bottom = Достигнут верх страницы, продолжено снизу

findbar-normal-find =
    .placeholder = Найти на странице
findbar-fast-find =
    .placeholder = Быстрый поиск
findbar-fast-find-links =
    .placeholder = Быстрый поиск (только ссылки)

findbar-case-sensitive-status =
    .value = (С учётом регистра)
findbar-match-diacritics-status =
    .value = (С учётом диакритических знаков)
findbar-entire-word-status =
    .value = (Только слова целиком)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value =
        { $total ->
            [one] { $current }-е из { $total } совпадения
            [few] { $current }-е из { $total } совпадений
           *[many] { $current }-е из { $total } совпадений
        }

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value =
        { $limit ->
            [one] Более { $limit } совпадения
            [few] Более { $limit } совпадений
           *[many] Более { $limit } совпадений
        }
