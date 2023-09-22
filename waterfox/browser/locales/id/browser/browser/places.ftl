# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = Buka
    .accesskey = B
places-open-in-tab =
    .label = Buka di Tab Baru
    .accesskey = T
places-open-in-container-tab =
    .label = Buka di Tab Kontainer Baru
    .accesskey = i
places-open-all-bookmarks =
    .label = Buka Semua Markah
    .accesskey = M
places-open-all-in-tabs =
    .label = Buka Semua di Tab
    .accesskey = m
places-open-in-window =
    .label = Buka di Jendela Baru
    .accesskey = J
places-open-in-private-window =
    .label = Buka di Jendela Penjelajahan Pribadi Baru
    .accesskey = P

places-empty-bookmarks-folder =
    .label = (Kosong)

places-add-bookmark =
    .label = Tambah Markah…
    .accesskey = M
places-add-folder-contextmenu =
    .label = Tambahkan Folder…
    .accesskey = F
places-add-folder =
    .label = Tambahkan Folder…
    .accesskey = F
places-add-separator =
    .label = Tambahkan Pemisah
    .accesskey = s

places-view =
    .label = Tampilkan
    .accesskey = l
places-by-date =
    .label = Berdasarkan Tanggal
    .accesskey = T
places-by-site =
    .label = Berdasarkan Situs
    .accesskey = S
places-by-most-visited =
    .label = Berdasarkan Jumlah Kunjungan
    .accesskey = J
places-by-last-visited =
    .label = Berdasarkan Kunjungan Terakhir
    .accesskey = K
places-by-day-and-site =
    .label = Berdasarkan Tanggal dan Situs
    .accesskey = d

places-history-search =
    .placeholder = Cari riwayat
places-history =
    .aria-label = Riwayat
places-bookmarks-search =
    .placeholder = Cari markah

places-delete-domain-data =
    .label = Lupakan Situs Ini
    .accesskey = L
places-sortby-name =
    .label = Urut Berdasar Nama
    .accesskey = r
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = Edit Markah…
    .accesskey = E
places-edit-generic =
    .label = Edit…
    .accesskey = E
places-edit-folder2 =
    .label = Edit Folder…
    .accesskey = i
places-delete-folder =
    .label =
        { $count ->
            [1] Hapus Folder
           *[other] Hapus Folder
        }
    .accesskey = H
# Variables:
#   $count (number) - The number of pages selected for removal.
places-delete-page =
    .label =
        { $count ->
            [1] Hapus Laman
           *[other] Hapus Laman
        }
    .accesskey = H

# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = Markah yang dikelola
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = Subfolder

# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = Markah Lain

places-show-in-folder =
    .label = Tampilkan di Folder
    .accesskey = F

# Variables:
# $count (number) - The number of elements being selected for removal.
places-delete-bookmark =
    .label =
        { $count ->
            [1] Hapus Markah
           *[other] Hapus Markah
        }
    .accesskey = H

# Variables:
#   $count (number) - The number of bookmarks being added.
places-create-bookmark =
    .label =
        { $count ->
            [1] Markahi Laman…
           *[other] Markahi Banyak Laman…
        }
    .accesskey = M

places-untag-bookmark =
    .label = Hapus tag
    .accesskey = H

places-manage-bookmarks =
    .label = Kelola Markah
    .accesskey = K

places-forget-about-this-site-confirmation-title = Lupakan situs ini

# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-msg = Tindakan ini akan menghapus data yang terkait dengan { $hostOrBaseDomain } termasuk riwayat, kuki, tembolok, dan preferensi konten. Sandi dan markah terkait tidak akan dihapus. Yakin ingin melanjutkan?

places-forget-about-this-site-forget = Lupakan

places-library3 =
    .title = Pustaka

places-organize-button =
    .label = Kelola
    .tooltiptext = Kelola markah Anda
    .accesskey = K

