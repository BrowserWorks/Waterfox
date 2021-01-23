# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Roghainnean a chum glanadh na h-eachdraidh
    .style = width: 45em

sanitize-prefs-style =
    .style = width: 30em

dialog-title =
    .title = Glan an eachdraidh faisg ort
    .style = width: 45em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Glan an eachdraidh gu lèir
    .style = width: 45em

clear-data-settings-label = Nuair a thèid a dhùnadh, bu chòir dha { -brand-short-name } na leanas a ghlanadh gu fèin-obrachail:

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Raon ama ri ghlanadh:{ " " }
    .accesskey = R

clear-time-duration-value-last-hour =
    .label = An uair a thìde seo chaidh

clear-time-duration-value-last-2-hours =
    .label = An 2 uair a thìde seo chaidh

clear-time-duration-value-last-4-hours =
    .label = Na 4 uairean a thìde seo chaidh

clear-time-duration-value-today =
    .label = An-diugh

clear-time-duration-value-everything =
    .label = A h-uile rud

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Eachdraidh

item-history-and-downloads =
    .label = An eachdraidh brabhsaidh ⁊ na chaidh a luchdadh a-nuas
    .accesskey = b

item-cookies =
    .label = Na briosgaidean
    .accesskey = b

item-active-logins =
    .label = Logadh a-steach beò sam bith
    .accesskey = L

item-cache =
    .label = An tasgadan
    .accesskey = a

item-form-search-history =
    .label = Eachdraidh nam foirmean ⁊ nan lorg
    .accesskey = f

data-section-label = Dàta

item-site-preferences =
    .label = Roghainnean nan làrach
    .accesskey = R

item-offline-apps =
    .label = Dàta làraichean far loidhne
    .accesskey = o

sanitize-everything-undo-warning = Chan urrainn dhut an gnìomh seo a neo-dhèanamh.

window-close =
    .key = w

sanitize-button-ok =
    .label = Falamhaich e an-dràsta

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = A' falamhadh

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Thèid an eachdraidh gu lèir a ghlanadh.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Thèid gach rud a thagh thu a ghlanadh.
