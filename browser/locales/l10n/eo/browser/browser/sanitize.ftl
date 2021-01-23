# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Agordoj por forviŝado de historio
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Forviŝi ĵusan historion
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Forviŝi tutan historion
    .style = width: 34em

clear-data-settings-label = Je fermo, { -brand-short-name } devus aŭtomate viŝi ĉion

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Forviŝota tempa amplekso:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = Lasta horo

clear-time-duration-value-last-2-hours =
    .label = Lastaj du horoj

clear-time-duration-value-last-4-hours =
    .label = Lastaj kvar horoj

clear-time-duration-value-today =
    .label = Hodiaŭ

clear-time-duration-value-everything =
    .label = Ĉio

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Historio

item-history-and-downloads =
    .label = Retuma kaj elŝuta historio
    .accesskey = e

item-cookies =
    .label = Kuketoj
    .accesskey = K

item-active-logins =
    .label = Aktivaj akreditadoj
    .accesskey = A

item-cache =
    .label = Staplo
    .accesskey = A

item-form-search-history =
    .label = Formulara kaj serĉa historio
    .accesskey = F

data-section-label = Datumoj

item-site-preferences =
    .label = Preferoj de retejoj
    .accesskey = P

item-offline-apps =
    .label = Datumoj de retejoj por malkonektita uzado
    .accesskey = D

sanitize-everything-undo-warning = Tiu ĉi ago ne estas malfarebla.

window-close =
    .key = w

sanitize-button-ok =
    .label = Forviŝi nun

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Forviŝado…

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = La tuta historio estos forviŝita.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Ĉiuj elektitaj elementoj estos forviŝitaj.
