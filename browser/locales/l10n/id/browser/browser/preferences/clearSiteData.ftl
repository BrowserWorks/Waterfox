# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Bersihkan Data
    .style = width: 35em

clear-site-data-description = Membersihkan semua kuki dan data situs yang disimpan oleh { -brand-short-name } mungkin mengeluarkan Anda dari situs web dan menghapus konten web luring. Membersihkan data tembolok tidak akan mempengaruhi info masuk Anda.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Kuki dan Data Situs ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Kuki dan Data Situs
    .accesskey = S

clear-site-data-cookies-info = Anda mungkin dikeluarkan dari situs web jika data situs dibersihkan

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Konten Web Ditembolokkan ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Konten Web Ditembolokkan
    .accesskey = W

clear-site-data-cache-info = Akan mengharuskan situs web untuk memuat ulang gambar dan data

clear-site-data-dialog =
    .buttonlabelaccept = Hapus
    .buttonaccesskeyaccept = H
