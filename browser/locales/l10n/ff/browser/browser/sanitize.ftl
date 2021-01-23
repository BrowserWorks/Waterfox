# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Teelte Momtugol Aslol
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Momtu Aslol Sakket
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Momtu Aslol Fof
    .style = width: 34em

clear-data-settings-label = So uddiima tan, { -brand-short-name } ina foti ɗoon e ɗoon momtude fof

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Njuuteendi sahaa momtugol:{ " " }
    .accesskey = N

clear-time-duration-value-last-hour =
    .label = Waktu Ɓennuɗo oo

clear-time-duration-value-last-2-hours =
    .label = Waktuuji Ɗiɗi Ɓennuɗi ɗii

clear-time-duration-value-last-4-hours =
    .label = Waktuuji Nay Ɓennuɗi ɗii

clear-time-duration-value-today =
    .label = Hannde

clear-time-duration-value-everything =
    .label = Fofof

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Aslol

item-history-and-downloads =
    .label = Aslol Peeragol & Aawtagol
    .accesskey = P

item-cookies =
    .label = Kukiije
    .accesskey = K

item-active-logins =
    .label = Ceŋe Caasɗe
    .accesskey = C

item-cache =
    .label = Kaasol
    .accesskey = a

item-form-search-history =
    .label = Formere & Aslol Njiilaw
    .accesskey = F

data-section-label = Keɓe

item-site-preferences =
    .label = Cuɓoraaɗe Lowre
    .accesskey = L

item-offline-apps =
    .label = Keɓe Lowre Ceŋrol
    .accesskey = K

sanitize-everything-undo-warning = Ngal baɗal waawaa firteede.

window-close =
    .key = w

sanitize-button-ok =
    .label = Momtu Jooni

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Nana momta

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Aslol fof maa momte.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Teme labaaɗe fof maa momte.
