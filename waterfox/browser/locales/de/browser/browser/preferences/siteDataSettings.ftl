# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Cookies und Website-Daten verwalten

site-data-settings-description = Die folgenden Websites speichern Cookies und Website-Daten auf dem Computer. { -brand-short-name } behält Daten von Websites mit dauerhaftem Speicher, bis Sie diese löschen, und löscht Daten von Websites mit nicht-dauerhaftem Speicher, wenn Speicherplatz benötigt wird.

site-data-search-textbox =
    .placeholder = Websites suchen
    .accesskey = s

site-data-column-host =
    .label = Website
site-data-column-cookies =
    .label = Cookies
site-data-column-storage =
    .label = Speicher
site-data-column-last-used =
    .label = Zuletzt verwendet

# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (lokale Dateien)

site-data-remove-selected =
    .label = Ausgewählte löschen
    .accesskey = g

site-data-settings-dialog =
    .buttonlabelaccept = Änderungen speichern
    .buttonaccesskeyaccept = p

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (dauerhaft)

site-data-remove-all =
    .label = Alle löschen
    .accesskey = A

site-data-remove-shown =
    .label = Alle angezeigten löschen
    .accesskey = z

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Entfernen

site-data-removing-header = Cookies und Website-Daten löschen

site-data-removing-desc = Durch das Löschen von Cookies und Website-Daten werden Sie eventuell von Websites abgemeldet. Sollen diese Änderungen wirklich vorgenommen werden?

# Variables:
#   $baseDomain (String) - The single domain for which data is being removed
site-data-removing-single-desc = Durch das Löschen von Cookies und Website-Daten werden Sie eventuell von Websites abgemeldet. Sollen wirklich alle Cookies und Website-Daten für <strong>{ $baseDomain }</strong> gelöscht werden?

site-data-removing-table = Cookies und Website-Daten der folgenden Websites werden verwendet
