# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Ponovno naloži zavihek
    .accesskey = n
select-all-tabs =
    .label = Izberi vse zavihke
    .accesskey = b
duplicate-tab =
    .label = Podvoji zavihek
    .accesskey = o
duplicate-tabs =
    .label = Podvoji zavihke
    .accesskey = o
close-tabs-to-the-end =
    .label = Zapri zavihke na desni
    .accesskey = i
close-other-tabs =
    .label = Zapri ostale zavihke
    .accesskey = t
reload-tabs =
    .label = Ponovno naloži zavihke
    .accesskey = n
pin-tab =
    .label = Pripni zavihek
    .accesskey = P
unpin-tab =
    .label = Odpni zavihek
    .accesskey = O
pin-selected-tabs =
    .label = Pripni zavihke
    .accesskey = P
unpin-selected-tabs =
    .label = Odpni zavihke
    .accesskey = O
bookmark-selected-tabs =
    .label = Dodaj zavihke med zaznamke …
    .accesskey = m
bookmark-tab =
    .label = Dodaj zavihek med zaznamke
    .accesskey = D
reopen-in-container =
    .label = Ponovno odpri v vsebniku
    .accesskey = v
move-to-start =
    .label = Premakni na začetek
    .accesskey = č
move-to-end =
    .label = Premakni na konec
    .accesskey = k
move-to-new-window =
    .label = Premakni v novo okno
    .accesskey = o
tab-context-close-multiple-tabs =
    .label = Zapri več zavihkov
    .accesskey = č

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Ponovno odpri zavihek
            [one] Ponovno odpri zavihek
            [two] Ponovno odpri zavihka
            [few] Ponovno odpri zavihke
           *[other] Ponovno odpri zavihke
        }
    .accesskey = h
close-tab =
    .label = Zapri zavihek
    .accesskey = Z
close-tabs =
    .label = Zapri zavihke
    .accesskey = Z
move-tabs =
    .label = Premakni zavihke
    .accesskey = k
move-tab =
    .label = Premakni zavihek
    .accesskey = k
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Zapri zavihek
            [one] Zapri zavihek
            [two] Zapri zavihka
            [few] Zapri zavihke
           *[other] Zapri zavihke
        }
    .accesskey = Z
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Premakni zavihek
            [one] Premakni zavihek
            [two] Premakni zavihka
            [few] Premakni zavihke
           *[other] Premakni zavihke
        }
    .accesskey = m
