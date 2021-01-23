# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Друк
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Захаваць як
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } аркуш паперы
        [few] { $sheetCount } аркушы паперы
       *[many] { $sheetCount } аркушаў паперы
    }
printui-page-range-all = Усе
printui-page-range-custom = Адмыслова
printui-page-range-label = Старонкі
printui-page-range-picker =
    .aria-label = Выбраць абсяг старонак
printui-page-custom-range =
    .aria-label = Увядзіце уласны дыяпазон старонак
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = Ад
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = да
# Section title for the number of copies to print
printui-copies-label = Копіі
printui-orientation = Арыентацыя
printui-landscape = Альбомная
printui-portrait = Кніжная
# Section title for the printer or destination device to target
printui-destination-label = Прызначэнне
printui-destination-pdf-label = Захаваць у PDF
printui-more-settings = Больш налад
printui-less-settings = Менш налад
printui-paper-size-label = Памер паперы
# Section title (noun) for the print scaling options
printui-scale = Маштаб
printui-scale-fit-to-page = Дапасаваць да старонкі
printui-scale-fit-to-page-width = Да шырыні старонкі
# Label for input control where user can set the scale percentage
printui-scale-pcent = Маштаб
# Section title for miscellaneous print options
printui-options = Налады
printui-headers-footers-checkbox = Друкаваць загалоўкі і калантытулы
printui-backgrounds-checkbox = Друкаваць фон
printui-color-mode-label = Каляровы рэжым
printui-color-mode-color = Каляровы
printui-color-mode-bw = Чорна-белы
printui-margins = Палі
printui-margins-default = Прадвызначана
printui-margins-min = Мінімум
printui-margins-none = Няма
printui-system-dialog-link = Друк з дапамогай сістэмнага дыялогу…
printui-primary-button = Друкаваць
printui-primary-button-save = Захаваць
printui-cancel-button = Адмена
printui-loading = Рыхтуецца папярэдні прагляд
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Перадпрагляд друку

## Paper sizes that may be supported by the Save to PDF destination:

printui-paper-a5 = A5
printui-paper-a4 = A4
printui-paper-a3 = A3
printui-paper-a2 = A2
printui-paper-a1 = A1
printui-paper-a0 = A0
printui-paper-b5 = B5
printui-paper-b4 = B4
printui-paper-jis-b5 = JIS-B5
printui-paper-jis-b4 = JIS-B4
printui-paper-letter = US Letter
printui-paper-legal = US Legal
printui-paper-tabloid = Tabloid

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = Маштаб павінен быць лічбай ад 10 да 200.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Дыяпазон павінен быць лічбай ад 1 да { $numPages }.
printui-error-invalid-start-overflow = Нумар старонкі "ад" павінен быць меншым, чым нумар старонкі "да".
