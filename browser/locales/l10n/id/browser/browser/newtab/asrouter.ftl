# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Rekomendasi Ekstensi
cfr-doorhanger-feature-heading = Fitur yang Direkomendasikan
cfr-doorhanger-pintab-heading = Coba Yang Ini: Sematkan Tab

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Mengapa saya melihat ini?
cfr-doorhanger-extension-cancel-button = Jangan Sekarang
    .accesskey = J
cfr-doorhanger-extension-ok-button = Tambahkan Sekarang
    .accesskey = T
cfr-doorhanger-pintab-ok-button = Sematkan Tab Ini
    .accesskey = S
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
cfr-doorhanger-pintab-description = Dapatkan akses mudah ke situs yang paling sering Anda gunakan. Jaga agar situs tetap terbuka di tab (bahkan saat Anda memuat ulang).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Klik kanan</b> pada tab yang ingin Anda sematkan.
cfr-doorhanger-pintab-step2 = Pilih <b>Sematkan Tab</b> dari menu.
cfr-doorhanger-pintab-step3 = Jika situs  diperbarui, akan ada titik biru pada tab yang Anda sematkan.
cfr-doorhanger-pintab-animation-pause = Jeda
cfr-doorhanger-pintab-animation-resume = Lanjutkan

## Firefox Accounts Message

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
cfr-whatsnew-panel-header = Yang Baru
cfr-whatsnew-release-notes-link-text = Baca catatan rilis
cfr-whatsnew-fx70-title = { -brand-short-name } kini berjuang lebih keras untuk privasi Anda
cfr-whatsnew-fx70-body =
    Pembaruan terbaru meningkatkan fitur Perlindungan Pelacakan dan membuatnya
    lebih mudah dari sebelumnya untuk membuat kata sandi aman untuk setiap situs.
cfr-whatsnew-tracking-protect-title = Lindungi diri Anda dari para pelacak
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } memblokir banyak pelacak sosial dan lintas situs umum yang
    mengikuti kegiatan daring Anda.
cfr-whatsnew-tracking-protect-link-text = Lihat Laporan Anda
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
       *[other] Pelacak diblokir
    }
cfr-whatsnew-tracking-blocked-subtitle = Sejak { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Lihat Laporan
cfr-whatsnew-lockwise-backup-title = Cadangkan kata sandi Anda
cfr-whatsnew-lockwise-backup-body = Kini buat kata sandi aman yang dapat diakses di mana saja Anda masuk.
cfr-whatsnew-lockwise-backup-link-text = Aktifkan pencadangan
cfr-whatsnew-lockwise-take-title = Bawa sandi ke mana Anda pergi
cfr-whatsnew-lockwise-take-body = Aplikasi seluler { -lockwise-brand-short-name } memungkinkan Anda mengakses cadangan kata sandi Anda dari mana saja.
cfr-whatsnew-lockwise-take-link-text = Dapatkan aplikasinya

## Search Bar

cfr-whatsnew-searchbar-title = Ketik lebih sedikit, temukan lebih banyak, dengan bilah alamat
cfr-whatsnew-searchbar-body-topsites = Kini cukup pilih bilah alamat dan sebuah kotak akan membentang yang berisi tautan ke situs teratas Anda.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = Ikon kaca pembesar

## Picture-in-Picture

cfr-whatsnew-pip-header = Tonton video sambil menjelajah
cfr-whatsnew-pip-body = Fitur gambar dalam gambar menampilkan video dalam jendela mengambang agar Anda bisa bekerja di tab lainnya.
cfr-whatsnew-pip-cta = Pelajari lebih lanjut

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Lebih sedikit pop-up situs yang mengganggu
cfr-whatsnew-permission-prompt-body = Kini { -brand-shorter-name } memblokir situs agar tidak secara otomatis meminta Anda mengirim pesan pop-up.
cfr-whatsnew-permission-prompt-cta = Pelajari lebih lanjut

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
       *[other] Pelacak Sidik diblokir
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } memblokir banyak pelacak sidik yang diam-diam mengumpulkan informasi tentang perangkat dan tindakan Anda untuk membuat profil iklan tentang Anda.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Pelacak Sidik
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } bisa memblokir pelacak sidik yang diam-diam mengumpulkan informasi tentang perangkat dan tindakan Anda untuk membuat profil iklan tentang Anda.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Dapatkan markah ini di ponsel Anda
cfr-doorhanger-sync-bookmarks-body = Bawa markah, kata sandi, riwayat dan lainnya di mana pun Anda masuk ke { -brand-product-name }
cfr-doorhanger-sync-bookmarks-ok-button = Aktifkan { -sync-brand-short-name }
    .accesskey = A

