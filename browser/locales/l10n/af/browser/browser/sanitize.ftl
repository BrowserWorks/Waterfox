# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Tydomvang om te wis:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = Vorige uur

clear-time-duration-value-last-2-hours =
    .label = Vorige twee uur

clear-time-duration-value-last-4-hours =
    .label = Vorige vier uur

clear-time-duration-value-today =
    .label = Vandag

clear-time-duration-value-everything =
    .label = Alles

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Geskiedenis

item-history-and-downloads =
    .label = Blaai- en aflaaigeskiedenis
    .accesskey = B

item-cookies =
    .label = Koekies
    .accesskey = K

item-active-logins =
    .label = Aktiewe aanmeldings
    .accesskey = a

item-cache =
    .label = Kas
    .accesskey = a

item-form-search-history =
    .label = Vorm- en soekgeskiedenis
    .accesskey = V

data-section-label = Data

item-site-preferences =
    .label = Werfvoorkeure
    .accesskey = W

item-offline-apps =
    .label = Vanlyn webwerfdata
    .accesskey = V

sanitize-everything-undo-warning = Hierdie aksie kan nie ontdoen word nie.

window-close =
    .key = w

sanitize-button-ok =
    .label = Wis nou

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Wis tans

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Alle geskiedenis sal gewis word.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Alle gekose items sal gewis word.
