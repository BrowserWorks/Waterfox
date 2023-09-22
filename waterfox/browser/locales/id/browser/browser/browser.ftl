# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS.
# .data-title-default and .data-title-private are used when the web content
# opened has no title:
#
# default - "Waterfox"
# private - "Waterfox (Private Browsing)"
#
# .data-content-title-default and .data-content-title-private are for use when
# there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-window-titles =
    .data-title-default = { -brand-full-name }
    .data-title-private = Penjelajahan Pribadi { -brand-full-name }
    .data-content-title-default = { $content-title } — { -brand-full-name }
    .data-content-title-private = { $content-title } — Penjelajahan Pribadi { -brand-full-name }
# These are the default window titles on macOS.
# .data-title-default and .data-title-private are used when the web content
# opened has no title:
#
#
# "default" - "Waterfox"
# "private" - "Waterfox — (Private Browsing)"
#
# .data-content-title-default and .data-content-title-private are for use when
# there *is* a content title.
# Do not use the brand name in these, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac-window-titles =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } — Penjelajahan Pribadi
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } — Penjelajahan Pribadi
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }
# The non-variable portion of this MUST match the translation of
# "PRIVATE_BROWSING_SHORTCUT_TITLE" in custom.properties
private-browsing-shortcut-text-2 = Penjelajahan Pribadi { -brand-shortcut-name }

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
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Mengelola berbagi laman atau layar Anda dengan situs ini
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Buka panel pesan penyimpanan luring
urlbar-password-notification-anchor =
    .tooltiptext = Buka panel pesan penyimpanan sandi
urlbar-plugins-notification-anchor =
    .tooltiptext = Kelola penggunaan plug-in
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Mengelola berbagi kamera dan atau mikrofon Anda dengan situs ini
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
urlbar-web-rtc-share-speaker-notification-anchor =
    .tooltiptext = Kelola berbagi pengeras suara dengan situs ini
urlbar-autoplay-notification-anchor =
    .tooltiptext = Buka panel putar-otomatis
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Simpan data di Penyimpanan Persisten
urlbar-addons-notification-anchor =
    .tooltiptext = Buka panel pesan pemasangan pengaya
urlbar-tip-help-icon =
    .title = Dapatkan bantuan
urlbar-search-tips-confirm = Oke, Paham
urlbar-search-tips-confirm-short = Paham
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Kiat:
urlbar-result-menu-button =
    .title = Buka menu
urlbar-result-menu-button-feedback = Umpan Balik
    .title = Buka menu
urlbar-result-menu-learn-more =
    .label = Pelajari lebih lanjut
    .accesskey = P
urlbar-result-menu-remove-from-history =
    .label = Hapus dari riwayat
    .accesskey = r
urlbar-result-menu-tip-get-help =
    .label = Dapatkan bantuan
    .accesskey = b

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Ketik lebih sedikit, temukan lebih banyak: Pencarian { $engineName } langsung dari bilah alamat Anda.
urlbar-search-tips-redirect-2 = Mulai pencarian Anda di bilah alat untuk melihat saran dari { $engineName } dan riwayat penjelajahan Anda.
# Make sure to match the name of the Search panel in settings.
urlbar-search-tips-persist = Pencarian menjadi lebih sederhana. Coba buat pencarian Anda lebih spesifik di bilah alamat. Untuk menampilkan URL saja, kunjungi Pencarian, di pengaturan.
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Pilih pintasan ini untuk menemukan lebih cepat apa yang dibutuhkan.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Markah
urlbar-search-mode-tabs = Tab
urlbar-search-mode-history = Riwayat
urlbar-search-mode-actions = Aksi

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

page-action-manage-extension2 =
    .label = Kelola Ekstensi…
    .accesskey = E
page-action-remove-extension2 =
    .label = Hapus Ekstensi
    .accesskey = s

## Auto-hide Context Menu

full-screen-autohide =
    .label = Sembunyikan Bilah Alat
    .accesskey = S
full-screen-exit =
    .label = Keluar dari Mode Layar Penuh
    .accesskey = P

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = Kali ini, cari dengan:
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
# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = Tambahkan "{ $engineName }"
    .tooltiptext = Tambahkan mesin pencari "{ $engineName }"
    .aria-label = Tambahkan mesin pencari "{ $engineName }"
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = Tambah mesin pencari

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
search-one-offs-actions =
    .tooltiptext = Aksi ({ $restrict })

