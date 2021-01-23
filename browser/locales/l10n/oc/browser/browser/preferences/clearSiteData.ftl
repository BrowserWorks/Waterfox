# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Escafar las donadas
    .style = width: 35em

clear-site-data-description = Escafar totes los cookies e las dondas dels sites emmagazinats per { -brand-short-name } pòt provocar una desconnexion als sites web e suprimir de contenguts fòra linha. Escafar las donadas en cache afècta pas las sessions iniciadas.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookies e donadas dels sites ({ $amount } { $unit })
    .accesskey = s

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookies e donadas de sites
    .accesskey = s

clear-site-data-cookies-info = Seretz benlèu desconnectat dels sites web s’escafetz aquestas donadas

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Contengut web en cache ({ $amount } { $unit })
    .accesskey = e

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Contengut Web en cache
    .accesskey = e

clear-site-data-cache-info = Caldrà que los sites web tòrnen cargar los imatges e las donadas

clear-site-data-cancel =
    .label = Anullar
    .accesskey = A

clear-site-data-clear =
    .label = Escafar
    .accesskey = E
