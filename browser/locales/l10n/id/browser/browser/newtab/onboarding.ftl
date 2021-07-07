# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

## Welcome modal dialog strings


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.

## Welcome page strings

onboarding-welcome-header = Selamat datang di { -brand-short-name }

onboarding-start-browsing-button-label = Mulai Menjelajah

## Welcome full page string

## Waterfox Sync modal dialog strings.

## This is part of the line "Enter your email to continue to Waterfox Sync"


## These are individual benefit messages shown with an image, title and
## description.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

## Message strings belonging to the Return to AMO flow

onboarding-not-now-button-label = Jangan sekarang

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Bagus, Anda mendapat { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Sekarang dapatkan <img data-l10n-name="icon"/><b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Tambahkan Ekstensi

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Selamat datang di <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Peramban cepat, aman, dan pribadi yang didukung oleh nirlaba.
onboarding-multistage-welcome-primary-button-label = Mulai Penyiapan
onboarding-multistage-welcome-secondary-button-label = Masuk
onboarding-multistage-welcome-secondary-button-text = Sudah punya akun?

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = Jadikan { -brand-short-name } sebagai <span data-l10n-name="zap">yang baku</span>
onboarding-multistage-set-default-subtitle = Kecepatan, keamanan, dan privasi setiap kali Anda menjelajah.
onboarding-multistage-set-default-primary-button-label = Jadikan sebagai Peramban Baku
onboarding-multistage-set-default-secondary-button-label = Jangan sekarang

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = Luncurkan <span data-l10n-name="zap">{ -brand-short-name }</span> dengan sekali klik
onboarding-multistage-pin-default-subtitle = Peramban yang cepat, aman, disertai penjelajahan pribadi untuk Anda berselancar di web.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = Pilih { -brand-short-name } di bawah Browser web saat pengaturan Anda terbuka
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = Ini akan menyematkan { -brand-short-name } ke bilah tugas dan membuka pengaturan
onboarding-multistage-pin-default-primary-button-label = Jadikan { -brand-short-name } Peramban Utama Saya

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Impor kata sandi, markah, <br/>dan <span data-l10n-name="zap">yang lain</span>
onboarding-multistage-import-subtitle = Dari peramban lain? Mudah sekali membawa semuanya ke { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Mulai Impor
onboarding-multistage-import-secondary-button-label = Jangan sekarang

# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Situs yang terdaftar di sini ditemukan di perangkat ini. { -brand-short-name } tidak menyimpan ataupun menyinkronkan data dari peramban lain kecuali Anda memilih untuk mengimpornya.

## Multistage onboarding strings (about:welcome pages)

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
onboarding-multistage-theme-primary-button-label2 = Selesai
onboarding-multistage-theme-secondary-button-label = Jangan sekarang

# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Otomatis

onboarding-multistage-theme-label-light = Terang
onboarding-multistage-theme-label-dark = Gelap
# "Waterfox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow

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

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

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
        Gunakan tampilan terang untuk
        tombol, menu, dan jendela.

# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Gunakan tampilan terang untuk
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

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

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
