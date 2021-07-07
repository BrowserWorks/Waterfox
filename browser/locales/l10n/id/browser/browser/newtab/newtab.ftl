# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Waterfox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Tab Baru
newtab-settings-button =
    .title = Ubahsuai laman Tab Baru Anda

newtab-personalize-icon-label =
    .title = Personalisasikan tab baru
    .aria-label = Personalisasikan tab baru
newtab-personalize-dialog-label =
    .aria-label = Personalisasikan

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Cari
    .aria-label = Cari

# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = Cari lewat { $engine } atau masukkan alamat
newtab-search-box-handoff-text-no-engine = Cari atau masukkan alamat
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = Cari lewat { $engine } atau masukkan alamat
    .title = Cari lewat { $engine } atau masukkan alamat
    .aria-label = Cari lewat { $engine } atau masukkan alamat
newtab-search-box-handoff-input-no-engine =
    .placeholder = Cari atau masukkan alamat
    .title = Cari atau masukkan alamat
    .aria-label = Cari atau masukkan alamat

newtab-search-box-search-the-web-input =
    .placeholder = Cari di Web
    .title = Cari di Web
    .aria-label = Cari di Web

newtab-search-box-input =
    .placeholder = Cari di web
    .aria-label = Cari di web

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Tambahkan Mesin Pencari
newtab-topsites-add-topsites-header = Situs Pilihan Baru
newtab-topsites-add-shortcut-header = Pintasan Baru
newtab-topsites-edit-topsites-header = Ubah Situs Pilihan
newtab-topsites-edit-shortcut-header = Edit Pintasan
newtab-topsites-title-label = Judul
newtab-topsites-title-input =
    .placeholder = Masukkan judul

newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Ketik atau tempel URL
newtab-topsites-url-validation = URL valid diperlukan

newtab-topsites-image-url-label = URL Gambar Khusus
newtab-topsites-use-image-link = Gunakan gambar khusus…
newtab-topsites-image-validation = Gambar gagal dimuat. Coba URL lain.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Batalkan
newtab-topsites-delete-history-button = Hapus dari Riwayat
newtab-topsites-save-button = Simpan
newtab-topsites-preview-button = Pratinjau
newtab-topsites-add-button = Tambah

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Yakin ingin menghapus setiap bagian dari laman ini dari riwayat Anda?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Tindakan ini tidak bisa diurungkan.

## Top Sites - Sponsored label

newtab-topsite-sponsored = Bersponsor

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Buka menu
    .aria-label = Buka menu

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Hapus
    .aria-label = Hapus

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Buka menu
    .aria-label = Buka menu konteks untuk { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Edit situs ini
    .aria-label = Edit situs ini

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Edit
newtab-menu-open-new-window = Buka di Jendela Baru
newtab-menu-open-new-private-window = Buka di Jendela Penjelajahan Pribadi Baru
newtab-menu-dismiss = Tutup
newtab-menu-pin = Semat
newtab-menu-unpin = Lepas
newtab-menu-delete-history = Hapus dari Riwayat
newtab-menu-save-to-pocket = Simpan ke { -pocket-brand-name }
newtab-menu-delete-pocket = Hapus dari { -pocket-brand-name }
newtab-menu-archive-pocket = Arsip di { -pocket-brand-name }
newtab-menu-show-privacy-info = Sponsor kami & privasi Anda

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Selesai
newtab-privacy-modal-button-manage = Kelola pengaturan konten sponsor
newtab-privacy-modal-header = Privasi Anda penting.
newtab-privacy-modal-paragraph-2 = Selain menampilkan berbagai kisah menawan, kami juga menampilkan konten yang relevan, yang telah diperiksa dari sponsor tertentu, untuk Anda. Yakinlah, <strong>data penjelajahan Anda tidak pernah meninggalkan { -brand-product-name } Anda</strong> — kami dan sponsor kami tidak melihatnya.
newtab-privacy-modal-link = Pelajari cara privasi bekerja di tab baru

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Hapus Markah
# Bookmark is a verb here.
newtab-menu-bookmark = Markah

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Salin Tautan Unduhan
newtab-menu-go-to-download-page = Buka Laman Unduhan
newtab-menu-remove-download = Hapus dari Riwayat

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Tampilkan di Finder
       *[other] Buka Foldernya
    }
