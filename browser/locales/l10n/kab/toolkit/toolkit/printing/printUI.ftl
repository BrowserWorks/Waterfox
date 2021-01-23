# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Siggez
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Sekles s yisem
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } taferkit n lkaɣeḍ
       *[other] { $sheetCount } tiferka n lkaɣeḍ
    }
printui-page-range-all = Meṛṛa
printui-page-range-custom = Udmawan
printui-page-range-label = Isebtar
printui-page-range-picker =
    .aria-label = Fren azilal n yisebtar
printui-page-custom-range =
    .aria-label = Skcem ailal udmawan n yisebtar
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = Seg
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = Ɣer
# Section title for the number of copies to print
printui-copies-label = Anɣalen
printui-orientation = Taɣda
printui-landscape = S tehri
printui-portrait = S teɣzi
# Section title for the printer or destination device to target
printui-destination-label = Aserken
printui-destination-pdf-label = Sekles d PDF
printui-more-settings = Ugar n yiɣewwaren
printui-less-settings = Drus n yiɣewwaren
printui-paper-size-label = Teɣzi n usebter
# Section title (noun) for the print scaling options
printui-scale = Sellum
printui-scale-fit-to-page = Ṣeggem asebter
printui-scale-fit-to-page-width = Ṣeggem almend n tehri n tferkit
# Label for input control where user can set the scale percentage
printui-scale-pcent = Sellum
# Section title for miscellaneous print options
printui-options = Iɣewwaren
printui-headers-footers-checkbox = Siggez iqerra d yiḍarren n usebter
printui-backgrounds-checkbox = Siggez agilal
printui-color-mode-label = Askar n yiniten
printui-color-mode-color = Initen
printui-color-mode-bw = Aberkan d ucebḥan
printui-margins = Timiwa
printui-margins-default = Amezwer
printui-margins-min = Adday
printui-margins-none = Ulac
printui-system-dialog-link = Siggez s useqdec n udiwenni anagraw…
printui-primary-button = Siggez
printui-primary-button-save = Sekles
printui-cancel-button = Sefsex
printui-loading = Aheyyi n teskant
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Taskant send asiggez

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
printui-paper-letter = Tabrat US
printui-paper-legal = Azerfan US
printui-paper-tabloid = Tabloid

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = Sellum ilaq ad yili d amḍan gar 10 d 200.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Azilal yessefk ad yili d amḍan gar 1 d { $numPages }.
printui-error-invalid-start-overflow = Uṭṭun n usebter “seg” yessefk ad yili meẓẓiy ɣef wuṭṭun n usebter “ɣer”.
