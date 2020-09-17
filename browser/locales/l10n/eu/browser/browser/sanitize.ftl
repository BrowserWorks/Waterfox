# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Historia garbitzeko ezarpenak
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Garbitu azken historia
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Garbitu historia osoa
    .style = width: 34em

clear-data-settings-label = { -brand-short-name } ixtean, garbitu automatikoki

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Garbituko den denbora-tartea:{ " " }
    .accesskey = t

clear-time-duration-value-last-hour =
    .label = Azken ordua

clear-time-duration-value-last-2-hours =
    .label = Azken bi orduak

clear-time-duration-value-last-4-hours =
    .label = Azken lau orduak

clear-time-duration-value-today =
    .label = Gaur

clear-time-duration-value-everything =
    .label = Dena

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Historia

item-history-and-downloads =
    .label = Nabigatze- eta deskarga-historia
    .accesskey = b

item-cookies =
    .label = Cookieak
    .accesskey = C

item-active-logins =
    .label = Saio-hasiera aktiboak
    .accesskey = S

item-cache =
    .label = Cachea
    .accesskey = a

item-form-search-history =
    .label = Inprimaki- eta bilaketa-historia
    .accesskey = n

data-section-label = Datuak

item-site-preferences =
    .label = Gunearen hobespenak
    .accesskey = s

item-offline-apps =
    .label = Lineaz kanpoko webguneen datuak
    .accesskey = L

sanitize-everything-undo-warning = Aldaketa hau ezin da desegin.

window-close =
    .key = w

sanitize-button-ok =
    .label = Garbitu orain

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Garbitzen

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Historia guztia garbituko da.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Hautatutako elementu guztiak garbituko dira.
