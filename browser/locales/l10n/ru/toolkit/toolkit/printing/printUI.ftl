# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Печать
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Сохранить как
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } лист бумаги
        [few] { $sheetCount } листа бумаги
       *[many] { $sheetCount } листов бумаги
    }
printui-page-range-all = Все
printui-page-range-custom = Диапазон
printui-page-range-label = Страницы
printui-page-range-picker =
    .aria-label = Выберите диапазон страниц
printui-page-custom-range =
    .aria-label = Введите свой диапазон страниц
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = С
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = по
# Section title for the number of copies to print
printui-copies-label = Число копий
printui-orientation = Ориентация
printui-landscape = Альбомная
printui-portrait = Книжная
# Section title for the printer or destination device to target
printui-destination-label = Получатель
printui-destination-pdf-label = Сохранить в PDF
printui-more-settings = Все настройки
printui-less-settings = Основные настройки
printui-paper-size-label = Размер бумаги
# Section title (noun) for the print scaling options
printui-scale = Масштаб
printui-scale-fit-to-page = По размеру страницы
printui-scale-fit-to-page-width = По ширине страницы
# Label for input control where user can set the scale percentage
printui-scale-pcent = Масштаб
# Section title for miscellaneous print options
printui-options = Настройки
printui-headers-footers-checkbox = Печатать колонтитулы
printui-backgrounds-checkbox = Печатать фон
printui-color-mode-label = Цветовой режим
printui-color-mode-color = Цветной
printui-color-mode-bw = Чёрно-белый
printui-margins = Поля
printui-margins-default = По умолчанию
printui-margins-min = Минимальные
printui-margins-none = Нет
printui-system-dialog-link = Печатать, используя системный диалог…
printui-primary-button = Печать
printui-primary-button-save = Сохранить
printui-cancel-button = Отмена
printui-loading = Подготовка к предпросмотру
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Предварительный просмотр

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

printui-error-invalid-scale = Масштаб должен быть числом от 10 до 200.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Диапазон должен быть числом от 1 до { $numPages }.
printui-error-invalid-start-overflow = Номер страницы «С» должен быть меньше, чем номер страницы «по».
