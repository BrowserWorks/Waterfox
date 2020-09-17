# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Друк
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Зберегти як
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } аркуш паперу
        [few] { $sheetCount } аркуші паперу
       *[many] { $sheetCount } аркушів паперу
    }
printui-page-range-all = Всі
printui-page-range-custom = Вибірково
printui-page-range-label = Сторінки
printui-page-range-picker =
    .aria-label = Вибір діапазону сторінок
printui-page-custom-range =
    .aria-label = Введіть власний діапазон сторінок
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = З
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = по
# Section title for the number of copies to print
printui-copies-label = Копії
printui-orientation = Орієнтація
printui-landscape = Альбомна
printui-portrait = Книжкова
# Section title for the printer or destination device to target
printui-destination-label = Пристрій
printui-destination-pdf-label = Зберегти до PDF
printui-more-settings = Ще налаштування
printui-less-settings = Згорнути налаштування
printui-paper-size-label = Розмір паперу
# Section title (noun) for the print scaling options
printui-scale = Масштаб
printui-scale-fit-to-page = Припасувати до сторінки
printui-scale-fit-to-page-width = Заповнити по ширині аркуша
# Label for input control where user can set the scale percentage
printui-scale-pcent = Масштаб
# Section title for miscellaneous print options
printui-options = Параметри
printui-headers-footers-checkbox = Друкувати колонтитули
printui-backgrounds-checkbox = Друкувати тло
printui-color-mode-label = Кольоровий режим
printui-color-mode-color = Кольоровий
printui-color-mode-bw = Чорно-білий
printui-margins = Поля
printui-margins-default = Типово
printui-margins-min = Якнайменше
printui-margins-none = Немає
printui-system-dialog-link = Друк за допомогою засобу системи…
printui-primary-button = Надрукувати
printui-primary-button-save = Зберегти
printui-cancel-button = Скасувати
printui-loading = Підготовка до попереднього перегляду
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Попередній перегляд

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

printui-error-invalid-scale = Масштаб повинен бути числом від 10 до 200.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Діапазон повинен бути числом від 1 до { $numPages }.
printui-error-invalid-start-overflow = Номер сторінки “від” повинен бути меншим, ніж номер сторінки “до”.
