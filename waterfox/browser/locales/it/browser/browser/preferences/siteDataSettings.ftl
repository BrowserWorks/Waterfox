# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Gestione cookie e dati dei siti web

site-data-settings-description = I seguenti siti web stanno salvando cookie e dati su questo computer. I dati salvati nell’archivio permanente vengono mantenuti in { -brand-short-name } fino a quando non vengono rimossi dall’utente, mentre i dati salvati nell’archivio non permanente vengono rimossi quando è necessario recuperare spazio.

site-data-search-textbox =
    .placeholder = Cerca sito web
    .accesskey = C

site-data-column-host =
    .label = Sito
site-data-column-cookies =
    .label = Cookie
site-data-column-storage =
    .label = Spazio utilizzato
site-data-column-last-used =
    .label = Ultimo utilizzo

site-data-local-file-host = (file locale)

site-data-remove-selected =
    .label = Rimuovi selezionati
    .accesskey = R

site-data-settings-dialog =
    .buttonlabelaccept = Salva modifiche
    .buttonaccesskeyaccept = S

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (permanente)

site-data-remove-all =
    .label = Rimuovi tutti
    .accesskey = u

site-data-remove-shown =
    .label = Rimuovi visualizzati
    .accesskey = u

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Rimuovi

site-data-removing-header = Rimozione cookie e dati dei siti web

site-data-removing-desc = La rimozione di cookie e dati dei siti web potrebbe comportare la disconnessione dai siti web. Rimuovere i dati?

# Variables:
#   $baseDomain (String) - The single domain for which data is being removed
site-data-removing-single-desc = La rimozione di cookie e dati dei siti web potrebbe comportare la disconnessione dai siti web. Rimuovere cookie e dati per <strong>{ $baseDomain }</strong>?

site-data-removing-table = Verranno rimossi i cookie e i dati per i seguenti siti web
