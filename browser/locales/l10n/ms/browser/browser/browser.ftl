# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (Pelayaran Peribadi)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Pelayaran Peribadi)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox - (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } - (Pelayaran Peribadi)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Pelayaran Peribadi)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Papar maklumat laman

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Buka panel mesej pemasangan
urlbar-web-notification-anchor =
    .tooltiptext = Tukar pilihan samada anda boleh menerima notifikasi dari laman
urlbar-midi-notification-anchor =
    .tooltiptext = Buka panel MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Urus penggunaan perisian DRM
urlbar-web-authn-anchor =
    .tooltiptext = Buka panel Pengesahan Web
urlbar-canvas-notification-anchor =
    .tooltiptext = Urus izin ekstrak kanvas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Urus perkongsian mikrofon anda dengan laman
urlbar-default-notification-anchor =
    .tooltiptext = Buka panel mesej
urlbar-geolocation-notification-anchor =
    .tooltiptext = Buka lokasi panel permintaan
urlbar-translate-notification-anchor =
    .tooltiptext = Terjemahkan halaman ini
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Urus perkongsian tetingkap atau skrin anda dengan laman
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Buka panel mesej storan luar talian
urlbar-password-notification-anchor =
    .tooltiptext = Buka panel mesej kata laluan disimpan
urlbar-translated-notification-anchor =
    .tooltiptext = Urus terjemahan halaman
urlbar-plugins-notification-anchor =
    .tooltiptext = Urus kegunaan plugin
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Urus perkongsian kamera dan/atau mikrofon anda dengan laman
urlbar-autoplay-notification-anchor =
    .tooltiptext = Buka panel automain
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Simpan data dalam Storan Kekal
urlbar-addons-notification-anchor =
    .tooltiptext = Buka panel mesej pemasangan add-on

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Taip sedikit, cari selanjutnya: Carian { $engineName } dari bar alamat anda.

## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = Anda telah menyekat maklumat lokasi untuk laman web ini.
urlbar-web-notifications-blocked =
    .tooltiptext = Anda telah menyekat notifikasi untuk laman web ini.
urlbar-camera-blocked =
    .tooltiptext = Anda telah menyekat kamera anda untuk laman web ini.
urlbar-microphone-blocked =
    .tooltiptext = Anda telah menyekat mikrofon anda untuk laman web ini.
urlbar-screen-blocked =
    .tooltiptext = Anda telah menyekat laman web ini daripada berkongsi skrin anda.
urlbar-persistent-storage-blocked =
    .tooltiptext = Anda telah menghalang storan gigih untuk laman web ini.
urlbar-popup-blocked =
    .tooltiptext = Anda telah menyekat pop-up untuk laman web ini.
urlbar-autoplay-media-blocked =
    .tooltiptext = Anda telah menyekat media automain dengan suara untuk laman web ini.
urlbar-canvas-blocked =
    .tooltiptext = Anda telah menyekat ekstraksi data kanvas untuk laman web ini.
urlbar-midi-blocked =
    .tooltiptext = Anda telah menyekat akses MIDI untuk laman web ini.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Edit tandabuku ini ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Tandabuku halaman Ini ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Tambah ke Bar Alamat
page-action-manage-extension =
    .label = Urus Ekstensi…
page-action-remove-from-urlbar =
    .label = Buang daripada Bar Alamat

## Auto-hide Context Menu

full-screen-autohide =
    .label = Sorok Bar Alatan
    .accesskey = B
full-screen-exit =
    .label = Keluar Mod Skrin Penuh
    .accesskey = K

## Search Engine selection buttons (one-offs)

# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Ubah Tetapan Carian
search-one-offs-change-settings-compact-button =
    .tooltiptext = Ubah tetapan carian
search-one-offs-context-open-new-tab =
    .label = Cari dalam Tab Baru
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = Tetapkan sebagai Enjin Carian Piawai
    .accesskey = P

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Papar editor apabila menyimpan
    .accesskey = P
