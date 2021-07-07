# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Kirim sinyal “Jangan Lacak” ke situs web bahwa Anda tidak ingin dilacak
do-not-track-learn-more = Pelajari lebih lanjut
do-not-track-option-default-content-blocking-known =
    .label = Hanya ketika { -brand-short-name } diatur untuk memblokir pelacak yang diketahui
do-not-track-option-always =
    .label = Selalu

settings-page-title = Pengaturan

# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box2 =
    .style = width: 15.4em
    .placeholder = Cari di Pengaturan

managed-notice = Peramban Anda dikelola oleh organisasi Anda.

category-list =
    .aria-label = Kategori

pane-general-title = Umum
category-general =
    .tooltiptext = { pane-general-title }

pane-home-title = Beranda
category-home =
    .tooltiptext = { pane-home-title }

pane-search-title = Cari
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = Privasi & Keamanan
category-privacy =
    .tooltiptext = { pane-privacy-title }

pane-sync-title3 = Sinkronisasi
category-sync3 =
    .tooltiptext = { pane-sync-title3 }

pane-experimental-title = Eksperimen { -brand-short-name }
category-experimental =
    .tooltiptext = Eksperimen { -brand-short-name }
pane-experimental-subtitle = Lanjutkan dengan Kehati-hatian
pane-experimental-search-results-header = Eksperimen { -brand-short-name }: Lanjutkan dengan Hati-hati
pane-experimental-description2 = Mengubah pengaturan konfigurasi tingkat lanjut dapat mempengaruhi kinerja atau keamanan { -brand-short-name }.

pane-experimental-reset =
    .label = Pulihkan Bawaan
    .accesskey = B

help-button-label = Dukungan { -brand-short-name }
addons-button-label = Ekstensi & Tema

focus-search =
    .key = f

close-button =
    .aria-label = Tutup

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } harus dimulai ulang untuk mengaktifkan fitur ini.
feature-disable-requires-restart = { -brand-short-name } harus dimulai ulang untuk menonaktifkan fitur ini.
should-restart-title = Mulai Ulang { -brand-short-name }
should-restart-ok = Mulai ulang { -brand-short-name } sekarang
cancel-no-restart-button = Batal
restart-later = Mulai Ulang Nanti

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Ekstensi <img data-l10n-name="icon"/> { $name } mengendalikan setelan ini.

# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Sebuah ekstensi bernama <img data-l10n-name="icon"/> { $name } mengendalikan setelan ini.

# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Ekstensi <img data-l10n-name="icon"/> { $name } membutuhkan Tab Kontainer.

# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Ekstensi <img data-l10n-name="icon"/> { $name } mengontrol setelan ini.

# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Ekstensi <img data-l10n-name="icon"/> { $name } mengendalikan cara { -brand-short-name } tersambung ke internet.

# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Untuk mengaktifkan ekstensi buka Pengaya <img data-l10n-name="addons-icon"/> di menu <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Hasil Pencarian

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = Maaf! Tidak ada hasil di Pengaturan untuk “<span data-l10n-name="query"></span>”.

search-results-help-link = Butuh bantuan? Kunjungi <a data-l10n-name="url">Dukungan { -brand-short-name }</a>

## General Section

startup-header = Memulai

always-check-default =
    .label = Selalu periksa apakah { -brand-short-name } adalah peramban baku Anda
    .accesskey = S

is-default = { -brand-short-name } adalah peramban baku Anda
is-not-default = { -brand-short-name } bukan peramban baku Anda

set-as-my-default-browser =
    .label = Jadikan Baku…
    .accesskey = U

startup-restore-previous-session =
    .label = Pulihkan sesi sebelumnya
    .accesskey = P

startup-restore-warn-on-quit =
    .label = Memperingatkan Anda saat keluar dari peramban

disable-extension =
    .label = Nonaktifkan Ekstensi

tabs-group-header = Tab

ctrl-tab-recently-used-order =
    .label = Ctrl+Tab berputar melalui tab dalam urutan yang baru saja digunakan
    .accesskey = T

open-new-link-as-tabs =
    .label = Buka tautan di tab, bukan di jendela baru
    .accesskey = t

warn-on-close-multiple-tabs =
    .label = Ingatkan ketika menutup banyak tab sekaligus
    .accesskey = m

warn-on-open-many-tabs =
    .label = Ingatkan bahwa ketika membuka banyak tab mungkin akan memperlambat { -brand-short-name }
    .accesskey = l

switch-to-new-tabs =
    .label = Saat Anda membuka suatu tautan, gambar, atau media di tab baru, seketika beralih ke sana
    .accesskey = h

show-tabs-in-taskbar =
    .label = Tampilkan pratinjau tab pada bilah tugas Windows
    .accesskey = k

browser-containers-enabled =
    .label = Aktifkan Tab Kontainer
    .accesskey = k

browser-containers-learn-more = Pelajari lebih lanjut

