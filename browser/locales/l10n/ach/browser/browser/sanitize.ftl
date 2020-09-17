# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Ter pi jwayo gin mukato
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Jwa gin mukato cokki
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Jwa gin mukato weng
    .style = width: 34em

clear-data-settings-label = Ka kiloro woko { -brand-short-name } myero ojwa weng pire kene

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Kin cawa me ajwaya:{ " " }
    .accesskey = K

clear-time-duration-value-last-hour =
    .label = Wang cawa me agiki

clear-time-duration-value-last-2-hours =
    .label = Wang cawa aryo mugiko

clear-time-duration-value-last-4-hours =
    .label = Wang cawa angwen mugiko

clear-time-duration-value-today =
    .label = Tin

clear-time-duration-value-everything =
    .label = Jami weng

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Gin mukato

item-history-and-downloads =
    .label = Yeny ki Gam mukato
    .accesskey = Y

item-cookies =
    .label = Angija
    .accesskey = A

item-active-logins =
    .label = Donyo iyie ma tye katic
    .accesskey = D

item-cache =
    .label = Kikano
    .accesskey = k

item-form-search-history =
    .label = Fom ki Yeny mukato
    .accesskey = F

data-section-label = Tic

item-site-preferences =
    .label = Ter me kakube
    .accesskey = k

item-offline-apps =
    .label = Tic me kakube ma pe iyamo
    .accesskey = T

sanitize-everything-undo-warning = Tic man pe kitwero gonyo ne.

window-close =
    .key = w

sanitize-button-ok =
    .label = Jwa Kombedi

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Jwayo

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Gin mukato weng ki bi jwayo woko.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Jami weng ma kiyero ki bi jwayo woko.
