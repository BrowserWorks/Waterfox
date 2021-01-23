# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = ઇતિહાસ સાફ કરવા માટેના સેટીંગ
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = છેલ્લો ઇતિહાસ સાફ કરો
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = બધો ઇતિહાસ સાફ કરો
    .style = width: 34em

clear-data-settings-label = યારે બંધ હોય, { -brand-short-name } આપમેળે બધાને સાફ કરવું જોઈએ

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = દૂર કરો{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = છેલ્લો કલાક

clear-time-duration-value-last-2-hours =
    .label = છેલ્લા ૨ કલાકો

clear-time-duration-value-last-4-hours =
    .label = છેલ્લા ૪ કલાકો

clear-time-duration-value-today =
    .label = મારો આજનો ઇતિહાસ

clear-time-duration-value-everything =
    .label = મારો આખો ઇતિહાસ

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = ઇતિહાસ

item-history-and-downloads =
    .label = બ્રાઉઝીંગ અને ડાઉનલોડ ઇતિહાસ
    .accesskey = B

item-cookies =
    .label = કુકીઓ
    .accesskey = C

item-active-logins =
    .label = સક્રિય પ્રવેશો
    .accesskey = L

item-cache =
    .label = કેશ
    .accesskey = a

item-form-search-history =
    .label = ફોર્મ & શોધ ઇતિહાસ
    .accesskey = F

data-section-label = માહિતી

item-site-preferences =
    .label = સાઈટ પસંદગીઓ
    .accesskey = S

item-offline-apps =
    .label = ઓફલાઈન વેબસાઈટ માહિતી
    .accesskey = O

sanitize-everything-undo-warning = આ ક્રિયા રદ કરી શકાતી નથી.

window-close =
    .key = w

sanitize-button-ok =
    .label = હમણાં સાફ કરો

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = સાફ કરી રહ્યા છે

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = બધા ઇતિહાસને સાફ કરેલ હશે.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = બધી પસંદ થયેલ વસ્તુઓને સાફ કરેલ હશે.
