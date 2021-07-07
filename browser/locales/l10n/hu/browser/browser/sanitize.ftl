# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Előzmények törlésének beállításai
    .style = width: 40em

sanitize-prefs-style =
    .style = width: 20em

dialog-title =
    .title = Előzmények törlése
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Minden előzmény törlése
    .style = width: 34em

clear-data-settings-label = Bezáráskor a { -brand-short-name } mindent távolítson el automatikusan

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Törlendő időtartomány:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = Utolsó egy óra

clear-time-duration-value-last-2-hours =
    .label = Utolsó két óra

clear-time-duration-value-last-4-hours =
    .label = Utolsó négy óra

clear-time-duration-value-today =
    .label = Ma

clear-time-duration-value-everything =
    .label = Minden

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Előzmények

item-history-and-downloads =
    .label = Böngészési és letöltési előzmények
    .accesskey = B

item-cookies =
    .label = Sütik
    .accesskey = t

item-active-logins =
    .label = Aktív bejelentkezések
    .accesskey = A

item-cache =
    .label = Gyorsítótár
    .accesskey = G

item-form-search-history =
    .label = Űrlapok és keresőmezők előzményei
    .accesskey = r

data-section-label = Adatok

item-site-preferences =
    .label = Webhely beállításai
    .accesskey = W

item-offline-apps =
    .label = Kapcsolat nélküli webhelyadatok
    .accesskey = o

sanitize-everything-undo-warning = Ez a művelet nem vonható vissza.

window-close =
    .key = w

sanitize-button-ok =
    .label = Törlés most

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Törlés

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Minden előzmény törölve lesz.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Minden kijelölt elem törölve lesz.
