# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Salin
    .accesskey = a

select-all =
    .key = A
menu-select-all =
    .label = Pilih Semua
    .accesskey = S

general-tab =
    .label = Umum
    .accesskey = U
general-title =
    .value = Tajuk:
general-url =
    .value = Alamat:
general-type =
    .value = Jenis:
general-mode =
    .value = Mod Penghuraian:
general-size =
    .value = Saiz:
general-referrer =
    .value = URL Perujuk:
general-modified =
    .value = Diubahsuai:
general-encoding =
    .value = Pengekodan Teks:
general-meta-name =
    .label = Nama
general-meta-content =
    .label = Kandungan

media-tab =
    .label = Media
    .accesskey = M
media-location =
    .value = Lokasi:
media-text =
    .value = Teks Berkaitan:
media-alt-header =
    .label = Teks Alternatif
media-address =
    .label = Alamat
media-type =
    .label = Jenis
media-size =
    .label = Saiz
media-count =
    .label = Kiraan
media-dimension =
    .value = Dimensi:
media-long-desc =
    .value = Keterangan:
media-save-as =
    .label = Simpan Sebagai…
    .accesskey = S
media-save-image-as =
    .label = Simpan Sebagai…
    .accesskey = e

perm-tab =
    .label = Keizinan
    .accesskey = K
permissions-for =
    .value = Keizinan untuk:

security-tab =
    .label = Keselamatan
    .accesskey = S
security-view =
    .label = Papar Sijil
    .accesskey = V
security-view-unknown = Tidak diketahui
    .value = Tidak diketahui
security-view-identity =
    .value = Identiti Laman Web
security-view-identity-owner =
    .value = Pemilik:
security-view-identity-domain =
    .value = Laman web:
security-view-identity-verifier =
    .value = Disahkan oleh:
security-view-identity-validity =
    .value = Luput pada:
security-view-privacy =
    .value = Privasi & Sejarah

security-view-privacy-history-value = Adakah saya pernah lawati laman web ini sebelum ini?
security-view-privacy-sitedata-value = Adakah laman web ini menyimpan maklumat dalam komputer saya?

security-view-privacy-clearsitedata =
    .label = Buang Kuki dan Data Laman
    .accesskey = B

security-view-privacy-passwords-value = Adakah saya pernah simpan kata laluan bagi laman web ini?

security-view-privacy-viewpasswords =
    .label = Papar Kata laluan yang Disimpan
    .accesskey = p
security-view-technical =
    .value = Butiran Teknikal

help-button =
    .label = Bantuan

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Ya, kuki dan { $value } { $unit } data laman
security-site-data-only = Ya, { $value } { $unit } data laman

security-site-data-cookies-only = Ya, kuki
security-site-data-no = Tidak

image-size-unknown = Tidak diketahui
page-info-not-specified =
    .value = Tidak dinyatakan
not-set-alternative-text = Tidak dinyatakan
not-set-date = Tidak dinyatakan
media-img = Imej
media-bg-img = Latar Belakang
media-border-img = Sempadan
media-list-img = Peluru
media-cursor = Kursor
media-object = Objek
media-embed = Benam
media-link = Ikon
media-input = Input
media-video = Video
media-audio = Audio
saved-passwords-yes = Ya
saved-passwords-no = Tidak

no-page-title =
    .value = Halaman Tak Bertajuk:
general-quirks-mode =
    .value = Mod kekhasan
general-strict-mode =
    .value = Mod pematuhan piawai
page-info-security-no-owner =
    .value = Laman web ini tidak menyediakan maklumat pemilik.
media-select-folder = Pilih Folder untuk Simpan Imej
media-unknown-not-cached =
    .value = Tidak diketahui (tiada cache)
permissions-use-default =
    .label = Guna Piawai
security-no-visits = Tidak

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Imej { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (berskala { $scaledx }px × { $scaledy }px)

# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx }px × { $dimy }px

# This string is used to display the size of a media
# file in kilobytes
# Variables:
#   $size (number) - The size of the media file in kilobytes
media-file-size = { $size } KB

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Sekat imej dari { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Info Halaman - { $website }
page-info-frame =
    .title = Info Bingkai- { $website }
