# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-page-title = Pengelola Pengaya

search-header =
    .placeholder = Cari addons.mozilla.org
    .searchbuttonlabel = Cari

search-header-shortcut =
    .key = f

list-empty-get-extensions-message = Dapatkan ekstensi dan tema di <a data-l10n-name="get-extensions">{ $domain }</a>

list-empty-installed =
    .value = Anda tidak memiliki pengaya terpasang jenis ini

list-empty-available-updates =
    .value = Tidak ada versi baru ditemukan

list-empty-recent-updates =
    .value = Anda masih belum memasang versi baru pengaya

list-empty-find-updates =
    .label = Periksa Versi Baru

list-empty-button =
    .label = Pelajari lebih lanjut tentang pengaya

help-button = Dukungan Pengaya
sidebar-help-button-title =
    .title = Dukungan Pengaya

addons-settings-button = Pengaturan { -brand-short-name }
sidebar-settings-button-title =
    .title = Pengaturan { -brand-short-name }

show-unsigned-extensions-button =
    .label = Beberapa ekstensi tidak dapat diverifikasi

show-all-extensions-button =
    .label = Tampilkan semua ekstensi

detail-version =
    .label = Versi

detail-last-updated =
    .label = Terakhir Diperbarui

detail-contributions-description = Pengembang pengaya ini memohon bantuan dukungan Anda untuk membantu kesinambungan pengembangan pengaya dengan memberikan kontribusi kecil.

detail-contributions-button = Berkontribusi
    .title = Berkontribusi dalam pengembangan pengaya ini
    .accesskey = k

detail-update-type =
    .value = Pemutakhiran Otomatis

detail-update-default =
    .label = Bawaan
    .tooltiptext = Otomatis pasang pemutakhiran hanya jika pengaturan bawaan diatur demikian

detail-update-automatic =
    .label = Aktif
    .tooltiptext = Otomatis memasang pemutakhiran

detail-update-manual =
    .label = Mati
    .tooltiptext = Jangan otomatis memasang pemutakhiran

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Jalankan di Jendela Pribadi

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Tidak Diizinkan di Jendela Pribadi
detail-private-disallowed-description2 = Ekstensi ini tidak berjalan saat penjelajahan pribadi. <a data-l10n-name="learn-more">Pelajari lebih lanjut</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Membutuhkan Akses ke Jendela Pribadi
detail-private-required-description2 = Ekstensi ini memiliki akses ke aktivitas daring Anda saat penjelajahan pribadi. <a data-l10n-name="learn-more">Pelajari lebih lanjut</a>

detail-private-browsing-on =
    .label = Izinkan
    .tooltiptext = Aktifkan di Penjelajahan Pribadi

detail-private-browsing-off =
    .label = Jangan Izinkan
    .tooltiptext = Nonaktifkan di Penjelajahan Pribadi

detail-home =
    .label = Beranda

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Profil Pengaya

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Periksa versi baru
    .accesskey = v
    .tooltiptext = Periksa versi baru pengaya ini

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Pengaturan
           *[other] Pengaturan
        }
    .accesskey =
        { PLATFORM() ->
            [windows] P
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Ubah pengaturan pengaya ini
           *[other] Ubah pengaturan pengaya ini
        }

detail-rating =
    .value = Peringkat

addon-restart-now =
    .label = Mulai ulang sekarang

disabled-unsigned-heading =
    .value = Beberapa pengaya telah dinonaktifkan

disabled-unsigned-description = Pengaya berikut belum diverifikasi untuk digunakan di { -brand-short-name }. Anda dapat <label data-l10n-name="find-addons">temukan pengganti</label> atau minta pengembangnya untuk memverifikasi.

disabled-unsigned-learn-more = Pelajari tentang usaha kami untuk menjaga keselamatan daring Anda.

disabled-unsigned-devinfo = Pengembang yang tertarik untuk memverifikasi pengayanya dapat terus melanjutkan membaca <label data-l10n-name="learn-more">manual</label> kami.

plugin-deprecation-description = Kehilangan sesuatu? Beberapa plugin tidak didukung lagi oleh { -brand-short-name }. <label data-l10n-name="learn-more">Pelajari Lebih Lanjut.</label>

legacy-warning-show-legacy = Tampilkan ekstensi peninggalan

legacy-extensions =
    .value = Ekstensi Peninggalan

legacy-extensions-description = Ekstensi ini tidak memenuhi standar { -brand-short-name } saat ini sehingga telah dinonaktifkan. <label data-l10n-name="legacy-learn-more">Pelajari tentang perubahan terhadap pengaya</label>

