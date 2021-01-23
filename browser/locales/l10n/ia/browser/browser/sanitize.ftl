# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Parametros pro vacuar le chronologia
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Vacuar le chronologia recente
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Vacuar tote le chronologia
    .style = width: 34em

clear-data-settings-label = Quando claudite, { -brand-short-name } deberea automaticamente rader tote le

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Intervallo de tempore a vacuar:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = Ultime hora

clear-time-duration-value-last-2-hours =
    .label = Ultime duo horas

clear-time-duration-value-last-4-hours =
    .label = Ultime quatro horas

clear-time-duration-value-today =
    .label = Hodie

clear-time-duration-value-everything =
    .label = Toto

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Chronologia

item-history-and-downloads =
    .label = Chronologia de navigation e de discargamentos
    .accesskey = C

item-cookies =
    .label = Cookies
    .accesskey = C

item-active-logins =
    .label = Authenticationes active
    .accesskey = u

item-cache =
    .label = Cache
    .accesskey = A

item-form-search-history =
    .label = Chronologia de recercas e formularios
    .accesskey = F

data-section-label = Datos

item-site-preferences =
    .label = Preferentias de sito
    .accesskey = S

item-offline-apps =
    .label = Datos de sitos web foras de linea
    .accesskey = o

sanitize-everything-undo-warning = Iste action es irreversibile.

window-close =
    .key = w

sanitize-button-ok =
    .label = Vacuar ora

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Vacuante

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Tote le chronologia essera vacuate.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Tote le elementos seligite essera vacuate.
