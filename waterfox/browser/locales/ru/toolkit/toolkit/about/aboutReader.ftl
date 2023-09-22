# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-reader-loading = Загрузка…
about-reader-load-error = Не удалось загрузить статью со страницы

about-reader-color-scheme-light = Светлая
    .title = Цветовая схема «Светлая»
about-reader-color-scheme-dark = Тёмная
    .title = Цветовая схема «Тёмная»
about-reader-color-scheme-sepia = Сепия
    .title = Цветовая схема «Сепия»
about-reader-color-scheme-auto = Авто
    .title = Цветовая схема «Авто»

# An estimate for how long it takes to read an article,
# expressed as a range covering both slow and fast readers.
# Variables:
#   $rangePlural (String): The plural category of the range, using the same set as for numbers.
#   $range (String): The range of minutes as a localised string. Examples: "3-7", "~1".
about-reader-estimated-read-time =
    { $rangePlural ->
        [one] { $range } минута
        [few] { $range } минуты
       *[many] { $range } минут
    }

## These are used as tooltips in Type Control

about-reader-toolbar-minus =
    .title = Уменьшить размер шрифта
about-reader-toolbar-plus =
    .title = Увеличить размер шрифта
about-reader-toolbar-contentwidthminus =
    .title = Уменьшить ширину содержимого
about-reader-toolbar-contentwidthplus =
    .title = Увеличить ширину содержимого
about-reader-toolbar-lineheightminus =
    .title = Уменьшить междустрочный интервал
about-reader-toolbar-lineheightplus =
    .title = Увеличить междустрочный интервал

## These are the styles of typeface that are options in the reader view controls.

about-reader-font-type-serif = С засечками
about-reader-font-type-sans-serif = Без засечек

## Reader View toolbar buttons

about-reader-toolbar-close = Закрыть режим чтения
about-reader-toolbar-type-controls = Настройка шрифтов
about-reader-toolbar-savetopocket = Сохранить в { -pocket-brand-name }