## QuickActions are shown in the urlbar as the user types a matching string
## The -cmd- strings are comma separated list of keywords that will match
## the action.

# Opens the about:addons page in the home / recommendations section
quickactions-addons = Tampilkan Pengaya
quickactions-cmd-addons2 = pengaya
# Opens the bookmarks library window
quickactions-bookmarks2 = Kelola markah
quickactions-cmd-bookmarks = markah
# Opens a SUMO article explaining how to clear history
quickactions-clearhistory = Bersihkan Riwayat
quickactions-cmd-clearhistory = bersihkan riwayat
# Opens about:downloads page
quickactions-downloads2 = Tampilkan unduhan
quickactions-cmd-downloads = unduhan
# Opens about:addons page in the extensions section
quickactions-extensions = Kelola ekstensi
quickactions-cmd-extensions = ekstensi
# Opens the devtools web inspector
quickactions-inspector2 = Buka Perangkat Pengembang
quickactions-cmd-inspector = inspektur, perangkat pengembang
# Opens about:logins
quickactions-logins2 = Kelola sandi
quickactions-cmd-logins = info masuk, kata sandi
# Opens about:addons page in the plugins section
quickactions-plugins = Kelola plugin
quickactions-cmd-plugins = plugin
# Opens the print dialog
quickactions-print2 = Cetak halaman
quickactions-cmd-print = cetak
# Opens a new private browsing window
quickactions-private2 = Buka jendela pribadi
quickactions-cmd-private = penjelajahan pribadi
# Opens a SUMO article explaining how to refresh
quickactions-refresh = Segarkan { -brand-short-name }
quickactions-cmd-refresh = segarkan
# Restarts the browser
quickactions-restart = Mulai Ulang { -brand-short-name }
quickactions-cmd-restart = mulai ulang
# Opens the screenshot tool
quickactions-screenshot3 = Ambil tangkapan layar
quickactions-cmd-screenshot = tangkapan layar
# Opens about:preferences
quickactions-settings2 = Kelola pengaturan
quickactions-cmd-settings = pengaturan, preferensi, pilihan
# Opens about:addons page in the themes section
quickactions-themes = Kelola tema
quickactions-cmd-themes = tema;themes;
# Opens a SUMO article explaining how to update the browser
quickactions-update = Perbarui { -brand-short-name }
quickactions-cmd-update = versi baru
# Opens the view-source UI with current pages source
quickactions-viewsource2 = Lihat Kode Sumber Laman
quickactions-cmd-viewsource = lihat kode sumber, sumber
# Tooltip text for the help button shown in the result.
quickactions-learn-more =
    .title = Pelajari lebih lanjut tentang Tindakan Cepat

## Bookmark Panel

bookmarks-add-bookmark = Tambah markah
bookmarks-edit-bookmark = Edit markah
bookmark-panel-cancel =
    .label = Batal
    .accesskey = B
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label = Hapus { $count } Markah
    .accesskey = H
bookmark-panel-show-editor-checkbox =
    .label = Tampilkan editor saat menyimpan
    .accesskey = e
bookmark-panel-save-button =
    .label = Simpan
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = Informasi Situs untuk { $host }
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = Keamanan Sambungan untuk { $host }
identity-connection-not-secure = Sambungan tidak aman
identity-connection-secure = Sambungan aman
identity-connection-failure = Sambungan gagal
identity-connection-internal = Ini adalah laman { -brand-short-name } aman.
identity-connection-file = Laman ini tersimpan di komputer Anda.
identity-extension-page = Laman ini dimuat dari ekstensi.
identity-active-blocked = { -brand-short-name } telah memblokir bagian dari laman ini yang tidak aman.
identity-custom-root = Koneksi diverifikasi oleh penerbit sertifikat yang tidak dikenali oleh BrowserWorks.
identity-passive-loaded = Bagian dari laman ini tidak aman (misalnya, gambar).
identity-active-loaded = Anda telah menonaktifkan perlindungan di laman ini.
identity-weak-encryption = Laman ini menggunakan enkripsi lemah.
identity-insecure-login-forms = Info masuk yang dimasukkan di laman ini bisa diketahui orang lain.
identity-https-only-connection-upgraded = (ditingkatkan ke HTTPS)
identity-https-only-label = Mode Hanya HTTPS
identity-https-only-dropdown-on =
    .label = Aktif
