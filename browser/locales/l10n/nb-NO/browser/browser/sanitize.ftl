# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Innstillinger for sletting av historikk
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Slett nylig historikk
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Slett all historikk
    .style = width: 34em

clear-data-settings-label = Når { -brand-short-name } avslutter, skal følgende slettes automatisk

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Slett tidsrommet:{ " " }
    .accesskey = S

clear-time-duration-value-last-hour =
    .label = Den siste timen

clear-time-duration-value-last-2-hours =
    .label = De siste 2 timene

clear-time-duration-value-last-4-hours =
    .label = De siste 4 timene

clear-time-duration-value-today =
    .label = Hele dagen

clear-time-duration-value-everything =
    .label = Alt

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Historikk

item-history-and-downloads =
    .label = Nettleser- og nedlastingshistorikk
    .accesskey = N

item-cookies =
    .label = Infokapsler
    .accesskey = I

item-active-logins =
    .label = Aktive innlogginger
    .accesskey = A

item-cache =
    .label = Hurtiglager for nettsider
    .accesskey = H

item-form-search-history =
    .label = Skjema- og søkehistorikk
    .accesskey = S

data-section-label = Data

item-site-preferences =
    .label = Nettstedsinnstillinger
    .accesskey = N

item-offline-apps =
    .label = Frakoblet nettstedsdata
    .accesskey = F

sanitize-everything-undo-warning = Denne handlingen kan ikke angres.

window-close =
    .key = w

sanitize-button-ok =
    .label = Slett nå

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Sletter

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = All historikk vil slettes.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Alle valgte elementer vil slettes.
