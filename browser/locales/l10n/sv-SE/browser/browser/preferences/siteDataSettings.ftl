# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Hantera kakor och webbplatsdata
site-data-settings-description = Följande webbplatser lagrar kakor och webbplatsdata på din dator. { -brand-short-name } spara data från webbplatser med beständig lagring tills du raderar det och raderar data från webbplatser med icke-beständig lagringsutrymme, eftersom det behövs utrymme.
site-data-search-textbox =
    .placeholder = Sök webbplatser
    .accesskey = S
site-data-column-host =
    .label = Webbplats
site-data-column-cookies =
    .label = Kakor
site-data-column-storage =
    .label = Lagring
site-data-column-last-used =
    .label = Senast använd
# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (lokal fil)
site-data-remove-selected =
    .label = Ta bort markerad
    .accesskey = T
site-data-button-cancel =
    .label = Avbryt
    .accesskey = A
site-data-button-save =
    .label = Spara ändringar
    .accesskey = a
site-data-settings-dialog =
    .buttonlabelaccept = Spara ändringar
    .buttonaccesskeyaccept = a
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (beständig)
site-data-remove-all =
    .label = Ta bort alla
    .accesskey = a
site-data-remove-shown =
    .label = Ta bort alla som visas
    .accesskey = a

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Ta bort
site-data-removing-header = Tar bort kakor och webbplatsdata
site-data-removing-desc = Om du tar bort kakor och webbplatsdata kan du loggas ut från webbplatser. Är du säker på att du vill göra dessa ändringar?
site-data-removing-table = Kakor och webbplatsdata för följande webbplatser kommer att tas bort
