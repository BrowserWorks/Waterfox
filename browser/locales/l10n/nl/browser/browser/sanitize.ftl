# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Instellingen voor het wissen van geschiedenis
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Recente geschiedenis wissen
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Alle geschiedenis wissen
    .style = width: 34em

clear-data-settings-label = Als { -brand-short-name } wordt afgesloten, automatisch het volgende wissen

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Te wissen tijdsperiode:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = Laatste uur

clear-time-duration-value-last-2-hours =
    .label = Laatste twee uur

clear-time-duration-value-last-4-hours =
    .label = Laatste vier uur

clear-time-duration-value-today =
    .label = Vandaag

clear-time-duration-value-everything =
    .label = Alles

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Geschiedenis

item-history-and-downloads =
    .label = Navigatie- & downloadgeschiedenis
    .accesskey = N

item-cookies =
    .label = Cookies
    .accesskey = C

item-active-logins =
    .label = Actieve aanmeldingen
    .accesskey = A

item-cache =
    .label = Buffer
    .accesskey = B

item-form-search-history =
    .label = Formulier- & zoekgeschiedenis
    .accesskey = F

data-section-label = Gegevens

item-site-preferences =
    .label = Websitevoorkeuren
    .accesskey = v

item-offline-apps =
    .label = Offlinewebsitegegevens
    .accesskey = O

sanitize-everything-undo-warning = Deze actie kan niet ongedaan worden gemaakt.

window-close =
    .key = w

sanitize-button-ok =
    .label = Nu wissen

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Wissen

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Alle geschiedenis zal worden gewist.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Alle geselecteerde items zullen worden gewist.
