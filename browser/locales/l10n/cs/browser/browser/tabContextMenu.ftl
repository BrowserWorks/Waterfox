# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tab-context-new-tab =
    .label = Nový panel
    .accesskey = o
reload-tab =
    .label = Znovu načíst panel
    .accesskey = n
select-all-tabs =
    .label = Vybrat všechny panely
    .accesskey = a
duplicate-tab =
    .label = Duplikovat panel
    .accesskey = D
duplicate-tabs =
    .label = Duplikovat panely
    .accesskey = D
# The following string is displayed on a menuitem that will close the tabs from the start of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Left" and in right-to-left languages this should use "Right".
close-tabs-to-the-start =
    .label = Zavřít panely vlevo
    .accesskey = l
# The following string is displayed on a menuitem that will close the tabs from the end of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Right" and in right-to-left languages this should use "Left".
close-tabs-to-the-end =
    .label = Zavřít panely vpravo
    .accesskey = r
close-other-tabs =
    .label = Zavřít ostatní panely
    .accesskey = o
reload-tabs =
    .label = Znovu načíst panely
    .accesskey = n
pin-tab =
    .label = Připnout panel
    .accesskey = a
unpin-tab =
    .label = Odepnout panel
    .accesskey = a
pin-selected-tabs =
    .label = Připnout panely
    .accesskey = a
unpin-selected-tabs =
    .label = Odepnout panely
    .accesskey = a
bookmark-selected-tabs =
    .label = Přidat panely do záložek…
    .accesskey = P
bookmark-tab =
    .label = Přidat panel do záložek
    .accesskey = P
reopen-in-container =
    .label = Otevřít v kontejnerovém panelu
    .accesskey = e
tab-context-open-in-new-container-tab =
    .label = Otevřít v novém kontejnerovém panelu
    .accesskey = e
move-to-start =
    .label = Přesunout na začátek
    .accesskey = z
move-to-end =
    .label = Přesunout na konec
    .accesskey = e
move-to-new-window =
    .label = Přesunout do nového okna
    .accesskey = k
tab-context-close-multiple-tabs =
    .label = Zavřít několik panelů
    .accesskey = k
tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Obnovit zavřený panel
            [one] Obnovit zavřený panel
            [few] Obnovit zavřené panely
           *[other] Obnovit zavřené panely
        }
    .accesskey = t
close-tab =
    .label = Zavřít panel
    .accesskey = Z
close-tabs =
    .label = Zavřít panely
    .accesskey = Z
move-tabs =
    .label = Přesunout panely
    .accesskey = s
move-tab =
    .label = Přesunout panel
    .accesskey = s
tab-context-share-url =
    .label = Sdílet
    .accesskey = S
tab-context-share-more =
    .label = Další…

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-reopen-closed-tabs =
    .label =
        { $tabCount ->
            [1] Obnovit zavřený panel
            [one] Obnovit zavřený panel
            [few] Obnovit zavřené panely
           *[other] Obnovit zavřené panely
        }
    .accesskey = b
tab-context-close-tabs =
    .label =
        Zavřít { $tabCount ->
            [one] panel
            [few] { $tabCount } panely
           *[other] { $tabCount } panelů
        }
    .accesskey = Z
tab-context-move-tabs =
    .label =
        Přesunout { $tabCount ->
            [one] panel
            [few] { $tabCount } panely
           *[other] { $tabCount } panelů
        }
    .accesskey = s