browser-containers-settings =
    .label = Setelan…
    .accesskey = E

containers-disable-alert-title = Tutup Semua Kontainer Tab?
containers-disable-alert-desc = Jika Anda menonaktifkan Tab Kontainer sekarang, { $tabCount } tab kontainer akan ditutup. Yakin ingin menonaktifkan Tab Kontainer?

containers-disable-alert-ok-button = Tutup { $tabCount } Tab Kontainer
containers-disable-alert-cancel-button = Tetap aktifkan

containers-remove-alert-title = Hapus Kontainer Ini?

# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg = Jika Anda menghapus Kontainer ini sekarang, { $count } tab kontainer akan ditutup. Yakin ingin menghapus Kontainer ini?

containers-remove-ok-button = Hapus Kontainer ini
containers-remove-cancel-button = Jangan hapus Kontainer ini


## General Section - Language & Appearance

language-and-appearance-header = Bahasa dan Tampilan

fonts-and-colors-header = Huruf & Warna

default-font = Fon baku
    .accesskey = F
default-font-size = Ukuran
    .accesskey = U

advanced-fonts =
    .label = Lebih lanjut…
    .accesskey = L

colors-settings =
    .label = Warna…
    .accesskey = W

# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Perbesaran

preferences-default-zoom = Perbesaran baku
    .accesskey = P

preferences-default-zoom-value =
    .label = { $percentage }%

preferences-zoom-text-only =
    .label = Perbesar teks saja
    .accesskey = t

language-header = Bahasa

choose-language-description = Pilih bahasa yang disukai untuk menampilkan laman

choose-button =
    .label = Pilih…
    .accesskey = P

choose-browser-language-description = Pilih bahasa yang digunakan untuk menampilkan menu, pesan, dan notifikasi dari { -brand-short-name }.
manage-browser-languages-button =
    .label = Setel Alternatif…
    .accesskey = S
confirm-browser-language-change-description = Mulai ulang { -brand-short-name } untuk menerapkan perubahan
confirm-browser-language-change-button = Terapkan dan Mulai Ulang

translate-web-pages =
    .label = Penerjemahan isi web
    .accesskey = n

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Terjemahan oleh <img data-l10n-name="logo"/>

translate-exceptions =
    .label = Pengecualian…
    .accesskey = l

# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Gunakan pengaturan sistem operasi Anda pada “{ $localeName }” untuk format tanggal, waktu, angka, dan pengukuran.

check-user-spelling =
    .label = Periksa ejaan saat mengetik teks
    .accesskey = j

## General Section - Files and Applications

files-and-applications-title = Berkas dan Aplikasi

download-header = Unduhan

download-save-to =
    .label = Simpan berkas di
    .accesskey = S

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Pilih…
           *[other] Telusuri…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] P
           *[other] e
        }

download-always-ask-where =
    .label = Tanyakan selalu tempat menyimpan berkas
    .accesskey = T

applications-header = Aplikasi

applications-description = Pilih cara { -brand-short-name } menangani berkas yang Anda unduh dari Web atau aplikasi yang Anda gunakan saat menjelajah.

applications-filter =
    .placeholder = Cari jenis berkas atau aplikasi

applications-type-column =
    .label = Tipe Isi
    .accesskey = T

applications-action-column =
    .label = Aksi
    .accesskey = A

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = berkas { $extension }
applications-action-save =
    .label = Simpan Berkas

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Gunakan { $app-name }

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Gunakan { $app-name } (bawaan)

applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Gunakan aplikasi baku macOS
            [windows] Gunakan aplikasi baku Windows
           *[other] Gunakan aplikasi baku sistem
        }

applications-use-other =
    .label = Gunakan yang lain…
applications-select-helper = Pilih Aplikasi Pembantu

applications-manage-app =
    .label = Detail Aplikasi…
applications-always-ask =
    .label = Tanyakan selalu

# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })

# Variables:
#   $extension (String) - file extension (e.g .TXT)
#   $type (String) - the MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })

# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = Gunakan { $plugin-name } (di { -brand-short-name })
applications-open-inapp =
    .label = Buka di { -brand-short-name }

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }

applications-action-save-label =
    .value = { applications-action-save.label }

applications-use-app-label =
    .value = { applications-use-app.label }

applications-open-inapp-label =
    .value = { applications-open-inapp.label }

applications-always-ask-label =
    .value = { applications-always-ask.label }

applications-use-app-default-label =
    .value = { applications-use-app-default.label }

applications-use-other-label =
    .value = { applications-use-other.label }

applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

drm-content-header = Konten Digital Rights Management (DRM)

play-drm-content =
    .label = Putar konten DRM-terkontrol
    .accesskey = P

play-drm-content-learn-more = Pelajari lebih lanjut

update-application-title = Pemutakhiran { -brand-short-name }

update-application-description = Pastikan { -brand-short-name } selalu mutakhir demi kinerja, stabilitas, dan keamanan terbaik.

