# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Salin
    .accesskey = S

select-all =
    .key = A
menu-select-all =
    .label = Pilih Semua
    .accesskey = a

close-dialog =
    .key = w

general-tab =
    .label = Umum
    .accesskey = U
general-title =
    .value = Judul:
general-url =
    .value = Alamat:
general-type =
    .value = Jenis:
general-mode =
    .value = Mode Render:
general-size =
    .value = Besar:
general-referrer =
    .value = URL Perujuk:
general-modified =
    .value = Diubah:
general-encoding =
    .value = Pengodean Teks:
general-meta-name =
    .label = Nama
general-meta-content =
    .label = Isi

media-tab =
    .label = Media
    .accesskey = M
media-location =
    .value = Lokasi:
media-text =
    .value = Teks yang Berhubungan:
media-alt-header =
    .label = Teks Alternatif
media-address =
    .label = Alamat
media-type =
    .label = Jenis
media-size =
    .label = Besar
media-count =
    .label = Jumlah
media-dimension =
    .value = Dimensi:
media-long-desc =
    .value = Deskripsi Lengkap:
media-save-as =
    .label = Simpan dengan Nama…
    .accesskey = S
media-save-image-as =
    .label = Simpan dengan Nama…
    .accesskey = e

perm-tab =
    .label = Hak Akses
    .accesskey = a
permissions-for =
    .value = Hak akses untuk:

security-tab =
    .label = Keamanan
    .accesskey = K
security-view =
    .label = Tampilkan Sertifikat
    .accesskey = S
security-view-unknown = Tidak Diketahui
    .value = Tidak Diketahui
security-view-identity =
    .value = Identitas Situs Web
security-view-identity-owner =
    .value = Pemilik:
security-view-identity-domain =
    .value = Situs web:
security-view-identity-verifier =
    .value = Diverifikasi oleh:
security-view-identity-validity =
    .value = Kedaluwarsa pada:
security-view-privacy =
    .value = Privasi & Riwayat

security-view-privacy-history-value = Pernahkah situs ini dikunjungi sebelum hari ini?
security-view-privacy-sitedata-value = Apakah situs web ini menyimpan informasi dalam komputer saya?

security-view-privacy-clearsitedata =
    .label = Bersihkan Kuki dan Data Situs
    .accesskey = B

security-view-privacy-passwords-value = Pernahkah sandi untuk situs web ini disimpan?

security-view-privacy-viewpasswords =
    .label = Sandi Tersimpan
    .accesskey = s
security-view-technical =
    .value = Detail Teknis

help-button =
    .label = Bantuan

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Ya, kuki dan data situs { $value } { $unit }
security-site-data-only = Ya, data situs { $value } { $unit }

security-site-data-cookies-only = Ya, kuki
security-site-data-no = Tidak

##

image-size-unknown = Tidak Diketahui
page-info-not-specified =
    .value = Tidak ditentukan
not-set-alternative-text = Tidak ditentukan
not-set-date = Tidak ditentukan
media-img = Gambar
media-bg-img = Latar Belakang
media-border-img = Tepian
media-list-img = Butir
media-cursor = Kursor
media-object = Objek
media-embed = Menggabung
media-link = Ikon
media-input = Masukan
media-video = Video
media-audio = Audio
saved-passwords-yes = Ya
saved-passwords-no = Tidak

no-page-title =
    .value = Laman Tak Berjudul:
general-quirks-mode =
    .value = Mode "quirk"
general-strict-mode =
    .value = Mode pemenuhan standar
page-info-security-no-owner =
    .value = Situs web ini tidak menyediakan informasi identitas.
media-select-folder = Pilih folder untuk Menyimpan Gambar
media-unknown-not-cached =
    .value = Tidak Diketahui (tidak tersimpan di tembolok)
permissions-use-default =
    .label = Gunakan yang Baku
security-no-visits = Tidak

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
           *[other] Meta ({ $tags } tag)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Tidak
       *[other] Ya, { $visits } kali
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
           *[other] { $kb } KB ({ $bytes } byte)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
           *[other] Gambar { $type } (animasi, { $frames } frame)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Gambar { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (diskalakan menjadi { $scaledx }px × { $scaledy }px)

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
    .label = Blokir Gambar dari { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Informasi Laman - { $website }
page-info-frame =
    .title = Informasi Bingkai - { $website }
