# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Počisti podatke
    .style = width: 35em

clear-site-data-description = Brisanje vseh piškotkov in podatkov strani, ki jih hrani { -brand-short-name }, vas lahko odjavi iz spletnih strani in odstrani vsebino za delo brez povezave. Brisanje podatkov v predpomnilniku ne bo vplivalo na vaše prijave.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Piškotki in podatki strani ({ $amount } { $unit })
    .accesskey = š

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Piškotki in podatki strani
    .accesskey = š

clear-site-data-cookies-info = Če počistite te podatke, boste morda odjavljeni iz spletnih strani

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Vsebina v predpomnilniku ({ $amount } { $unit })
    .accesskey = m

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Vsebina v predpomnilniku
    .accesskey = m

clear-site-data-cache-info = Strani bodo morale ponovno naložiti slike in podatke

clear-site-data-cancel =
    .label = Prekliči
    .accesskey = k

clear-site-data-clear =
    .label = Počisti
    .accesskey = č