update-application-version = Versi { $version } <a data-l10n-name="learn-more">Yang baru</a>

update-history =
    .label = Tampilkan Riwayat Pemutakhiran…
    .accesskey = P

update-application-allow-description = Izinkan { -brand-short-name } untuk

update-application-auto =
    .label = Secara otomatis memasang pemutakhiran (disarankan)
    .accesskey = S

update-application-check-choose =
    .label = Periksa pemutakhiran, biarkan saya memilih memasangnya atau tidak
    .accesskey = P

update-application-manual =
    .label = Jangan pernah memeriksa pemutakhiran (tidak disarankan)
    .accesskey = J

update-application-background-enabled =
    .label = Ketika { -brand-short-name } sedang tidak berjalan
    .accesskey = t

update-application-warning-cross-user-setting = Pengaturan ini akan berlaku untuk semua akun Windows dan profil { -brand-short-name } yang menggunakan pemasangan { -brand-short-name } ini.

update-application-use-service =
    .label = Gunakan layanan latar belakang untuk memasang pemutakhiran
    .accesskey = l

update-setting-write-failure-title2 = Gagal menyimpan pengaturan Pemutakhiran

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    { -brand-short-name } mengalami kesalahan dan tidak menyimpan perubahan ini. Perhatikan bahwa perubahan pengaturan pembaruan ini memerlukan izin untuk menulis ke file di bawah ini. Anda atau administrator sistem mungkin dapat menyelesaikan kesalahan dengan memberikan kontrol penuh grup Pengguna ke file ini.
    
    Tidak dapat menulis ke file: { $path }

update-in-progress-title = Sedang Memperbarui

update-in-progress-message = Apakah Anda ingin { -brand-short-name } melanjutkan pembaruan ini?

update-in-progress-ok-button = &Hapus Perubahan
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Lanjutkan

## General Section - Performance

performance-title = Kinerja

performance-use-recommended-settings-checkbox =
    .label = Gunakan setelan kinerja yang disarankan
    .accesskey = G

performance-use-recommended-settings-desc = Setelan ini dirancang untuk perangkat keras dan sistem operasi komputer Anda.

performance-settings-learn-more = Pelajari lebih lanjut

performance-allow-hw-accel =
    .label = Gunakan akselerasi perangkat keras jika tersedia
    .accesskey = a

performance-limit-content-process-option = Batas proses konten
    .accesskey = P

performance-limit-content-process-enabled-desc = Proses konten tambahan dapat meningkatkan performa ketika menggunakan banyak tab, tetapi juga akan menggunakan lebih banyak memori.
performance-limit-content-process-blocked-desc = Memodifikasi jumlah proses konten hanya bisa dengan multiproses { -brand-short-name }. <a data-l10n-name="learn-more">Pelajari cara mengecek jika multiproses diaktifkan</a>

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (baku)

## General Section - Browsing

browsing-title = Jelajah Web

browsing-use-autoscroll =
    .label = Gunakan penggeseran otomatis
    .accesskey = G

browsing-use-smooth-scrolling =
    .label = Geser dengan mulus
    .accesskey = m

browsing-use-onscreen-keyboard =
    .label = Tampilkan papan ketik sentuh saat diperlukan
    .accesskey = k

browsing-use-cursor-navigation =
    .label = Selalu gunakan kursor papan ketik untuk navigasi laman
    .accesskey = S

browsing-search-on-start-typing =
    .label = Cari teks saat Anda mulai mengetik
    .accesskey = k

browsing-picture-in-picture-toggle-enabled =
    .label = Aktifkan kontrol video gambar-dalam-gambar
    .accesskey = g

browsing-picture-in-picture-learn-more = Pelajari lebih lanjut

browsing-media-control =
    .label = Kontrol media melalui papan ketik, headset, atau antarmuka virtual
    .accesskey = K

browsing-media-control-learn-more = Pelajari lebih lanjut

browsing-cfr-recommendations =
    .label = Sarankan ekstensi seiring penjelajahan Anda
    .accesskey = r
browsing-cfr-features =
    .label = Sarankan fitur seiring penjelajahan Anda
    .accesskey = S

browsing-cfr-recommendations-learn-more = Pelajari lebih lanjut

## General Section - Proxy

network-settings-title = Setelan Jaringan

network-proxy-connection-description = Atur bagaimana { -brand-short-name } tersambung ke internet.

network-proxy-connection-learn-more = Pelajari lebih lanjut

network-proxy-connection-settings =
    .label = Setelan…
    .accesskey = S

## Home Section

home-new-windows-tabs-header = Jendela dan Tab Baru

home-new-windows-tabs-description2 = Pilih yang akan dilihat pertama kali ketika membuka beranda, jendela baru, dan tab baru.

## Home Section - Home Page Customization

home-homepage-mode-label = Laman beranda dan jendela baru

home-newtabs-mode-label = Tab baru

home-restore-defaults =
    .label = Pulihkan Bawaan
    .accesskey = B

