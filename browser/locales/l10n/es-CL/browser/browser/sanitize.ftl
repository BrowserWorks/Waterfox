# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Ajustes para la limpieza del historial
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Limpiar historial reciente
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Limpiar todo el historial
    .style = width: 34em

clear-data-settings-label = Al ser cerrado, { -brand-short-name } debiera borrar automáticamente todo

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Rango de tiempo para limpiar:{ " " }
    .accesskey = t

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
    .label = Historial de navegación y búsquedas
    .accesskey = b

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
    .label = Historial de formularios y búsquedas
    .accesskey = f

data-section-label = Datos

item-site-preferences =
    .label = Preferencias del sitio
    .accesskey = s

item-offline-apps =
    .label = Datos de sitios web sin conexión
    .accesskey = o

sanitize-everything-undo-warning = Esta acción no puede revertirse.

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
sanitize-everything-warning = Todo el historial será limpiado.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Todos los elementos seleccionados serán limpiados.