## Login Sync

cfr-doorhanger-sync-logins-header = Jangan Pernah Kehilangan Kata Sandi Lagi
cfr-doorhanger-sync-logins-body = Simpan dan sinkronkan kata sandi Anda dengan aman ke semua peranti Anda.
cfr-doorhanger-sync-logins-ok-button = Aktifkan { -sync-brand-short-name }
    .accesskey = A

## Send Tab

cfr-doorhanger-send-tab-header = Baca ini saat bepergian
cfr-doorhanger-send-tab-recipe-header = Bawa resep ini ke dapur
cfr-doorhanger-send-tab-body = Fitur Kirim Tab dapat Anda gunakan untuk membagikan tautan ini dengan mudah ke ponsel atau di mana saja Anda masuk ke { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Coba Kirim Tab
    .accesskey = K

## Firefox Send

cfr-doorhanger-firefox-send-header = Bagikan PDF ini dengan aman
cfr-doorhanger-firefox-send-body = Jaga dokumen rahasia Anda dari pengintip dengan menggunakan penyandian ujung-ke-ujung dan tautan yang menghilang saat sudah selesai.
cfr-doorhanger-firefox-send-ok-button = Coba { -send-brand-name }
    .accesskey = C

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Tampilkan Proteksi
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = Tutup
    .accesskey = T
cfr-doorhanger-socialtracking-dont-show-again = Jangan tampilkan pesan seperti ini lagi
    .accesskey = J
cfr-doorhanger-socialtracking-heading = { -brand-short-name } menghentikan sebuah jejaring sosial melacak Anda di sini
cfr-doorhanger-socialtracking-description = Privasi Anda sangatlah penting. { -brand-short-name } sekarang memblokir pelacak media sosial umum, dengan membatasi jumlah data yang dapat mereka kumpulkan tentang semua yang Anda lakukan saat daring.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } memblokir pelacak sidik pada laman ini
cfr-doorhanger-fingerprinters-description = Privasi Anda penting. Kini { -brand-short-name } sekarang memblokir pelacak sidik, yang mengumpulkan informasi unik teridentifikasi tentang perangkat untuk melacak Anda.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } memblokir penambang kripto pada laman ini
cfr-doorhanger-cryptominers-description = Privasi Anda penting. { -brand-short-name } sekarang memblokir penambang kripto, yang menggunakan daya komputasi sistem Anda untuk menambang uang digital.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] { -brand-short-name } telah memblokir lebih dari <b>{ $blockedCount }</b> pelacak sejak { $date }!
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] { -brand-short-name } memblokir lebih dari <b>{ $blockedCount }</b> pelacak sejak { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = Lihat Semua
    .accesskey = L

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Mudahnya membuat kata sandi aman
cfr-whatsnew-lockwise-body = Sulit untuk memikirkan kata sandi unik dan aman untuk setiap akun. Saat membuat kata sandi, pilih bidang kata sandi untuk menggunakan kata sandi aman yang dibuat dari { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Ikon { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Dapatkan peringatan tentang kata sandi yang rentan
cfr-whatsnew-passwords-body = Peretas tahu orang menggunakan kembali kata sandi yang sama. Jika Anda menggunakan kata sandi yang sama di beberapa situs, dan salah satu situs tersebut melanggar data, Anda akan melihat peringat di { -lockwise-brand-short-name } untuk mengubah kata sandi di situs-situs tersebut.
cfr-whatsnew-passwords-icon-alt = Ikon kunci kata sandi yang rentan

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Buat tayangan gambar-dalam-gambar menjadi layar penuh
cfr-whatsnew-pip-fullscreen-body = Saat Anda menjadikan video sebagai jendela mengambang, sekarang Anda dapat mengeklik ganda jendelanya agar memenuhi layar.
cfr-whatsnew-pip-fullscreen-icon-alt = Ikon gambar-dalam-gambar

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = Tutup
    .accesskey = T

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = Sekilas tentang perlindungan
cfr-whatsnew-protections-body = Dasbor Perlindungan mencakup ringkasan laporan tentang pelanggaran data dan manajemen kata sandi. Anda sekarang dapat melacak berapa banyak pelanggaran yang Anda selesaikan, dan melihat apakah ada kata sandi Anda yang tersimpan mungkin terekspos dalam pelanggaran data.
cfr-whatsnew-protections-cta-link = Tampilkan Dasbor Perlindungan
cfr-whatsnew-protections-icon-alt = Ikon perisai

## Better PDF message

cfr-whatsnew-better-pdf-header = Pengalaman PDF yang lebih baik
cfr-whatsnew-better-pdf-body = Dokumen PDF kini dapat dibuka langsung di { -brand-short-name }, membuat alur kerja Anda menjadi mudah.

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

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Perlindungan otomatis dari taktik pelacakan licik
cfr-whatsnew-clear-cookies-body = Beberapa pelacak mengarahkan Anda ke situs web lain yang secara diam-diam mengatur kuki. Kini { -brand-short-name } menghapus kuki tersebut secara otomatis sehingga Anda tidak dapat diikuti.
cfr-whatsnew-clear-cookies-image-alt = Ilustrasi kuki yang diblokir

## What's new: Media controls message

cfr-whatsnew-media-keys-header = Kontrol media lainnya
cfr-whatsnew-media-keys-body = Putar dan jeda audio atau video langsung dari papan ketik atau headset Anda, sehingga mudah untuk mengontrol media dari tab atau program lain, atau bahkan ketika komputer Anda terkunci. Anda juga dapat berpindah antara trek dengan menggunakan tombol maju dan mundur.
cfr-whatsnew-media-keys-button = Pelajari caranya

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = Pintasan pencarian di bilah alamat
cfr-whatsnew-search-shortcuts-body = Sekarang, ketika Anda mengetikkan mesin pencari atau situs tertentu ke dalam bilah alamat, pintasan biru akan muncul dalam saran pencarian di bawah. Pilih pintasan untuk menyelesaikan pencarian Anda langsung dari bilah alamat.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = Perlindungan dari superkuki yang berbahaya
cfr-whatsnew-supercookies-body = Situs web dapat menyimpan "superkuki" secara rahasia ke peramban Anda yang dapat mengikuti Anda di Web, bahkan setelah Anda membersihkan kuki. { -brand-short-name } sekarang menyediakan perlindungan yang kuat atas superkuki sehingga mereka tidak dapat digunakan untuk melacak aktivitas daring Anda dari satu situs ke situs lainnya.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = Markah yang lebih baik
cfr-whatsnew-bookmarking-body = Lebih mudah melacak situs favorit Anda. { -brand-short-name } kini mengingat lokasi yang diinginkan untuk markah tersimpan, menampilkan bilah markah secara baku di tab baru, dan memudahkan akses ke seluruh markah melalui folder bilah alat.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = Perlindungan menyeluruh dari pelacakan kuki lintas situs
cfr-whatsnew-cross-site-tracking-body = Kini Anda dapat memilih perlindungan yang lebih baik dari pelacakan kuki. { -brand-short-name } dapat mengisolasi aktivitas dan data situs tempat Anda berada sekarang sehingga informasi yang tersimpan di peramban tidak dibagikan di antara situs web.

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Video pada situs ini mungkin tidak dapat diputar dengan benar dalam versi { -brand-short-name } ini. Untuk dukungan video penuh, perbarui { -brand-short-name } sekarang.
cfr-doorhanger-video-support-header = Perbarui { -brand-short-name } untuk memutar video
cfr-doorhanger-video-support-primary-button = Perbarui Sekarang
    .accesskey = u
