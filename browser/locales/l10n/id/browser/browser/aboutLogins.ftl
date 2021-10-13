# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Info Masuk dan Kata Sandi

# "Google Play" and "App Store" are both branding and should not be translated

login-filter =
    .placeholder = Cari Info Masuk

create-login-button = Buat Info Masuk Baru

fxaccounts-sign-in-text = Dapatkan kata sandi Anda di perangkat lain
fxaccounts-sign-in-sync-button = Masuk untuk sinkronisasi
fxaccounts-avatar-button =
    .title = Kelola akun

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Buka menu
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Impor dari Peramban Lain…
about-logins-menu-menuitem-import-from-a-file = Impor dari Berkas…
about-logins-menu-menuitem-export-logins = Ekspor Info Masuk…
about-logins-menu-menuitem-remove-all-logins = Hapus Semua Log Masuk…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Pengaturan
       *[other] Pengaturan
    }
about-logins-menu-menuitem-help = Bantuan

## Login List

login-list =
    .aria-label = Info masuk yang cocok dengan permintaan pencarian
login-list-count =
    { $count ->
       *[other] { $count } info masuk
    }
login-list-sort-label-text = Urutkan berdasarkan:
login-list-name-option = Nama (A-Z)
login-list-name-reverse-option = Nama (Z-A)
about-logins-login-list-alerts-option = Peringatan
login-list-last-changed-option = Terakhir Diubah
login-list-last-used-option = Terakhir Digunakan
login-list-intro-title = Tidak ada info masuk ditemukan
login-list-intro-description = Ketika Anda menyimpan kata sandi di { -brand-product-name }, itu akan muncul di sini.
about-logins-login-list-empty-search-title = Tidak ada info masuk ditemukan
about-logins-login-list-empty-search-description = Tidak ada hasil pencarian yang cocok
login-list-item-title-new-login = Info Masuk Baru
login-list-item-subtitle-new-login = Masukkan kredensial info masuk Anda
login-list-item-subtitle-missing-username = (tidak ada nama pengguna)
about-logins-list-item-breach-icon =
    .title = Situs web yang dibobol
about-logins-list-item-vulnerable-password-icon =
    .title = Sandi rentan

## Introduction screen

about-logins-login-intro-heading-logged-out2 = Mencari info masuk Anda yang simpan? Aktifkan sinkronisasi atau mengimpornya.
about-logins-login-intro-heading-logged-in = Info masuk yang disinkronkan tidak ditemukan.
login-intro-description = Jika Anda menyimpan info masuk Anda di { -brand-product-name } pada perangkat lain, berikut cara mendapatkannya di sini:
login-intro-instructions-fxa = Buat atau masuk ke { -fxaccount-brand-name } Anda pada perangkat tempat info masuk Anda tersimpan
login-intro-instructions-fxa-settings = Buka Pengaturan > Sinkronisasi > Aktifkan sinkronisasi… Centang Info masuk dan sandi.
login-intro-instructions-fxa-help = Kunjungi <a data-l10n-name="help-link">Bantuan { -lockwise-brand-short-name }</a> untuk bantuan lebih lanjut.
about-logins-intro-import = Jika info masuk Anda tersimpan dalam peramban lain, Anda dapat <a data-l10n-name="import-link">mengimpor data tersebut ke { -lockwise-brand-short-name }</a>

about-logins-intro-import2 = Jika info masuk Anda tersimpan di luar { -brand-product-name }, Anda bisa <a data-l10n-name="import-browser-link">mengimpornya dari peramban lain</a> atau <a data-l10n-name="import-file-link">mengimpornya dari berkas</a>.

## Login

login-item-new-login-title = Buat Info Masuk Baru
login-item-edit-button = Edit
about-logins-login-item-remove-button = Hapus
login-item-origin-label = Alamat Situs Web
login-item-tooltip-message = Pastikan ini sesuai dengan alamat situs web tempat Anda masuk.
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Nama Pengguna
about-logins-login-item-username =
    .placeholder = (tidak ada nama pengguna)
login-item-copy-username-button-text = Salin
login-item-copied-username-button-text = Tersalin!
login-item-password-label = Sandi
login-item-password-reveal-checkbox =
    .aria-label = Tampilkan sandi
