# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Parameters per stizzar la cronologia
    .style = width: 38em

sanitize-prefs-style =
    .style = width: 19em

dialog-title =
    .title = Stizzar la cronologia pli nova
    .style = width: 38em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Stizzar l'entira cronologia
    .style = width: 38em

clear-data-settings-label = Stizzar automaticamain las suandantas datas cura { -brand-short-name } vegn terminà

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Perioda per stizzar:{ " " }
    .accesskey = t

clear-time-duration-value-last-hour =
    .label = l'ultima ura

clear-time-duration-value-last-2-hours =
    .label = las ultimas duas uras

clear-time-duration-value-last-4-hours =
    .label = las ultimas quatter uras

clear-time-duration-value-today =
    .label = datas dad oz

clear-time-duration-value-everything =
    .label = Tut

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Cronologia

item-history-and-downloads =
    .label = La cronologia da navigaziun e da telechargiadas
    .accesskey = L

item-cookies =
    .label = Cookies
    .accesskey = C

item-active-logins =
    .label = Annunzias activas
    .accesskey = A

item-cache =
    .label = Cache
    .accesskey = a

item-form-search-history =
    .label = Cronologia dals formulars e dals champs da tschertgar
    .accesskey = f

data-section-label = Datas

item-site-preferences =
    .label = Preferenzas per websites
    .accesskey = s

item-offline-apps =
    .label = Datas da websites offline
    .accesskey = o

sanitize-everything-undo-warning = Attenziun: Ins na po betg revocar questa acziun.

window-close =
    .key = w

sanitize-button-ok =
    .label = Stizzar uss

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Stizzar

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = L'entira cronologia vegn stizzada.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Tut ils elements tschernids vegnan stizzads.
