# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Limpiar datos
    .style = width: 45em
clear-site-data-description = Limpiar todas las cookies y datos del sitio guardados por { -brand-short-name } puede desconectarle de los sitios web y eliminar el contenido web sin conexión. Limpiar los datos del caché no afectará a sus sesiones.
clear-site-data-close-key =
    .key = w
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookies y datos del sitio ({ $amount } { $unit })
    .accesskey = C
# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookies y datos del sitio
    .accesskey = C
clear-site-data-cookies-info = Puede ser desconectado de los sitios web si se borran las cookies
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Contenido web en caché ({ $amount } { $unit })
    .accesskey = w
# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Contenido web en caché
    .accesskey = w
clear-site-data-cache-info = Requerirá que los sitios web recarguen las imágenes y datos
clear-site-data-cancel =
    .label = Cancelar
    .accesskey = a
clear-site-data-clear =
    .label = Limpiar
    .accesskey = L
clear-site-data-dialog =
    .buttonlabelaccept = Limpiar
    .buttonaccesskeyaccept = L
