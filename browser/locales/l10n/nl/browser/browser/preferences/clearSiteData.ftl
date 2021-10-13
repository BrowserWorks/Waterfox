# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Gegevens wissen
    .style = width: 35em

clear-site-data-description = Het wissen van alle cookies en websitegegevens die door { -brand-short-name } zijn opgeslagen kan u bij websites afmelden en offline webinhoud verwijderen. Het wissen van buffergegevens heeft geen invloed op uw aanmeldingen.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookies en websitegegevens ({ $amount } { $unit })
    .accesskey = w

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookies en websitegegevens
    .accesskey = w

clear-site-data-cookies-info = Bij wissen hiervan kunt u bij websites worden afgemeld

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Gebufferde webinhoud ({ $amount } { $unit })
    .accesskey = b

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Gebufferde webinhoud
    .accesskey = b

clear-site-data-cache-info = Vereist opnieuw laden van afbeeldingen en gegevens door websites

clear-site-data-dialog =
    .buttonlabelaccept = Wissen
    .buttonaccesskeyaccept = s
