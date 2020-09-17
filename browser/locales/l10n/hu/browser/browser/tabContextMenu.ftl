# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Lap frissítése
    .accesskey = r
select-all-tabs =
    .label = Összes lap kiválasztása
    .accesskey = e
duplicate-tab =
    .label = Lap duplikálása
    .accesskey = d
duplicate-tabs =
    .label = Lapok duplikálása
    .accesskey = d
close-tabs-to-the-end =
    .label = Jobbra lévő lapok bezárása
    .accesskey = J
close-other-tabs =
    .label = Többi lap bezárása
    .accesskey = T
reload-tabs =
    .label = Lapok frissítése
    .accesskey = f
pin-tab =
    .label = Lap rögzítése
    .accesskey = r
unpin-tab =
    .label = Lap feloldása
    .accesskey = f
pin-selected-tabs =
    .label = Lapok rögzítése
    .accesskey = r
unpin-selected-tabs =
    .label = Lapok feloldása
    .accesskey = f
bookmark-selected-tabs =
    .label = Lapok könyvjelzőzése…
    .accesskey = k
bookmark-tab =
    .label = Lap könyvjelzőzése
    .accesskey = k
reopen-in-container =
    .label = Újranyitás konténerben
    .accesskey = j
move-to-start =
    .label = Áthelyezés az elejére
    .accesskey = e
move-to-end =
    .label = Áthelyezés a végére
    .accesskey = v
move-to-new-window =
    .label = Áthelyezés új ablakba
    .accesskey = t
tab-context-close-multiple-tabs =
    .label = Több lap bezárása
    .accesskey = T

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Lapbezárás visszavonása
            [one] Lapbezárás visszavonása
           *[other] Lapbezárások visszavonása
        }
    .accesskey = L
close-tab =
    .label = Lap bezárása
    .accesskey = b
close-tabs =
    .label = Lapok bezárása
    .accesskey = z
move-tabs =
    .label = Lapok áthelyezése
    .accesskey = h
move-tab =
    .label = Lap áthelyezése
    .accesskey = h
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Lap bezárása
            [one] Lap bezárása
           *[other] Lapok bezárása
        }
    .accesskey = C
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Lap áthelyezése
            [one] Lap áthelyezése
           *[other] Lapok áthelyezése
        }
    .accesskey = v
