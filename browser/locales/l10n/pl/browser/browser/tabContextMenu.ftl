# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Odśwież kartę
    .accesskey = O
select-all-tabs =
    .label = Zaznacz wszystkie karty
    .accesskey = c
duplicate-tab =
    .label = Duplikuj kartę
    .accesskey = u
duplicate-tabs =
    .label = Duplikuj karty
    .accesskey = u
close-tabs-to-the-end =
    .label = Zamknij karty po prawej stronie
    .accesskey = s
close-other-tabs =
    .label = Zamknij inne karty
    .accesskey = m
reload-tabs =
    .label = Odśwież karty
    .accesskey = O
pin-tab =
    .label = Przypnij kartę
    .accesskey = n
unpin-tab =
    .label = Odepnij kartę
    .accesskey = n
pin-selected-tabs =
    .label = Przypnij karty
    .accesskey = n
unpin-selected-tabs =
    .label = Odepnij karty
    .accesskey = n
bookmark-selected-tabs =
    .label = Dodaj zakładki do zaznaczonych kart…
    .accesskey = D
bookmark-tab =
    .label = Dodaj zakładkę do karty
    .accesskey = D
reopen-in-container =
    .label = Otwórz ponownie w karcie z kontekstem
    .accesskey = k
move-to-start =
    .label = Przenieś na początek
    .accesskey = P
move-to-end =
    .label = Przenieś na koniec
    .accesskey = k
move-to-new-window =
    .label = Przenieś do nowego okna
    .accesskey = o
tab-context-close-multiple-tabs =
    .label = Zamknij wiele kart
    .accesskey = w

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Przywróć zamkniętą kartę
            [one] Przywróć zamkniętą kartę
            [few] Przywróć zamknięte karty
           *[many] Przywróć zamknięte karty
        }
    .accesskey = a
close-tab =
    .label = Zamknij kartę
    .accesskey = Z
close-tabs =
    .label = Zamknij karty
    .accesskey = Z
move-tabs =
    .label = Przenieś karty
    .accesskey = r
move-tab =
    .label = Przenieś kartę
    .accesskey = r
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Zamknij kartę
            [one] Zamknij kartę
            [few] Zamknij karty
           *[many] Zamknij karty
        }
    .accesskey = Z
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Przenieś kartę
            [one] Przenieś kartę
            [few] Przenieś karty
           *[many] Przenieś karty
        }
    .accesskey = r