identity-https-only-dropdown-off =
    .label = Nonaktif
identity-https-only-dropdown-off-temporarily =
    .label = Nonaktif sementara
identity-https-only-info-turn-on2 = Nyalakan Mode HTTPS-Only untuk situs ini jika Anda ingin { -brand-short-name } meningkatkan sambungan bila memungkinkan.
identity-https-only-info-turn-off2 = Jika laman terlihat bermasalah, Anda mungkin ingin menonaktifkan Mode HTTPS-Only lalu memuat ulang situsnya dengan HTTP yang tidak aman.
identity-https-only-info-no-upgrade = Tidak dapat meningkatkan koneksi dari HTTP.
identity-permissions-storage-access-header = Kuki lintas situs
identity-permissions-storage-access-hint = Pihak berikut dapat menggunakan kuki lintas situs dan data situs saat Anda berada di situs ini.
identity-permissions-storage-access-learn-more = Pelajari lebih lanjut
identity-permissions-reload-hint = Anda mungkin perlu memuat ulang laman untuk menerapkan perubahan.
identity-clear-site-data =
    .label = Hapus Kuki dan Data Situs…
identity-connection-not-secure-security-view = Anda tidak terhubung dengan aman ke situs ini.
identity-connection-verified = Anda terhubung dengan aman ke situs ini.
identity-ev-owner-label = Sertifikat diterbitkan untuk:
identity-description-custom-root2 = BrowserWorks tidak mengenali penerbit sertifikat ini. Itu mungkin telah ditambahkan dari sistem operasi Anda atau oleh administrator.
identity-remove-cert-exception =
    .label = Buang Pengecualian
    .accesskey = B
identity-description-insecure = Sambungan Anda ke laman ini tidak pribadi. Informasi yang Anda kirim dapat dilihat oleh pihak lain (misalnya, sandi, pesan, kartu kredit, dll.).
identity-description-insecure-login-forms = Info masuk yang Anda masukkan di laman ini tidak aman dan bisa diketahui orang lain.
identity-description-weak-cipher-intro = Sambungan Anda ke situs web ini menggunakan enkripsi lemah dan tidak pribadi.
identity-description-weak-cipher-risk = Orang lain dapat melihat informasi Anda atau memodifikasi perilaku situs web ini.
identity-description-active-blocked2 = { -brand-short-name } telah memblokir bagian dari laman ini yang tidak aman.
identity-description-passive-loaded = Sambungan Anda tidak pribadi dan informasi yang Anda bagikan dengan situs ini dapat dilihat oleh pihak lain.
identity-description-passive-loaded-insecure2 = Situs web ini mengandung konten yang tidak aman (misalnya, gambar).
identity-description-passive-loaded-mixed2 = Meskipun { -brand-short-name } telah memblokir sejumlah konten, tetapi masih ada konten di laman ini yang tidak aman (misalnya gambar).
identity-description-active-loaded = Situs web ini mengandung konten yang tidak aman (misalnya skrip) dan sambungan Anda tidak pribadi.
identity-description-active-loaded-insecure = Informasi yang Anda bagikan dengan situs ini dapat dilihat oleh pihak lain (misalnya sandi, pesan, kartu kredit, dll.)
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

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = MEMUTAR
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = DISENYAPKAN
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = PUTAR OTOMATIS DIBLOKIR
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = GAMBAR DALAM GAMBAR

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] SENYAPKAN { $count } TAB
       *[other] S
    }
browser-tab-unmute =
    { $count ->
        [1] SUARAKAN { $count } TAB
       *[other] U
    }
