# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Ryd data
    .style = width: 35em
clear-site-data-description = Ved at rydde cookies og webstedsdata logger { -brand-short-name } dig muligvis ud fra websteder, og offline webstedsdata kan blive fjernet. Det påvirker ikke dine logins at rydde cache-data
clear-site-data-close-key =
    .key = w
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookies og websteds-data ({ $amount } { $unit })
    .accesskey = C
# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookies og websteds-data
    .accesskey = C
clear-site-data-cookies-info = Du kan blive logget ud fra websteder ved at rydde disse
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Cached web-indhold ({ $amount } { $unit })
    .accesskey = w
# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Cached webstedsindhold
    .accesskey = w
clear-site-data-cache-info = Tvinger websteder til at genindlæse billeder og data
clear-site-data-cancel =
    .label = Fortryd
    .accesskey = F
clear-site-data-clear =
    .label = Ryd
    .accesskey = R
clear-site-data-dialog =
    .buttonlabelaccept = Ryd
    .buttonaccesskeyaccept = R
