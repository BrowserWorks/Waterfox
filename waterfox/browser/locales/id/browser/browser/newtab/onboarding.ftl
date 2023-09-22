# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Selamat datang di { -brand-short-name }
onboarding-start-browsing-button-label = Mulai Menjelajah
onboarding-not-now-button-label = Jangan sekarang

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Memulai

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Bagus, Anda mendapat { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Sekarang dapatkan <img data-l10n-name="icon"/><b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Tambahkan Ekstensi
return-to-amo-add-theme-label = Tambahkan Tema

##  Variables: $addon-name (String) - Name of the add-on to be installed

mr1-return-to-amo-subtitle = Sambutlah { -brand-short-name }
mr1-return-to-amo-addon-title = Anda memiliki peramban pribadi yang cepat di ujung jari Anda. Sekarang Anda dapat menambahkan <b>{ $addon-name }</b> dan melakukan lebih banyak lagi dengan { -brand-short-name }.
mr1-return-to-amo-add-extension-label = Tambahkan { $addon-name }

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator-label =
    .aria-label = Progres: langkah { $current } dari { $total }

# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Nonaktifkan animasi

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-sign-in-button-label = Masuk

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

## Multistage MR1 onboarding strings (about:welcome pages)

# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Impor dari { $previous }

mr1-onboarding-theme-header = Jadikan milik Anda
mr1-onboarding-theme-subtitle = Personalisasikan { -brand-short-name } dengan tema.
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


## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"
##   $systemLanguage (String) - The name of the system language, e.g "Español (ES)"
##   $appLanguage (String) - The name of the language shipping in the browser build, e.g. "English (EN)"

onboarding-live-language-header = Pilih Bahasa

mr2022-onboarding-live-language-text = { -brand-short-name } berbicara bahasa Anda

mr2022-language-mismatch-subtitle = Berkat komunitas kami, { -brand-short-name } diterjemahkan ke lebih dari 90 bahasa. Sepertinya sistem Anda menggunakan { $systemLanguage }, dan { -brand-short-name } menggunakan { $appLanguage }.

onboarding-live-language-button-label-downloading = Mengunduh paket bahasa untuk { $negotiatedLanguage }…
onboarding-live-language-waiting-button = Mendapatkan bahasa yang tersedia…
onboarding-live-language-installing = Mengunduh paket bahasa untuk { $negotiatedLanguage }…

mr2022-onboarding-live-language-switch-to = Beralih ke { $negotiatedLanguage }
mr2022-onboarding-live-language-continue-in = Lanjutkan dalam { $appLanguage }

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

mr2022-onboarding-secondary-skip-button-label = Lewati langkah ini

## MR2022 New User Easy Setup screen strings

# Primary button string used on new user onboarding first screen showing multiple actions such as Set Default, Import from previous browser.
mr2022-onboarding-easy-setup-primary-button-label = Simpan dan Lanjutkan
# Set Default action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-set-default-checkbox-label = Atur { -brand-short-name } sebagai peramban baku
# Import action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-import-checkbox-label = Impor dari peramban sebelumnya

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = Jelajahi Internet yang menakjubkan
# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle = Luncurkan { -brand-short-name } dari mana saja dengan sekali klik. Setiap kali melakukannya, Anda memilih web yang lebih terbuka dan independen.
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Simpan { -brand-short-name } di Dock
       *[other] Sematkan { -brand-short-name } di bilah tugas
    }
# Subtitle will be used when user already has Waterfox pinned, but
# has not set it as their default browser.
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-only-subtitle = Mulailah dengan peramban yang didukung oleh organisasi nirlaba. Kami mempertahankan privasi Anda sementara Anda menjelajahi web.

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header = Terima kasih telah menyukai { -brand-product-name }
# Subtitle is used on onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-subtitle = Luncurkan internet yang lebih sehat dari mana saja dengan sekali klik. Pembaruan terbaru kami dikemas dengan hal-hal baru yang kami rasa akan Anda kagumi.
# Subtitle will be used on the welcome screen for existing users
# when they already have Waterfox pinned but not set as default
mr2022-onboarding-existing-set-default-only-subtitle = Gunakan peramban yang melindungi privasi Anda saat Anda menjelajahi web. Pembaruan terbaru kami dikemas dengan hal-hal yang Anda sukai.
mr2022-onboarding-existing-pin-checkbox-label = Tambahkan juga penjelajahan pribadi { -brand-short-name }

