# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Reîncarcă fila
    .accesskey = R
select-all-tabs =
    .label = Selectează toate filele
    .accesskey = S
duplicate-tab =
    .label = Duplică fila
    .accesskey = D
duplicate-tabs =
    .label = Duplică filele
    .accesskey = D
close-tabs-to-the-end =
    .label = Închide filele de la dreapta
    .accesskey = i
close-other-tabs =
    .label = Închide celelalte file
    .accesskey = o
reload-tabs =
    .label = Reîncarcă filele
    .accesskey = R
pin-tab =
    .label = Fixează fila
    .accesskey = P
unpin-tab =
    .label = Anulează fixarea filei
    .accesskey = b
pin-selected-tabs =
    .label = Fixează filele
    .accesskey = P
unpin-selected-tabs =
    .label = Anulează fixarea filelor
    .accesskey = b
bookmark-selected-tabs =
    .label = Marchează filele…
    .accesskey = k
bookmark-tab =
    .label = Marchează fila
    .accesskey = B
reopen-in-container =
    .label = Redeschide într-un container
    .accesskey = e
move-to-start =
    .label = Mută la început
    .accesskey = S
move-to-end =
    .label = Mută la sfârșit
    .accesskey = E
move-to-new-window =
    .label = Mută într-o fereastră nouă
    .accesskey = W
tab-context-close-multiple-tabs =
    .label = Închide mai multe file
    .accesskey = M

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Anulează închiderea filelor
            [one] Anulează închiderea filei
            [few] Anulează închiderea filelor
           *[other] Anulează închiderea filelor
        }
    .accesskey = U
close-tab =
    .label = Închide fila
    .accesskey = c
close-tabs =
    .label = Închide filele
    .accesskey = S
move-tabs =
    .label = Mută filele
    .accesskey = v
move-tab =
    .label = Mută fila
    .accesskey = v
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Închide filele
            [one] Închide fila
            [few] Închide filele
           *[other] Închide filele
        }
    .accesskey = C
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Mută filele
            [one] Mută fila
            [few] Mută filele
           *[other] Mută filele
        }
    .accesskey = v
