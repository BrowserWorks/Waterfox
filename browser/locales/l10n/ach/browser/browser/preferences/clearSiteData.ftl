# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Jwa data
    .style = width: 35em

clear-site-data-description = Jwano angija ki data me kakube weng ma { -brand-short-name } ogwoko twero kwanyi woko ki ii kakube ki kwanyo jami me kakube mape iwiyamo. Jwano data ma kigwoko pe bi yelo donyo iyie mamegi.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Angija ki Data me kakube ({ $amount } { $unit })
    .accesskey = J

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Angija ki Data me kakube
    .accesskey = J

clear-site-data-cookies-info = Mogo ki bikwanyi woko ki ii kakube kacce kijwayo

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Jami me kakube ma kigwoko ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Jami me kakube ma kigwoko
    .accesskey = W

clear-site-data-cache-info = Bimite ki kakube ma nwoyo cano cal ki data

clear-site-data-cancel =
    .label = Juki
    .accesskey = K

clear-site-data-clear =
    .label = Jwa
    .accesskey = j
