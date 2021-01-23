# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Clirio Data
    .style = width: 35em

clear-site-data-description = Gall glirio'r oll gwcis a data gwefan wedi eu cadw gan { -brand-short-name } eich allgofnodi o wefannau a thynnu cynnwys all-lein gwe. Ni fydd clirio data storfa dros dro yn effeithio ar eich mewngofnodion.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cwcis a Data Gwefan ({ $amount } { $unit })
    .accesskey = C

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cwcis a Data Gwefan
    .accesskey = C

clear-site-data-cookies-info = Efallai y cewch eich allgofnodi os fydd wedi ei glirio

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Cynnwys Gwe wedi'i Storio Dros Dro ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Cynnwys Gwe wedi ei Storio Dros Dro
    .accesskey = S

clear-site-data-cache-info = Bydd angen i wefannau ail lwytho delweddau a data

clear-site-data-cancel =
    .label = Diddymu
    .accesskey = D

clear-site-data-clear =
    .label = Clirio
    .accesskey = l