places-organize-button-mac =
    .label = Kelola
    .tooltiptext = Kelola markah Anda

places-file-close =
    .label = Tutup
    .accesskey = T

places-cmd-close =
    .key = w

places-view-button =
    .label = Tampilan
    .tooltiptext = Atur tampilan
    .accesskey = T

places-view-button-mac =
    .label = Tampilan
    .tooltiptext = Atur tampilan

places-view-menu-columns =
    .label = Tampilkan Kolom
    .accesskey = K

places-view-menu-sort =
    .label = Urutan
    .accesskey = U

places-view-sort-unsorted =
    .label = Tidak Diurut
    .accesskey = T

places-view-sort-ascending =
    .label = Urutan A ke Z
    .accesskey = A

places-view-sort-descending =
    .label = Urutan Z ke A
    .accesskey = Z

places-maintenance-button =
    .label = Impor dan Cadangan
    .tooltiptext = Impor dan cadangkan markah Anda‚
    .accesskey = I

places-maintenance-button-mac =
    .label = Impor dan Cadangan
    .tooltiptext = Impor dan cadangkan markah Anda‚

places-cmd-backup =
    .label = Buat Cadangan…
    .accesskey = C

places-cmd-restore =
    .label = Kembalikan
    .accesskey = K

places-cmd-restore-from-file =
    .label = Pilih Berkas…
    .accesskey = B

places-import-bookmarks-from-html =
    .label = Impor Markah dari HTML…
    .accesskey = I

places-export-bookmarks-to-html =
    .label = Ekspor Markah ke HTML…
    .accesskey = E

places-import-other-browser =
    .label = Impor Data dari Peramban Lain…
    .accesskey = a

places-view-sort-col-name =
    .label = Nama

places-view-sort-col-tags =
    .label = Tag

places-view-sort-col-url =
    .label = Lokasi

places-view-sort-col-most-recent-visit =
    .label = Kunjungan Terakhir

places-view-sort-col-visit-count =
    .label = Jumlah Kunjungan

places-view-sort-col-date-added =
    .label = Ditambahkan pada

places-view-sort-col-last-modified =
    .label = Modifikasi Terakhir

places-view-sortby-name =
    .label = Urut berdasarkan Nama
    .accesskey = N
places-view-sortby-url =
    .label = Urut berdasarkan Lokasi
    .accesskey = L
places-view-sortby-date =
    .label = Urut berdasarkan Yang Terbaru & Kunjungan
    .accesskey = K
places-view-sortby-visit-count =
    .label = Urut berdasarkan Jumlah Kunjungan
    .accesskey = J
places-view-sortby-date-added =
    .label = Urut berdasarkan Waktu Ditambahkan
    .accesskey = W
places-view-sortby-last-modified =
    .label = Urut berdasarkan Terakhir Diubah
    .accesskey = T
places-view-sortby-tags =
    .label = Urut berdasarkan Tag
    .accesskey = T

places-cmd-find-key =
    .key = f

places-back-button =
    .tooltiptext = Mundur

places-forward-button =
    .tooltiptext = Maju

places-details-pane-select-an-item-description = Pilih item untuk ditampilkan dan diubah propertinya

places-details-pane-no-items =
    .value = Tak ada item
# Variables:
#   $count (Number): number of items
places-details-pane-items-count =
    .value = { $count } item

## Strings used as a placeholder in the Library search field. For example,
## "Search History" stands for "Search through the browser's history".

places-search-bookmarks =
    .placeholder = Cari di Daftar Markah
places-search-history =
    .placeholder = Cari di Riwayat
places-search-downloads =
    .placeholder = Cari di Unduhan

##

places-locked-prompt = Sistem markah dan riwayat tidak dapat berfungsi karena salah satu berkas milik { -brand-short-name } sedang digunakan oleh aplikasi lainnya. Beberapa perangkat lunak keamanan dapat menyebabkan masalah ini.
