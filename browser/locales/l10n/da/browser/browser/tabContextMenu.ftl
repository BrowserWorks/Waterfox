# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Genindlæs faneblad
    .accesskey = e
select-all-tabs =
    .label = Vælg alle faneblade
    .accesskey = V
duplicate-tab =
    .label = Kopier faneblad
    .accesskey = K
duplicate-tabs =
    .label = Kopier faneblade
    .accesskey = K
close-tabs-to-the-end =
    .label = Luk faneblade til højre
    .accesskey = h
close-other-tabs =
    .label = Luk øvrige faneblade
    .accesskey = ø
reload-tabs =
    .label = Genindlæs faneblade
    .accesskey = e
pin-tab =
    .label = Fastgør faneblad
    .accesskey = F
unpin-tab =
    .label = Frigør faneblad
    .accesskey = F
pin-selected-tabs =
    .label = Fastgør faneblade
    .accesskey = F
unpin-selected-tabs =
    .label = Frigør faneblade
    .accesskey = F
bookmark-selected-tabs =
    .label = Bogmærk faneblade…
    .accesskey = B
bookmark-tab =
    .label = Bogmærk faneblad
    .accesskey = B
reopen-in-container =
    .label = Åbn igen i Kontekst
    .accesskey = o
move-to-start =
    .label = Flyt længst til venstre
    .accesskey = e
move-to-end =
    .label = Flyt længst til højre
    .accesskey = h
move-to-new-window =
    .label = Flyt til nyt vindue
    .accesskey = v
tab-context-close-multiple-tabs =
    .label = Luk flere faneblade
    .accesskey = a

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Fortryk lukning af faneblad
           *[other] Fortryd lukning af faneblade
        }
    .accesskey = r
close-tab =
    .label = Luk faneblad
    .accesskey = u
close-tabs =
    .label = Luk faneblade
    .accesskey = u
move-tabs =
    .label = Flyt faneblade
    .accesskey = y
move-tab =
    .label = Flyt faneblad
    .accesskey = y
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Luk faneblad
            [one] Luk et faneblad
           *[other] Luk faneblade
        }
    .accesskey = u
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Flyt faneblad
            [one] Flyt et faneblad
           *[other] Flyt faneblade
        }
    .accesskey = y