# "Waterfox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Beranda Waterfox (Baku)

home-mode-choice-custom =
    .label = URL Ubahsuai…

home-mode-choice-blank =
    .label = Laman Kosong

home-homepage-custom-url =
    .placeholder = Tempel URL...

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Gunakan Laman Sekarang
           *[other] Gunakan Semua Laman Berikut
        }
    .accesskey = G

choose-bookmark =
    .label = Gunakan Markah…
    .accesskey = h

## Home Section - Waterfox Home Content Customization

home-prefs-content-header = Konten Beranda Waterfox
home-prefs-content-description = Pilih konten yang ingin Anda tampilkan dalam Beranda Waterfox.

home-prefs-search-header =
    .label = Pencarian Web
home-prefs-topsites-header =
    .label = Situs Teratas
home-prefs-topsites-description = Situs yang sering Anda kunjungi

home-prefs-topsites-by-option-sponsored =
    .label = Situs Teratas yang Disponsori
home-prefs-shortcuts-header =
    .label = Pintasan
home-prefs-shortcuts-description = Situs yang Anda simpan atau kunjungi
home-prefs-shortcuts-by-option-sponsored =
    .label = Pintasan bersponsor

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Disarankan oleh { $provider }
home-prefs-recommended-by-description-update = Konten luar biasa dari seluruh web, dikuratori oleh { $provider }
home-prefs-recommended-by-description-new = Konten luar biasa yang dikelola oleh { $provider }, bagian dari keluarga { -brand-product-name }

##

home-prefs-recommended-by-learn-more = Panduan
home-prefs-recommended-by-option-sponsored-stories =
    .label = Konten Sponsor

home-prefs-highlights-header =
    .label = Sorotan
home-prefs-highlights-description = Sejumlah situs yang Anda simpan atau kunjungi
home-prefs-highlights-option-visited-pages =
    .label = Laman yang Dikunjungi
home-prefs-highlights-options-bookmarks =
    .label = Markah
home-prefs-highlights-option-most-recent-download =
    .label = Unduhan Terbaru
home-prefs-highlights-option-saved-to-pocket =
    .label = Laman Disimpan di { -pocket-brand-name }

home-prefs-recent-activity-header =
    .label = Aktivitas terbaru
home-prefs-recent-activity-description = Pilihan situs dan konten terbaru

# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Catatan Kecil
home-prefs-snippets-description = Pembaruan dari { -vendor-short-name } dan { -brand-product-name }

home-prefs-snippets-description-new = Kiat dan berita dari { -vendor-short-name } dan { -brand-product-name }

home-prefs-sections-rows-option =
    .label = { $num } baris

## Search Section

search-bar-header = Bilah Pencarian
search-bar-hidden =
    .label = Gunakan bilah alamat untuk mencari dan navigasi
search-bar-shown =
    .label = Tambahkan bilah pencarian di bilah alat

search-engine-default-header = Mesin Pencari Baku
search-engine-default-desc-2 = Ini adalah mesin pencari baku Anda dalam bilah alamat dan bilah pencarian. Anda dapat menggantinya kapan saja.
search-engine-default-private-desc-2 = Pilih mesin pencari bawaan yang berbeda hanya untuk Jendela Pribadi
search-separate-default-engine =
    .label = Gunakan mesin pencari ini dalam Jendela Pribadi
    .accesskey = G

search-suggestions-header = Saran Pencarian
search-suggestions-desc = Pilih bagaimana saran dari mesin pencari tampil.

search-suggestions-option =
    .label = Sertakan saran pencarian
    .accesskey = s

search-show-suggestions-url-bar-option =
    .label = Tampilkan saran pencarian di hasil bilah alamat
    .accesskey = l

# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Tampilkan saran pencarian di atas riwayat penjelajahan dalam hasil bilah alamat

search-show-suggestions-private-windows =
    .label = Tampilkan saran pencarian di Jendela Pribadi

suggestions-addressbar-settings-generic2 = Ubah pengaturan untuk saran bilah alamat lainnya

search-suggestions-cant-show = Saran pencarian tidak akan ditampilkan di hasil bilah lokasi karena Anda telah mengatur { -brand-short-name } agar tidak mengingat riwayat.

search-one-click-header2 = Pintasan Pencarian

search-one-click-desc = Pilih mesin pencari alternatif yang muncul di bawah bilah alamat dan bilah pencarian ketika Anda mulai memasukkan kata kunci.

search-choose-engine-column =
    .label = Mesin Pencari
search-choose-keyword-column =
    .label = Kata Kunci

search-restore-default =
    .label = Pulihkan Mesin Pencari Bawaan
    .accesskey = n

search-remove-engine =
    .label = Hapus
    .accesskey = H

search-add-engine =
    .label = Tambah
    .accesskey = a

