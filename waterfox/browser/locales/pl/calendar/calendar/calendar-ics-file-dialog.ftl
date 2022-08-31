# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

calendar-ics-file-window-2 =
    .title = Importuj wydarzenia kalendarza i zadania
calendar-ics-file-dialog-import-event-button-label = Importuj wydarzenie
calendar-ics-file-dialog-import-task-button-label = Importuj zadanie
calendar-ics-file-dialog-2 =
    .buttonlabelaccept = Importuj wszystko
calendar-ics-file-accept-button-ok-label = OK
calendar-ics-file-cancel-button-close-label = Zamknij
calendar-ics-file-dialog-message-2 = Importuj z pliku:
calendar-ics-file-dialog-calendar-menu-label = Importuj do kalendarza:
calendar-ics-file-dialog-items-loading-message =
    .value = Wczytywanie elementów…
calendar-ics-file-dialog-search-input =
    .placeholder = Filtruj elementy…
calendar-ics-file-dialog-sort-start-ascending =
    .label = Sortuj według daty rozpoczęcia (od najstarszej do najnowszej)
calendar-ics-file-dialog-sort-start-descending =
    .label = Sortuj według daty rozpoczęcia (od najnowszej do najstarszej)
# "A > Z" is used as a concise way to say "alphabetical order".
# You may replace it with something appropriate to your language.
calendar-ics-file-dialog-sort-title-ascending =
    .label = Sortuj według nazwy (A→Z)
# "Z > A" is used as a concise way to say "reverse alphabetical order".
# You may replace it with something appropriate to your language.
calendar-ics-file-dialog-sort-title-descending =
    .label = Sortuj według nazwy (Z→A)
calendar-ics-file-dialog-progress-message = Importowanie…
calendar-ics-file-import-success = Pomyślnie zaimportowano.
calendar-ics-file-import-error = Wystąpił błąd i import się nie powiódł.
calendar-ics-file-import-complete = Ukończono importowanie.
calendar-ics-file-import-duplicates =
    { $duplicatesCount ->
        [one] Jeden element został zignorowany, ponieważ już istnieje w kalendarzu docelowym.
        [few] { $duplicatesCount } elementy zostały zignorowane, ponieważ już istnieją w kalendarzu docelowym.
       *[many] { $duplicatesCount } elementów zostało zignorowanych, ponieważ już istnieją w kalendarzu docelowym.
    }
calendar-ics-file-import-errors =
    { $errorsCount ->
        [one] Zaimportowanie jednego elementu się nie powiodło. Konsola błędów zawiera więcej informacji.
        [few] Zaimportowanie { $errorsCount } elementów się nie powiodło. Konsola błędów zawiera więcej informacji.
       *[many] Zaimportowanie { $errorsCount } elementów się nie powiodło. Konsola błędów zawiera więcej informacji.
    }
calendar-ics-file-dialog-no-calendars = Nie ma żadnych kalendarzy, które mogą importować wydarzenia lub zadania.
