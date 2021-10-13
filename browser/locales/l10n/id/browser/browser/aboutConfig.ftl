# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Lanjutkan dengan Kehati-hatian
about-config-intro-warning-text = Mengubah pilihan konfigurasi tingkat lanjut dapat mempengaruhi kinerja atau keamanan { -brand-short-name } .
about-config-intro-warning-checkbox = Peringatkan saya ketika mencoba untuk mengakses preferensi ini.
about-config-intro-warning-button = Terima Risiko dan Lanjutkan

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Mengubah pilihan ini dapat mempengaruhi kinerja atau keamanan { -brand-short-name } .

about-config-page-title = Preferensi Tingkat Lanjut

about-config-search-input1 =
    .placeholder = Cari nama preferensi
about-config-show-all = Tampilkan Semua

about-config-pref-add-button =
    .title = Tambah
about-config-pref-toggle-button =
    .title = Aktifkan/Nonaktifkan
about-config-pref-edit-button =
    .title = Edit
about-config-pref-save-button =
    .title = Simpan
about-config-pref-reset-button =
    .title = Setel ulang
about-config-pref-delete-button =
    .title = Hapus

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boolean
about-config-pref-add-type-number = Angka
about-config-pref-add-type-string = String

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (bawaan)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (khusus)
