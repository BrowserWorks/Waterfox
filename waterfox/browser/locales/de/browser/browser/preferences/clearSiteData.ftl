# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Daten löschen
    .style = width: 45em

clear-site-data-description = Das Leeren von durch { -brand-short-name } gespeicherten Cookies und Website-Daten meldet Sie eventuell von Websites ab und entfernt lokal zwischengespeicherte Webinhalte (Cache). Ihre Zugangsdaten bleiben beim Leeren des Caches erhalten.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookies und Website-Daten ({ $amount } { $unit })
    .accesskey = o

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookies und Website-Daten
    .accesskey = o

clear-site-data-cookies-info = Sie werden eventuell von Websites abgemeldet und müssen sich erneut mit den Zugangsdaten anmelden.

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Zwischengespeicherte Webinhalte/Cache ({ $amount } { $unit })
    .accesskey = z

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Lokal zwischengespeicherte Webinhalte/Cache
    .accesskey = z

clear-site-data-cache-info = Webseiten müssen Grafiken und Daten neu laden.

clear-site-data-dialog =
    .buttonlabelaccept = Leeren
    .buttonaccesskeyaccept = L
