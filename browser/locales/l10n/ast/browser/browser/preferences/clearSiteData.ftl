# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Llimpiar datos
    .style = width: 35em

clear-site-data-description = Llimpiar toles cookies y datos de sitios atroxaos por { -brand-short-name } podríen zarrate la sesión en sitios web y desaniciar conteníu web fuera de llinia. Llimpiar los datos de la caché nun va afeutar a los anicios de sesión.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookies y datos del sitiu ({ $amount } { $unit })
    .accesskey = C

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookies y datos del sitiu
    .accesskey = o

clear-site-data-cookies-info = Esborralos pue facer que te desconeute la sesión de los sitios web

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Conteníu web en caché ({ $amount } { $unit })
    .accesskey = w

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Conteníu web en caché
    .accesskey = w

clear-site-data-cache-info = Va riquir que los sitios web recarguen les imáxenes y datos

clear-site-data-cancel =
    .label = Encaboxar
    .accesskey = E

clear-site-data-clear =
    .label = Llimpiar
    .accesskey = L
