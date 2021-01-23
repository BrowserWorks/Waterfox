# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Gosodiadau Clirio Hanes
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Clirio'r Hanes Diweddar
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Clirio'r Holl Hanes
    .style = width: 34em

clear-data-settings-label = Pan fyddai'n gadael { -brand-short-name } dylai glirio popeth yn awtomatig

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Cyfnod i'w glirio:{ " " }
    .accesskey = C

clear-time-duration-value-last-hour =
    .label = Awr Diwethaf

clear-time-duration-value-last-2-hours =
    .label = Dwy Awr Diwethaf

clear-time-duration-value-last-4-hours =
    .label = Pedair Awr Diwethaf

clear-time-duration-value-today =
    .label = Heddiw

clear-time-duration-value-everything =
    .label = Popeth

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Hanes

item-history-and-downloads =
    .label = Hanes Pori a Llwytho i Lawr
    .accesskey = H

item-cookies =
    .label = Cwcis
    .accesskey = w

item-active-logins =
    .label = Mewngofnodion Gweithredol
    .accesskey = M

item-cache =
    .label = Storfa Dros Dro
    .accesskey = S

item-form-search-history =
    .label = Hanes Ffurflenni a Chwilio
    .accesskey = F

data-section-label = Data

item-site-preferences =
    .label = Dewisiadau'r Wefan
    .accesskey = D

item-offline-apps =
    .label = Data Gwefan All-lein
    .accesskey = D

sanitize-everything-undo-warning = Nid oes modd dadwneud y weithred.

window-close =
    .key = w

sanitize-button-ok =
    .label = Clirio Nawr

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Clirio

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Bydd yr holl hanes yn cael ei glirio.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Bydd yr holl eitemau a ddewiswyd yn cael eu clirio.
