# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Tab neu laden
    .accesskey = d
select-all-tabs =
    .label = Alle Tabs auswählen
    .accesskey = u
duplicate-tab =
    .label = Tab klonen
    .accesskey = k
duplicate-tabs =
    .label = Tabs klonen
    .accesskey = k
close-tabs-to-the-end =
    .label = Rechte Tabs schließen
    .accesskey = R
close-other-tabs =
    .label = Andere Tabs schließen
    .accesskey = A
reload-tabs =
    .label = Tabs neu laden
    .accesskey = d
pin-tab =
    .label = Tab anheften
    .accesskey = h
unpin-tab =
    .label = Tab ablösen
    .accesskey = b
pin-selected-tabs =
    .label = Tabs anheften
    .accesskey = h
unpin-selected-tabs =
    .label = Tabs ablösen
    .accesskey = b
bookmark-selected-tabs =
    .label = Tabs als Lesezeichen hinzufügen…
    .accesskey = L
bookmark-tab =
    .label = Tab als Lesezeichen hinzufügen
    .accesskey = L
reopen-in-container =
    .label = In Tab-Umgebung öffnen
    .accesskey = U
move-to-start =
    .label = An Anfang verschieben
    .accesskey = A
move-to-end =
    .label = An Ende verschieben
    .accesskey = E
move-to-new-window =
    .label = In neues Fenster verschieben
    .accesskey = n
tab-context-close-multiple-tabs =
    .label = Mehrere Tabs schließen
    .accesskey = M

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Geschlossenen Tab wiederherstellen
           *[other] Geschlossene Tabs wiederherstellen
        }
    .accesskey = G
close-tab =
    .label = Tab schließen
    .accesskey = c
close-tabs =
    .label = Tabs schließen
    .accesskey = c
move-tabs =
    .label = Tabs verschieben
    .accesskey = v
move-tab =
    .label = Tab verschieben
    .accesskey = v
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Tab schließen
            [one] Tab schließen
           *[other] Tabs schließen
        }
    .accesskey = c
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Tab verschieben
            [one] Tab verschieben
           *[other] Tabs verschieben
        }
    .accesskey = v
