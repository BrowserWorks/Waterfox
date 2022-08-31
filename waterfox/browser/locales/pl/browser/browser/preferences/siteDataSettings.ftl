# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Zachowane ciasteczka i dane witryn

site-data-settings-description = Następujące witryny przechowują ciasteczka i dane na tym komputerze. { -brand-short-name } trwale przechowuje dane do czasu ręcznego ich usunięcia i usuwa nietrwałe dane, jeśli potrzebna jest przestrzeń.

site-data-search-textbox =
    .placeholder = Szukaj witryn
    .accesskey = S

site-data-column-host =
    .label = Witryna
site-data-column-cookies =
    .label = Ciasteczka
site-data-column-storage =
    .label = Rozmiar
site-data-column-last-used =
    .label = Ostatni dostęp

# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (plik lokalny)

site-data-remove-selected =
    .label = Usuń zaznaczone
    .accesskey = U

site-data-settings-dialog =
    .buttonlabelaccept = Zapisz zmiany
    .buttonaccesskeyaccept = Z

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (trwałe)

site-data-remove-all =
    .label = Usuń wszystkie
    .accesskey = U

site-data-remove-shown =
    .label = Usuń wszystkie wyświetlane
    .accesskey = U

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Usuń

site-data-removing-header = Usuwanie ciasteczek i danych witryn

site-data-removing-desc = Usunięcie ciasteczek i danych witryn może spowodować wylogowanie z niektórych witryn. Czy wprowadzić zmiany?

# Variables:
#   $baseDomain (String) - The single domain for which data is being removed
site-data-removing-single-desc = Usunięcie ciasteczek i danych witryn może spowodować wylogowanie z niektórych witryn. Czy usunąć ciasteczka i dane witryny <strong>{ $baseDomain }</strong>?

site-data-removing-table = Ciasteczka i dane stron następujących witryn zostaną usunięte:
