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
    .data-title-private = { -brand-full-name } (Mode Penjelajahan Pribadi)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Mode Penjelajahan Pribadi)
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
    .data-title-private = { -brand-full-name } - (Mode Penjelajahan Pribadi)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Mode Penjelajahan Pribadi)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Tampilkan informasi situs

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Buka panel pesan pasang
urlbar-web-notification-anchor =
    .tooltiptext = Mengubah apakah Anda dapat menerima pemberitahuan dari situs ini
urlbar-midi-notification-anchor =
    .tooltiptext = Buka panel MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Kelola penggunaan perangkat lunak DRM
urlbar-web-authn-anchor =
    .tooltiptext = Panel Autentikasi Web Terbuka
urlbar-canvas-notification-anchor =
    .tooltiptext = Kelola izin ekstraksi canvas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Mengelola berbagi mikrofon Anda dengan situs ini
urlbar-default-notification-anchor =
    .tooltiptext = Buka panel pesan
urlbar-geolocation-notification-anchor =
    .tooltiptext = Buka panel permintaan lokasi
urlbar-xr-notification-anchor =
    .tooltiptext = Buka panel perizinan realitas virtual
urlbar-storage-access-anchor =
    .tooltiptext = Buka panel perizinan aktivitas penjelajahan
urlbar-translate-notification-anchor =
    .tooltiptext = Terjemahkan laman ini
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Mengelola berbagi laman atau layar Anda dengan situs ini
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Buka panel pesan penyimpanan luring
urlbar-password-notification-anchor =
    .tooltiptext = Buka panel pesan penyimpanan sandi
urlbar-translated-notification-anchor =
    .tooltiptext = Kelola terjemahan laman
urlbar-plugins-notification-anchor =
    .tooltiptext = Kelola penggunaan plug-in
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Mengelola berbagi kamera dan atau mikrofon Anda dengan situs ini
urlbar-autoplay-notification-anchor =
    .tooltiptext = Buka panel putar-otomatis
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Simpan data di Penyimpanan Persisten
urlbar-addons-notification-anchor =
    .tooltiptext = Buka panel pesan pemasangan pengaya
urlbar-tip-help-icon =
    .title = Dapatkan bantuan
urlbar-search-tips-confirm = Oke, Paham
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Kiat:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Ketik lebih sedikit, temukan lebih banyak: Pencarian { $engineName } langsung dari bilah alamat Anda.
urlbar-search-tips-redirect-2 = Mulai pencarian Anda di bilah alat untuk melihat saran dari { $engineName } dan riwayat penjelajahan Anda.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Markah
urlbar-search-mode-tabs = Tab
urlbar-search-mode-history = Riwayat

##

urlbar-geolocation-blocked =
    .tooltiptext = Anda telah memblokir informasi lokasi untuk situs web ini.
urlbar-xr-blocked =
    .tooltiptext = Anda telah memblokir akses perangkat realitas virtual untuk situs web ini.
urlbar-web-notifications-blocked =
    .tooltiptext = Anda telah memblokir notifikasi untuk situs web ini.
urlbar-camera-blocked =
    .tooltiptext = Anda telah memblokir kamera Anda untuk situs web ini.
urlbar-microphone-blocked =
    .tooltiptext = Anda telah memblokir mikrofon Anda untuk situs web ini.
urlbar-screen-blocked =
    .tooltiptext = Anda telah memblokir situs ini untuk berbagi layar Anda.
urlbar-persistent-storage-blocked =
    .tooltiptext = Anda telah memblokir penyimpanan tetap untuk situs web ini.
urlbar-popup-blocked =
    .tooltiptext = Anda telah memblokir pop-up untuk situs web ini.
urlbar-autoplay-media-blocked =
    .tooltiptext = Anda telah memblokir media putar-otomatis dengan suara untuk situs web ini.
urlbar-canvas-blocked =
    .tooltiptext = Anda telah memblokir ekstraksi data canvas untuk situs web ini.
urlbar-midi-blocked =
    .tooltiptext = Anda telah memblokir akses MIDI untuk situs web ini.
