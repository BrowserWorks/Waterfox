# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Configuración para o borrado do historial
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Borrar historial recente
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Borrar todo o historial
    .style = width: 34em

clear-data-settings-label = Cando peche { -brand-short-name } deberá borrar todo automaticamente

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Período para borrar:{ " " }
    .accesskey = p

clear-time-duration-value-last-hour =
    .label = Última hora

clear-time-duration-value-last-2-hours =
    .label = Últimas 2 horas

clear-time-duration-value-last-4-hours =
    .label = Últimas 4 horas

clear-time-duration-value-today =
    .label = Hoxe

clear-time-duration-value-everything =
    .label = Todo

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Historial

item-history-and-downloads =
    .label = Historial de navegación e descargas
    .accesskey = g

item-cookies =
    .label = Cookies
    .accesskey = C

item-active-logins =
    .label = Sesións activas
    .accesskey = S

item-cache =
    .label = Caché
    .accesskey = a

item-form-search-history =
    .label = Historial de formularios e buscas
    .accesskey = f

data-section-label = Datos

item-site-preferences =
    .label = Preferencias do sitio
    .accesskey = s

item-offline-apps =
    .label = Datos de sitios web sen conexión
    .accesskey = o

sanitize-everything-undo-warning = Non é posíbel desfacer esta acción.

window-close =
    .key = w

sanitize-button-ok =
    .label = Borrar agora

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Borrando

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Borrarase todo o historial.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Borraranse todos os elementos seleccionados.
