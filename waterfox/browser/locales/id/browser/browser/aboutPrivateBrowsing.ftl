# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Buka Jendela Pribadi
    .accesskey = P
about-private-browsing-search-placeholder = Cari di Web
about-private-browsing-info-title = Anda berada di Jendela Pribadi
about-private-browsing-search-btn =
    .title = Cari di web
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Cari lewat { $engine } atau masukkan alamat
about-private-browsing-handoff-no-engine =
    .title = Cari atau masukkan alamat
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Cari lewat { $engine } atau masukkan alamat
about-private-browsing-handoff-text-no-engine = Cari atau masukkan alamat
about-private-browsing-not-private = Anda tidak sedang dalam jendela pribadi.
about-private-browsing-info-description-private-window = Jendela pribadi: { -brand-short-name } menghapus riwayat pencarian dan penjelajahan saat Anda menutup semua jendela pribadi. Ini tidak membuat Anda anonim.
about-private-browsing-info-description-simplified = { -brand-short-name } membersihkan riwayat pencarian dan penjelajahan Anda ketika Anda menutup semua jendela privat, namun tidak membuat Anda terlihat anonim.
about-private-browsing-learn-more-link = Pelajari lebih lanjut
about-private-browsing-hide-activity = Sembunyikan aktivitas dan lokasi Anda, di mana pun Anda menjelajah
about-private-browsing-get-privacy = Dapatkan perlindungan privasi di mana pun saat Anda menjelajah
about-private-browsing-hide-activity-1 = Sembunyikan aktivitas dan lokasi penjelajahan dengan { -mozilla-vpn-brand-name }. Satu klik menciptakan koneksi aman, bahkan di Wi-Fi publik.
about-private-browsing-prominent-cta = Jaga privasi dengan { -mozilla-vpn-brand-name }
about-private-browsing-focus-promo-cta = Unduh { -focus-brand-name }
about-private-browsing-focus-promo-header = { -focus-brand-name }: Penjelajahan pribadi di mana saja
about-private-browsing-focus-promo-text = Aplkasi seluler penjelajahan pribadi khusus dari kami untuk menghapus riwayat dan kuki Anda setiap saat.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = Bawa penjelajahan pribadi ke ponsel Anda
about-private-browsing-focus-promo-text-b = Gunakan { -focus-brand-name } untuk pencarian pribadi yang tidak ingin terlihat dari peramban utama Anda.
about-private-browsing-focus-promo-header-c = Privasi tingkat lanjut di ponsel
about-private-browsing-focus-promo-text-c = { -focus-brand-name } menghapus riwayat Anda setiap saat sekaligus memblokir iklan dan pelacak.
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } adalah mesin pencari baku Anda di dalam Jendela Pribadi.
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] Untuk memilih mesin pencari yang berbeda, buka <a data-l10n-name="link-options">Pengaturan</a>
       *[other] Untuk memilih mesin pencari yang berbeda, buka <a data-l10n-name="link-options">Pengaturan</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Tutup
about-private-browsing-promo-close-button =
    .title = Tutup

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = Kebebasan penjelajahan pribadi dengan sekali klik
about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] Sematkan di Dock
       *[other] Sematkan ke bilah tugas
    }
about-private-browsing-pin-promo-title = Tidak ada kuki tersimpan atau riwayat, langsung dari desktop Anda. Menjelajah seperti tidak ada yang mengawasi.