browser-tab-unblock =
    { $count ->
        [1] PUTAR { $count } TAB
       *[other] P
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = Impor markah…
    .tooltiptext = Impor markah dari peramban lain ke { -brand-short-name }.
bookmarks-toolbar-empty-message = Untuk akses cepat, tempatkan markah Anda di sini pada bilah alat markah. <a data-l10n-name="manage-bookmarks">Kelola markah…</a>

## WebRTC Pop-up notifications

popup-select-camera-device =
    .value = Kamera:
    .accesskey = K
popup-select-camera-icon =
    .tooltiptext = Kamera
popup-select-microphone-device =
    .value = Mikrofon:
    .accesskey = M
popup-select-microphone-icon =
    .tooltiptext = Mikrofon
popup-select-speaker-icon =
    .tooltiptext = Pengeras suara
popup-select-window-or-screen =
    .label = Jendela atau layar:
    .accesskey = J
popup-all-windows-shared = Semua jendela yang terlihat pada layar Anda akan dibagikan.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Anda membagikan { -brand-short-name }. Orang lain dapat melihat saat Anda beralih ke tab baru.
sharing-warning-screen = Anda membagikan seluruh layar Anda. Orang lain dapat melihat saat Anda beralih ke tab baru.
sharing-warning-proceed-to-tab =
    .label = Lanjutkan ke Tab
sharing-warning-disable-for-session =
    .label = Nonaktifkan perlindungan berbagi untuk sesi ini.

## DevTools F12 popup

enable-devtools-popup-description2 = Untuk menggunakan pintasan F12, pertama-tama, buka DevTools melalui menu Alat Peramban.

## URL Bar

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
# This placeholder is used when searching quick actions.
urlbar-placeholder-search-mode-other-actions =
    .placeholder = Masukan istilah pencarian
    .aria-label = Cari aksi
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Cari lewat { $name } atau masukkan alamat
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = Browser berada di bawah kendali jarak jauh (alasan: { $component })
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

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = Cari lewat { $engine } di Jendela Pribadi
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = Cari di Jendela Pribadi
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = Cari lewat { $engine }
urlbar-result-action-sponsored = Bersponsor
urlbar-result-action-switch-tab = Pindah ke Tab
urlbar-result-action-visit = Kunjungi
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = Tekan Tab untuk mencari dengan { $engine }
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = Tekan Tab untuk mencari { $engine }
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = Cari dengan { $engine } langsung dari bilah alamat
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = Cari dengan { $engine } langsung dari bilah alamat
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = Salin
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = Cari Markah
urlbar-result-action-search-history = Cari di Riwayat
urlbar-result-action-search-tabs = Cari Tab
urlbar-result-action-search-actions = Cari Tindakan

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
    .label = { -firefox-suggest-brand-name }
# A label shown above the search suggestions group in the urlbar results. It
# should use sentence case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
    .label = Saran { $engine }
# A label shown above Quick Actions in the urlbar results.
urlbar-group-quickactions =
    .label = Tindakan Cepat

## Reader View toolbar buttons

# This should match menu-view-enter-readerview in menubar.ftl
reader-view-enter-button =
    .aria-label = Masuk ke Tampilan Baca
# This should match menu-view-close-readerview in menubar.ftl
reader-view-close-button =
    .aria-label = Tutup Tampilan Pembaca

## Picture-in-Picture urlbar button
## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

picture-in-picture-urlbar-button-open =
    .tooltiptext = Buka Gambar dalam Gambar ({ $shortcut })
picture-in-picture-urlbar-button-close =
    .tooltiptext = Tutup Gambar dalam Gambar ({ $shortcut })
picture-in-picture-panel-header = Gambar-dalam-Gambar
picture-in-picture-panel-headline = Situs web ini tidak merekomendasikan Gambar-dalam-Gambar
picture-in-picture-enable-toggle =
    .label = Tetap aktifkan

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

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = Kelola Markah
bookmarks-recent-bookmarks-panel-subheader = Markah Terbaru
bookmarks-toolbar-chevron =
    .tooltiptext = Tampilkan markah lainnya
bookmarks-sidebar-content =
    .aria-label = Markah
bookmarks-menu-button =
    .label = Menu Markah
bookmarks-other-bookmarks-menu =
    .label = Markah Lain
bookmarks-mobile-bookmarks-menu =
    .label = Markah Seluler

## Variables:
##   $isVisible (boolean): if the specific element (e.g. bookmarks sidebar,
##                         bookmarks toolbar, etc.) is visible or not.

bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] Sembunyikan Bilah Samping Markah
           *[other] Tampilkan Bilah Samping Markah
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] Sembunyikan Bilah Alat Markah
           *[other] Tampilkan Bilah Alat Markah
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] Sembunyikan Bilah Alat Markah
           *[other] Tampilkan Bilah Alat Markah
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] Hapus Menu Markah dari Bilah Alat
           *[other] Tambahkan Menu Markah ke Bilah Alat
        }

