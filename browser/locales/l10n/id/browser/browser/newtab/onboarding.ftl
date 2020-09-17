# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Pelajari Lebih Lanjut
onboarding-button-label-get-started = Bersiap

## Welcome modal dialog strings

onboarding-welcome-header = Selamat datang di { -brand-short-name }
onboarding-welcome-body = Anda telah mendapatkan perambannya. <br/>Temui lini produk { -brand-product-name } lainnya.
onboarding-welcome-learn-more = Pelajari lebih lanjut tentang manfaatnya.
onboarding-welcome-modal-get-body = Anda telah mendapatkan perambannya. <br/>Kini dapatkan yang terbaik dari { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Perkuat perlindungan privasi Anda.
onboarding-welcome-modal-privacy-body = Anda telah mendapatkan perambannya. Mari tambahkan perlindungan privasi lebih lengkap.
onboarding-welcome-modal-family-learn-more = Pelajari tentang rangkaian produk { -brand-product-name }.
onboarding-welcome-form-header = Mulai di sini
onboarding-join-form-body = Masukkan alamat surel Anda untuk memulai.
onboarding-join-form-email =
    .placeholder = Masukan surel
onboarding-join-form-email-error = Surel harus valid
onboarding-join-form-legal = Dengan melanjutkan, berarti Anda setuju dengan <a data-l10n-name="terms">Ketentuan Layanan</a> dan <a data-l10n-name="privacy">Pernyataan Privasi</a>.
onboarding-join-form-continue = Lanjut
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Sudah memiliki akun?
# Text for link to submit the sign in form
onboarding-join-form-signin = Masuk
onboarding-start-browsing-button-label = Mulai Menjelajah
onboarding-cards-dismiss =
    .title = Tutup
    .aria-label = Tutup

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Selamat datang di <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Peramban cepat, aman, dan pribadi yang didukung oleh nirlaba.
onboarding-multistage-welcome-primary-button-label = Mulai Penyiapan
onboarding-multistage-welcome-secondary-button-label = Masuk
onboarding-multistage-welcome-secondary-button-text = Sudah punya akun?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Impor kata sandi, markah, <br/>dan <span data-l10n-name="zap">yang lain</span>
onboarding-multistage-import-subtitle = Dari peramban lain? Mudah sekali membawa semuanya ke { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Mulai Impor
onboarding-multistage-import-secondary-button-label = Jangan sekarang
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Situs yang terdaftar di sini ditemukan di perangkat ini. { -brand-short-name } tidak menyimpan ataupun menyinkronkan data dari peramban lain kecuali Anda memilih untuk mengimpornya.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Memulai: layar { $current } dari { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Pilih <span data-l10n-name="zap">tampilan</span>
onboarding-multistage-theme-subtitle = Personalisasikan { -brand-short-name } dengan tema.
onboarding-multistage-theme-primary-button-label = Simpan Tema
onboarding-multistage-theme-secondary-button-label = Jangan sekarang
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Otomatis
# System refers to the operating system
onboarding-multistage-theme-description-automatic = Gunakan tema sistem
onboarding-multistage-theme-label-light = Terang
onboarding-multistage-theme-label-dark = Gelap
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title =
        Mengikuti tampilan dari sistem operasi
        Anda untuk tombol, menu, dan jendela.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title =
        Gunakan tampilan cerah untuk
        tombol, menu, dan jendela.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title =
        Gunakan tampilan gelap untuk
        tombol, menu, dan jendela.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title =
        Gunakan tampilan berwarna untuk
        tombol, menu, dan jendela.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Mengikuti tampilan dari sistem operasi
        Anda untuk tombol, menu, dan jendela.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Mengikuti tampilan dari sistem operasi
        Anda untuk tombol, menu, dan jendela.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Gunakan tampilan cerah untuk
        tombol, menu, dan jendela.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Gunakan tampilan cerah untuk
        tombol, menu, dan jendela.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Gunakan tampilan gelap untuk
        tombol, menu, dan jendela.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Gunakan tampilan gelap untuk
        tombol, menu, dan jendela.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Gunakan tampilan berwarna untuk
        tombol, menu, dan jendela.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Gunakan tampilan berwarna untuk
        tombol, menu, dan jendela.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Mari mulai mengeksplorasi semua yang dapat Anda lakukan.
onboarding-fullpage-form-email =
    .placeholder = Alamat surel Anda…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Bawa { -brand-product-name } bersama Anda
onboarding-sync-welcome-content = Dapatkan markah, riwayat, sandi, dan setelan lainnya di semua peranti Anda.
onboarding-sync-welcome-learn-more-link = Pelajari selengkapnya tentang Firefox Accounts
onboarding-sync-form-input =
    .placeholder = Surel
onboarding-sync-form-continue-button = Lanjutkan
onboarding-sync-form-skip-login-button = Lewati langkah ini

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Masukkan surel Anda
onboarding-sync-form-sub-header = Lanjutkan ke { -sync-brand-name }

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Selesaikan dengan serangkaian alat yang menghormati privasi Anda di sepanjang perangkat Anda.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Segala yang kami lakukan menghormati Janji Data Pribadi kami: Ambil lebih sedikit. Jaga agar tetap aman. Tidak ada rahasia.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Bawa markah, kata sandi, riwayat dan lainnya di mana pun Anda menggunakan { -brand-product-name }
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Dapatkan pemberitahuan saat info pribadi Anda ada di dalam pembobolan data publik.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Mengelola kata sandi yang dilindungi dan portabel.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Perlindungan Dari Pelacakan
onboarding-tracking-protection-text2 = { -brand-short-name } bantu menghentikan situs Web untuk melacak Anda secara daring, menjadikan lebih sulit bagi iklan untuk mengikuti Anda di web.
onboarding-tracking-protection-button2 = Panduan
onboarding-data-sync-title = Bawalah Pengaturan dengan Anda
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Sinkronkan markah, kata sandi, dan lainnya di mana pun Anda menggunakan { -brand-product-name }.
onboarding-data-sync-button2 = Masuk ke { -sync-brand-short-name }
onboarding-firefox-monitor-title = Selalu Waspada akan Pembobolan Data
onboarding-firefox-monitor-text2 = { -monitor-brand-name } memantau jika surel Anda telah muncul dalam pembobolan data publik dan memberitahu Anda jika muncul dalam pembobolan terbaru.
onboarding-firefox-monitor-button = Daftar untuk Pemberitahuan
onboarding-browse-privately-title = Menjelajah Secara Privat
onboarding-browse-privately-text = Penjelajahan Pribadi menghapus pencarian dan riwayat penjelajahan Anda untuk merahasiakannya dari orang yang menggunakan komputer Anda.
onboarding-browse-privately-button = Buka Jendela Pribadi
onboarding-firefox-send-title = Simpan Berkas Bersama Anda Secara Pribadi
onboarding-firefox-send-text2 = Unggah berkas Anda ke { -send-brand-name } untuk membagikannya dengan enkripsi ujung-ke-ujung dan tautan yang secara otomatis kedaluwarsa.
onboarding-firefox-send-button = Coba { -send-brand-name }
onboarding-mobile-phone-title = Dapatkan { -brand-product-name } di Ponsel Anda
onboarding-mobile-phone-text = Unduh { -brand-product-name } untuk iOS atau Android dan sinkronkan data Anda di seluruh perangkat.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Unduh Peramban Seluler
onboarding-send-tabs-title = Kirim Tab Secara Instan
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Mudah berbagi halaman di semua perangkat Anda tanpa perlu menyalin tautan atau meninggalkan peramban.
onboarding-send-tabs-button = Mulai Gunakan Kirim Tab
onboarding-pocket-anywhere-title = Baca dan Dengarkan di Mana Saja
onboarding-pocket-anywhere-text2 = Simpan konten favorit Anda luring dengan aplikasi { -pocket-brand-name } dan baca, dengarkan, dan simak kapanpun senyaman Anda.
onboarding-pocket-anywhere-button = Coba { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Buat dan Simpan Sandi yang Kuat
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } menciptakan sandi yang kuat langsung di tempat dan menyimpan semuanya di satu tempat.
onboarding-lockwise-strong-passwords-button = Kelola Info Masuk Anda
onboarding-facebook-container-title = Tetapkan Batas dengan Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } menjaga profil Anda terpisah dari hal lainnya, menjadikan Facebook lebih sulit untuk menargetkan Anda dengan iklan.
onboarding-facebook-container-button = Tambahkan Ekstensi
onboarding-import-browser-settings-title = Impor Markah, Kata Sandi, dan Lainnya
onboarding-import-browser-settings-text = Gunakan langsung — pindahkan situs dan pengaturan Anda dari Chrome dengan mudah.
onboarding-import-browser-settings-button = Impor Data Chrome
onboarding-personal-data-promise-title = Didesain secara privat
onboarding-personal-data-promise-text = { -brand-product-name } menghormati data Anda dengan mengambil sedikit mungkin bagiannya, melindunginya dan jelas akan penggunaannya.
onboarding-personal-data-promise-button = Baca janji kami

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Bagus, Anda mendapat { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Sekarang dapatkan <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Tambahkan Ekstensi
return-to-amo-get-started-button = Mulai dengan { -brand-short-name }
