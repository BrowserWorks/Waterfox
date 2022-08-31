# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printpreview-simplify-page-checkbox =
    .label = Упростить страницу
    .accesskey = п
    .tooltiptext = Эта страница не может быть автоматически упрощена
printpreview-simplify-page-checkbox-enabled =
    .label = { printpreview-simplify-page-checkbox.label }
    .accesskey = { printpreview-simplify-page-checkbox.accesskey }
    .tooltiptext = Изменить макет для облегчения её чтения
printpreview-close =
    .label = Закрыть
    .accesskey = ы
printpreview-portrait =
    .label = Книжная
    .accesskey = н
printpreview-landscape =
    .label = Альбомная
    .accesskey = л
printpreview-scale =
    .value = Масштаб:
    .accesskey = ш
printpreview-shrink-to-fit =
    .label = Сжать по размеру
printpreview-custom =
    .label = Настроить…
printpreview-print =
    .label = Печать…
    .accesskey = е
printpreview-of =
    .value = из
printpreview-custom-scale-prompt-title = Настроить масштаб
printpreview-page-setup =
    .label = Параметры…
    .accesskey = а
printpreview-page =
    .value = Страница:
    .accesskey = и

# Variables
# $sheetNum (integer) - The current sheet number
# $sheetCount (integer) - The total number of sheets to print
printpreview-sheet-of-sheets = { $sheetNum } из { $sheetCount }

## Variables
## $percent (integer) - menuitem percent label
## $arrow (String) - UTF-8 arrow character for navigation buttons

printpreview-percentage-value =
    .label = { $percent }%
printpreview-homearrow =
    .label = { $arrow }
    .tooltiptext = Первая страница
printpreview-previousarrow =
    .label = { $arrow }
    .tooltiptext = Предыдущая страница
printpreview-nextarrow =
    .label = { $arrow }
    .tooltiptext = Следующая страница
printpreview-endarrow =
    .label = { $arrow }
    .tooltiptext = Последняя страница

printpreview-homearrow-button =
    .title = Первая страница
printpreview-previousarrow-button =
    .title = Предыдущая страница
printpreview-nextarrow-button =
    .title = Следующая страница
printpreview-endarrow-button =
    .title = Последняя страница
