# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Rekomendasi Ekstensi
cfr-doorhanger-feature-heading = Fitur yang Direkomendasikan

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Mengapa saya melihat ini?
cfr-doorhanger-extension-cancel-button = Jangan Sekarang
    .accesskey = J
cfr-doorhanger-extension-ok-button = Tambahkan Sekarang
    .accesskey = T
cfr-doorhanger-extension-manage-settings-button = Kelola Pengaturan Rekomendasi
    .accesskey = K
cfr-doorhanger-extension-never-show-recommendation = Jangan Tampilkan Rekomendasi Ini
    .accesskey = T
cfr-doorhanger-extension-learn-more-link = Pelajari lebih lanjut
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = oleh { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Rekomendasi
cfr-doorhanger-extension-notification2 = Rekomendasi
    .tooltiptext = Rekomendasi ekstensi
    .a11y-announcement = Rekomendasi ekstensi tersedia
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Rekomendasi
    .tooltiptext = Rekomendasi fitur
    .a11y-announcement = Rekomendasi fitur tersedia

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
           *[other] { $total } bintang
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
       *[other] { $total } pengguna
    }

## Waterfox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Sinkronkan markah Anda di mana saja.
cfr-doorhanger-bookmark-fxa-body = Penemuan yang mantap! Sekarang jangan pergi tanpa markah ini di perangkat seluler Anda. Mulai dengan { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Sinkronkan markah sekarang…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Tombol tutup
    .title = T

## Protections panel

cfr-protections-panel-header = Menjelajah tanpa diikuti
cfr-protections-panel-body = Simpan data Anda untuk diri sendiri. { -brand-short-name } melindungi Anda dari banyak pelacak umum yang mengikuti apa yang Anda lakukan daring.
cfr-protections-panel-link-text = Pelajari lebih lanjut

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Fitur baru:
cfr-whatsnew-button =
    .label = Yang Baru
    .tooltiptext = Yang Baru
cfr-whatsnew-release-notes-link-text = Baca catatan rilis

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] { -brand-short-name } memblokir lebih dari <b>{ $blockedCount }</b> pelacak sejak { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = Lihat Semua
    .accesskey = L
cfr-doorhanger-milestone-close-button = Tutup
    .accesskey = T

## DOH Message

cfr-doorhanger-doh-body = Privasi Anda penting. { -brand-short-name } sekarang dengan aman merutekan permintaan DNS Anda bila memungkinkan ke layanan mitra untuk melindungi saat Anda menjelajah.
cfr-doorhanger-doh-header = Pencarian DNS yang lebih aman dan terenkripsi
cfr-doorhanger-doh-primary-button-2 = Oke
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Nonaktifkan
    .accesskey = D

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Privasi Anda penting. { -brand-short-name } sekarang mengisolasi (atau memasukkan ke kotak pasir) masing-masing situs, yang mempersulit peretas untuk mencuri kata sandi, nomor kartu kredit, dan informasi sensitif lainnya.
cfr-doorhanger-fission-header = Isolasi Situs
cfr-doorhanger-fission-primary-button = Oke, paham
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Pelajari lebih lanjut
    .accesskey = P

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Video pada situs ini mungkin tidak dapat diputar dengan benar dalam versi { -brand-short-name } ini. Untuk dukungan video penuh, perbarui { -brand-short-name } sekarang.
cfr-doorhanger-video-support-header = Perbarui { -brand-short-name } untuk memutar video
cfr-doorhanger-video-support-primary-button = Perbarui Sekarang
    .accesskey = u

## Spotlight modal shared strings

spotlight-learn-more-collapsed = Pelajari Lebih Lanjut
    .title = Buka untuk pempelajari fitur ini lebih lanjut
spotlight-learn-more-expanded = Pelajari lebih lanjut
    .title = Tutup

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Sepertinya Anda menggunakan Wi-Fi publik
spotlight-public-wifi-vpn-body = Untuk menyembunyikan lokasi dan aktivitas penjelajahan Anda, pertimbangkan Jaringan Pribadi Virtual (VPN). Ini akan membantu Anda tetap terlindungi saat menjelajah di tempat umum seperti bandara dan kedai kopi.
spotlight-public-wifi-vpn-primary-button = Tetap terjaga dengan { -mozilla-vpn-brand-name }
    .accesskey = T
spotlight-public-wifi-vpn-link = Jangan Sekarang
    .accesskey = J

## Total Cookie Protection Rollout

# "Test pilot" is used as a verb. Possible alternatives: "Be the first to try",
# "Join an early experiment". This header text can be explicitly wrapped.
spotlight-total-cookie-protection-header =
    Uji coba pengalaman privasi terkuat
    kami yang pernah ada
spotlight-total-cookie-protection-body = Perlindungan Kuki Total mencegah pelacak menggunakan kuki untuk menguntit Anda di web.
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch" as not everybody will get it yet.
spotlight-total-cookie-protection-expanded = { -brand-short-name } membangun pagar di sekitar kuki, dengan membatasi kuki di situs tempat Anda berada, sehingga pelacak tidak dapat menggunakannya untuk mengikuti Anda. Dengan akses awal, Anda akan membantu mengoptimalkan fitur ini agar kami dapat terus membangun web yang lebih baik untuk semua orang.
spotlight-total-cookie-protection-primary-button = Aktifkan Perlindungan Kuki Total
spotlight-total-cookie-protection-secondary-button = Jangan sekarang
cfr-total-cookie-protection-header = Berkat Anda, { -brand-short-name } menjadi lebih aman dan privat dari sebelumnya
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch". Only those who received it and accepted are shown this message.
cfr-total-cookie-protection-body = Perlindungan Kuki Total adalah perlindungan privasi terkuat kami - dan kini menjadi pengaturan baku bagi pengguna { -brand-short-name } di mana saja. Kami tidak dapat melakukannya tanpa peserta akses awal seperti Anda. Jadi, terima kasih telah membantu kami menciptakan Internet yang lebih baik dan lebih privat.

## Emotive Continuous Onboarding

spotlight-better-internet-header = Internet yang lebih baik dimulai dari Anda
spotlight-better-internet-body = Ketika Anda menggunakan { -brand-short-name }, Anda memilih Internet yang terbuka dan dapat diakses secara lebih baik untuk semua orang.
spotlight-peace-mind-header = Kami membantu Anda
spotlight-peace-mind-body = Setiap bulan, { -brand-short-name } memblokir rata-rata lebih dari 3000 pelacak per pengguna. Karena tidak ada yang bisa menghalangi antara Anda dengan Internet yang baik, terutama gangguan privasi seperti pelacak.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] Sematkan ke Dock
       *[other] Sematkan ke bilah tugas
    }
spotlight-pin-secondary-button = Jangan sekarang
