# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Nadurê' nuguan'an
    .style = width: 35em

clear-site-data-description = Si na'nint nej cookies nī datos 'ngà ma riña sitio { -brand-short-name } ni ga'ue ganarán si sesiont gi'iaj ma. Si na'nint nej datos caché nī nitaj si giran' si sesiont gi'iaj ma.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Kookies ni si dato sitio ({ $amount }{ $unit })
    .accesskey = K

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Kookies nī si dato sitio
    .accesskey = K

clear-site-data-cookies-info = Si duret ma ni ga'ue si ganrân si sesiont riña a'go sitio web

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Cache nu riña web ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Cache nu riña Web
    .accesskey = W

clear-site-data-cache-info = Da'ui a'ngo nej sitio web ni nachra ma datos

clear-site-data-cancel =
    .label = Duyichin'
    .accesskey = C

clear-site-data-clear =
    .label = Na'nïn'
    .accesskey = l
