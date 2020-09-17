# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Ail lwytho Tab
    .accesskey = A
select-all-tabs =
    .label = Dewis Pob Tab
    .accesskey = D
duplicate-tab =
    .label = Dyblygu Tab
    .accesskey = D
duplicate-tabs =
    .label = Tabiau Dyblyg
    .accesskey = D
close-tabs-to-the-end =
    .label = Cau Tabiau i'r Dde
    .accesskey = D
close-other-tabs =
    .label = Cau Tabiau Eraill
    .accesskey = C
reload-tabs =
    .label = Ail-lwytho Tabiau
    .accesskey = A
pin-tab =
    .label = Pinio Tab
    .accesskey = P
unpin-tab =
    .label = Dadbinio Tab
    .accesskey = D
pin-selected-tabs =
    .label = Pinio Tabiau
    .accesskey = P
unpin-selected-tabs =
    .label = Dadbinio Tabiau
    .accesskey = b
bookmark-selected-tabs =
    .label = Gosod Nod Tudalen i'r Tabiau…
    .accesskey = T
bookmark-tab =
    .label = Gosod Nod Tudalen i'r Tab
    .accesskey = N
reopen-in-container =
    .label = Ail agor mewn Cynhwysydd
    .accesskey = A
move-to-start =
    .label = Symud i'r Cychwyn
    .accesskey = C
move-to-end =
    .label = Symud i'r Diwedd
    .accesskey = D
move-to-new-window =
    .label = Symud i Ffenestr Newydd
    .accesskey = N
tab-context-close-multiple-tabs =
    .label = Cau Tabiau Lluosog
    .accesskey = L

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Dadwneud Cau Tabiau
            [zero] Dadwneud Cau Tabiau
            [one] Dadwneud Cau Tab
            [two] Dadwneud Cau Tabiau
            [few] Dadwneud Cau Tabiau
            [many] Dadwneud Cau Tabiau
           *[other] Dadwneud Cau Tabiau
        }
    .accesskey = D
close-tab =
    .label = Cau Tab
    .accesskey = C
close-tabs =
    .label = Cau Tabiau
    .accesskey = T
move-tabs =
    .label = Symud Tabiau
    .accesskey = y
move-tab =
    .label = Symud Tab
    .accesskey = y
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Cau Tab
            [zero] Cau Tab
            [one] Cau Tab
            [two] Cau Tab
            [few] Cau Tab
            [many] Cau Tab
           *[other] Cau Tab
        }
    .accesskey = C
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Symud Tab
            [zero] Symud Tab
            [one] Symud Tab
            [two] Symud Tab
            [few] Symud Tab
            [many] Symud Tab
           *[other] Symud Tab
        }
    .accesskey = S
