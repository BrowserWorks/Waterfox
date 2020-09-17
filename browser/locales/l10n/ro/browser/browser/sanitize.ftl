# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Setări pentru ștergerea istoricului
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Șterge istoricul recent
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Șterge tot istoricul
    .style = width: 34em

clear-data-settings-label = Când este închis, { -brand-short-name } ar trebui să șteargă automat totul

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Perioadă de șters:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = Ultima oră

clear-time-duration-value-last-2-hours =
    .label = Ultimele două ore

clear-time-duration-value-last-4-hours =
    .label = Ultimele patru ore

clear-time-duration-value-today =
    .label = Azi

clear-time-duration-value-everything =
    .label = Tot

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Istoric

item-history-and-downloads =
    .label = Istoricul navigării și al descărcărilor
    .accesskey = B

item-cookies =
    .label = Cookie-urile
    .accesskey = C

item-active-logins =
    .label = Autentificările active
    .accesskey = L

item-cache =
    .label = Cache-ul
    .accesskey = a

item-form-search-history =
    .label = Istoricul formularelor și al căutărilor
    .accesskey = F

data-section-label = Date

item-site-preferences =
    .label = Preferințele pentru site-uri
    .accesskey = S

item-offline-apps =
    .label = Datele offline ale site-urilor web
    .accesskey = O

sanitize-everything-undo-warning = Această acțiune este ireversibilă.

window-close =
    .key = w

sanitize-button-ok =
    .label = Șterge acum

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Se șterge

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Va fi șters tot istoricul.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Se vor șterge toate elementele selectate.
