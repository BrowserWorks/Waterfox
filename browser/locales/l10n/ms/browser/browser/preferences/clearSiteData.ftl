# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Buang Data
    .style = width: 35em

clear-site-data-description = Membersihkan semua kuki dan lokasi data yang disimpan oleh { -brand-short-name } boleh menyebabkan anda didaftar keluar dari laman web dan kandungan web luar talian dibuang. Membersihkan data cache tidak akan menjejaskan log masuk anda.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Kuki dan Data Laman ({ $amount } { $unit })
    .accesskey = L

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Kuki dan Data Laman
    .accesskey = L

clear-site-data-cookies-info = Anda didaftar keluar daripada laman web jika dibersihkan

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Cache Kandungan Web ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Cache Kandungan Web
    .accesskey = W

clear-site-data-cache-info = Laman web perlu memuatkan semula imej dan data

clear-site-data-cancel =
    .label = Batal
    .accesskey = B

clear-site-data-clear =
    .label = Buang
    .accesskey = u
