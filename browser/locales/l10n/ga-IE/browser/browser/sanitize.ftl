# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Socruithe maidir le glanadh na staire
    .style = width: 46em

sanitize-prefs-style =
    .style = width: 19em

dialog-title =
    .title = Glan an Stair Is Déanaí
    .style = width: 46em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Glan an Stair Go Léir
    .style = width: 46em

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Raon ama le glanadh:{ " " }
    .accesskey = R

clear-time-duration-value-last-hour =
    .label = An Uair Is Déanaí

clear-time-duration-value-last-2-hours =
    .label = An Dá Uair Is Déanaí

clear-time-duration-value-last-4-hours =
    .label = Na Ceithre hUaire Is Déanaí

clear-time-duration-value-today =
    .label = Inniu

clear-time-duration-value-everything =
    .label = Gach Uile Rud

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Stair

item-history-and-downloads =
    .label = Stair Bhrabhsála agus Íoslódála
    .accesskey = B

item-cookies =
    .label = Fianáin
    .accesskey = F

item-active-logins =
    .label = Seisiúin Ghníomhacha
    .accesskey = S

item-cache =
    .label = Taisce
    .accesskey = a

item-form-search-history =
    .label = Stair Fhoirmeacha agus Chuardaigh
    .accesskey = F

data-section-label = Sonraí

item-site-preferences =
    .label = Sainroghanna an tSuímh
    .accesskey = S

item-offline-apps =
    .label = Sonraí Shuíomhanna Gréasáin As Líne
    .accesskey = o

sanitize-everything-undo-warning = Ní féidir an gníomh seo a chur ar ceal.

window-close =
    .key = w

sanitize-button-ok =
    .label = Glan Anois

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Á Ghlanadh

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Glanfar an stair go léir.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Glanfar gach mír roghnaithe.
