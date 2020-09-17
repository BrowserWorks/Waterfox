# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Stizzar las datas
    .style = width: 45em

clear-site-data-description = Cun stizzar tut ils cookies e tut las datas da websites memorisadas da { -brand-short-name } vegnas ti eventualmain deconnectà da tschertas websites e cuntegn da web offline vegn stizzà. Las infurmaziuns d'annunzia vegnan preservadas era sch'il cache vegn svidà.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookies e datas da websites ({ $amount } { $unit })
    .accesskey = C

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookies e datas da websites
    .accesskey = o

clear-site-data-cookies-info = Ti vegns eventualmain deconnectà da websites sche ti stizzas questas datas

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Cuntegn web en il cache ({ $amount } { $unit })
    .accesskey = u

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Cuntegn web en il cache
    .accesskey = n

clear-site-data-cache-info = Las paginas web vegnan a stuair rechargiar ils maletgs e las datas

clear-site-data-cancel =
    .label = Interrumper
    .accesskey = I

clear-site-data-clear =
    .label = Stizzar
    .accesskey = z