search-find-more-link = Temukan lebih banyak mesin pencari

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Kata Kunci Ganda
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Anda telah memilih kata kunci yang sama dengan "{ $name }". Silakan pilih kata lain.
search-keyword-warning-bookmark = Anda telah memilih kata kunci yang sama dengan nama Markah. Silakan pilih kata lain.

## Containers Section

containers-back-button2 =
    .aria-label = Kembali ke Pengaturan
containers-header = Tab Kontainer
containers-add-button =
    .label = Tambahkan Kontainer Baru
    .accesskey = T

containers-new-tab-check =
    .label = Pilih kontainer untuk setiap tab baru
    .accesskey = k

containers-settings-button =
    .label = Pengaturan
containers-remove-button =
    .label = Hapus

## Waterfox Account - Signed out. Note that "Sync" and "Waterfox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Bawalah Web bersama Anda

sync-signedout-description2 = Sinkronkan markah, riwayat, tab, sandi, pengaya, dan pengaturan di berbagai perangkat Anda.

sync-signedout-account-signin3 =
    .label = Masuk untuk sinkronisasi…
    .accesskey = M

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Unduh Waterfox untuk <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> atau <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> untuk menyinkronkan dengan peranti seluler Anda.

## Waterfox Account - Signed in

sync-profile-picture =
    .tooltiptext = Ubah gambar profil

sync-sign-out =
    .label = Keluar…
    .accesskey = K

sync-manage-account = Kelola Akun
    .accesskey = o

sync-signedin-unverified = { $email } tidak dapat diverifikasi.
sync-signedin-login-failure = Mohon masuk untuk menyambungkan ulang { $email }

sync-resend-verification =
    .label = Kirim Ulang Verifikasi
    .accesskey = u

sync-remove-account =
    .label = Hapus Akun
    .accesskey = H

sync-sign-in =
    .label = Masuk
    .accesskey = M

## Sync section - enabling or disabling sync.

prefs-syncing-on = Sinkronisasi: AKTIF

prefs-syncing-off = Sinkronisasi: NONAKTIF

prefs-sync-turn-on-syncing =
    .label = Aktifkan sinkronisasi…
    .accesskey = A

prefs-sync-offer-setup-label2 = Sinkronkan markah, riwayat, tab, sandi, pengaya, dan pengaturan di berbagai perangkat Anda.

prefs-sync-now =
    .labelnotsyncing = Sinkronkan Sekarang
    .accesskeynotsyncing = S
    .labelsyncing = Menyinkronkan…

## The list of things currently syncing.

sync-currently-syncing-heading = Anda sedang menyinkronkan item ini:

sync-currently-syncing-bookmarks = Markah
sync-currently-syncing-history = Riwayat
sync-currently-syncing-tabs = Tab terbuka
sync-currently-syncing-logins-passwords = Info masuk dan sandi
sync-currently-syncing-addresses = Alamat
sync-currently-syncing-creditcards = Kartu kredit
sync-currently-syncing-addons = Pengaya

sync-currently-syncing-settings = Pengaturan

sync-change-options =
    .label = Ubah
    .accesskey = U

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Pilih yang Akan Disinkronkan
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Simpan Perubahan
    .buttonaccesskeyaccept = S
    .buttonlabelextra2 = Putuskan…
    .buttonaccesskeyextra2 = P

sync-engine-bookmarks =
    .label = Markah
    .accesskey = M

sync-engine-history =
    .label = Riwayat
    .accesskey = w

sync-engine-tabs =
    .label = Tab terbuka
    .tooltiptext = Daftar tab terbuka di semua peranti yang disinkronkan
    .accesskey = T

sync-engine-logins-passwords =
    .label = Info masuk dan sandi
    .tooltiptext = Nama pengguna dan sandi yang Anda simpan
    .accesskey = I

sync-engine-addresses =
    .label = Alamat
    .tooltiptext = Alamat surat yang Anda simpan (hanya desktop)
    .accesskey = a

sync-engine-creditcards =
    .label = Kartu kredit
    .tooltiptext = Nama, nomor, dan tanggal kedaluwarsa (hanya desktop)
    .accesskey = K

sync-engine-addons =
    .label = Pengaya
    .tooltiptext = Ekstensi dan tema untuk Waterfox desktop
    .accesskey = y

sync-engine-settings =
    .label = Pengaturan
    .tooltiptext = Pengaturan Umum, Privasi, dan Keamanan yang Anda ubah
    .accesskey = P

## The device name controls.

sync-device-name-header = Nama Peranti

sync-device-name-change =
    .label = Ubah Nama Peranti…
    .accesskey = h

sync-device-name-cancel =
    .label = Batal
    .accesskey = B

sync-device-name-save =
    .label = Simpan
    .accesskey = S

sync-connect-another-device = Hubungkan perangkat lain

## Privacy Section

privacy-header = Privasi Peramban

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Info Masuk & Sandi
    .searchkeywords = { -lockwise-brand-short-name }

# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Minta untuk menyimpan info masuk dan kata sandi untuk situs web
    .accesskey = M
