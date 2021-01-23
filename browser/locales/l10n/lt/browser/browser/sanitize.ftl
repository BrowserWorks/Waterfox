# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Žurnalo valymo nuostatos
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Žurnalo valymas
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Visiškas žurnalo išvalymas
    .style = width: 34em

clear-data-settings-label = Baigiant darbą su „{ -brand-short-name }“, turi būti išvaloma:

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Pašalinti
    .accesskey = P

clear-time-duration-value-last-hour =
    .label = pastarosios valandos

clear-time-duration-value-last-2-hours =
    .label = pastarųjų dviejų valandų

clear-time-duration-value-last-4-hours =
    .label = pastarųjų keturių valandų

clear-time-duration-value-today =
    .label = šios dienos

clear-time-duration-value-everything =
    .label = visus

clear-time-duration-suffix =
    .value = įrašus

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Žurnalas

item-history-and-downloads =
    .label = Naršymo ir atsiuntimų žurnalas
    .accesskey = N

item-cookies =
    .label = Slapukai
    .accesskey = a

item-active-logins =
    .label = Esami prisijungimai
    .accesskey = E

item-cache =
    .label = Podėlis
    .accesskey = P

item-form-search-history =
    .label = Formų ir paieškos laukų reikšmės
    .accesskey = F

data-section-label = Kita

item-site-preferences =
    .label = Svetainių nuostatos
    .accesskey = v

item-offline-apps =
    .label = Duomenys darbui neprisijungus
    .accesskey = D

sanitize-everything-undo-warning = Atlikus šį veiksmą, jo atšaukti neįmanoma.

window-close =
    .key = w

sanitize-button-ok =
    .label = Valyti

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Valoma

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Žurnalas bus visiškai išvalytas.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Visi pažymėti įrašai bus pašalinti iš žurnalo.
