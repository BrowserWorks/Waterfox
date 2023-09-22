# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

toolbar-button-firefox-view =
    .label = { -firefoxview-brand-name }
    .tooltiptext = { -firefoxview-brand-name }
menu-tools-firefox-view =
    .label = { -firefoxview-brand-name }
    .accesskey = F
firefoxview-page-title = { -firefoxview-brand-name }
firefoxview-close-button =
    .title = Tutup
    .aria-label = Tutup
# Used instead of the localized relative time when a timestamp is within a minute or so of now
firefoxview-just-now-timestamp = Baru saja
# This is a headline for an area in the product where users can resume and re-open tabs they have previously viewed on other devices.
firefoxview-tabpickup-header = Pengambilan tab
firefoxview-tabpickup-description = Buka laman dari perangkat lain
# Variables:
#  $percentValue (Number): the percentage value for setup completion
firefoxview-tabpickup-progress-label = { $percentValue }% selesai
firefoxview-tabpickup-step-signin-header = Beralih antara perangkat dengan mulus
firefoxview-tabpickup-step-signin-description = Untuk mengambil tab ponsel Anda di sini, masuk terlebih dahulu atau buat akun.
firefoxview-tabpickup-step-signin-primarybutton = Lanjutkan
firefoxview-syncedtabs-signin-primarybutton = Masuk atau daftar
firefoxview-tabpickup-adddevice-header = Sinkronkan { -brand-product-name } di ponsel atau tablet Anda
firefoxview-tabpickup-adddevice-description = Unduh { -brand-product-name } untuk ponsel dan masuk di sana.
firefoxview-tabpickup-adddevice-learn-how = Pelajari caranya
firefoxview-tabpickup-adddevice-primarybutton = Dapatkan { -brand-product-name } untuk ponsel
firefoxview-syncedtabs-adddevice-header = Masuk ke { -brand-product-name } pada perangkat lainnya
firefoxview-syncedtabs-adddevice-primarybutton = Coba { -brand-product-name } untuk ponsel
firefoxview-tabpickup-synctabs-header = Aktifkan sinkronisasi tab
firefoxview-tabpickup-synctabs-description = Izinkan { -brand-short-name } untuk membagikan tab antar perangkat.
firefoxview-tabpickup-synctabs-learn-how = Pelajari caranya
firefoxview-tabpickup-synctabs-primarybutton = Sinkronkan tab terbuka
firefoxview-syncedtabs-synctabs-header = Perbarui pengaturan sinkronisasi Anda
firefoxview-syncedtabs-synctabs-checkbox = Izinkan tab terbuka untuk disinkronkan
firefoxview-tabpickup-fxa-admin-disabled-header = Organisasi Anda telah menonaktifkan sinkronisasi
firefoxview-tabpickup-fxa-admin-disabled-description = { -brand-short-name } tidak dapat menyinkronkan tab antar perangkat karena administrator Anda telah menonaktifkan sinkronisasi.
firefoxview-tabpickup-network-offline-header = Periksa koneksi Internet Anda
firefoxview-tabpickup-network-offline-description = Jika Anda menggunakan firewall atau proksi, periksa apakah { -brand-short-name } memiliki izin untuk mengakses web.
firefoxview-tabpickup-network-offline-primarybutton = Coba lagi
firefoxview-tabpickup-sync-error-header = Kami mengalami kesulitan untuk menyinkronkan
firefoxview-tabpickup-generic-sync-error-description = { -brand-short-name } tidak dapat menjangkau layanan sinkronisasi saat ini. Coba lagi dalam beberapa saat.
firefoxview-tabpickup-sync-error-primarybutton = Coba lagi
firefoxview-tabpickup-sync-disconnected-header = Aktifkan sinkronisasi untuk melanjutkan
firefoxview-tabpickup-sync-disconnected-description = Untuk mengambil tab Anda, Anda perlu mengizinkan sinkronisasi di { -brand-short-name }.
firefoxview-tabpickup-sync-disconnected-primarybutton = Aktifkan sinkronisasi di pengaturan
firefoxview-tabpickup-password-locked-header = Masukkan Sandi Utama Anda untuk melihat tab
firefoxview-tabpickup-password-locked-description = Untuk mengambil tab Anda, Anda harus memasukkan Sandi Utama untuk { -brand-short-name }.
firefoxview-tabpickup-password-locked-link = Pelajari lebih lanjut
firefoxview-tabpickup-password-locked-primarybutton = Masukkan Sandi Utama
firefoxview-tabpickup-signed-out-header = Masuk untuk menghubungkan ulang
firefoxview-tabpickup-signed-out-description = Untuk menyambungkan ulang dan mengambil tab Anda, masuk ke { -fxaccount-brand-name } Anda.
firefoxview-tabpickup-signed-out-primarybutton = Masuk
firefoxview-tabpickup-syncing = Duduklah dengan tenang saat tab Anda disinkronkan. Tunggu sebentar.
firefoxview-mobile-promo-header = Ambil tab dari ponsel atau tablet Anda
firefoxview-mobile-promo-description = Untuk melihat tab seluler terbaru, masuk ke { -brand-product-name } di iOS atau Android.
firefoxview-mobile-promo-primarybutton = Dapatkan { -brand-product-name } untuk ponsel
firefoxview-mobile-confirmation-header = 🎉 Semua sudah siap!
firefoxview-mobile-confirmation-description = Sekarang Anda dapat mengambil tab { -brand-product-name } dari tablet atau ponsel Anda.
firefoxview-closed-tabs-title = Baru saja ditutup
firefoxview-closed-tabs-description2 = Buka kembali laman yang Anda tutup pada jendela ini.
firefoxview-closed-tabs-placeholder-header = Tidak ada tab yang baru saja ditutup
firefoxview-closed-tabs-placeholder-body = Ketika Anda menutup tab di jendela ini, Anda dapat mengambilnya dari sini.
firefoxview-closed-tabs-placeholder-body2 = Ketika Anda menutup tab, Anda dapat mengambilnya dari sini.
# Variables:
#   $tabTitle (string) - Title of tab being dismissed
firefoxview-closed-tabs-dismiss-tab =
    .title = Tutup { $tabTitle }