##

bookmarks-search =
    .label = Cari Markah
bookmarks-tools =
    .label = Alat Pemarkahan
bookmarks-subview-edit-bookmark =
    .label = Ubah markah ini…
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = Bilah Alat Markah
    .accesskey = B
    .aria-label = Markah
bookmarks-toolbar-menu =
    .label = Bilah Alat Markah
bookmarks-toolbar-placeholder =
    .title = Nama Markah
bookmarks-toolbar-placeholder-button =
    .label = Nama Markah
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-subview-bookmark-tab =
    .label = Markahi tab saat ini…

## Library Panel items

library-bookmarks-menu =
    .label = Markah
library-recent-activity-title =
    .value = Aktivitas Terkini

## Pocket toolbar button

save-to-pocket-button =
    .label = Simpan ke { -pocket-brand-name }
    .tooltiptext = Simpan ke { -pocket-brand-name }

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = Memperbaiki pengodean teks
    .tooltiptext = Menebak pengkodean teks yang benar dari isi halaman

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Pengaturan
    .tooltiptext =
        { PLATFORM() ->
            [macos] Buka pengaturan ({ $shortcut })
           *[other] Buka pengaturan
        }
toolbar-overflow-customize-button =
    .label = Ubahsuai Bilah Alat…
    .accesskey = U
toolbar-button-email-link =
    .label = Surelkan Tautan
    .tooltiptext = Surelkan tautan laman ini
toolbar-button-logins =
    .label = Sandi
    .tooltiptext = Lihat dan kelola sandi tersimpan Anda
# Variables:
#  $shortcut (String): keyboard shortcut to save a copy of the page
toolbar-button-save-page =
    .label = Simpan Laman
    .tooltiptext = Simpan laman ini ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open a local file
toolbar-button-open-file =
    .label = Buka Berkas
    .tooltiptext = Buka berkas ({ $shortcut })
toolbar-button-synced-tabs =
    .label = Tab yang Disinkronkan
    .tooltiptext = Tampilkan tab dari perangkat lain
# Variables
# $shortcut (string) - Keyboard shortcut to open a new private browsing window
toolbar-button-new-private-window =
    .label = Jendela Mode Pribadi Baru
    .tooltiptext = Buka jendela Penjelajahan Pribadi baru ({ $shortcut })

## EME notification panel

eme-notifications-drm-content-playing = Beberapa audio atau video pada situs ini menggunakan perangkat lunak DRM yang mungkin membatasi pemakaian Anda atas { -brand-short-name }.
eme-notifications-drm-content-playing-manage = Kelola Pengaturan
eme-notifications-drm-content-playing-manage-accesskey = K
eme-notifications-drm-content-playing-dismiss = Tutup
eme-notifications-drm-content-playing-dismiss-accesskey = T

## Password save/update panel

panel-save-update-username = Nama Pengguna
panel-save-update-password = Kata Sandi

##

# "More" item in macOS share menu
menu-share-more =
    .label = Lainnya…
ui-tour-info-panel-close =
    .tooltiptext = Tutup

## Variables:
##  $uriHost (String): URI host for which the popup was allowed or blocked.

popups-infobar-allow =
    .label = Izinkan pop-up untuk { $uriHost }
    .accesskey = i
popups-infobar-block =
    .label = Blokir pop-up untuk { $uriHost }
    .accesskey = i

##

popups-infobar-dont-show-message =
    .label = Jangan tampilkan pesan ini saat pop-up diblokir
    .accesskey = J
edit-popup-settings =
    .label = Kelola setelan pop-up…
    .accesskey = p
picture-in-picture-hide-toggle =
    .label = Sembunyikan Sakelar Gambar-dalam-Gambar
    .accesskey = S

## Since the default position for PiP controls does not change for RTL layout,
## right-to-left languages should use "Left" and "Right" as in the English strings,

picture-in-picture-move-toggle-right =
    .label = Pindahkan Tombol Pengalih Gambar-dalam-Gambar ke Sisi Kanan
    .accesskey = a
