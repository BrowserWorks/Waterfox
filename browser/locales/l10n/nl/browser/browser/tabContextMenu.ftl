# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Tabblad vernieuwen
    .accesskey = n
select-all-tabs =
    .label = Alle tabbladen selecteren
    .accesskey = b
duplicate-tab =
    .label = Tabblad dupliceren
    .accesskey = u
duplicate-tabs =
    .label = Tabbladen dupliceren
    .accesskey = u
close-tabs-to-the-end =
    .label = Tabbladen aan de rechterkant sluiten
    .accesskey = r
close-other-tabs =
    .label = Overige tabbladen sluiten
    .accesskey = e
reload-tabs =
    .label = Tabbladen vernieuwen
    .accesskey = n
pin-tab =
    .label = Tabblad vastmaken
    .accesskey = v
unpin-tab =
    .label = Tabblad losmaken
    .accesskey = l
pin-selected-tabs =
    .label = Tabbladen vastmaken
    .accesskey = v
unpin-selected-tabs =
    .label = Tabbladen losmaken
    .accesskey = l
bookmark-selected-tabs =
    .label = Bladwijzer voor tabbladen maken…
    .accesskey = t
bookmark-tab =
    .label = Bladwijzer voor tabblad maken
    .accesskey = t
reopen-in-container =
    .label = Opnieuw openen in Container
    .accesskey = C
move-to-start =
    .label = Verplaatsen naar begin
    .accesskey = b
move-to-end =
    .label = Verplaatsen naar einde
    .accesskey = d
move-to-new-window =
    .label = Verplaatsen naar nieuw venster
    .accesskey = w
tab-context-close-multiple-tabs =
    .label = Meerdere tabbladen sluiten
    .accesskey = M

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Tabblad sluiten ongedaan maken
            [one] Tabblad sluiten ongedaan maken
           *[other] Tabbladen sluiten ongedaan maken
        }
    .accesskey = o
close-tab =
    .label = Tabblad sluiten
    .accesskey = s
close-tabs =
    .label = Tabbladen sluiten
    .accesskey = s
move-tabs =
    .label = Tabbladen verplaatsen
    .accesskey = l
move-tab =
    .label = Tabblad verplaatsen
    .accesskey = l
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Tabblad sluiten
            [one] Tabblad sluiten
           *[other] Tabbladen sluiten
        }
    .accesskey = T
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Tabblad verplaatsen
            [one] Tabblad verplaatsen
           *[other] Tabbladen verplaatsen
        }
    .accesskey = v