forms-exceptions =
    .label = Pengecualian…
    .accesskey = c
forms-generate-passwords =
    .label = Sarankan dan hasilkan kata sandi yang kuat
    .accesskey = u
forms-breach-alerts =
    .label = Tampilkan peringatan tentang kata sandi untuk situs web yang diretas
    .accesskey = w
forms-breach-alerts-learn-more-link = Pelajari lebih lanjut

# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Isi info masuk dan kata sandi secara otomatis
    .accesskey = I
forms-saved-logins =
    .label = Info Masuk Tersimpan…
    .accesskey = I
forms-primary-pw-use =
    .label = Gunakan Sandi Utama
    .accesskey = S
forms-primary-pw-learn-more-link = Pelajari lebih lanjut
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Ubah Sandi Utama…
    .accesskey = U

forms-primary-pw-change =
    .label = Ubah Sandi Utama…
    .accesskey = U
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }

forms-primary-pw-fips-title = Anda sedang dalam mode FIPS. Mode ini mewajibkan Sandi Utama harus diisi.
forms-master-pw-fips-desc = Sandi Gagal Diubah

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Untuk membuat Sandi Utama, masukkan kredensial info masuk Windows Anda. Hal ini membantu melindungi keamanan akun Anda.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Waterfox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = membuat Sandi Utama
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Riwayat

# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Waterfox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Waterfox history settings:".
history-remember-label = { -brand-short-name }
    .accesskey = i

history-remember-option-all =
    .label = akan mengingat data riwayat
history-remember-option-never =
    .label = tidak akan mengingat data riwayat
history-remember-option-custom =
    .label = akan menggunakan pengaturan khusus untuk data riwayat

history-remember-description = { -brand-short-name } akan mengingat penjelajahan, unduhan, formulir, dan riwayat pencarian Anda.
history-dontremember-description = { -brand-short-name } akan menggunakan pengaturan seperti halnya pengaturan mode penjelajahan pribadi dan tidak akan menyimpan riwayat apa pun ketika Anda menjelajah Web.

history-private-browsing-permanent =
    .label = Selalu gunakan mode penjelajahan pribadi
    .accesskey = p

history-remember-browser-option =
    .label = Ingat riwayat penjelajahan dan unduhan
    .accesskey = r

history-remember-search-option =
    .label = Simpan riwayat pencarian dan isian form
    .accesskey = i

history-clear-on-close-option =
    .label = Hapus riwayat saat { -brand-short-name } ditutup
    .accesskey = H

history-clear-on-close-settings =
    .label = Pengaturan…
    .accesskey = P

history-clear-button =
    .label = Hapus riwayat…
    .accesskey = r

## Privacy Section - Site Data

sitedata-header = Kuki dan Data Situs

sitedata-total-size-calculating = Menghitung ukuran data situs dan tembolok…

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Kuki, data situs tersimpan, dan tembolok Anda saat ini menggunakan ruang penyimpanan { $value } { $unit }.

sitedata-learn-more = Pelajari lebih lanjut

sitedata-delete-on-close =
    .label = Hapus kuki dan data situs ketika { -brand-short-name } ditutup
    .accesskey = H

sitedata-delete-on-close-private-browsing = Pada mode penjelajahan pribadi yang permanen, kuki dan data situs akan selalu dibersihkan saat { -brand-short-name } ditutup.

sitedata-allow-cookies-option =
    .label = Terima kuki dan data situs
    .accesskey = T

sitedata-disallow-cookies-option =
    .label = Blokir kuki dan data situs
    .accesskey = B

# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Tipe yang diblokir
    .accesskey = T

sitedata-option-block-cross-site-trackers =
    .label = Pelacak lintas situs
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Pelacak lintas situs dan media sosial
sitedata-option-block-cross-site-tracking-cookies-including-social-media =
    .label = Kuki pelacak lintas situs — juga termasuk kuki media sosial
sitedata-option-block-cross-site-cookies-including-social-media =
    .label = Kuki lintas situs — juga termasuk kuki media sosial
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Pelacak media sosial dan lintas situs, dan mengisolasi kuki tersisa
sitedata-option-block-unvisited =
    .label = Kuki dari situs yang tidak dikunjungi
sitedata-option-block-all-third-party =
    .label = Semua kuki pihak ketiga (dapat menyebabkan kerusakan situs)
sitedata-option-block-all =
    .label = Semua kuki (akan menyebabkan kerusakan situs)

sitedata-clear =
    .label = Hapus Data…
    .accesskey = H

sitedata-settings =
    .label = Kelola Data
    .accesskey = K

sitedata-cookies-exceptions =
    .label = Kelola Pengecualian…
    .accesskey = K

## Privacy Section - Address Bar

addressbar-header = Bilah Alamat

addressbar-suggest = Saat menggunakan bilah alamat, sarankan

addressbar-locbar-history-option =
    .label = Riwayat penjelajahan
    .accesskey = R
