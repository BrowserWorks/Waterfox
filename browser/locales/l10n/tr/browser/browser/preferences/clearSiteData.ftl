# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Verileri Temizle
    .style = width: 35em

clear-site-data-description = { -brand-short-name } tarafından saklanan çerezleri ve site verilerini temizlemeniz web sitelerindeki oturumlarınızın kapanmasına ve çevrimdışı web içeriklerinin silinmesine yol açabilir. Önbelleği temizlemeniz oturumlarınızı etkilemez.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Çerezler ve site verileri ({ $amount } { $unit })
    .accesskey = s

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Çerezler ve site verileri
    .accesskey = s

clear-site-data-cookies-info = Bunları temizlerseniz web sitelerindeki oturumlarınız kapanabilir

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Önbelleğe alınmış web içeriği ({ $amount } { $unit })
    .accesskey = w

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Önbelleğe alınmış web içeriği
    .accesskey = w

clear-site-data-cache-info = Web sitelerinin resim ve verileri yeniden yüklemesi gerekir

clear-site-data-cancel =
    .label = Vazgeç
    .accesskey = z

clear-site-data-clear =
    .label = Temizle
    .accesskey = l
