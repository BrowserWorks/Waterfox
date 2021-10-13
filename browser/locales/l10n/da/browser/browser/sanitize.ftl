# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Indstillinger for rydning af historik
    .style = width: 34em
sanitize-prefs-style =
    .style = width: 17em
dialog-title =
    .title = Ryd historik
    .style = width: 34em
# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Ryd al historik
    .style = width: 34em
clear-data-settings-label = Når jeg lukker { -brand-short-name }, skal den automatisk rydde:

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Fjern{ " " }
    .accesskey = F
clear-time-duration-value-last-hour =
    .label = min historik for den seneste time
clear-time-duration-value-last-2-hours =
    .label = min historik for de seneste to timer
clear-time-duration-value-last-4-hours =
    .label = min historik for de seneste fire timer
clear-time-duration-value-today =
    .label = min historik for i dag
clear-time-duration-value-everything =
    .label = hele min historik
clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Historik
item-history-and-downloads =
    .label = Browser- og filhentningshistorik
    .accesskey = B
item-cookies =
    .label = Cookies
    .accesskey = C
item-active-logins =
    .label = Aktive logins
    .accesskey = A
item-cache =
    .label = Cache
    .accesskey = h
item-form-search-history =
    .label = Formular- og søgehistorik
    .accesskey = s
data-section-label = Data
item-site-preferences =
    .label = Webstedsspecifikke indstillinger
    .accesskey = W
item-site-settings =
    .label = Webstedsspecifikke indstillinger
    .accesskey = W
item-offline-apps =
    .label = Offline webstedsdata
    .accesskey = O
sanitize-everything-undo-warning = Denne handling kan ikke fortrydes.
window-close =
    .key = w
sanitize-button-ok =
    .label = Ryd nu
# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = rydder historik
# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Al historik vil blive ryddet.
# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Alle valgte emner vil blive ryddet.