urlbar-install-blocked =
    .tooltiptext = Anda telah memblokir pemasangan pengaya untuk situs Web ini.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Edit markah ini ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Markahi laman ini ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Tambahkan ke Bilah Alamat
page-action-manage-extension =
    .label = Kelola Ekstensi…
page-action-remove-from-urlbar =
    .label = Singkirkan dari Bilah Alamat
page-action-remove-extension =
    .label = Hapus Ekstensi

## Auto-hide Context Menu

full-screen-autohide =
    .label = Sembunyikan Bilah Alat
    .accesskey = S
full-screen-exit =
    .label = Keluar dari Mode Layar Penuh
    .accesskey = P

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Kali ini, cari dengan:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Ubah Pengaturan Pencarian
search-one-offs-change-settings-compact-button =
    .tooltiptext = Ubah setelan pencarian
search-one-offs-context-open-new-tab =
    .label = Cari di Tab Baru
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = Setel sebagai Mesin Pencari Baku
    .accesskey = B
search-one-offs-context-set-as-default-private =
    .label = Jadikan sebagai Mesin Pencari Baku untuk Jendela Pribadi
    .accesskey = P
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = Markah ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Tab ({ $restrict })
search-one-offs-history =
    .tooltiptext = Riwayat ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Tampilkan editor saat menyimpan
    .accesskey = e
bookmark-panel-done-button =
    .label = Selesai
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Sambungan tidak aman
identity-connection-secure = Sambungan aman
identity-connection-internal = Ini adalah laman { -brand-short-name } aman.
identity-connection-file = Laman ini tersimpan di komputer Anda.
identity-extension-page = Laman ini dimuat dari ekstensi.
identity-active-blocked = { -brand-short-name } telah memblokir bagian dari laman ini yang tidak aman.
identity-custom-root = Koneksi diverifikasi oleh penerbit sertifikat yang tidak dikenali oleh Mozilla.
identity-passive-loaded = Bagian dari laman ini tidak aman (misalnya, gambar).
identity-active-loaded = Anda telah menonaktifkan perlindungan di laman ini.
identity-weak-encryption = Laman ini menggunakan enkripsi lemah.
identity-insecure-login-forms = Info masuk yang dimasukkan di laman ini bisa diketahui orang lain.
identity-permissions =
    .value = Izin
identity-permissions-reload-hint = Anda mungkin perlu memuat ulang laman untuk menerapkan perubahan.
identity-permissions-empty = Anda belum memberikan izin khusus apa pun untuk situs ini.
identity-clear-site-data =
    .label = Hapus Kuki dan Data Situs…
identity-connection-not-secure-security-view = Anda tidak terhubung dengan aman ke situs ini.
identity-connection-verified = Anda terhubung dengan aman ke situs ini.
identity-ev-owner-label = Sertifikat diterbitkan untuk:
identity-description-custom-root = Mozilla tidak mengenali penerbit sertifikat ini. Itu mungkin telah ditambahkan dari sistem operasi Anda atau oleh administrator. <label data-l10n-name="link">Pelajari Lebih Lanjut</label>
identity-remove-cert-exception =
    .label = Buang Pengecualian
    .accesskey = B
identity-description-insecure = Sambungan Anda ke laman ini tidak pribadi. Informasi yang Anda kirim dapat dilihat oleh pihak lain (misalnya, sandi, pesan, kartu kredit, dll.).
identity-description-insecure-login-forms = Info masuk yang Anda masukkan di laman ini tidak aman dan bisa diketahui orang lain.
identity-description-weak-cipher-intro = Sambungan Anda ke situs web ini menggunakan enkripsi lemah dan tidak pribadi.
identity-description-weak-cipher-risk = Orang lain dapat melihat informasi Anda atau memodifikasi perilaku situs web ini.
identity-description-active-blocked = { -brand-short-name } telah memblokir bagian dari laman ini yang tidak aman. <label data-l10n-name="link">Pelajari Lebih Lanjut</label>
identity-description-passive-loaded = Sambungan Anda tidak pribadi dan informasi yang Anda bagikan dengan situs ini dapat dilihat oleh pihak lain.
identity-description-passive-loaded-insecure = Situs web ini mengandung konten yang tidak aman (misalnya, gambar). <label data-l10n-name="link">Pelajari Lebih Lanjut</label>
identity-description-passive-loaded-mixed = Meskipun { -brand-short-name } telah memblokir sejumlah konten, tetapi masih ada konten di laman ini yang tidak aman (misalnya gambar). <label data-l10n-name="link">Pelajari Lebih Lanjut</label>
identity-description-active-loaded = Situs web ini mengandung konten yang tidak aman (misalnya skrip) dan sambungan Anda tidak pribadi.
identity-description-active-loaded-insecure = Informasi yang Anda bagikan dengan situs ini dapat dilihat oleh pihak lain (misalnya sandi, pesan, kartu kredit, dll.)
identity-learn-more =
    .value = Pelajari Lebih Lanjut
