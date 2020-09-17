# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## File Menu

menu-file =
    .label = Fail
    .accesskey = F
menu-file-new-tab =
    .label = Tab Baru
    .accesskey = T
menu-file-new-container-tab =
    .label = Tab Penyimpan Baru
    .accesskey = B
menu-file-new-window =
    .label = Tetingkap Baru
    .accesskey = B
menu-file-new-private-window =
    .label = Tetingkap Peribadi Baru
    .accesskey = T
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Buka Lokasi…
menu-file-open-file =
    .label = Buka Fail…
    .accesskey = B
menu-file-close =
    .label = Tutup
    .accesskey = T
menu-file-close-window =
    .label = Tutup Tetingkap
    .accesskey = u
menu-file-save-page =
    .label = Simpan Halaman Sebagai…
    .accesskey = H
menu-file-email-link =
    .label = Pautan E-mel…
    .accesskey = E
menu-file-print-setup =
    .label = Penetapan Halaman…
    .accesskey = t
menu-file-print-preview =
    .label = Previu Cetakan
    .accesskey = v
menu-file-print =
    .label = Cetak…
    .accesskey = C
menu-file-go-offline =
    .label = Kerja Luar Talian
    .accesskey = K

## Edit Menu

menu-edit =
    .label = Edit
    .accesskey = E
menu-edit-find-on =
    .label = Cari dalam Halaman Ini…
    .accesskey = C
menu-edit-find-again =
    .label = Cari Lagi
    .accesskey = g
menu-edit-bidi-switch-text-direction =
    .label = Tukar Hala Teks
    .accesskey = u

## View Menu

menu-view =
    .label = Papar
    .accesskey = p
menu-view-toolbars-menu =
    .label = Bar alatan
    .accesskey = B
menu-view-customize-toolbar =
    .label = Penyesuaian…
    .accesskey = P
menu-view-sidebar =
    .label = Bar sisi
    .accesskey = B
menu-view-bookmarks =
    .label = Tandabuku
menu-view-history-button =
    .label = Sejarah
menu-view-synced-tabs-sidebar =
    .label = Tab Sync
menu-view-full-zoom =
    .label = Zum
    .accesskey = Z
menu-view-full-zoom-enlarge =
    .label = Zum Masuk
    .accesskey = M
menu-view-full-zoom-reduce =
    .label = Zum Keluar
    .accesskey = K
menu-view-full-zoom-toggle =
    .label = Zum Teks Sahaja
    .accesskey = T
menu-view-page-style-menu =
    .label = Gaya Halaman
    .accesskey = y
menu-view-page-style-no-style =
    .label = Tiada Gaya
    .accesskey = d
menu-view-page-basic-style =
    .label = Gaya Halaman Asas
    .accesskey = a
menu-view-charset =
    .label = Pengekodan Teks
    .accesskey = n

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Masuk Skrin Penuh
    .accesskey = P
menu-view-exit-full-screen =
    .label = Keluar Skrin Penuh
    .accesskey = K
menu-view-full-screen =
    .label = Skrin Penuh
    .accesskey = S

##

menu-view-show-all-tabs =
    .label = Papar Semua Tab
    .accesskey = P
menu-view-bidi-switch-page-direction =
    .label = Tukar Hala Halaman
    .accesskey = H

## History Menu

menu-history =
    .label = Sejarah
    .accesskey = j
menu-history-show-all-history =
    .label = Papar Semua Sejarah
menu-history-clear-recent-history =
    .label = Buang Sejarah Terkini…
menu-history-synced-tabs =
    .label = Tab Sync
menu-history-restore-last-session =
    .label = Pulih Sesi Dahulu
menu-history-hidden-tabs =
    .label = Tab Tersorok
menu-history-undo-menu =
    .label = Tab Terkini Ditutup
menu-history-undo-window-menu =
    .label = Tetingkap Terkini Ditutup

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Tandabuku
    .accesskey = B
menu-bookmarks-show-all =
    .label = Papar Semua Tandabuku
menu-bookmark-this-page =
    .label = Tandabuku Halaman Ini
menu-bookmark-edit =
    .label = Edit Tandabuku Ini
menu-bookmarks-all-tabs =
    .label = Tandabuku Semua Tab…
menu-bookmarks-toolbar =
    .label = Bar alatan Tandabuku
menu-bookmarks-other =
    .label = Tandabuku Lain
menu-bookmarks-mobile =
    .label = Tandabuku Telefon

## Tools Menu

menu-tools =
    .label = Alatan
    .accesskey = A
menu-tools-downloads =
    .label = Muat turun
    .accesskey = M
menu-tools-addons =
    .label = Add-ons
    .accesskey = A
menu-tools-sync-now =
    .label = Sync Sekarang
    .accesskey = S
menu-tools-web-developer =
    .label = Pembangun Web
    .accesskey = W
menu-tools-page-source =
    .label = Sumber Halaman
    .accesskey = u
menu-tools-page-info =
    .label = Info Halaman
    .accesskey = I
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Pilihan
           *[other] Keutamaan
        }
    .accesskey =
        { PLATFORM() ->
            [windows] h
           *[other] n
        }
menu-tools-layout-debugger =
    .label = Penyahpepijat Susun Atur
    .accesskey = S

## Window Menu

menu-window-menu =
    .label = Tetingkap
menu-window-bring-all-to-front =
    .label = Bawa Semua ke Hadapan

## Help Menu

menu-help =
    .label = Bantuan
    .accesskey = B
menu-help-product =
    .label = Bantuan { -brand-shorter-name }
    .accesskey = B
menu-help-show-tour =
    .label = Teroka { -brand-shorter-name }
    .accesskey = o
menu-help-keyboard-shortcuts =
    .label = Pintasan Papan Kekunci
    .accesskey = K
menu-help-troubleshooting-info =
    .label = Maklumat Pencarisilapan
    .accesskey = P
menu-help-feedback-page =
    .label = Hantar Maklum balas…
    .accesskey = H
menu-help-safe-mode-without-addons =
    .label = Mula semula dengan Add-ons Dinyahdayakan…
    .accesskey = M
menu-help-safe-mode-with-addons =
    .label = Mula semula dengan Add-ons Didayakan
    .accesskey = M
# Label of the Help menu item. Either this or
# safeb.palm.notdeceptive.label from
# phishing-afterload-warning-message.dtd is shown.
menu-help-report-deceptive-site =
    .label = Laporkan laman yang mengelirukan…
    .accesskey = m
menu-help-not-deceptive =
    .label = Ini bukan laman mengelirukan…
    .accesskey = m
