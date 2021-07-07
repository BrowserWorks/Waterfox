# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Správa cookies a dat stránek
site-data-settings-description = Následující servery mají ve vašem počítači uloženy cookies a data stránek. Trvale uložená data stránek { -brand-short-name } uchovává, dokud je nesmažete. Dočasně uložená data jsou smazána, když je potřeba uvolnit místo.
site-data-search-textbox =
    .placeholder = Hledat
    .accesskey = H
site-data-column-host =
    .label = Server
site-data-column-cookies =
    .label = Cookies
site-data-column-storage =
    .label = Úložiště
site-data-column-last-used =
    .label = Poslední použití
# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (místní soubor)
site-data-remove-selected =
    .label = Odstranit vybrané
    .accesskey = r
site-data-button-cancel =
    .label = Zrušit
    .accesskey = Z
site-data-button-save =
    .label = Uložit změny
    .accesskey = l
site-data-settings-dialog =
    .buttonlabelaccept = Uložit změny
    .buttonaccesskeyaccept = l
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (trvale)
site-data-remove-all =
    .label = Odstranit vše
    .accesskey = e
site-data-remove-shown =
    .label = Odstranit vše zobrazené
    .accesskey = e

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Odstranit
site-data-removing-header = Mazání cookies a dat stránek
site-data-removing-desc = Smazání cookies a dat stránek může způsobit vaše odhlášení z některých webových stránek. Opravdu chcete změny provést?
site-data-removing-table = Cookies a data stránek budou smazány pro následující servery