addressbar-locbar-bookmarks-option =
    .label = Markah
    .accesskey = M
addressbar-locbar-openpage-option =
    .label = Tab terbuka
    .accesskey = T
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = Pintasan
    .accesskey = P
addressbar-locbar-topsites-option =
    .label = Situs teratas
    .accesskey = T

addressbar-locbar-engines-option =
    .label = Mesin pencari
    .accesskey = p

addressbar-suggestions-settings = Ubah pengaturan untuk saran mesin pencari

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Perlindungan Pelacakan yang Ditingkatkan

content-blocking-section-top-level-description = Pelacak mengikuti Anda berkeliling daring untuk mengumpulkan informasi tentang kebiasaan dan minat penelusuran Anda. { -brand-short-name } memblokir banyak pelacak dan skrip jahat lainnya.

content-blocking-learn-more = Pelajari Lebih Lanjut

content-blocking-fpi-incompatibility-warning = Anda menggunakan First Party Isolation (FPI), yang menimpa beberapa pengaturan kuki { -brand-short-name }.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Standar
    .accesskey = S
enhanced-tracking-protection-setting-strict =
    .label = Ketat
    .accesskey = K
enhanced-tracking-protection-setting-custom =
    .label = Ubahsuai
    .accesskey = U

##

content-blocking-etp-standard-desc = Seimbang untuk perlindungan dan kinerja. Halaman akan dimuat secara normal.
content-blocking-etp-strict-desc = Perlindungan yang lebih kuat, tetapi dapat menyebabkan beberapa situs atau konten rusak.
content-blocking-etp-custom-desc = Pilih pelacak dan skrip yang akan diblokir.

content-blocking-etp-blocking-desc = { -brand-short-name } memblokir yang berikut:

content-blocking-private-windows = Melacak konten di Jendela Pribadi
content-blocking-cross-site-cookies-in-all-windows = Kuki lintas situs di semua jendela (termasuk kuki pelacakan)
content-blocking-cross-site-tracking-cookies = Kuki pelacakan lintas situs
content-blocking-all-cross-site-cookies-private-windows = Kuki lintas situs di Jendela Pribadi
content-blocking-cross-site-tracking-cookies-plus-isolate = Kuki pelacak lintas situs, dan isolasi kuki tersisa
content-blocking-social-media-trackers = Pelacak media sosial
content-blocking-all-cookies = Semua kuki
content-blocking-unvisited-cookies = Kuki dari situs yang belum dikunjungi
content-blocking-all-windows-tracking-content = Melacak konten di seluruh jendela
content-blocking-all-third-party-cookies = Semua kuki pihak ketiga
content-blocking-cryptominers = Penambang Kripto
content-blocking-fingerprinters = Pelacak Sidik

content-blocking-warning-title = Perhatian!
content-blocking-and-isolating-etp-warning-description = Memblokir pelacak dan mengisolasi kuki dapat memengaruhi fungsionalitas beberapa situs. Muat ulang laman dengan pelacak untuk memuat semua konten.
content-blocking-and-isolating-etp-warning-description-2 = Pengaturan ini mungkin menyebabkan beberapa situs web tidak menampilkan konten atau bekerja dengan baik. Jika situs rusak, Anda mungkin ingin menonaktifkan perlindungan pelacakan untuk situs tersebut untuk memuat semua konten.
content-blocking-warning-learn-how = Pelajari caranya

content-blocking-reload-description = Anda harus memuat ulang tab Anda untuk menerapkan perubahan ini.
content-blocking-reload-tabs-button =
    .label = Muat Ulang Semua Tab
    .accesskey = M

content-blocking-tracking-content-label =
    .label = Pelacakan konten
    .accesskey = P
content-blocking-tracking-protection-option-all-windows =
    .label = Di semua jendela
    .accesskey = s
content-blocking-option-private =
    .label = Hanya di Jendela Pribadi
    .accesskey = H
content-blocking-tracking-protection-change-block-list = Ubah daftar blokir

content-blocking-cookies-label =
    .label = Kuki
    .accesskey = K

content-blocking-expand-section =
    .tooltiptext = Keterangan lebih lanjut

# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Penambang Kripto
    .accesskey = P

# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Pelacak Sidik
    .accesskey = P

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Kelola Pengecualian…
    .accesskey = P

## Privacy Section - Permissions

permissions-header = Hak Akses

permissions-location = Lokasi
permissions-location-settings =
    .label = Setelan…
    .accesskey = t

permissions-xr = Realitas Virtual
permissions-xr-settings =
    .label = Pengaturan…
    .accesskey = P

permissions-camera = Kamera
permissions-camera-settings =
    .label = Setelan…
    .accesskey = t

permissions-microphone = Mikrofon
permissions-microphone-settings =
    .label = Setelan…
    .accesskey = t

permissions-notification = Notifikasi
permissions-notification-settings =
    .label = Setelan…
    .accesskey = t
permissions-notification-link = Pelajari lebih lanjut

