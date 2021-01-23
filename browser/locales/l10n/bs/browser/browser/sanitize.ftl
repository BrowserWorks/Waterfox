# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Postavke za čišćenje historije
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Obriši skorašnju historiju
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Obriši cijelu historiju
    .style = width: 34em

clear-data-settings-label = Pri zatvaranju, { -brand-short-name } će automatski brisati sve

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Vremensko razdoblje za brisanje:{ " " }
    .accesskey = V

clear-time-duration-value-last-hour =
    .label = Zadnji sat

clear-time-duration-value-last-2-hours =
    .label = Zadnja dva sata

clear-time-duration-value-last-4-hours =
    .label = Zadnja četiri sata

clear-time-duration-value-today =
    .label = Danas

clear-time-duration-value-everything =
    .label = Sve

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Historija

item-history-and-downloads =
    .label = Historija surfanja & preuzimanja
    .accesskey = H

item-cookies =
    .label = Kolačići
    .accesskey = K

item-active-logins =
    .label = Aktivne prijave
    .accesskey = A

item-cache =
    .label = Cache
    .accesskey = a

item-form-search-history =
    .label = Historija formi i pretrage
    .accesskey = f

data-section-label = Podaci

item-site-preferences =
    .label = Postavke stranice
    .accesskey = s

item-offline-apps =
    .label = Offline podaci web stranica
    .accesskey = O

sanitize-everything-undo-warning = Ova radnja se ne može poništiti.

window-close =
    .key = w

sanitize-button-ok =
    .label = Očisti odmah

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Čistim

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Cijela historija će biti obrisana.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Sve označene stavke će biti obrisane.
