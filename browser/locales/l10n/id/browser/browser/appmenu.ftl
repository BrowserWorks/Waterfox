# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-update-banner3 =
    .label-update-downloading = Mengunduh pembaruan { -brand-shorter-name }
    .label-update-available = Pembaruan tersedia — unduh sekarang
    .label-update-manual = Pembaruan tersedia — unduh sekarang
    .label-update-unsupported = Pembaruan tersedia — sistem tidak kompatibel
    .label-update-restart = Pembaruan tersedia — mulai ulang sekarang
appmenuitem-protection-dashboard-title = Dasbor Perlindungan
appmenuitem-new-tab =
    .label = Tab Baru
appmenuitem-new-window =
    .label = Jendela Baru
appmenuitem-new-private-window =
    .label = Jendela Mode Pribadi Baru
appmenuitem-history =
    .label = Riwayat
appmenuitem-downloads =
    .label = Unduhan
appmenuitem-passwords =
    .label = Kata Sandi
appmenuitem-addons-and-themes =
    .label = Pengaya dan Tema
appmenuitem-print =
    .label = Cetak…
appmenuitem-find-in-page =
    .label = Temukan di Halaman…
appmenuitem-zoom =
    .value = Perbesaran
appmenuitem-more-tools =
    .label = Alat Lainnya
appmenuitem-help =
    .label = Bantuan
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] Keluar
           *[other] Keluar
        }
appmenu-menu-button-closed2 =
    .tooltiptext = Buka Menu Aplikasi
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = Tutup Menu Aplikasi
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = Pengaturan

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = Perbesar
appmenuitem-zoom-reduce =
    .label = Perkecil
appmenuitem-fullscreen =
    .label = Layar Penuh

## Waterfox Account toolbar button and Sync panel in App menu.

appmenu-remote-tabs-sign-into-sync =
    .label = Masuk ke Sinkronisasi…
appmenu-remote-tabs-turn-on-sync =
    .label = Aktifkan Sinkronisasi…
# This is shown after the tabs list if we can display more tabs by clicking on the button
appmenu-remote-tabs-showmore =
    .label = Tampilkan Tab Lainnya
    .tooltiptext = Tampilkan lebih banyak dari perangkat ini
# This is shown beneath the name of a device when that device has no open tabs
appmenu-remote-tabs-notabs = Tak ada tab terbuka
# This is shown when Sync is configured but syncing tabs is disabled.
appmenu-remote-tabs-tabsnotsyncing = Aktifkan sinkronisasi tab untuk melihat daftar tab dari perangkat Anda lainnya.
# This is shown when Sync is configured but this appears to be the only device attached to
# the account. We also show links to download Waterfox for android/ios.
appmenu-remote-tabs-noclients = Ingin melihat tab dari perangkat Anda yang lain di sini?
appmenu-remote-tabs-connectdevice =
    .label = Sambungkan Perangkat Lainnya
appmenu-remote-tabs-welcome = Lihat daftar tab dari perangkat Anda lainnya.
appmenu-remote-tabs-unverified = Akun Anda perlu diverifikasi.
appmenuitem-fxa-toolbar-sync-now2 = Sinkronkan Sekarang
appmenuitem-fxa-sign-in = Masuk ke { -brand-product-name }
appmenuitem-fxa-manage-account = Kelola Akun
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = Terakhir disinkronkan { $time }
    .label = Terakhir disinkronkan { $time }
appmenu-fxa-sync-and-save-data2 = Sinkronkan dan Simpan Data
appmenu-fxa-signed-in-label = Masuk
appmenu-fxa-setup-sync =
    .label = Aktifkan Sinkronisasi…
appmenu-fxa-show-more-tabs = Tampilkan Tab Lainnya
appmenuitem-save-page =
    .label = Simpan Laman dengan Nama…

## What's New panel in App menu.

whatsnew-panel-header = Yang Baru
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = Beri tahu tentang fitur baru
    .accesskey = f

## The Waterfox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-button-idle =
    .label = Profiler
    .tooltiptext = Rekam profil kinerja
profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = Tampilkan informasi lebih lanjut
profiler-popup-description-title =
    .value = Rekam, analisis, bagikan
profiler-popup-description = Berkolaborasi dalam masalah kinerja dengan mempublikasikan profil untuk dibagikan dengan tim Anda.
profiler-popup-learn-more = Pelajari lebih lanjut
profiler-popup-learn-more-button =
    .label = Pelajari lebih lanjut
profiler-popup-settings =
    .value = Pengaturan
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = Edit Pengaturan…
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings-button =
    .label = Edit Pengaturan…
profiler-popup-disabled = Profiler saat ini dimatikan, kemungkinan besar karena jendela Penjelajahan Pribadi terbuka.
profiler-popup-recording-screen = Merekam…
# The profiler presets list is generated elsewhere, but the custom preset is defined
# here only.
profiler-popup-presets-custom =
    .label = Khusus
profiler-popup-start-recording-button =
    .label = Mulai Rekam
profiler-popup-discard-button =
    .label = Buang
profiler-popup-capture-button =
    .label = Tangkap
profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Ctrl+Shift+1
    }
profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Ctrl+Shift+2
    }

## Profiler presets
## They are shown in the popup's select box.


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# Please take care that the same values are also defined in devtools' perftools.ftl.


## History panel

appmenu-manage-history =
    .label = Kelola Riwayat
appmenu-reopen-all-tabs = Buka Ulang Semua Tab
appmenu-reopen-all-windows = Buka Ulang Semua Jendela
appmenu-restore-session =
    .label = Pulihkan Sesi Sebelumnya
appmenu-clear-history =
    .label = Bersihkan Riwayat Terakhir
appmenu-recent-history-subheader = Riwayat Terakhir
appmenu-recently-closed-tabs =
    .label = Tab yang Baru Saja Ditutup
appmenu-recently-closed-windows =
    .label = Jendela yang Baru Saja Ditutup

## Help panel

appmenu-help-header =
    .title = Bantuan { -brand-shorter-name }
appmenu-about =
    .label = Tentang { -brand-shorter-name }
    .accesskey = T
appmenu-get-help =
    .label = Dapatkan Bantuan
    .accesskey = D
appmenu-help-more-troubleshooting-info =
    .label = Informasi Pemecahan Masalah Lebih Lanjut
    .accesskey = I
appmenu-help-report-site-issue =
    .label = Laporkan Masalah Situs…
appmenu-help-feedback-page =
    .label = Kirim Saran…
    .accesskey = S

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Mode Pemecahan Masalah…
    .accesskey = P
appmenu-help-exit-troubleshoot-mode =
    .label = Nonaktifkan Mode Pemecahan Masalah
    .accesskey = N

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Laporkan Situs Tipuan…
    .accesskey = s
appmenu-help-not-deceptive =
    .label = Ini bukan situs tipuan…
    .accesskey = d

## More Tools

appmenu-customizetoolbar =
    .label = Ubahsuai Bilah Alat…
appmenu-taskmanager =
    .label = Pengelola Tugas
appmenu-developer-tools-subheader = Alat Peramban
appmenu-developer-tools-extensions =
    .label = Ekstensi untuk Pengembang
