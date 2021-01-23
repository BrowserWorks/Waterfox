# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Șterge datele
    .style = width: 35em

clear-site-data-description = Ștergerea tuturor cookie-urilor și a datelor de site-uri stocate de { -brand-short-name } te poate deconecta de pe site-urile web și va elimina conținutul web offline. Ștergerea datelor din cache nu va afecta datele de autentificare.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookie-uri și date ale site-urilor ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookie-uri și date ale site-urilor
    .accesskey = S

clear-site-data-cookies-info = Este posibil să te deconecteze de pe site-uri web dacă acestea sunt șterse

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Conținut web în cache ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Conținut web în cache
    .accesskey = W

clear-site-data-cache-info = Site-urile web vor fi nevoite să reîncarce imaginile și datele

clear-site-data-cancel =
    .label = Renunță
    .accesskey = C

clear-site-data-clear =
    .label = Șterge
    .accesskey = l
