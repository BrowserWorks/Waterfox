# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Selamat datang di { -brand-short-name }
onboarding-start-browsing-button-label = Mulai Menjelajah
onboarding-not-now-button-label = Jangan sekarang

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Bagus, Anda mendapat { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Sekarang dapatkan <img data-l10n-name="icon"/><b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Tambahkan Ekstensi
return-to-amo-add-theme-label = Tambahkan Tema

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Memulai: layar { $current } dari { $total }

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator2 =
    .aria-valuetext = Progres: langkah { $current } dari { $total }
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text =
    Semangat dimulai
    dari sini
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — Desainer Furnitur, penggemar Waterfox
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Nonaktifkan animasi

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Sematkan { -brand-short-name } ke Dock Anda untuk akses mudah
       *[other] Pin { -brand-short-name } ke bilah tugas Anda untuk akses mudah
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Pertahankan dalam Dock
       *[other] Sematkan ke bilah tugas
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Memulai
mr1-onboarding-welcome-header = Selamat datang di { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Jadikan { -brand-short-name } peramban utama saya
    .title = Jadikan { -brand-short-name } sebagai peramban baku dan sematkan ke bilah tugas
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Jadikan { -brand-short-name } peramban baku saya
mr1-onboarding-set-default-secondary-button-label = Jangan sekarang
mr1-onboarding-sign-in-button-label = Masuk

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = Jadikan { -brand-short-name } peramban baku Anda
mr1-onboarding-default-subtitle = Letakkan kecepatan, keamanan, dan privasi secara otomatis
mr1-onboarding-default-primary-button-label = Jadikan sebagai peramban baku

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Bawa semua bersama Anda
mr1-onboarding-import-subtitle = Impor sandi Anda, <br/>markah, dan lainnya.
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Impor dari { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Impor dari peramban sebelumnya
mr1-onboarding-import-secondary-button-label = Jangan sekarang
mr2-onboarding-colorway-header = Hidup bersama warna
mr2-onboarding-colorway-subtitle = Warna baru. Tersedia untuk waktu terbatas.
mr2-onboarding-colorway-primary-button-label = Simpan warna
mr2-onboarding-colorway-secondary-button-label = Jangan sekarang
mr2-onboarding-colorway-label-soft = Lembut
mr2-onboarding-colorway-label-balanced = Seimbang
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Mencolok
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Otomatis
# This string will be used for Default theme
mr2-onboarding-theme-label-default = Baku
mr1-onboarding-theme-header = Jadikan milik Anda
mr1-onboarding-theme-subtitle = Personalisasikan { -brand-short-name } dengan tema.
mr1-onboarding-theme-primary-button-label = Simpan tema
mr1-onboarding-theme-secondary-button-label = Jangan sekarang
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Tema sistem
mr1-onboarding-theme-label-light = Terang
mr1-onboarding-theme-label-dark = Gelap
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow
onboarding-theme-primary-button-label = Selesai

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Ikuti tema sistem operasi
        untuk tombol, menu, dan jendela.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Ikuti tema sistem operasi
        untuk tombol, menu, dan jendela.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Gunakan tampilan terang untuk
        tombol, menu, dan jendela.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Gunakan tampilan terang untuk
        tombol, menu, dan jendela.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Gunakan tampilan gelap untuk
        tombol, menu, dan jendela.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Gunakan tampilan gelap untuk
        tombol, menu, dan jendela.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Gunakan tampilan dinamis berwarna untuk
        tombol, menu, dan jendela.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Gunakan tampilan dinamis berwarna untuk
        tombol, menu, dan jendela.
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Gunakan warna ini.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Gunakan warna ini.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = Telusuri warna { $colorwayName }.
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-label = Telusuri warna { $colorwayName }.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Jelajahi tema baku.
# Selector description for default themes
mr2-onboarding-default-theme-label = Jelajahi tema baku.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Terima kasih telah memilih kami
mr2-onboarding-thank-you-text = { -brand-short-name } adalah peramban independen yang didukung oleh organisasi nirlaba. Bersama-sama, kita membuat web menjadi lebih aman, lebih sehat, dan lebih pribadi.
mr2-onboarding-start-browsing-button-label = Mulai menjelajah

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"

onboarding-live-language-header = Pilih Bahasa
onboarding-live-language-button-label-downloading = Mengunduh paket bahasa untuk { $negotiatedLanguage }…
onboarding-live-language-waiting-button = Mendapatkan bahasa yang tersedia…
onboarding-live-language-installing = Mengunduh paket bahasa untuk { $negotiatedLanguage }…
onboarding-live-language-secondary-cancel-download = Batalkan
onboarding-live-language-skip-button-label = Lewati

## Waterfox 100 Thank You screens

# "Hero Text" displayed on left side of welcome screen. This text can be
# formatted to span multiple lines as needed. The <span data-l10n-name="zap">
# </span> in this string allows a "zap" underline style to be automatically
# added to the text inside it. "Yous" should stay inside the zap span, but
# "Thank" can be put inside instead if there's no "you" in the translation.
# The English text would normally be "100 Thank-Yous" i.e., plural noun, but for
# aesthetics of splitting it across multiple lines, the hyphen is omitted.
fx100-thank-you-hero-text =
    100x
    <span data-l10n-name="zap">Terima Kasih</span>
fx100-thank-you-subtitle = Ini adalah rilis ke-100 kami! Terima kasih telah membantu kami membangun internet yang lebih baik dan lebih sehat.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Simpan { -brand-short-name } di Dock
       *[other] Sematkan { -brand-short-name } di bilah tugas
    }
fx100-upgrade-thanks-header = 100x Terima Kasih
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = Ini adalah rilis { -brand-short-name } ke-100. Terima kasih untuk <em>Anda</em> karena telah membantu kami membangun Internet yang lebih baik dan lebih sehat.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = Ini adalah rilis ke-100 kami! Terima kasih telah menjadi bagian dari komunitas kami. Hanya sekali klik untuk terus 100x bersama { -brand-short-name } berikutnya.

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-onboarding-skip-step-button-label = Lewati langkah ini
mr2022-upgrade-onboarding-pin-private-window-header = Dapatkan kebebasan penjelajahan pribadi dengan sekali klik
mr2022-upgrade-onboarding-pin-private-window-subtitle = Tidak ada kuki tersimpan atau riwayat, langsung dari desktop Anda. Menjelajah seperti tidak ada yang mengawasi.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] Sematkan penjelajahan pribadi { -brand-short-name } di Dock
       *[other] Sematkan penjelajahan pribadi { -brand-short-name } ke bilah tugas
    }
