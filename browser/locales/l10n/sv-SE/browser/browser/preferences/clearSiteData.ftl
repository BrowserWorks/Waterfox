# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Rensa data
    .style = width: 35em
clear-site-data-description = Rensning av alla kakor och webbplatsdata lagrade av { -brand-short-name } kan logga ut dig från webbplatser och ta bort offline-webbinnehåll. Rensning av cache påverkar inte dina inloggningar.
clear-site-data-close-key =
    .key = w
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Kakor och webbplatsdata ({ $amount } { $unit })
    .accesskey = p
# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Kakor och webbplatsdata
    .accesskey = p
clear-site-data-cookies-info = Du kan bli utloggad från webbplatser som du rensat
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Cachat webbinnehåll ({ $amount } { $unit })
    .accesskey = w
# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Cachat webbinnehåll
    .accesskey = w
clear-site-data-cache-info = Kräver att webbplatser laddar om bilder och data
clear-site-data-cancel =
    .label = Avbryt
    .accesskey = A
clear-site-data-clear =
    .label = Rensa
    .accesskey = R
clear-site-data-dialog =
    .buttonlabelaccept = Rensa
    .buttonaccesskeyaccept = R
