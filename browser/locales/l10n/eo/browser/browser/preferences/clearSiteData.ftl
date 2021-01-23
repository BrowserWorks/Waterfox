# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Viŝi datumojn
    .style = width: 35em

clear-site-data-description = Viŝo de ĉiuj kuketoj kaj datumoj de retejo konservitaj de { -brand-short-name } povus okazigi finon de viaj seancoj en retejoj kaj forigon de teksaĵaj malkonektitaĵoj.  Viŝo de la staplo ne efikos sur viaj seancoj.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Kuketoj kaj datumoj de retejo ({ $amount } { $unit })
    .accesskey = K

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Kuketoj kaj retejaj datumoj
    .accesskey = K

clear-site-data-cookies-info = Viŝinte, viaj seancoj en retejoj povus esti finitaj

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Teksaĵa enhavo en staplo ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Staplo de teksaĵa enhavo
    .accesskey = S

clear-site-data-cache-info = Tio postulos al retejo reŝargadon de bildoj kaj datumoj

clear-site-data-cancel =
    .label = Nuligi
    .accesskey = N

clear-site-data-clear =
    .label = Viŝi
    .accesskey = V
