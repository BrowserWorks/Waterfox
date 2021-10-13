# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Inställningar för rensning av historik
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 22em

dialog-title =
    .title = Rensa ut tidigare historik
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Ta bort all historik
    .style = width: 34em

clear-data-settings-label = När { -brand-short-name } stängs, ska följande tas bort automatiskt

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Tidsintervall att ta bort:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = Senaste timmen

clear-time-duration-value-last-2-hours =
    .label = Senaste 2 timmarna

clear-time-duration-value-last-4-hours =
    .label = Senaste 4 timmarna

clear-time-duration-value-today =
    .label = Idag

clear-time-duration-value-everything =
    .label = All historik

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Historik

item-history-and-downloads =
    .label = Besökta sidor och filhämtningshistorik
    .accesskey = B

item-cookies =
    .label = Kakor
    .accesskey = K

item-active-logins =
    .label = Aktiva inloggningar
    .accesskey = A

item-cache =
    .label = Cache
    .accesskey = C

item-form-search-history =
    .label = Formulär- och sökhistorik
    .accesskey = F

data-section-label = Data

item-site-preferences =
    .label = Platsspecifika inställningar
    .accesskey = P

item-site-settings =
    .label = Webbplatsinställningar
    .accesskey = W

item-offline-apps =
    .label = Nedkopplad webbplatsdata
    .accesskey = N

sanitize-everything-undo-warning = Den här åtgärden kan inte ångras.

window-close =
    .key = w

sanitize-button-ok =
    .label = Ta bort

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Tar bort

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = All historik kommer att tas bort.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Alla markerade poster kommer att tas bort.