login-item-copy-password-button-text = Salin
login-item-copied-password-button-text = Tersalin!
login-item-save-changes-button = Simpan Perubahan
login-item-save-new-button = Simpan
login-item-cancel-button = Batal
login-item-time-changed = Terakhir diubah: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Dibuat: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Terakhir digunakan: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Waterfox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Untuk mengubah info masuk Anda, masukkan kredensial info masuk Windows Anda. Hal ini membantu melindungi keamanan akun Anda.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = mengedit info masuk tersimpan

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Untuk melihat kata sandi Anda, masukkan kredensial info masuk Windows Anda. Hal ini membantu melindungi keamanan akun Anda.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = mengungkapkan kata sandi tersimpan

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Untuk menyalin kata sandi Anda, masukkan kredensial info masuk Windows Anda. Hal ini membantu melindungi keamanan akun Anda.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = menyalin kata sandi tersimpan.

## Master Password notification

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Untuk mengekspor info masuk Anda, silakan masukkan kredensial info masuk Windows Anda. Ini akan membantu mengamankan akun Anda.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = mengekspor info masuk dan sandi tersimpan

## Primary Password notification

about-logins-primary-password-notification-message = Silakan masukkan Sandi Utama Anda untuk melihat info masuk dan kata sandi yang disimpan
master-password-reload-button =
    .label = Masuk
    .accesskey = M

## Password Sync notification

## Dialogs

confirmation-dialog-cancel-button = Batal
confirmation-dialog-dismiss-button =
    .title = Batal

about-logins-confirm-remove-dialog-title = Hapus info masuk ini?
confirm-delete-dialog-message = Tindakan ini tidak dapat diurungkan.
about-logins-confirm-remove-dialog-confirm-button = Hapus

about-logins-confirm-remove-all-dialog-confirm-button-label =
    { $count ->
        [1] Hapus
       *[other] Hapus Seluruhnya
    }

about-logins-confirm-remove-all-dialog-checkbox-label = Ya, hapus log masuk ini

about-logins-confirm-remove-all-dialog-title =
    { $count ->
       *[other] Hapus seluruh { $count } log masuk?
    }
about-logins-confirm-remove-all-dialog-message =
    { $count ->
        [1] Ini akan menghapus info masuk yang Anda simpan ke { -brand-short-name } dan semua peringatan pembobolan yang muncul di sini. Anda tidak akan dapat membatalkan tindakan ini.
       *[other] Ini akan menghapus info masuk yang Anda simpan ke { -brand-short-name } dan semua peringatan pembobolan yang muncul di sini. Anda tidak akan dapat membatalkan tindakan ini.
    }

about-logins-confirm-remove-all-sync-dialog-title =
    { $count ->
       *[other] Hapus { $count } info masuk dari semua perangkat?
    }
about-logins-confirm-remove-all-sync-dialog-message =
    { $count ->
        [1] Ini akan menghapus info masuk yang Anda simpan ke { -brand-short-name } di semua perangkat yang disinkronkan ke { -fxaccount-brand-name } Anda. Ini juga akan menghapus peringatan pembobolan yang muncul di sini. Anda tidak akan dapat mengurungkan tindakan ini.
       *[other] Ini akan menghapus info masuk yang Anda simpan ke { -brand-short-name } di semua perangkat yang disinkronkan ke { -fxaccount-brand-name } Anda. Ini juga akan menghapus peringatan pembobolan yang muncul di sini. Anda tidak akan dapat mengurungkan tindakan ini.
    }

about-logins-confirm-export-dialog-title = Ekspor info masuk dan sandi
about-logins-confirm-export-dialog-message = Kata sandi Anda akan disimpan sebagai teks biasa yang bisa dibaca (contoh: P@sw0rd) sehingga siapa pun yang dapat membuka berkas yang Anda ekspor akan bisa membacanya.
about-logins-confirm-export-dialog-confirm-button = Ekspor…

about-logins-alert-import-title = Proses Impor Selesai
about-logins-alert-import-message = Lihat ringkasan Detail Impor

confirm-discard-changes-dialog-title = Buang perubahan yang belum disimpan?
confirm-discard-changes-dialog-message = Semua perubahan yang belum disimpan akan hilang.
confirm-discard-changes-dialog-confirm-button = Hapus Perubahan

## Breach Alert notification

