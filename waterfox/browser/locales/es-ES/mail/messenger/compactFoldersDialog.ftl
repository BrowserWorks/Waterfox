# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

compact-dialog-window =
    .title = Compactar carpetas
    .style = width: 50em;

compact-dialog =
    .buttonlabelaccept = Compactar ahora
    .buttonaccesskeyaccept = C
    .buttonlabelcancel = Recordármelo más tarde
    .buttonaccesskeycancel = R
    .buttonlabelextra1 = Saber más…
    .buttonaccesskeyextra1 = S

# Variables:
#  $data (String): The amount of space to be freed, formatted byte, MB, GB, etc., based on the size.
compact-dialog-message = { -brand-short-name } debe realizar un mantenimiento regular de los archivos para mejorar  el rendimiento de sus carpetas de mensajes. Esta acción recuperará { $data } de espacio en disco sin cambiar sus mensajes. Para permitir que { -brand-short-name } haga esto automáticamente en el futuro sin preguntar, marque la casilla de abajo antes de elegir ‘{ compact-dialog.buttonlabelaccept }’.

compact-dialog-never-ask-checkbox =
    .label = Compactar automáticamente las carpetas en el futuro
    .accesskey = a

