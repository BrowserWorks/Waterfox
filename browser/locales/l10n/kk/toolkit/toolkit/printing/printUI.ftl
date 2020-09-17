# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Баспаға шығару
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Қалайша сақтау
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
       *[other] { $sheetCount } қағаз парағы
    }
printui-page-range-all = Барлығы
printui-page-range-custom = Таңдауыңызша
printui-page-range-label = Парақтар
printui-page-range-picker =
    .aria-label = Парақтар ауқымын таңдау
printui-page-custom-range =
    .aria-label = Таңдауыңызша парақтар ауқымын енгізу
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = Бастап
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = дейін
# Section title for the number of copies to print
printui-copies-label = Көшірмелер
printui-orientation = Бағыт
printui-landscape = Жатық
printui-portrait = Тік
# Section title for the printer or destination device to target
printui-destination-label = Мақсаты
printui-destination-pdf-label = PDF ретінде сақтау
printui-more-settings = Көбірек баптаулар
printui-less-settings = Азырақ баптаулар
printui-paper-size-label = Қағаз өлшемі
# Section title (noun) for the print scaling options
printui-scale = Масштаб
printui-scale-fit-to-page = Бетке сыйдыру
printui-scale-fit-to-page-width = Парақтың енімен
# Label for input control where user can set the scale percentage
printui-scale-pcent = Масштаб
# Section title for miscellaneous print options
printui-options = Опциялар
printui-headers-footers-checkbox = Үстіңгі және астыңғы тақырыптамаларды баспаға шығару
printui-backgrounds-checkbox = Фондарды баспаға шығару
printui-color-mode-label = Түс режимі
printui-color-mode-color = Түс
printui-color-mode-bw = Қара және ақ
printui-margins = Шеттер
printui-margins-default = Бастапқы
printui-margins-min = Минималды
printui-margins-none = Жоқ
printui-system-dialog-link = Жүйелік сұхбатын қолданып, баспаға шығару…
printui-primary-button = Баспаға шығару
printui-primary-button-save = Сақтау
printui-cancel-button = Бас тарту
printui-loading = Алдын ала қарауды дайындау
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Алдын-ала қарау

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

printui-error-invalid-scale = Масштаб 10 мен 200 арасындағы сан болуы керек.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Ауқым 1 мен { $numPages } арасындағы сан болуы керек.
printui-error-invalid-start-overflow = "Бастап" бет нөмірі "дейін" бет нөмірінен кіші болуы тиіс.
