# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Neteja les dades
    .style = width: 35em

clear-site-data-description = Esborrar totes les galetes i dades dels llocs emmagatzemades pel { -brand-short-name } pot fer que es tanqui la sessió dels llocs web i que s'elimini el contingut web fora de línia. Esborrar les dades de la memòria cau no afecta les sessions iniciades.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Galetes i dades dels llocs ({ $amount } { $unit })
    .accesskey = G

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Galetes i dades dels llocs
    .accesskey = G

clear-site-data-cookies-info = Esborrar-les pot fer que se us tanqui la sessió dels llocs web

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Contingut web en memòria cau ({ $amount } { $unit })
    .accesskey = w

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Contingut web en memòria cau
    .accesskey = w

clear-site-data-cache-info = Els llocs web hauran de tornar a carregar les imatges i les dades

clear-site-data-cancel =
    .label = Cancel·la
    .accesskey = C

clear-site-data-clear =
    .label = Esborra
    .accesskey = b
