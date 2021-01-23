# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Mga pagtatakda para sa Pagbura ng Kasaysayan
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Burahin ang Kasaysayan Kamakailan
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Burahin Lahat ng Kasaysayan
    .style = width: 34em

clear-data-settings-label = Kapag isinara, buburahin dapat ng { -brand-short-name } ang lahat

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Saklaw ng oras upang burahin:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = Huling Oras

clear-time-duration-value-last-2-hours =
    .label = Nakaraang dalawang oras

clear-time-duration-value-last-4-hours =
    .label = Nakaraang apat na oras

clear-time-duration-value-today =
    .label = Ngayon

clear-time-duration-value-everything =
    .label = Lahat

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Kasaysayan

item-history-and-downloads =
    .label = Kasaysayan ng Pag-browse & Pag-download
    .accesskey = B

item-cookies =
    .label = Mga Cookie
    .accesskey = C

item-active-logins =
    .label = Mga Active Login
    .accesskey = L

item-cache =
    .label = Cache
    .accesskey = A

item-form-search-history =
    .label = Form & Search History
    .accesskey = F

data-section-label = Data

item-site-preferences =
    .label = Mga Kagustuhan sa Site
    .accesskey = S

item-offline-apps =
    .label = Offline Website Data
    .accesskey = O

sanitize-everything-undo-warning = Ang pagkilos na ito'y hindi na maaaring baliktarin.

window-close =
    .key = w

sanitize-button-ok =
    .label = Burahin na Ngayon

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Binubura

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Buburahin lahat ng kasaysayan.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Ang lahat ng pinili ay buburahin.
