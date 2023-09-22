# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = Tentang { -brand-full-name }

releaseNotes-link = Yang baru

update-checkForUpdatesButton =
    .label = Periksa versi baru
    .accesskey = P

update-updateButton =
    .label = Mulai ulang untuk memutakhirkan { -brand-shorter-name }
    .accesskey = U

update-checkingForUpdates = Memeriksa versi baru…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>Mengunduh versi baru — <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = Mengunduh pemutakhiran — <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = Menerapkan pemutakhiran…

update-failed = Pemutakhiran gagal. <label data-l10n-name="failed-link">Unduh versi terbaru</label>
update-failed-main = Pemutakhiran gagal. <a data-l10n-name="failed-link-main">Unduh versi terbaru</a>

update-adminDisabled = Pemutakhiran dinonaktifkan oleh administrator sistem
update-noUpdatesFound = { -brand-short-name } sudah dalam versi terbaru
aboutdialog-update-checking-failed = Gagal memeriksa versi baru
update-otherInstanceHandlingUpdates = { -brand-short-name } sedang diperbarui oleh salinan lainnya

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = Versi baru tersedia di <label data-l10n-name="manual-link">{ $displayUrl }</label>
settings-update-manual-with-link = Versi baru tersedia di <a data-l10n-name="manual-link">{ $displayUrl }</a>

update-unsupported = Anda tidak dapat melakukan pemutakhiran selanjutnya pada sistem ini. <label data-l10n-name="unsupported-link">Pelajari lebih lanjut</label>

update-restarting = Memulai ulang…

update-internal-error2 = Gagal memeriksa versi baru karena kesalahan internal. Versi baru tersedia di <label data-l10n-name="manual-link">{ $displayUrl }</label>

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = Anda sedang berada di kanal pemutakhiran <label data-l10n-name="current-channel">{ $channel }</label>.

warningDesc-version = { -brand-short-name } bersifat eksperimental dan mungkin tidak stabil.

aboutdialog-help-user = Bantuan { -brand-product-name }
aboutdialog-submit-feedback = Kirim Masukan

community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> adalah sebuah <label data-l10n-name="community-exp-creditsLink">komunitas global</label> yang bekerja sama untuk menjaga agar dunia Web tetap terbuka, untuk publik, dan dapat diakses oleh semua orang tanpa batasan.

community-2 = { -brand-short-name } didesain oleh <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>, sebuah <label data-l10n-name="community-creditsLink">komunitas global</label> yang bekerja sama untuk menjaga agar dunia Web tetap terbuka, untuk publik, dan dapat diakses oleh semua orang tanpa batasan.

helpus = Ingin membantu? <label data-l10n-name="helpus-donateLink">Berikan sumbangan</label> atau <label data-l10n-name="helpus-getInvolvedLink">mari ikut berperan!</label>

bottomLinks-license = Informasi Lisensi
bottomLinks-rights = Hak Pengguna Akhir
bottomLinks-privacy = Kebijakan Privasi

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits }-bit)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits }-bit)