identity-disable-mixed-content-blocking =
    .label = Nonaktifkan perlindungan untuk saat ini
    .accesskey = N
identity-enable-mixed-content-blocking =
    .label = Aktifkan perlindungan
    .accesskey = A
identity-more-info-link-text =
    .label = Informasi Lebih Lanjut

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minikan
browser-window-maximize-button =
    .tooltiptext = Besarkan
browser-window-restore-down-button =
    .tooltiptext = Kembali ke Bawah
browser-window-close-button =
    .tooltiptext = Tutup

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Kamera untuk dibagikan:
    .accesskey = K
popup-select-microphone =
    .value = Mikrofon untuk dibagikan:
    .accesskey = M
popup-all-windows-shared = Semua jendela yang terlihat pada layar Anda akan dibagikan.
popup-screen-sharing-not-now =
    .label = Jangan Sekarang
    .accesskey = J
popup-screen-sharing-never =
    .label = Jangan Pernah Izinkan
    .accesskey = N
popup-silence-notifications-checkbox = Nonaktifkan pemberitahuan dari { -brand-short-name } ketika berbagi
popup-silence-notifications-checkbox-warning = { -brand-short-name } tidak akan menampilkan pemberitahuan saat Anda berbagi.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Anda membagikan { -brand-short-name }. Orang lain dapat melihat saat Anda beralih ke tab baru.
sharing-warning-screen = Anda membagikan seluruh layar Anda. Orang lain dapat melihat saat Anda beralih ke tab baru.
sharing-warning-proceed-to-tab =
    .label = Lanjutkan ke Tab
sharing-warning-disable-for-session =
    .label = Nonaktifkan perlindungan berbagi untuk sesi ini.

## DevTools F12 popup

enable-devtools-popup-description = Untuk menggunakan pintasan F12, pertama buka DevTools melalui menu Pengembang Web.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Cari atau masukkan alamat
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Cari atau masukkan alamat
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Cari di Web
    .aria-label = Cari lewat { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Masukkan istilah pencarian
    .aria-label = Cari di { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Masukan istilah pencarian
    .aria-label = Cari markah
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Masukan istilah pencarian
    .aria-label = Cari riwayat
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Masukkan istilah pencarian
    .aria-label = Cari tab
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Cari lewat { $name } atau masukkan alamat
urlbar-remote-control-notification-anchor =
    .tooltiptext = Peramban dalam kendali jarak jauh
urlbar-permissions-granted =
    .tooltiptext = Anda telah memberikan izin tambahan kepada situs web ini.
urlbar-switch-to-tab =
    .value = Pindah ke tab:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Ekstensi:
urlbar-go-button =
    .tooltiptext = Pindah ke alamat di Bilah Lokasi
urlbar-page-action-button =
    .tooltiptext = Tindakan laman
urlbar-pocket-button =
    .tooltiptext = Simpan ke { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> sekarang dalam layar penuh
fullscreen-warning-no-domain = Sekarang dokumen ini dalam layar penuh
fullscreen-exit-button = Keluar dari Layar Penuh (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Keluar dari Layar Penuh (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> memiliki kendali atas penunjuk Anda. Tekan Esc untuk mengembalikan kendali.
pointerlock-warning-no-domain = Dokumen ini memiliki kendali atas pointer Anda. Tekan Esc untuk mengambil kembali kendali.
