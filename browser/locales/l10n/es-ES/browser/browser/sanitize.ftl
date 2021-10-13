# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Preferencias para la limpieza del historial
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Limpiar el historial reciente
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Limpiar todo el historial
    .style = width: 34em

clear-data-settings-label = Al cerrarlo, { -brand-short-name } debería limpiarlo todo automáticamente

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Rango temporal a limpiar:{ " " }
    .accesskey = T

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
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Historial

item-history-and-downloads =
    .label = Historial de navegación y descargas
    .accesskey = g

item-cookies =
    .label = Cookies
    .accesskey = C

item-active-logins =
    .label = Sesiones activas
    .accesskey = S

item-cache =
    .label = Caché
    .accesskey = A

item-form-search-history =
    .label = Formularios e historial de búsquedas
    .accesskey = F

data-section-label = Datos

item-site-preferences =
    .label = Preferencias del sitio
    .accesskey = r

item-site-settings =
    .label = Configuración del sitio
    .accesskey = C

item-offline-apps =
    .label = Datos de sitios web sin conexión
    .accesskey = O

sanitize-everything-undo-warning = Esta acción no se puede deshacer.

window-close =
    .key = w

sanitize-button-ok =
    .label = Limpiar ahora

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Limpiando

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Todo el historial será borrado.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Todos los ítems seleccionados serán eliminados.
