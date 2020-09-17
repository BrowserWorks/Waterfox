# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Nastavitve brisanja zgodovine
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Počisti nedavno zgodovino
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Počisti vso zgodovino
    .style = width: 34em

clear-data-settings-label = Ob izhodu naj { -brand-short-name } samodejno počisti

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Časovni obseg brisanja:{ " " }
    .accesskey = o

clear-time-duration-value-last-hour =
    .label = Zadnja ura

clear-time-duration-value-last-2-hours =
    .label = Zadnji dve uri

clear-time-duration-value-last-4-hours =
    .label = Zadnje štiri ure

clear-time-duration-value-today =
    .label = Danes

clear-time-duration-value-everything =
    .label = Vse

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Zgodovino

item-history-and-downloads =
    .label = zgodovino brskanja in prenosov
    .accesskey = B

item-cookies =
    .label = piškotke
    .accesskey = P

item-active-logins =
    .label = aktivne prijave
    .accesskey = A

item-cache =
    .label = predpomnilnik
    .accesskey = R

item-form-search-history =
    .label = zgodovino obrazcev in iskanja
    .accesskey = I

data-section-label = Podatke

item-site-preferences =
    .label = nastavitve strani
    .accesskey = S

item-offline-apps =
    .label = podatke pri delu brez povezave
    .accesskey = B

sanitize-everything-undo-warning = Tega dejanja ni mogoče razveljaviti.

window-close =
    .key = w

sanitize-button-ok =
    .label = Počisti zdaj

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Čiščenje

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Vsa zgodovina bo izbrisana.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Vsi izbrani predmeti bodo izbrisani.
