# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Preferencias para borrar el historial
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Borrar el historial reciente
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Borrar todo el historial
    .style = width: 34em

clear-data-settings-label = Cuando se cierre { -brand-short-name } debería automáticamente limpiar todo

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Rango de tiempo para borrar:{ " " }
    .accesskey = R

clear-time-duration-value-last-hour =
    .label = Última hora

clear-time-duration-value-last-2-hours =
    .label = Últimas dos horas

clear-time-duration-value-last-4-hours =
    .label = Últimas cuatro horas

clear-time-duration-value-today =
    .label = Hoy

clear-time-duration-value-everything =
    .label = Todo

clear-time-duration-suffix =
    .value = Todo

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Historial

item-history-and-downloads =
    .label = Historial de navegación y descargas
    .accesskey = n

item-cookies =
    .label = Cookies
    .accesskey = C

item-active-logins =
    .label = Conexiones activas
    .accesskey = C

item-cache =
    .label = Caché
    .accesskey = a

item-form-search-history =
    .label = Historial de búsquedas y formularios
    .accesskey = f

data-section-label = Datos

item-site-preferences =
    .label = Preferencias del sitio
    .accesskey = P

item-offline-apps =
    .label = Datos de sitios web sin conexión
    .accesskey = o

sanitize-everything-undo-warning = Esta acción no podrá deshacerse.

window-close =
    .key = w

sanitize-button-ok =
    .label = Limpiar ahora

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Borrando

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Se borrará todo el historial.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Se borrarán los elementos seleccionados.