about-logins-breach-alert-title = Pembobolan Situs Web
breach-alert-text = Kata sandi telah bocor atau dicuri dari situs Web ini sejak terakhir Anda memperbarui rincian info masuk Anda. Ubah kata sandi Anda untuk melindungi akun Anda.
about-logins-breach-alert-date = Pembobolan ini terjadi pada { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Buka { $hostname }
about-logins-breach-alert-learn-more-link = Pelajari lebih lanjut

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Kata Sandi Rentan
about-logins-vulnerable-alert-text2 = Kata sandi ini telah digunakan pada akun lain yang kemungkinan besar telah diketahui dalam peristiwa pembobolan data. Penggunaan ulang kredensial akan membahayakan semua akun anda. Ubah kata sandi ini.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Buka { $hostname }
about-logins-vulnerable-alert-learn-more-link = Pelajari lebih lanjut

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Entri info masuk { $loginTitle } dengan nama pengguna itu sudah tersimpan. <a data-l10n-name="duplicate-link">Buka entri yang tersimpan?</a>

# This is a generic error message.
about-logins-error-message-default = Terjadi kesalahan saat mencoba menyimpan kata sandi ini.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Ekspor Berkas Info Masuk
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Ekspor
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Dokumen CSV
       *[other] Berkas CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Impor Berkas Info Masuk
about-logins-import-file-picker-import-button = Impor
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Dokumen CSV
       *[other] Berkas CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
about-logins-import-file-picker-tsv-filter-title =
    { PLATFORM() ->
        [macos] Berkas TSV
       *[other] Berkas TSV
    }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-dialog-title = Proses Impor Selesai
about-logins-import-dialog-items-added =
    { $count ->
       *[other] <span>Info masuk baru ditambahkan:</span> <span data-l10n-name="count">{ $count }</span>
    }

about-logins-import-dialog-items-modified =
    { $count ->
       *[other] <span>Info masuk yang ada diperbarui:</span> <span data-l10n-name="count">{ $count }</span>
    }

about-logins-import-dialog-items-no-change =
    { $count ->
       *[other] <span>Info masuk ganda ditemukan:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(tidak diimpor)</span>
    }
about-logins-import-dialog-items-error =
    { $count ->
       *[other] <span>Kesalahan:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(tidak diimpor)</span>
    }
about-logins-import-dialog-done = Selesai

about-logins-import-dialog-error-title = Kesalahan Impor
about-logins-import-dialog-error-conflicting-values-title = Nilai-Nilai yang Tidak Sama untuk Sebuah Info Masuk
about-logins-import-dialog-error-conflicting-values-description = Misalnya: ada beberapa nama pengguna, kata sandi, URL, dll. untuk sebuah info masuk.
about-logins-import-dialog-error-file-format-title = Masalah Format File
about-logins-import-dialog-error-file-format-description = Tajuk kolom salah atau hilang. Pastikan berkas tersebut menyertakan kolom nama pengguna, kata sandi, dan URL.
about-logins-import-dialog-error-file-permission-title = Tidak Dapat Membaca Berkas
about-logins-import-dialog-error-file-permission-description = { -brand-short-name } tidak memiliki izin untuk membaca berkas. Coba ubah izin berkas.
about-logins-import-dialog-error-unable-to-read-title = Tidak Dapat Mengurai Berkas
about-logins-import-dialog-error-unable-to-read-description = Pastikan Anda memilih file CSV atau TSV.
about-logins-import-dialog-error-no-logins-imported = Tidak ada info masuk yang diimpor
about-logins-import-dialog-error-learn-more = Pelajari lebih lanjut
about-logins-import-dialog-error-try-import-again = Coba Impor Lagi…
about-logins-import-dialog-error-cancel = Batalkan

about-logins-import-report-title = Ringkasan Impor
about-logins-import-report-description = Info masuk dan kata sandi yang diimpor ke { -brand-short-name }.

#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = Baris { $number }
about-logins-import-report-row-description-no-change = Duplikat: Persis sama dengan info masuk yang ada
about-logins-import-report-row-description-modified = Info masuk yang sudah ada yang diperbarui
about-logins-import-report-row-description-added = Info masuk baru yang ditambahkan
about-logins-import-report-row-description-error = Kesalahan: Bidang tidak ada

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = Kesalahan: Beberapa nilai untuk { $field }
about-logins-import-report-row-description-error-missing-field = Kesalahan: { $field } tidak ada

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-report-added =
    { $count ->
       *[other] <div data-l10n-name = "count">{ $count }</div> <div data-l10n-name = "details">Info masuk baru yang ditambahkan</div>
    }
about-logins-import-report-modified =
    { $count ->
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Info masuk yang sudah ada yang diperbarui</div>
    }
about-logins-import-report-no-change =
    { $count ->
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Info masuk duplikat</div> <div data-l10n-name="not-imported">(tidak diimpor)</div>
    }
about-logins-import-report-error =
    { $count ->
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Kesalahan</div> <div data-l10n-name="not-imported">(tidak diimpor)</div>
    }

## Logins import report page

about-logins-import-report-page-title = Laporan Ringkasan Impor
