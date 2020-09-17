# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Daj dure' riña gaché nu'
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Dure' riña gaché nu'
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Nadure' riña gaché nu'
    .style = width: 34em

clear-data-settings-label = 'Ngà ganaránt, { -brand-short-name } ni nare' ma'an ma

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Diu da'uit dure't:
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = Sa' rukù ni'in

clear-time-duration-value-last-2-hours =
    .label = Huij hora rukù ni'in

clear-time-duration-value-last-4-hours =
    .label = Huij hora rukù ni'in

clear-time-duration-value-today =
    .label = Gui hiáj

clear-time-duration-value-everything =
    .label = Da'ua ngej

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Riña gaché nut

item-history-and-downloads =
    .label = Riña gaché nu' ni nej sa naduni'
    .accesskey = B

item-cookies =
    .label = Kookies
    .accesskey = C

item-active-logins =
    .label = Konexion hua
    .accesskey = L

item-cache =
    .label = Kache
    .accesskey = A

item-form-search-history =
    .label = Nej sa nana'ui' ni formulario
    .accesskey = F

data-section-label = Nej dato

item-site-preferences =
    .label = Sitio preferensia
    .accesskey = S

item-offline-apps =
    .label = Nitaj konexion hua rinà sitio web
    .accesskey = O

sanitize-everything-undo-warning = Si ga'ue dure' sa 'ngà gahuin na.

window-close =
    .key = w

sanitize-button-ok =
    .label = Dure' hiaj

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = 'Hìaj nadure'ej

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Nare' daran' riña aché nut.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Nare' nej sa ganahuit.