private-browsing-description2 =
    { -brand-short-name } mengubah cara kerja ekstensi di mode penjelajahan pribadi. Setiap ekstensi baru yang Anda tambahkan
    ke { -brand-short-name } tidak akan berjalan secara baku di Jendela Pribadi. Kecuali Anda mengizinkannya dalam pengaturan,
    ekstensi tidak akan berfungsi saat menjelajah secara pribadi dan tidak akan memiliki akses ke aktivitas daring Anda
    pada jendela pribadi tersebut. Kami telah membuat perubahan ini untuk menjaga penelusuran pribadi Anda tetap pribadi.
    <label data-l10n-name="private-browsing-learn-more">Pelajari cara mengelola pengaturan ekstensi.</label>

addon-category-discover = Rekomendasi
addon-category-discover-title =
    .title = Rekomendasi
addon-category-extension = Ekstensi
addon-category-extension-title =
    .title = Ekstensi
addon-category-theme = Tema
addon-category-theme-title =
    .title = Tema
addon-category-plugin = Plugin
addon-category-plugin-title =
    .title = Plugin
addon-category-dictionary = Kamus
addon-category-dictionary-title =
    .title = Kamus
addon-category-locale = Bahasa
addon-category-locale-title =
    .title = Bahasa
addon-category-available-updates = Versi Baru yang Tersedia
addon-category-available-updates-title =
    .title = Versi Baru yang Tersedia
addon-category-recent-updates = Versi Baru
addon-category-recent-updates-title =
    .title = Versi Baru

## These are global warnings

extensions-warning-safe-mode = Semua pengaya telah dinonaktifkan dalam mode aman.
extensions-warning-check-compatibility = Pemeriksaan kompatibilitas pengaya telah dinonaktifkan. Anda mungkin menggunakan pengaya yang tidak kompatibel.
extensions-warning-check-compatibility-button = Aktifkan
    .title = Aktifkan pemeriksaan kompatibilitas pengaya
extensions-warning-update-security = Pemeriksaan keamanan pemutakhiran pengaya telah dinonaktifkan. Pemutakhiran pengaya saat ini memiliki risiko keamanan.
extensions-warning-update-security-button = Aktifkan
    .title = Aktifkan pemeriksaan keamanan pemutakhiran pengaya


## Strings connected to add-on updates

addon-updates-check-for-updates = Periksa Versi Baru
    .accesskey = P
addon-updates-view-updates = Tampilkan Versi Baru
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Otomatis Perbarui Pengaya
    .accesskey = O

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Setel Ulang Semua Pengaya agar Diperbarui Otomatis
    .accesskey = S
addon-updates-reset-updates-to-manual = Setel Ulang Semua Pengaya agar Hanya Diperbarui Manual
    .accesskey = M

## Status messages displayed when updating add-ons

addon-updates-updating = Memperbarui pengaya
addon-updates-installed = Pengaya Anda telah diperbarui.
addon-updates-none-found = Tidak ada versi baru ditemukan
addon-updates-manual-updates-found = Tampilkan Versi Baru yang Tersedia

## Add-on install/debug strings for page options menu

addon-install-from-file = Pasang Pengaya dari Berkas…
    .accesskey = B
addon-install-from-file-dialog-title = Pilih berkas pengaya untuk dipasang
addon-install-from-file-filter-name = Pengaya
addon-open-about-debugging = Debug Pengaya
    .accesskey = b

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Kelola Pintasan Ekstensi
    .accesskey = K

shortcuts-no-addons = Anda tidak memiliki ekstensi yang aktif.
shortcuts-no-commands = Ekstensi berikut tidak memiliki pintasan:
shortcuts-input =
    .placeholder = Ketikkan pintasan

shortcuts-browserAction2 = Aktifkan tombol bilah alat
shortcuts-pageAction = Aktifkan tindakan laman
shortcuts-sidebarAction = Aktifkan/Nonaktifkan bilah samping

shortcuts-modifier-mac = Sertakan Ctrl, Alt, atau ⌘
shortcuts-modifier-other = Sertakan Ctrl atau Alt
shortcuts-invalid = Kombinasi tidak valid
shortcuts-letter = Ketikkan huruf
shortcuts-system = Tidak bisa menimpa pintasan { -brand-short-name }

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Pintasan ganda

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } digunakan sebagai pintasan di lebih dari satu tempat. Pintasan duplikat dapat menyebabkan perilaku yang tidak terduga.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Sudah digunakan oleh { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
       *[other] Tampilkan { $numberToShow } Lainnya
    }

shortcuts-card-collapse-button = Lebih Sedikit

header-back-button =
    .title = Mundur

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Ekstensi dan tema seperti layaknya aplikasi untuk browser Anda, dan mereka bisa digunakan untuk melindungi kata sandi, mengunduh video, menemukan penawaran, memblokir iklan yang mengganggu, mengubah tampilan peramban Anda, dan banyak lagi. Program perangkat lunak kecil ini banyak dikembangkan oleh pihak ketiga. Berikut adalah pilihan 
    <a data-l10n-name="learn-more-trigger">yang disarankan</a> { -brand-product-name } berdasarkan keamanan, kinerja, dan fungsionalitas mereka.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Beberapa rekomendasi ini dipersonalisasi. Rekomendasi tersebut didasarkan pada ekstensi lain
    yang Anda pasang, preferensi profil, dan statistik penggunaan.