picture-in-picture-move-toggle-left =
    .label = Pindahkan Tombol Pengalih Gambar-dalam-Gambar ke Sisi Kiri
    .accesskey = i

##


# Navigator Toolbox

# This string is a spoken label that should not include
# the word "toolbar" or such, because screen readers already know that
# this container is a toolbar. This avoids double-speaking.
navbar-accessible =
    .aria-label = Navigasi
navbar-downloads =
    .label = Unduhan
navbar-overflow =
    .tooltiptext = Alat lainnya…
# Variables:
#   $shortcut (String): keyboard shortcut to print the page
navbar-print =
    .label = Cetak
    .tooltiptext = Cetak laman ini… ({ $shortcut })
navbar-home =
    .label = Beranda
    .tooltiptext = Beranda { -brand-short-name }
navbar-library =
    .label = Pustaka
    .tooltiptext = Lihat riwayat, markah tersimpan, dan lainnya
navbar-search =
    .title = Cari
# Name for the tabs toolbar as spoken by screen readers. The word
# "toolbar" is appended automatically and should not be included in
# in the string
tabs-toolbar =
    .aria-label = Tab peramban
tabs-toolbar-new-tab =
    .label = Tab Baru
tabs-toolbar-list-all-tabs =
    .label = Daftar tab
    .tooltiptext = Daftar tab

## Infobar shown at startup to suggest session-restore

# <img data-l10n-name="icon"/> will be replaced by the application menu icon
restore-session-startup-suggestion-message = <strong>Buka tab sebelumnya?</strong> Anda dapat memulihkan sesi sebelumnya dari menu aplikasi { -brand-short-name } <img data-l10n-name="icon"/>, di bawah menu Riwayat.
restore-session-startup-suggestion-button = Tunjukkan caranya

## BrowserWorks data reporting notification (Telemetry, Waterfox Health Report, etc)

data-reporting-notification-message = { -brand-short-name } mengirimkan beberapa jenis data ke { -vendor-short-name } agar kami dapat meningkatkan pengalaman Anda.
data-reporting-notification-button =
    .label = Pilih yang Saya Bagikan
    .accesskey = P
# Label for the indicator shown in the private browsing window titlebar.
private-browsing-indicator-label = Penjelajahan pribadi

## Unified extensions (toolbar) button

unified-extensions-button =
    .label = Ekstensi
    .tooltiptext = Ekstensi

## Unified extensions button when permission(s) are needed.
## Note that the new line is intentionally part of the tooltip.

unified-extensions-button-permissions-needed =
    .label = Ekstensi
    .tooltiptext =
        Ekstensi
        Izin dibutuhkan

## Unified extensions button when some extensions are quarantined.
## Note that the new line is intentionally part of the tooltip.

unified-extensions-button-quarantined =
    .label = Ekstensi
    .tooltiptext = Ekstensi

## Autorefresh blocker

refresh-blocked-refresh-label = { -brand-short-name } telah mencegah laman ini untuk otomatis dimuat ulang.
refresh-blocked-redirect-label = { -brand-short-name } telah mencegah laman ini untuk otomatis mengalihkan ke laman lain.
refresh-blocked-allow =
    .label = Izinkan
    .accesskey = I

## Waterfox Relay integration


## Add-on Pop-up Notifications

popup-notification-addon-install-unsigned =
    .value = (Belum Diverifikasi)
popup-notification-xpinstall-prompt-learn-more = Pelajari lebih lanjut tentang memasang pengaya dengan aman

## Pop-up warning

# Variables:
#   $popupCount (Number): the number of pop-ups blocked.
popup-warning-message = { -brand-short-name } telah mencegah situs ini untuk membuka { $popupCount } jendela pop-up.
# The singular form is left out for English, since the number of blocked pop-ups is always greater than 1.
# Variables:
#   $popupCount (Number): the number of pop-ups blocked.
popup-warning-exceeded-message = { -brand-short-name } mencegah situs ini membuka lebih dari { $popupCount } jendela pop-up.
popup-warning-button =
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
# Variables:
#   $popupURI (String): the URI for the pop-up window
popup-show-popup-menuitem =
    .label = Tampilkan “{ $popupURI }”