bookmark-panel-done-button =
    .label = Siap
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-internal = Ini adalah halaman { -brand-short-name } yang selamat.
identity-connection-file = Halaman ini disimpan dalam komputer anda.
identity-extension-page = Halaman ini dimuatkan dari ekstensi.
identity-active-blocked = { -brand-short-name } telah menyekat sebahagian halaman ini yang tidak selamat.
identity-passive-loaded = Sebahagian halaman ini tidak selamat (contohnya imej).
identity-active-loaded = Anda telah menyahdayakan perlindungan untuk halaman ini.
identity-weak-encryption = Halaman ini menggunakan enkripsi yang lemah.
identity-insecure-login-forms = Log masuk yang dimasukkan dalam halaman ini boleh dikompromi.
identity-permissions-reload-hint = Anda mungkin perlu memuat semula halaman supaya perubahan ini dilaksanakan.
identity-permissions-empty = Anda tidak memberikan laman ini sebarang keizinan khas.
identity-clear-site-data =
    .label = Buang Kuki dan Data Laman…
identity-remove-cert-exception =
    .label = Buang Pengecualian
    .accesskey = B
identity-description-insecure = Sambungan anda ke laman ini adalah terbuka. Maklumat yang anda hantar mampu dilihat oleh orang lain (seperti kata laluan, mesej, kad kredit, dll.).
identity-description-insecure-login-forms = Maklumat log masuk yang anda masukkan dalam halaman ini tidak selamat dan boleh dikompromi.
identity-description-weak-cipher-intro = Sambungan anda ke laman web ini menggunakan enkripsi yang lemah dan bukan secara persendirian.
identity-description-weak-cipher-risk = Orang lain boleh melihat maklumat anda atau mengubah tingkah laku laman web.
identity-description-active-blocked = { -brand-short-name } telah menyekat sebahagian halaman ini yang tidak selamat. <label data-l10n-name="link">Ketahui Selanjutnya</label>
identity-description-passive-loaded = Sambungan anda adalah terbuka dan maklumat yang anda kongsi dengan halaman ini mampu dilihat oleh orang lain.
identity-description-passive-loaded-insecure = Laman web ini mengandungi kandungan yang tidak selamat (seperti imej). <label data-l10n-name="link">Ketahui Selanjutnya</label>
identity-description-passive-loaded-mixed = Walaupun { -brand-short-name } telah menyekat beberapa kandungan, masih ada kandungan pada halaman ini yang tidak selamat (seperti imej). <label data-l10n-name="link">Ketahui Selanjutnya</label>
identity-description-active-loaded = Laman web ini mengandungi kandungan yang tidak selamat (seperti skrip) dan sambungan anda kepadanya adalah terbuka.
identity-description-active-loaded-insecure = Maklumat yang anda kongsi dengan laman ini boleh dilihat oleh orang lain (seperti kata laluan, mesej, kad kredit, dll.).
identity-learn-more =
    .value = Ketahui Selanjutnya
identity-disable-mixed-content-blocking =
    .label = Nyahdayakan perlindungan buat masa ni
    .accesskey = N
identity-enable-mixed-content-blocking =
    .label = Dayakan perlindungan
    .accesskey = D
identity-more-info-link-text =
    .label = Maklumat Lanjut

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimum
browser-window-close-button =
    .tooltiptext = Tutup

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Kamera untuk dikongsi:
    .accesskey = K
popup-select-microphone =
    .value = Mikrofon untuk dikongsi:
    .accesskey = M
popup-all-windows-shared = Semua tetingkap yang kelihatan pada skrin anda akan dikongsi.

## WebRTC window or screen share tab switch warning


## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Cari atau masukkan alamat
urlbar-placeholder =
    .placeholder = Cari atau masukkan alamat
urlbar-remote-control-notification-anchor =
    .tooltiptext = Pelayar berada dalam kawalan jauh
urlbar-switch-to-tab =
    .value = Tukar ke tab:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Ekstensi:
urlbar-go-button =
    .tooltiptext = Pergi ke alamat dalam Bar Lokasi
urlbar-page-action-button =
    .tooltiptext = Tindakan halaman

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> kini skrin penuh
fullscreen-warning-no-domain = Dokumen ini skrin penuh
fullscreen-exit-button = Keluar dari Skrin Penuh (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Keluar dari Skrin Penuh (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> mempunyai kawalan ke atas penunjuk anda. Tekan Esc untuk mengambil kembali kawalan.
pointerlock-warning-no-domain = Dokumen ini mempunyai kawalan ke atas penunjuk anda. Tekan Esc untuk mengambil kembali kawalan.
