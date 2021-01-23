# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Paramètres per voidar las donadas privadas
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Voidar l'istoric recent
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Suprimir tot l'istoric
    .style = width: 34em

clear-data-settings-label = En tampant { -brand-short-name }, escafant automaticament los elements seguents

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Periòde de suprimir :{ " " }
    .accesskey = s

clear-time-duration-value-last-hour =
    .label = la darrièra ora

clear-time-duration-value-last-2-hours =
    .label = las darrièras doas oras

clear-time-duration-value-last-4-hours =
    .label = las darrièras quatre oras

clear-time-duration-value-today =
    .label = Uèi

clear-time-duration-value-everything =
    .label = Tot

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Istoric

item-history-and-downloads =
    .label = Istoric de navegacion e dels telecargaments
    .accesskey = I

item-cookies =
    .label = Cookies
    .accesskey = C

item-active-logins =
    .label = Connexions activas
    .accesskey = a

item-cache =
    .label = Escondedor
    .accesskey = E

item-form-search-history =
    .label = Istoric dels formularis e de las recèrcas
    .accesskey = f

data-section-label = Donadas

item-site-preferences =
    .label = Preferéncias del site
    .accesskey = P

item-offline-apps =
    .label = Donadas de site web fòra connexion
    .accesskey = D

sanitize-everything-undo-warning = Impossible d'anullar aquesta accion.

window-close =
    .key = w

sanitize-button-ok =
    .label = Escafar ara

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Escafament

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Tot l'istoric serà escafat.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Tot l'istoric serà escafat.