discopane-notice-learn-more = Pelajari lebih lanjut

privacy-policy = Kebijakan Privasi

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = oleh <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Pengguna: { $dailyUsers }
install-extension-button = Tambahkan ke { -brand-product-name }
install-theme-button = Pasang Tema
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Kelola
find-more-addons = Temukan lebih banyak pengaya

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Opsi Lainnya

## Add-on actions

report-addon-button = Laporkan
remove-addon-button = Hapus
# The link will always be shown after the other text.
remove-addon-disabled-button = Tidak Dapat Dihapus <a data-l10n-name="link">Alasannya?</a>
disable-addon-button = Nonaktifkan
enable-addon-button = Aktifkan
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Aktifkan
preferences-addon-button =
    { PLATFORM() ->
        [windows] Pengaturan
       *[other] Preferensi
    }
details-addon-button = Detail
release-notes-addon-button = Catatan Rilis
permissions-addon-button = Hak Akses

extension-enabled-heading = Aktif
extension-disabled-heading = Nonaktif

theme-enabled-heading = Aktif
theme-disabled-heading = Nonaktif

plugin-enabled-heading = Aktif
plugin-disabled-heading = Nonaktif

dictionary-enabled-heading = Aktif
dictionary-disabled-heading = Nonaktif

locale-enabled-heading = Aktif
locale-disabled-heading = Nonaktif

always-activate-button = Selalu Aktif
never-activate-button = Jangan Pernah Aktifkan

addon-detail-author-label = Penyusun
addon-detail-version-label = Versi
addon-detail-last-updated-label = Terakhir Diperbarui
addon-detail-homepage-label = Beranda
addon-detail-rating-label = Peringkat

# Message for add-ons with a staged pending update.
install-postponed-message = Ekstensi ini akan diperbarui ketika { -brand-short-name } dimulai ulang.
install-postponed-button = Perbarui Sekarang

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Peringkat { NUMBER($rating, maximumFractionDigits: 1) } dari 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (dinonaktifkan)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
       *[other] { $numberOfReviews } ulasan
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> telah dihapus.
pending-uninstall-undo-button = Batal

addon-detail-updates-label = Izinkan pembaruan otomatis
addon-detail-updates-radio-default = Baku
addon-detail-updates-radio-on = Aktif
addon-detail-updates-radio-off = Nonaktif
addon-detail-update-check-label = Periksa Versi Baru
install-update-button = Perbarui

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Diizinkan di jendela pribadi
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Jika diizinkan, ekstensi akan memiliki akses ke aktivitas daring Anda saat menjelajah secara pribadi. <a data-l10n-name="learn-more">Pelajari lebih lanjut</a>
addon-detail-private-browsing-allow = Izinkan
addon-detail-private-browsing-disallow = Jangan Izinkan

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = { -brand-product-name } hanya menyarankan ekstensi yang memenuhi standar keamanan dan kinerja kami.
    .aria-label = { addon-badge-recommended2.title }

# We hard code "Waterfox" in the string below because the extensions are built
# by Waterfox and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = Ekstensi resmi yang dibuat oleh Waterfox, memenuhi standar keamanan dan kinerja
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = Ekstensi ini telah ditinjau untuk memenuhi standar keamanan dan kinerja kami
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = Versi Baru yang Tersedia
recent-updates-heading = Versi Terkini

release-notes-loading = Memuat…
release-notes-error = Maaf, galat terjadi ketika memuat catatan rilis.

addon-permissions-empty = Ekstensi ini tidak memerlukan izin apa pun

addon-permissions-required = Izin yang diperlukan untuk fungsi inti:
addon-permissions-optional = Izin opsional untuk fungsi tambahan:
addon-permissions-learnmore = Pelajari lebih lanjut tentang perizinan

recommended-extensions-heading = Ekstensi yang Disarankan
recommended-themes-heading = Tema yang Disarankan

# A recommendation for the Waterfox Color theme shown at the bottom of the theme
# list view. The "Waterfox Color" name itself should not be translated.
recommended-theme-1 = Merasa kreatif? <a data-l10n-name="link">Buat tema Anda sendiri dengan Waterfox Color.</a>

## Page headings

extension-heading = Kelola ekstensi Anda
theme-heading = Kelola tema Anda
plugin-heading = Kelola plugin Anda
dictionary-heading = Kelola kamus Anda
locale-heading = Kelola bahasa Anda
updates-heading = Kelola Pembaruan Anda
discover-heading = Personalisasikan { -brand-short-name } Anda
shortcuts-heading = Kelola Pintasan Ekstensi

default-heading-search-label = Temukan lebih banyak pengaya
addons-heading-search-input =
    .placeholder = Cari addons.mozilla.org

addon-page-options-button =
    .title = Alat untuk semua pengaya