## MR2022 New User Set Default screen strings

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title = Jadikan { -brand-short-name } peramban pilihan Anda
mr2022-onboarding-set-default-primary-button-label = Atur { -brand-short-name } sebagai peramban baku
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-subtitle = Gunakan peramban yang didukung oleh organisasi nirlaba. Kami mempertahankan privasi Anda sementara Anda menjelajahi web.

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-get-started-primary-subtitle = Versi terbaru kami dibangun untuk Anda, membuatnya lebih mudah dari sebelumnya untuk menjelajah web. Penuh dengan fitur yang kami rasa akan Anda sukai.
mr2022-onboarding-get-started-primary-button-label = Siapkan dalam hitungan detik

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = Pengaturan secepat kilat
mr2022-onboarding-import-subtitle = Siapkan { -brand-short-name } sesuai keinginan Anda. Tambahkan markah, sandi, dan lainnya dari peramban lama Anda.
mr2022-onboarding-import-primary-button-label-no-attribution = Impor dari peramban sebelumnya

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = Pilih warna yang menginspirasi Anda
mr2022-onboarding-colorway-subtitle = Suara independen dapat mengubah budaya.
mr2022-onboarding-colorway-primary-button-label-continue = Setel dan lanjutkan
mr2022-onboarding-existing-colorway-checkbox-label = Jadikan { -firefox-home-brand-name } beranda penuh warna

mr2022-onboarding-colorway-label-default = Bawaan
mr2022-onboarding-colorway-tooltip-default2 =
    .title = Warna { -brand-short-name } saat ini
mr2022-onboarding-colorway-description-default = <b>Gunakan warna { -brand-short-name } saya saat ini.</b>

mr2022-onboarding-colorway-label-playmaker = Playmaker
mr2022-onboarding-colorway-tooltip-playmaker2 =
    .title = Playmaker (merah)
mr2022-onboarding-colorway-description-playmaker = <b>Anda adalah seorang Playmaker.</b> Anda menciptakan peluang untuk menang dan membantu semua orang di sekitar Anda meningkatkan permainan mereka.

mr2022-onboarding-colorway-label-expressionist = Ekspresionis
mr2022-onboarding-colorway-tooltip-expressionist2 =
    .title = Ekspresionis (kuning)
mr2022-onboarding-colorway-description-expressionist = <b>Anda adalah seorang Ekspresionis.</b> Anda melihat dunia secara berbeda dan kreasi Anda membangkitkan emosi orang lain.

mr2022-onboarding-colorway-label-visionary = Visioner
mr2022-onboarding-colorway-tooltip-visionary2 =
    .title = Visioner (hijau)
mr2022-onboarding-colorway-description-visionary = <b>Anda adalah seorang Visioner.</b> Anda mempertanyakan status quo dan menggerakkan orang lain untuk membayangkan masa depan yang lebih baik.

mr2022-onboarding-colorway-label-activist = Aktivis
mr2022-onboarding-colorway-tooltip-activist2 =
    .title = Aktivis (biru)
mr2022-onboarding-colorway-description-activist = <b>Anda adalah seorang Aktivis.</b> Anda meninggalkan dunia sebagai tempat yang lebih baik daripada yang Anda temukan dan membuat orang lain percaya.

mr2022-onboarding-colorway-label-dreamer = Pemimpi
mr2022-onboarding-colorway-tooltip-dreamer2 =
    .title = Pemimpi (ungu)
mr2022-onboarding-colorway-description-dreamer = <b>Anda adalah Pemimpi.</b> Anda percaya bahwa keberuntungan berpihak pada yang berani dan menginspirasi orang lain untuk menjadi berani.

mr2022-onboarding-colorway-label-innovator = Inovator
mr2022-onboarding-colorway-tooltip-innovator2 =
    .title = Inovator (oranye)