permissions-notification-pause =
    .label = Jeda notifikasi hingga { -brand-short-name } dimulai ulang
    .accesskey = J

permissions-autoplay = Putar Otomatis

permissions-autoplay-settings =
    .label = Pengaturan...
    .accesskey = t

permissions-block-popups =
    .label = Blokir jendela pop-up
    .accesskey = B

permissions-block-popups-exceptions =
    .label = Pengecualian…
    .accesskey = e

permissions-addon-install-warning =
    .label = Ingatkan ketika situs web mencoba memasang pengaya
    .accesskey = I

permissions-addon-exceptions =
    .label = Pengecualian…
    .accesskey = P

## Privacy Section - Data Collection

collection-header = Pengumpulan dan Penggunaan Data { -brand-short-name }

collection-description = Kami berusaha memberi Anda pilihan dan mengumpulkan hanya apa yang kami butuhkan untuk menyediakan dan meningkatkan { -brand-short-name } bagi semua orang. Kami selalu meminta izin sebelum menerima informasi pribadi.
collection-privacy-notice = Pemberitahuan Privasi

collection-health-report-telemetry-disabled = Anda tidak lagi mengizinkan { -vendor-short-name } untuk menangkap data teknis dan interaksi. Semua data sebelumnya akan dihapus dalam waktu 30 hari.
collection-health-report-telemetry-disabled-link = Pelajari lebih lanjut

collection-health-report =
    .label = Izinkan { -brand-short-name } mengirim data teknis dan interaksi ke { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Pelajari Lebih Lanjut

collection-studies =
    .label = Izinkan { -brand-short-name } untuk memasang dan menjalankan kajian
collection-studies-link = Lihat kajian { -brand-short-name }

addon-recommendations =
    .label = Memungkinkan { -brand-short-name } membuat rekomendasi ekstensi pribadi.
addon-recommendations-link = Pelajari lebih lanjut

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Pelaporan data dinonaktifkan untuk konfigurasi build ini

collection-backlogged-crash-reports-with-link = Izinkan { -brand-short-name } mengirim laporan kerusakan sebelumnya atas nama Anda <a data-l10n-name="crash-reports-link">Pelajari lebih lanjut</a>
    .accesskey = l

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Keamanan

security-browsing-protection = Perlindungan Konten Penipuan dan Perangkat Lunak Berbahaya

security-enable-safe-browsing =
    .label = Blokir konten berbahaya dan tidak dapat dipercaya
    .accesskey = B
security-enable-safe-browsing-link = Pelajari lebih lanjut

security-block-downloads =
    .label = Blokir unduhan berbahaya
    .accesskey = u

security-block-uncommon-software =
    .label = Ingatkan mengenai perangkat lunak yang tidak diinginkan dan tidak umum
    .accesskey = I

## Privacy Section - Certificates

certs-header = Sertifikat

certs-enable-ocsp =
    .label = Kueri server penjawab OCSP untuk mengonfirmasikan validitas sertifikat
    .accesskey = v

certs-view =
    .label = Tampilkan Sertifikat…
    .accesskey = S

certs-devices =
    .label = Peranti Keamanan…
    .accesskey = P

space-alert-over-5gb-settings-button =
    .label = Buka Pengaturan
    .accesskey = B

space-alert-over-5gb-message2 = <strong>{ -brand-short-name } kehabisan ruang disk.</strong> Konten situs web mungkin tidak dapat tampil secara tepat. Anda dapat membersihkan data tersimpan dalam Pengaturan > Privasi & Keamanan > Kuki dan Data Situs.

space-alert-under-5gb-message2 = <strong>{ -brand-short-name } kehabisan ruang disk.</strong> Konten situs barangkali tidak dapat ditampilkan dengan tepat. Kunjungi “Pelajari Lebih Lanjut” untuk mengoptimalkan penggunaan disk Anda untuk pengalaman penjelajahan yang lebih baik.

## Privacy Section - HTTPS-Only

httpsonly-header = Mode Hanya HTTPS

httpsonly-description = HTTPS menyediakan koneksi yang aman, terenkripsi antara { -brand-short-name } dan situs web yang Anda kunjungi. Kebanyakan situs web mendukung HTTPS, dan jika Mode Hanya HTTPS diaktifkan, maka { -brand-short-name } akan meningkatkan semua koneksi ke HTTPS.

httpsonly-learn-more = Pelajari lebih lanjut

httpsonly-radio-enabled =
    .label = Aktifkan Mode Hanya HTTPS di semua jendela

httpsonly-radio-enabled-pbm =
    .label = Aktifkan Mode Hanya HTTPS di jendela pribadi saja

httpsonly-radio-disabled =
    .label = Jangan aktifkan Mode Hanya HTTPS

## The following strings are used in the Download section of settings

desktop-folder-name = Desktop
downloads-folder-name = Unduhan
choose-download-folder-title = Pilih Folder Unduhan:

# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Simpan berkas ke { $service-name }
