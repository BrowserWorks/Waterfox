# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Cetak
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Simpan sebagai
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
       *[other] { $sheetCount } lembar kertas
    }
printui-page-range-all = Semua
printui-page-range-custom = Ubahsuai
printui-page-range-label = Halaman
printui-page-range-picker =
    .aria-label = Pilih rentang halaman
printui-page-custom-range =
    .aria-label = Masukkan rentang halaman khusus
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = Dari
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = ke
# Section title for the number of copies to print
printui-copies-label = Salinan
printui-orientation = Orientasi
printui-landscape = Mendatar
printui-portrait = Tegak
# Section title for the printer or destination device to target
printui-destination-label = Tujuan
printui-destination-pdf-label = Simpan ke PDF
printui-more-settings = Pengaturan lainnya
printui-less-settings = Beberapa pengaturan
printui-paper-size-label = Ukuran kertas:
# Section title (noun) for the print scaling options
printui-scale = Skala
printui-scale-fit-to-page = Sesuaikan ke halaman
printui-scale-fit-to-page-width = Sesuaikan dengan lebar halaman
# Label for input control where user can set the scale percentage
printui-scale-pcent = Skala
# Section title for miscellaneous print options
printui-options = Opsi
printui-headers-footers-checkbox = Cetak kepala dan kaki
printui-backgrounds-checkbox = Cetak latar
printui-color-mode-label = Mode warna
printui-color-mode-color = Warna
printui-color-mode-bw = Hitam putih
printui-margins = Margin
printui-margins-default = Baku
printui-margins-min = Minimum
printui-margins-none = Tidak ada
printui-system-dialog-link = Cetak menggunakan dialog sistem…
printui-primary-button = Cetak
printui-primary-button-save = Simpan
printui-cancel-button = Batal
printui-loading = Mempersiapkan Pratinjau
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Pratinjau Cetak

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

printui-error-invalid-scale = Skala harus berupa angka antara 10 dan 200
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Rentang harus berupa angka antara 1 dan { $numPages }
printui-error-invalid-start-overflow = Nomor halaman "dari" harus lebih kecil daripada nomor halaman "ke".
