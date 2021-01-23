# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Tøm data
    .style = width: 35em

clear-site-data-description = Om du fjerner alle infokapsler og nettstedsdata som er lagret av { -brand-short-name } vil dette kunne logge deg ut av nettsteder og fjerne frakoblet nettinnhold. Fjerning av hurtiglager (cache-) data vil ikke påvirke innloggingene dine.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Infokapsler og nettstedsdata ({ $amount } { $unit })
    .accesskey = s

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Infokapsler og nettstedsdata
    .accesskey = s

clear-site-data-cookies-info = Du kan bli logget ut av nettsider du har fjernet data fra

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Hurtiglagret (cachet) nettinnhold ({ $amount } { $unit })
    .accesskey = s

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Hurtiglagret (cachet) nettinnhold
    .accesskey = s

clear-site-data-cache-info = Krever at nettsider laster bilder og data på nytt

clear-site-data-cancel =
    .label = Avbryt
    .accesskey = A

clear-site-data-clear =
    .label = Fjern
    .accesskey = F
