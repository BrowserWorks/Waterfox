# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Perlakuan ini dapat mengakibatkan pelanggaran terhadap garansi!
config-about-warning-text = Mengubah nilai bawaan pada pengaturan lanjutan ini dapat mengakibatkan kerusakan pada stabilitas, keamanan, dan kinerja aplikasi ini. Hanya lanjutkan jika benar-benar tahu apa yang akan Anda lakukan.
config-about-warning-button =
    .label = Saya terima risikonya!
config-about-warning-checkbox =
    .label = Tampilkan peringatan ini lagi nanti

config-search-prefs =
    .value = Cari:
    .accesskey = r

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Nama Pengaturan
config-lock-column =
    .label = Status
config-type-column =
    .label = Jenis
config-value-column =
    .label = Nilai

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Klik untuk mengurut
config-column-chooser =
    .tooltip = Klik untuk memilih kolom yang ditampilkan

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Salin
    .accesskey = S

config-copy-name =
    .label = Salin Nama
    .accesskey = S

config-copy-value =
    .label = Salin Nilai
    .accesskey = N

config-modify =
    .label = Ubah
    .accesskey = U

config-toggle =
    .label = Nyala/Mati
    .accesskey = M

config-reset =
    .label = Kembalikan
    .accesskey = K

config-new =
    .label = Baru
    .accesskey = B

config-string =
    .label = Teks
    .accesskey = k

config-integer =
    .label = Bilangan Bulat
    .accesskey = B

config-boolean =
    .label = Boolean
    .accesskey = B

config-default = bawaan
config-modified = diubah
config-locked = terkunci

config-property-string = teks
config-property-int = bilangan bulat
config-property-bool = boolean

config-new-prompt = Masukkan nama pengaturan

config-nan-title = Nilai tidak valid
config-nan-text = Teks yang baru Anda masukkan bukanlah bilangan.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Nilai baru { $type }

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Masukkan nilai { $type }
