# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Behandle infokapsler og nettstedsdata

site-data-settings-description = Følgende nettsteder lagrer infokapsler og nettsteddata på datamaskinen. { -brand-short-name } lagrer data fra nettsteder med vedvarende lagring inntil du sletter dem og sletter data fra nettsteder med ikke-vedvarende lagring ettersom det trenges plass.

site-data-search-textbox =
    .placeholder = Søk på nettsider
    .accesskey = S

site-data-column-host =
    .label = Nettsted
site-data-column-cookies =
    .label = Infokapsler
site-data-column-storage =
    .label = Lagring
site-data-column-last-used =
    .label = Sist brukt

# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (lokal fil)

site-data-remove-selected =
    .label = Fjern valgte
    .accesskey = r

site-data-button-cancel =
    .label = Avbryt
    .accesskey = A

site-data-button-save =
    .label = Lagre endringer
    .accesskey = a

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (permanent)

site-data-remove-all =
    .label = Fjern alle
    .accesskey = e

site-data-remove-shown =
    .label = Fjern alle vist
    .accesskey = e

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Fjern

site-data-removing-header = Fjerner infokapsler og nettstedsdata

site-data-removing-desc = Fjerning av infokapsler og nettstedsdata kan logge deg ut av nettsider. Er du sikker på at du vil gjøre endringene?

site-data-removing-table = Infokapsler og nettstedsdata fra følgende nettsteder vil bli fjernet
