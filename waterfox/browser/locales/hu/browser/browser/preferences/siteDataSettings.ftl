# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Sütik és oldaladatok kezelése

site-data-settings-description = A következő webhelyek tárolnak sütiket és oldaladatok a számítógépén. A { -brand-short-name } addig tárol adatokat a tartós tárolóban, amíg Ön törli azokat, és addig tárol adatokat a nem tartós tárolóban, amíg szükség nem lesz a helyre.

site-data-search-textbox =
    .placeholder = Weboldalak keresése
    .accesskey = S

site-data-column-host =
    .label = Oldal
site-data-column-cookies =
    .label = Sütik
site-data-column-storage =
    .label = Tárhely
site-data-column-last-used =
    .label = Utoljára használt

# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (helyi fájl)

site-data-remove-selected =
    .label = Kijelölt eltávolítása
    .accesskey = e

site-data-settings-dialog =
    .buttonlabelaccept = Változások mentése
    .buttonaccesskeyaccept = V

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (tartós)

site-data-remove-all =
    .label = Összes eltávolítása
    .accesskey = z

site-data-remove-shown =
    .label = Összes látható eltávolítása
    .accesskey = h

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Eltávolítás

site-data-removing-header = Sütik és oldaladatok eltávolítása

site-data-removing-desc = A sütik és oldaladatok eltávolítása kijelentkeztetheti a weboldalakról. Biztos akarja ezeket a változásokat?

# Variables:
#   $baseDomain (String) - The single domain for which data is being removed
site-data-removing-single-desc = A sütik és webhelyadatok eltávolítása kijelentkeztetheti a webhelyekről. Biztos, hogy eltávolítja a sütiket és webhelyadatokat ennél: <strong>{ $baseDomain }</strong>?

site-data-removing-table = A következő webhelyekhez tartozó sütik és oldaladatok eltávolításra kerülnek
