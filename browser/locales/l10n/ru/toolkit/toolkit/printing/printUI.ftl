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
printui-page-custom-range-input =
    .aria-label = Введите свой диапазон страниц
    .placeholder = например, 2-6, 9, 12-16
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
printui-scale-fit-to-page-width = По ширине страницы
# Label for input control where user can set the scale percentage
printui-scale-pcent = Масштаб
# Section title (noun) for the two-sided print options
printui-two-sided-printing = Двусторонняя печать
printui-two-sided-printing-off = Отключена
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = Переплет по длинной стороне
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = Переплет по короткой стороне
# Section title for miscellaneous print options
printui-options = Настройки
printui-headers-footers-checkbox = Печатать колонтитулы
printui-backgrounds-checkbox = Печатать фон
printui-selection-checkbox = Печатать только выделенную область
printui-color-mode-label = Цветовой режим
printui-color-mode-color = Цветной
printui-color-mode-bw = Чёрно-белый
printui-margins = Поля
printui-margins-default = По умолчанию
printui-margins-min = Минимальные
printui-margins-none = Нет
printui-margins-custom-inches = Настраиваемые (дюймы)
printui-margins-custom-mm = Настраиваемые (мм)
printui-margins-custom-top = Верхнее
printui-margins-custom-top-inches = Верхнее (дюймы)
printui-margins-custom-top-mm = Верхнее (мм)
printui-margins-custom-bottom = Нижнее
printui-margins-custom-bottom-inches = Нижнее (дюймы)
printui-margins-custom-bottom-mm = Нижнее (мм)
printui-margins-custom-left = Левое
printui-margins-custom-left-inches = Левое (дюймы)
printui-margins-custom-left-mm = Левое (мм)
printui-margins-custom-right = Правое
printui-margins-custom-right-inches = Правое (дюймы)
printui-margins-custom-right-mm = Правое (мм)
printui-system-dialog-link = Печатать, используя системный диалог…
printui-primary-button = Печать
printui-primary-button-save = Сохранить
printui-cancel-button = Отмена
printui-close-button = Закрыть
printui-loading = Подготовка к предпросмотру
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Предварительный просмотр
printui-pages-per-sheet = Страниц на одном листе
# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = Печать…
printui-print-progress-indicator-saving = Сохранение…

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
printui-error-invalid-margin = Пожалуйста, введите допустимые значения полей для выбранного размера бумаги.
printui-error-invalid-copies = Число копий должно быть числом от 1 до 10000.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Диапазон должен содержать числа от 1 до { $numPages }.
printui-error-invalid-start-overflow = Номер страницы «С» должен быть меньше, чем номер страницы «по».
