# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Preferense da scancelaçion da Stöia
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Scancella a stöia ciù neuva
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Scancelâ tutta a stöia
    .style = width: 34em

clear-data-settings-label = Quande sciòrto da { -brand-short-name }, o dove netezâ tutto in aotomatico

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Periodo da scancelâ:{ " " }
    .accesskey = P

clear-time-duration-value-last-hour =
    .label = Urtima oa

clear-time-duration-value-last-2-hours =
    .label = Urtime doe oe

clear-time-duration-value-last-4-hours =
    .label = Urtime quattro oe

clear-time-duration-value-today =
    .label = Ancheu

clear-time-duration-value-everything =
    .label = Tutto

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Stöia

item-history-and-downloads =
    .label = Stöia di descaregamenti & Navegaçion
    .accesskey = S

item-cookies =
    .label = Cookie
    .accesskey = C

item-active-logins =
    .label = Conescioin ative
    .accesskey = L

item-cache =
    .label = Cache
    .accesskey = a

item-form-search-history =
    .label = Stöia di Mòdoli & Riçerche
    .accesskey = S

data-section-label = Dæta

item-site-preferences =
    .label = Preferense di sciti
    .accesskey = s

item-offline-apps =
    .label = Dæti feua linia do scito
    .accesskey = o

sanitize-everything-undo-warning = St'açion a no peu ese anula.

window-close =
    .key = w

sanitize-button-ok =
    .label = Scancelâ òua

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Son derê a scancelâ

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Tutta a stöia a saiâ scancelâ.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Tutti i elementi seleçionæ saian scancelæ.
