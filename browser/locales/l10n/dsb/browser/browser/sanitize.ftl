# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Nastajenja za wuproznjenje historije
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Aktualnu historiju wuprozniś
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Cełu historiju wuprozniś
    .style = width: 34em

clear-data-settings-label = Gaž { -brand-short-name } se kóńcy, by měło se wšykno awtomatiski wulašowaś

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Cas za wuproznjenje:{ " " }
    .accesskey = C

clear-time-duration-value-last-hour =
    .label = Zachadna góźina

clear-time-duration-value-last-2-hours =
    .label = Zachadnej dwě góźinje

clear-time-duration-value-last-4-hours =
    .label = Zachadne styri góźiny

clear-time-duration-value-today =
    .label = Źinsa

clear-time-duration-value-everything =
    .label = Wšykno

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Historija

item-history-and-downloads =
    .label = Pśeglědowańska a ześěgnjeńska historija
    .accesskey = P

item-cookies =
    .label = Cookieje
    .accesskey = C

item-active-logins =
    .label = Aktiwne pśizjawjenja
    .accesskey = A

item-cache =
    .label = Pufrowak
    .accesskey = u

item-form-search-history =
    .label = Historija formularow a pytanja
    .accesskey = f

data-section-label = Daty

item-site-preferences =
    .label = Sedłowe nastajenja
    .accesskey = S

item-offline-apps =
    .label = Daty websedła offline
    .accesskey = D

sanitize-everything-undo-warning = Toś ta akcija njedajo se anulěrowaś.

window-close =
    .key = w

sanitize-button-ok =
    .label = Něnto wuprozniś

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Wuprozniś

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Wša historija se wuproznijo.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Wšykne wubrane zapiski se wótpóraju.
