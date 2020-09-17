# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Privāto datu dzēšanas iestatījumi
    .style = width: 40em

sanitize-prefs-style =
    .style = width: 19em

dialog-title =
    .title = Dzēst pārlūkošanas vēsturi
    .style = width: 40em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Dzēst visu vēsturi
    .style = width: 40em

clear-data-settings-label = Kad es aizveru { -brand-short-name } dzēst šo

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Aizvākt{ " " }
    .accesskey = A

clear-time-duration-value-last-hour =
    .label = pēdējo stundu

clear-time-duration-value-last-2-hours =
    .label = pēdējās 2 stundas

clear-time-duration-value-last-4-hours =
    .label = pēdējās 4 stundas

clear-time-duration-value-today =
    .label = šīs dienas pārlūkošanas vēsturi

clear-time-duration-value-everything =
    .label = visu pārlūkošanas vēsturi

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Vēsture

item-history-and-downloads =
    .label = Pārlūkošanas un lejupielāžu vēsturi
    .accesskey = r

item-cookies =
    .label = Sīkdatnes
    .accesskey = S

item-active-logins =
    .label = Aktīvos lietotājus
    .accesskey = l

item-cache =
    .label = Kešatmiņu
    .accesskey = K

item-form-search-history =
    .label = Formu un meklēšanas vēsturi
    .accesskey = F

data-section-label = Dati

item-site-preferences =
    .label = Lapas iestatījumus
    .accesskey = s

item-offline-apps =
    .label = Lapu nesaistes datus
    .accesskey = t

sanitize-everything-undo-warning = Šī ir neatgriezeniska darbība.

window-close =
    .key = w

sanitize-button-ok =
    .label = Dzēst privātos datus

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Notiek tīrīšana

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Visa vēsture tiks dzēsta.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Visas izvēlētās vienības tiks dzēstas.
