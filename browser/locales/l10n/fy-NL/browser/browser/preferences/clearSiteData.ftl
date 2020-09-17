# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Gegevens wiskje
    .style = width: 35em

clear-site-data-description = It wiskjen fan alle cookies en websitegegevens bewarre troch { -brand-short-name } kin jo fan websites ôfmelde en offline webynhâld fuortsmite. De buffer leegje sil jo oanmeldingen net beynfloedzje.

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

clear-site-data-cookies-info = Jo kinne fan websites ôfmeld wurde nei wiskjen

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Buffere webynhâld ({ $amount } { $unit })
    .accesskey = w

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Buffere webynhâld
    .accesskey = w

clear-site-data-cache-info = Dit fereasket dat websites ôfbyldingen en gegevens opnij lade

clear-site-data-cancel =
    .label = Annulearje
    .accesskey = A

clear-site-data-clear =
    .label = Wiskje
    .accesskey = i
