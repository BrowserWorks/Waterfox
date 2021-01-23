# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Tyhjennä tiedot
    .style = width: 35em

clear-site-data-description = Jos poistat kaikki evästeet ja sivuston { -brand-short-name }iin tallentamat tiedot, sinut saatetaan kirjata ulos sivustoilta ja yhteydetöntä tilaa varten tallennettu sisältö saatetaan poistaa. Välimuistissa olevan sisällön poistaminen ei kirjaa sinua ulos sivustoilta.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Evästeet ja sivustotiedot ({ $amount } { $unit })
    .accesskey = E

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Evästeet ja sivustotiedot
    .accesskey = E

clear-site-data-cookies-info = Näiden poistaminen saattaa kirjata sinut ulos sivustoilta

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Välimuistissa oleva verkkosisältö ({ $amount } { $unit })
    .accesskey = V

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Välimuistissa oleva verkkosisältö
    .accesskey = V

clear-site-data-cache-info = Vaatii sivustot lataamaan kuvat ja tiedot uudestaan

clear-site-data-cancel =
    .label = Peruuta
    .accesskey = P

clear-site-data-clear =
    .label = Tyhjennä
    .accesskey = T
