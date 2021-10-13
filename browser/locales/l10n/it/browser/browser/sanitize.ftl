# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Impostazioni per la cancellazione della cronologia
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Cancella cronologia recente
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Cancella tutta la cronologia
    .style = width: 34em

clear-data-settings-label = Alla chiusura di { -brand-short-name } eliminare automaticamente

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Intervallo di tempo da cancellare:{ " " }
    .accesskey = n

clear-time-duration-value-last-hour =
    .label = ultima ora

clear-time-duration-value-last-2-hours =
    .label = ultime due ore

clear-time-duration-value-last-4-hours =
    .label = ultime quattro ore

clear-time-duration-value-today =
    .label = oggi

clear-time-duration-value-everything =
    .label = tutto

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Cronologia

item-history-and-downloads =
    .label = Cronologia navigazione e download
    .accesskey = z

item-cookies =
    .label = Cookie
    .accesskey = o

item-active-logins =
    .label = Accessi effettuati
    .accesskey = A

item-cache =
    .label = Cache
    .accesskey = h

item-form-search-history =
    .label = Moduli e ricerche
    .accesskey = M

data-section-label = Dati

item-site-preferences =
    .label = Preferenze dei siti web
    .accesskey = P

item-site-settings =
    .label = Impostazioni dei siti web
    .accesskey = w

item-offline-apps =
    .label = Dati non in linea dei siti web
    .accesskey = w

sanitize-everything-undo-warning = Questa operazione non può essere annullata.

window-close =
    .key = w

sanitize-button-ok =
    .label = Cancella adesso

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Cancellazione in corso

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Tutta la cronologia verrà eliminata.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Tutti gli elementi selezionati verranno eliminati.
