# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Limpiar datos
    .style = width: 35em

clear-site-data-description = Al limpiar todas las cookies y los datos de sitio almacenados por { -brand-short-name }, puede que se te cierre la sesión en los sitios web y se te elimine el contenido web sin conexión. Limpiar los datos de caché no afectará a tus credenciales.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookies y datos de sitio ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookies y datos de sitio
    .accesskey = S

clear-site-data-cookies-info = De limpiarlos, puede que se te cierre la sesión en los sitios web

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Contenido Web cacheado ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Contenido Web cacheado
    .accesskey = W

clear-site-data-cache-info = Requerirá que los sitios web recargen las imágenes y los datos

clear-site-data-cancel =
    .label = Cancelar
    .accesskey = C

clear-site-data-clear =
    .label = Limpiar
    .accesskey = l
