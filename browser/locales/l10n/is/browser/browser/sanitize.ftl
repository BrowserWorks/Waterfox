# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Stillingar fyrir ferilhreinsun
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Hreinsa nýlega ferla
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Hreinsa alla ferla
    .style = width: 34em

clear-data-settings-label = Þegar lokað er ætti { -brand-short-name } sjálfkrafa að hreinsa allt.

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Tímabil sem á að hreinsa:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = Seinasta klukkustund

clear-time-duration-value-last-2-hours =
    .label = Seinustu tvær klukkustundir

clear-time-duration-value-last-4-hours =
    .label = Seinustu fjórar klukkustundir

clear-time-duration-value-today =
    .label = Í dag

clear-time-duration-value-everything =
    .label = Allt

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Ferill

item-history-and-downloads =
    .label = Vafra og niðurhals ferla
    .accesskey = V

item-cookies =
    .label = Smákökur
    .accesskey = S

item-active-logins =
    .label = Virkar innskráningar
    .accesskey = i

item-cache =
    .label = Biðminni
    .accesskey = B

item-form-search-history =
    .label = Eyðublaða og leitarferill
    .accesskey = f

data-section-label = Gögn

item-site-preferences =
    .label = Stillingar vefsvæðis
    .accesskey = S

item-offline-apps =
    .label = Ónettengd vefgögn
    .accesskey = t

sanitize-everything-undo-warning = Ekki er ekki hægt að bakfæra þessa aðgerð.

window-close =
    .key = w

sanitize-button-ok =
    .label = Hreinsa núna

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Léttir til

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Allir ferlar verða hreinsaðir.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Allt sem er valið verður hreinsað.
