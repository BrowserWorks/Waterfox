# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Daty zhašeć
    .style = width: 35em

clear-site-data-description = Přez zhašenje wšěch plackow a datow sydła přez { -brand-short-name } móže k wotzjewjenju z websydłow a wotstronjenju webwobsaha offline dóńć. Zhašenje datow pufrowaka waše přizjewjenja njewobwliwuje.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Placki a daty sydła ({ $amount } { $unit })
    .accesskey = P

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Placki a daty sydła
    .accesskey = P

clear-site-data-cookies-info = Přez zhašenje móže k wašemu wotzjewjenju z websydłow dóńć

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Pufrowany webwobsah ({ $amount } { $unit })
    .accesskey = P

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Pufrowany webwobsah
    .accesskey = P

clear-site-data-cache-info = Wužaduje sej, zo websydła wobrazy a daty znowa začitaja

clear-site-data-cancel =
    .label = Přetorhnyć
    .accesskey = t

clear-site-data-clear =
    .label = Zhašeć
    .accesskey = h