# refers to the last tab that was used
firefoxview-pickup-tabs-badge = Terakhir aktif
# Variables:
#   $targetURI (string) - URL that will be opened in the new tab
firefoxview-tabs-list-tab-button =
    .title = Buka { $targetURI } di tab baru
firefoxview-try-colorways-button = Coba ragam warna
firefoxview-change-colorway-button = Ubah ragam warna
# Variables:
#  $intensity (String): Colorway intensity
#  $collection (String): Colorway Collection name
firefoxview-colorway-description = { $intensity } · { $collection }
firefoxview-synced-tabs-placeholder-header = Belum ada yang bisa dilihat
firefoxview-synced-tabs-placeholder-body = Lain kali jika Anda membuka laman di { -brand-product-name } pada perangkat lain, ambil di sini seperti sulap.
firefoxview-collapse-button-show =
    .title = Tampilkan daftar
firefoxview-collapse-button-hide =
    .title = Sembunyikan daftar

## History in this context refers to browser history

firefoxview-history-nav = Riwayat
    .title = Riwayat
firefoxview-history-header = Riwayat
firefoxview-history-context-delete = Hapus dari Riwayat
    .accesskey = H

## Open Tabs in this context refers to all open tabs in the browser

firefoxview-opentabs-nav = Tab terbuka
    .title = Tab terbuka
firefoxview-opentabs-header = Tab terbuka

## Recently closed tabs in this context refers to recently closed tabs from all windows


## Tabs from other devices refers in this context refers to synced tabs from other devices

firefoxview-synced-tabs-nav = Tab dari perangkat lain
    .title = Tab dari perangkat lain
firefoxview-synced-tabs-header = Tab dari perangkat lain

##

# Used for a link in collapsible cards, in the ’Recent browsing’ page of Waterfox View
firefoxview-view-all-link = Tampilkan semua
# Variables:
#   $winID (Number) - The index of the owner window for this set of tabs
firefoxview-opentabs-window-header =
    .title = Jendela { $winID }
firefoxview-opentabs-focus-tab =
    .title = Pindah ke tab ini
firefoxview-show-more = Tampilkan lebih banyak
firefoxview-show-less = Tampilkan lebih sedikit
firefoxview-sort-history-by-date-label = Urut berdasarkan tanggal
firefoxview-sort-history-by-site-label = Urut berdasarkan situs

## Variables:
##   $date (string) - Date to be formatted based on locale


##


## Message displayed in Waterfox View when the user has no history data


##

# Button text for choosing a browser within the ’Import history from another browser’ banner
firefoxview-choose-browser-button = Pilih peramban
    .title = Pilih peramban

## Message displayed in Waterfox View when the user has chosen to never remember History


##

# This label is read by screen readers when focusing the close button for the "Import history from another browser" banner in Waterfox View
firefoxview-import-history-close-button =
    .aria-label = Tutup
    .title = Tutup

## Text displayed in a dismissable banner to import bookmarks/history from another browser

firefoxview-import-history-header = Impor riwayat dari peramban lainnya

## Message displayed in Waterfox View when the user has no recently closed tabs data


##


## This message is displayed below the name of another connected device when it doesn't have any open tabs.

