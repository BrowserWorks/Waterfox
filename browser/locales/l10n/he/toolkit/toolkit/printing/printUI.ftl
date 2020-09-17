# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = הדפסה
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = שמירה בשם
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] גיליון אחד של נייר
       *[other] { $sheetCount } גיליונות נייר
    }
printui-page-range-all = הכול
printui-page-range-custom = התאמה אישית
printui-page-range-label = עמודים
printui-page-range-picker =
    .aria-label = בחירת טווח עמודים
printui-page-custom-range =
    .aria-label = נא להזין טווח עמודים מותאם אישית
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = מעמוד
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = עד עמוד
# Section title for the number of copies to print
printui-copies-label = עותקים
printui-orientation = כיוון
printui-landscape = לרוחב
printui-portrait = לאורך
# Section title for the printer or destination device to target
printui-destination-label = יעד
printui-destination-pdf-label = שמירה ל־PDF
printui-more-settings = עוד הגדרות
printui-less-settings = פחות הגדרות
printui-paper-size-label = גודל נייר
# Section title (noun) for the print scaling options
printui-scale = קנה מידה
printui-scale-fit-to-page = התאמה לעמוד
printui-scale-fit-to-page-width = התאמה לרוחב העמוד
# Label for input control where user can set the scale percentage
printui-scale-pcent = קנה מידה
# Section title for miscellaneous print options
printui-options = אפשרויות
printui-headers-footers-checkbox = הדפסת כותרות עיליות ותחתיות
printui-backgrounds-checkbox = הדפסת רקעים
printui-color-mode-label = מצב צבע
printui-color-mode-color = צבע
printui-color-mode-bw = שחור ולבן
printui-margins = שוליים
printui-margins-default = ברירת מחדל
printui-margins-min = מינימום
printui-margins-none = ללא
printui-system-dialog-link = הדפסה באמצעות תיבת הדו־שיח של המערכת…
printui-primary-button = הדפסה
printui-primary-button-save = שמירה
printui-cancel-button = ביטול
printui-loading = בתהליך הכנת תצוגה מקדימה
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = תצוגה לפני הדפסה

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

printui-error-invalid-scale = קנה המידה חייב להיות מספר בין 10 ל־200.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = הטווח חייב להיות מספר בין 1 ל־{ $numPages }.
printui-error-invalid-start-overflow = ערך השדה ״מעמוד״ חייב להיות קטן מערך השדה ״עד עמוד״.
