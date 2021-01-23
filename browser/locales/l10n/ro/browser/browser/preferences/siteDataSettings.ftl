# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Gestionează cookie-urile și datele site-urilor

site-data-settings-description = Următoarele site-uri web stochează cookie-uri și date ale site-urilor pe calculator. { -brand-short-name } păstrează date de la site-urile web cu stocare persistentă până când le ștergi și șterge datele de la site-urile web cu stocare nonpersistentă când este nevoie de spațiu.

site-data-search-textbox =
    .placeholder = Caută site-uri web
    .accesskey = S

site-data-column-host =
    .label = Site
site-data-column-cookies =
    .label = Cookie-uri
site-data-column-storage =
    .label = Stocare
site-data-column-last-used =
    .label = Ultima utilizare

# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (fișier local)

site-data-remove-selected =
    .label = Elimină selecția
    .accesskey = R

site-data-button-cancel =
    .label = Renunță
    .accesskey = C

site-data-button-save =
    .label = Salvează schimbările
    .accesskey = a

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (persistentă)

site-data-remove-all =
    .label = Elimină tot
    .accesskey = e

site-data-remove-shown =
    .label = Elimină toate cele afișate
    .accesskey = e

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Elimină

site-data-removing-header = Eliminarea cookie-urilor și a datelor site-urilor

site-data-removing-desc = Eliminarea cookie-urilor și a datelor site-urilor te-ar putea deconecta de pe site-uri web. Sigur vrei să efectuezi schimbările?

site-data-removing-table = Vor fi eliminate cookie-urile și datele site-urilor pentru următoarele site-uri web
