# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Einstellungen für das Löschen der Chronik
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Neueste Chronik löschen
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Gesamte Chronik löschen
    .style = width: 34em

clear-data-settings-label = Wenn { -brand-short-name } beendet wird, folgende Daten automatisch löschen:

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = { "" }
    .accesskey = { "" }

clear-time-duration-value-last-hour =
    .label = Die letzte Stunde

clear-time-duration-value-last-2-hours =
    .label = Die letzten zwei Stunden

clear-time-duration-value-last-4-hours =
    .label = Die letzten vier Stunden

clear-time-duration-value-today =
    .label = Die heutige Chronik

clear-time-duration-value-everything =
    .label = Alles

clear-time-duration-suffix =
    .value = löschen

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Chronik

item-history-and-downloads =
    .label = Besuchte Seiten & Download-Chronik
    .accesskey = B

item-cookies =
    .label = Cookies
    .accesskey = C

item-active-logins =
    .label = Aktive Logins
    .accesskey = L

item-cache =
    .label = Cache
    .accesskey = A

item-form-search-history =
    .label = Eingegebene Suchbegriffe & Formulardaten
    .accesskey = F

data-section-label = Daten

item-site-preferences =
    .label = Website-Einstellungen
    .accesskey = W

item-offline-apps =
    .label = Offline-Website-Daten
    .accesskey = O

sanitize-everything-undo-warning = Diese Aktion kann nicht rückgängig gemacht werden.

window-close =
    .key = w

sanitize-button-ok =
    .label = Jetzt löschen

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Wird gelöscht…

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Die gesamte Chronik wird gelöscht.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Alle ausgewählten Elemente werden gelöscht.
