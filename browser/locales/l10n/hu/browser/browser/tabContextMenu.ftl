# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tab-context-new-tab =
    .label = Új lap
    .accesskey = j
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
# The following string is displayed on a menuitem that will close the tabs from the start of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Left" and in right-to-left languages this should use "Right".
close-tabs-to-the-start =
    .label = Balra lévő lapok bezárása
    .accesskey = B
# The following string is displayed on a menuitem that will close the tabs from the end of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Right" and in right-to-left languages this should use "Left".
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
tab-context-open-in-new-container-tab =
    .label = Megnyitás új konténerlapban
    .accesskey = e
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
tab-context-share-url =
    .label = Megosztás
    .accesskey = M
tab-context-share-more =
    .label = Továbbiak…

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-reopen-closed-tabs =
    .label =
        { $tabCount ->
            [1] Bezárt lap újranyitása
            [one] Bezárt lap újranyitása
           *[other] Bezárt lapok újranyitása
        }
    .accesskey = z
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Lap bezárása
            [one] Lap bezárása
           *[other] Lapok bezárása
        }
    .accesskey = b
tab-context-close-n-tabs =
    .label =
        { $tabCount ->
            [1] Lap bezárása
            [one] Lap bezárása
           *[other] { $tabCount } lap bezárása
        }
    .accesskey = b
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Lap áthelyezése
            [one] Lap áthelyezése
           *[other] Lapok áthelyezése
        }
    .accesskey = h

tab-context-send-tabs-to-device =
    .label =
        { $tabCount ->
            [1] Lap küldése az eszközre
            [one] Lap küldése az eszközre
           *[other] { $tabCount } lap küldése az eszközre
        }
    .accesskey = k
