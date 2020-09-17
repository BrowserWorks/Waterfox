# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Обриши податке
    .style = width: 35em

clear-site-data-description = Чишћење свих колачића и података сајтова које { -brand-short-name } складишти вас може одјавити са веб сајтова и може уклонити ванмрежни веб садржај. Чишћење кешираних података неће утицати на ваше пријаве.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Колачићи и подаци сајтова ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Колачићи и подаци сајтова
    .accesskey = S

clear-site-data-cookies-info = Можда ћете бити одјављени са веб сајтова ако се очисти

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Кеширани веб садржај ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Кеширани веб садржај
    .accesskey = W

clear-site-data-cache-info = Довешће до поновног учитавања слика и података на веб сајтовима

clear-site-data-cancel =
    .label = Откажи
    .accesskey = C

clear-site-data-clear =
    .label = Обриши
    .accesskey = l
