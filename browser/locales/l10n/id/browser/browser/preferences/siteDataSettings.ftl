# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Kelola Kuki dan Data Situs

site-data-settings-description = Situs web ini menyimpan kuki dan data situs pada komputer Anda. { -brand-short-name } menyimpan data dari situs web dengan penyimpanan tetap hingga Anda menghapusnya sendiri, dan menghapus data dari situs web dengan penyimpanan tidak tetap ketika memerlukan ruang penyimpanan lebih.

site-data-search-textbox =
    .placeholder = Cari situs web
    .accesskey = C

site-data-column-host =
    .label = Situs
site-data-column-cookies =
    .label = Kuki
site-data-column-storage =
    .label = Penyimpanan
site-data-column-last-used =
    .label = Terakhir Digunakan

# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (berkas lokal)

site-data-remove-selected =
    .label = Hapus yang Dipilih
    .accesskey = H

site-data-settings-dialog =
    .buttonlabelaccept = Simpan Perubahan
    .buttonaccesskeyaccept = a

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (Persisten)

site-data-remove-all =
    .label = Hapus Seluruhnya
    .accesskey = u

site-data-remove-shown =
    .label = Hapus Semua Yang Muncul
    .accesskey = u

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Buang

site-data-removing-header = Menghapus Kuki dan Data Situs

site-data-removing-desc = Menghapus kuki dan data situs mungkin mengeluarkan Anda dari situs web. Yakin ingin melakukannya?

site-data-removing-table = Kuki dan data situs untuk situs web berikut ini akan dihapus
