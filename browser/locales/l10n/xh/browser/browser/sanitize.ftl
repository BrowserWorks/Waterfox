# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Iisethingi zokususa imbali
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Susa iMbali Yakutshanje
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Susa yonke imbali
    .style = width: 34em

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Ubungakanani bexesha lokususa:{ " " }
    .accesskey = b

clear-time-duration-value-last-hour =
    .label = Iyure yokugqibela

clear-time-duration-value-last-2-hours =
    .label = Iiyure ezimbini zokugqibela

clear-time-duration-value-last-4-hours =
    .label = Iiyure ezinezokugqibela

clear-time-duration-value-today =
    .label = Namhla

clear-time-duration-value-everything =
    .label = Yonke into

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Imbali

item-history-and-downloads =
    .label = Ukubhrawuza nembali yokukhuphela
    .accesskey = U

item-cookies =
    .label = Iikhukhi
    .accesskey = k

item-active-logins =
    .label = Iilogin ezisebenzayo
    .accesskey = I

item-cache =
    .label = Uvimba wethutyana
    .accesskey = m

item-form-search-history =
    .label = Ifom nembali yokukhangela
    .accesskey = I

data-section-label = Iingcombolo

item-site-preferences =
    .label = Iipriferensi zesayithi
    .accesskey = z

item-offline-apps =
    .label = Iingcombolo zewebhusayithi engekho kwinethiwekhi
    .accesskey = e

sanitize-everything-undo-warning = Eli nyathelo alinakujikwa.

window-close =
    .key = w

sanitize-button-ok =
    .label = Susa ngoku

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Ukususa

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Yonke imbali iza kususwa.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Zonke iiayithem ezikhethiweyo ziza kususwa.
