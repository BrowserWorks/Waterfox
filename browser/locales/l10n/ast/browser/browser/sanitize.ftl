# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Axustes pa llimpiar l'historial
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Llimpiar l'historial recién
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Llimpiar tol historial
    .style = width: 34em

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Rangu temporal pa llimpiar:{ " " }
    .accesskey = t

clear-time-duration-value-last-hour =
    .label = Cabera hora

clear-time-duration-value-last-2-hours =
    .label = Caberes dos hores

clear-time-duration-value-last-4-hours =
    .label = Caberes cuatro hores

clear-time-duration-value-today =
    .label = Güei

clear-time-duration-value-everything =
    .label = Too

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Historial

item-history-and-downloads =
    .label = Historial de restolar y descargues
    .accesskey = H

item-cookies =
    .label = Cookies
    .accesskey = C

item-active-logins =
    .label = Anicios de sesión activos
    .accesskey = S

item-cache =
    .label = Caché
    .accesskey = a

item-form-search-history =
    .label = Historial de formularios y guetes
    .accesskey = F

data-section-label = Datos

item-site-preferences =
    .label = Preferencies de sitios
    .accesskey = S

item-offline-apps =
    .label = Datos de sitios web ensin conexón
    .accesskey = o

sanitize-everything-undo-warning = Esta aición nun pue desfacese.

window-close =
    .key = w

sanitize-button-ok =
    .label = Llimpiar agora

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Llimpiando

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Llimpiaráse tol historial.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Van llimpiase tolos elementos seleicionaos.