newtab-menu-open-file = Buka Berkas

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Dikunjungi
newtab-label-bookmarked = Dimarkahi
newtab-label-removed-bookmark = Markah dihapus
newtab-label-recommended = Trending
newtab-label-saved = Disimpan di { -pocket-brand-name }
newtab-label-download = Terunduh

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Pesan Sponsor

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Disponsori oleh { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Hapus Bagian
newtab-section-menu-collapse-section = Ciutkan Bagian
newtab-section-menu-expand-section = Bentangkan Bagian
newtab-section-menu-manage-section = Kelola Bagian
newtab-section-menu-manage-webext = Kelola Ekstensi
newtab-section-menu-add-topsite = Tambah Situs Pilihan
newtab-section-menu-add-search-engine = Tambahkan Mesin Pencari
newtab-section-menu-move-up = Naikkan
newtab-section-menu-move-down = Turunkan
newtab-section-menu-privacy-notice = Kebijakan Privasi

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Ciutkan Bagian
newtab-section-expand-section-label =
    .aria-label = Bentangkan Bagian

## Section Headers.

newtab-section-header-topsites = Situs Teratas
newtab-section-header-highlights = Sorotan
newtab-section-header-recent-activity = Aktivitas terbaru
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Disarankan oleh { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Mulai menjelajah, dan kami akan menampilkan beberapa artikel bagus, video, dan halaman lain yang baru saja Anda kunjungi atau termarkah di sini.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Maaf Anda tercegat. Periksa lagi nanti untuk lebih banyak cerita terbaik dari { $provider }. Tidak mau menunggu? Pilih topik populer untuk menemukan lebih banyak cerita hebat dari seluruh web.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Semua sudah selesai terbaca!
newtab-discovery-empty-section-topstories-content = Periksa kembali nanti untuk lebih banyak kisah.
newtab-discovery-empty-section-topstories-try-again-button = Coba Lagi
newtab-discovery-empty-section-topstories-loading = Memuat…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Ups! Kami belum selesai memuat bagian ini, tetapi ternyata belum.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Topik Populer:
newtab-pocket-more-recommendations = Rekomendasi Lainnya
newtab-pocket-learn-more = Pelajari lebih lanjut
newtab-pocket-cta-button = Dapatkan { -pocket-brand-name }
newtab-pocket-cta-text = Simpan cerita yang anda sukai di { -pocket-brand-name }, dan dapatkan bacaan menarik untuk Anda.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Ups, ada masalah saat memuat konten ini.
newtab-error-fallback-refresh-link = Segarkan laman untuk mencoba lagi.

## Customization Menu

newtab-custom-shortcuts-title = Pintasan
newtab-custom-shortcuts-subtitle = Situs yang Anda simpan atau kunjungi
newtab-custom-row-selector =
    { $num ->
       *[other] { $num } baris
    }
newtab-custom-sponsored-sites = Pintasan bersponsor
newtab-custom-pocket-title = Disarankan oleh { -pocket-brand-name }
newtab-custom-pocket-subtitle = Konten luar biasa yang dikelola oleh { -pocket-brand-name }, bagian dari keluarga { -brand-product-name }
newtab-custom-pocket-sponsored = Konten bersponsor
newtab-custom-recent-title = Aktivitas terbaru
newtab-custom-recent-subtitle = Pilihan situs dan konten terbaru
newtab-custom-close-button = Tutup

newtab-custom-settings = Kelola pengaturan lainnya
