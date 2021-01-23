# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Oppdater fane
    .accesskey = O
select-all-tabs =
    .label = Velg alle faner
    .accesskey = f
duplicate-tab =
    .label = Dupliser fane
    .accesskey = D
duplicate-tabs =
    .label = Dupliser faner
    .accesskey = D
close-tabs-to-the-end =
    .label = Lukk faner til høyre
    .accesskey = u
close-other-tabs =
    .label = Lukk andre faner
    .accesskey = a
reload-tabs =
    .label = Oppdater faner
    .accesskey = r
pin-tab =
    .label = Fest fane
    .accesskey = L
unpin-tab =
    .label = Løs fane
    .accesskey = o
pin-selected-tabs =
    .label = Fest faner
    .accesskey = F
unpin-selected-tabs =
    .label = Løs faner
    .accesskey = e
bookmark-selected-tabs =
    .label = Bokmerk faner…
    .accesskey = k
bookmark-tab =
    .label = Bokmerk fane
    .accesskey = B
reopen-in-container =
    .label = Åpne på nytt i innholdsfane
    .accesskey = e
move-to-start =
    .label = Flytt til begynnelsen
    .accesskey = b
move-to-end =
    .label = Flytt til slutten
    .accesskey = t
move-to-new-window =
    .label = Flytt til et nytt vindu
    .accesskey = t
tab-context-close-multiple-tabs =
    .label = Lukk flere faner
    .accesskey = f

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Angre lukking av fane
           *[other] Angre lukking av faner
        }
    .accesskey = A
close-tab =
    .label = Lukk fane
    .accesskey = k
close-tabs =
    .label = Lukk faner
    .accesskey = k
move-tabs =
    .label = Flytt faner
    .accesskey = y
move-tab =
    .label = Flytt fane
    .accesskey = y
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Lukk fane
           *[other] Lukk faner
        }
    .accesskey = L
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Flytt fane
           *[other] Flytt faner
        }
    .accesskey = F
