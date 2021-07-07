# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Innstillingar for sletting av historikk
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Slett nyleg historikk
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Slett all historikk
    .style = width: 34em

clear-data-settings-label = Når { -brand-short-name } avsluttar, skal følgjande slettast automatisk

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Tidsperiode å slette:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = Den siste timen

clear-time-duration-value-last-2-hours =
    .label = Dei siste to timane

clear-time-duration-value-last-4-hours =
    .label = Dei siste 4 timane

clear-time-duration-value-today =
    .label = I dag

clear-time-duration-value-everything =
    .label = Alt

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Historikk

item-history-and-downloads =
    .label = Nettlesing- og nedlastingshistorikk
    .accesskey = e

item-cookies =
    .label = Infokapslar
    .accesskey = I

item-active-logins =
    .label = Aktive innloggingar
    .accesskey = A

item-cache =
    .label = Snøgglager (Cache) for nettsider
    .accesskey = S

item-form-search-history =
    .label = Skjema og søkjehistorikk
    .accesskey = S

data-section-label = Data

item-site-preferences =
    .label = Nettsideinnstillingar
    .accesskey = N

item-site-settings =
    .label = Nettstadinnstillingar
    .accesskey = N

item-offline-apps =
    .label = Fråkopla nettsidedata
    .accesskey = F

sanitize-everything-undo-warning = Denne handlinga kan ikkje angrast.

window-close =
    .key = w

sanitize-button-ok =
    .label = Slett no

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Slettar

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = All historikk vert sletta

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Alle valde element vert sletta