mr2022-onboarding-colorway-description-innovator = <b>Anda adalah seorang Inovator.</b> Anda melihat peluang di mana-mana dan memberi dampak pada kehidupan semua orang di sekitar Anda.

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = Lompat dari laptop ke ponsel dan kembali lagi
mr2022-onboarding-mobile-download-subtitle = Ambil tab dari satu perangkat dan lanjutkan di mana Anda tinggalkan di perangkat lain. Selain itu, sinkronkan markah dan sandi Anda di mana pun Anda menggunakan { -brand-product-name }.
mr2022-onboarding-mobile-download-cta-text = Pindai kode QR untuk mendapatkan { -brand-product-name } untuk seluler atau <a data-l10n-name="download-label">kirim sendiri tautan unduhan.</a>
mr2022-onboarding-no-mobile-download-cta-text = Pindai kode QR untuk mendapatkan { -brand-product-name } untuk seluler.

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = Dapatkan kebebasan penjelajahan pribadi dengan sekali klik
mr2022-upgrade-onboarding-pin-private-window-subtitle = Tidak ada kuki tersimpan atau riwayat, langsung dari desktop Anda. Menjelajah seperti tidak ada yang mengawasi.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] Sematkan penjelajahan pribadi { -brand-short-name } di Dock
       *[other] Sematkan penjelajahan pribadi { -brand-short-name } ke bilah tugas
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = Kami selalu menghormati privasi Anda
mr2022-onboarding-privacy-segmentation-subtitle = Dari penyaranan cerdas hingga penelusuran yang lebih cerdas, kami terus berupaya menciptakan { -brand-product-name } yang lebih pribadi dan lebih baik.
mr2022-onboarding-privacy-segmentation-text-cta = Apa yang ingin Anda lihat saat kami menawarkan fitur baru yang menggunakan data Anda untuk menyempurnakan penjelajahan Anda?
mr2022-onboarding-privacy-segmentation-button-primary-label = Gunakan rekomendasi { -brand-product-name }
mr2022-onboarding-privacy-segmentation-button-secondary-label = Tampilkan informasi rinci

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = Anda membantu kami membangun web yang lebih baik
mr2022-onboarding-gratitude-subtitle = Terima kasih telah menggunakan { -brand-short-name }, yang didukung oleh BrowserWorks. Dengan dukungan Anda, kami berupaya menjadikan internet lebih terbuka, mudah diakses, dan lebih baik bagi semua orang.
mr2022-onboarding-gratitude-primary-button-label = Lihat apa yang baru
mr2022-onboarding-gratitude-secondary-button-label = Mulai menjelajah

## Onboarding spotlight for infrequent users

onboarding-infrequent-import-title = Anggap saja rumah sendiri
onboarding-infrequent-import-subtitle = Baik Anda sedang menetap atau hanya mampir, ingatlah bahwa Anda dapat mengimpor markah, kata sandi, dan lainnya.
onboarding-infrequent-import-primary-button = Impor ke { -brand-short-name }

## MR2022 Illustration alt tags
## Descriptive tags for illustrations used by screen readers and other assistive tech

mr2022-onboarding-pin-image-alt =
    .aria-label = Orang bekerja di laptop dikelilingi bintang-bintang dan bunga-bunga
mr2022-onboarding-default-image-alt =
    .aria-label = Orang yang memeluk logo { -brand-product-name }
mr2022-onboarding-import-image-alt =
    .aria-label = Orang mengendarai skateboard dengan sekotak ikon perangkat lunak
mr2022-onboarding-mobile-download-image-alt =
    .aria-label = Katak melompat melintasi bunga bakung dengan kode QR untuk mengunduh { -brand-product-name } untuk seluler di tengah
mr2022-onboarding-pin-private-image-alt =
    .aria-label = Tongkat sihir membuat logo penjelajahan pribadi { -brand-product-name } muncul dari topi
mr2022-onboarding-privacy-segmentation-image-alt =
    .aria-label = Tangan berkulit terang dan berkulit gelap melakukan tos
mr2022-onboarding-gratitude-image-alt =
    .aria-label = Pemandangan matahari terbenam melalui jendela dengan rubah dan tanaman rumah di ambang jendela
mr2022-onboarding-colorways-image-alt =
    .aria-label = Semprotan tangan melukis kolase warna-warni dari mata hijau, sepatu oranye, bola basket merah, headphone ungu, hati biru, dan mahkota kuning

## Device migration onboarding

