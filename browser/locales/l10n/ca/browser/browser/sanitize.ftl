# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Paràmetres de neteja de l'historial
    .style = width: 36em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Neteja l'historial recent
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Neteja tot l'historial
    .style = width: 34em

clear-data-settings-label = En tancar el { -brand-short-name }, esborra automàticament

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Abast temporal per netejar:{ " " }
    .accesskey = r

clear-time-duration-value-last-hour =
    .label = La darrera hora

clear-time-duration-value-last-2-hours =
    .label = Les darreres dues hores

clear-time-duration-value-last-4-hours =
    .label = Les darreres quatre hores

clear-time-duration-value-today =
    .label = Avui

clear-time-duration-value-everything =
    .label = Tot

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Historial

item-history-and-downloads =
    .label = Historial de navegació i de baixades
    .accesskey = H

item-cookies =
    .label = Galetes
    .accesskey = G

item-active-logins =
    .label = Sessions actives
    .accesskey = S

item-cache =
    .label = Memòria cau
    .accesskey = M

item-form-search-history =
    .label = Historial de formularis i de cerques
    .accesskey = F

data-section-label = Dades

item-site-preferences =
    .label = Preferències dels llocs
    .accesskey = P

item-offline-apps =
    .label = Dades de llocs web fora de línia
    .accesskey = D

sanitize-everything-undo-warning = Aquesta acció no es pot desfer.

window-close =
    .key = w

sanitize-button-ok =
    .label = Neteja-ho ara

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = S'està netejant

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Es netejarà tot l'historial.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Es netejaran tots els elements seleccionats.
