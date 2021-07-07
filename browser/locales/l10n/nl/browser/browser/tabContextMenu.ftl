# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tab-context-new-tab =
    .label = Nieuw tabblad
    .accesskey = i
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
# The following string is displayed on a menuitem that will close the tabs from the start of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Left" and in right-to-left languages this should use "Right".
close-tabs-to-the-start =
    .label = Tabbladen aan de linkerkant sluiten
    .accesskey = i
# The following string is displayed on a menuitem that will close the tabs from the end of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Right" and in right-to-left languages this should use "Left".
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
tab-context-open-in-new-container-tab =
    .label = Openen in nieuw containertabblad
    .accesskey = e
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
tab-context-share-url =
    .label = Delen
    .accesskey = e
tab-context-share-more =
    .label = Meer…

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-reopen-closed-tabs =
    .label =
        { $tabCount ->
            [1] Gesloten tabblad opnieuw openen
            [one] Gesloten tabblad opnieuw openen
           *[other] Gesloten tabbladen opnieuw openen
        }
    .accesskey = o
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Tabblad sluiten
            [one] Tabblad sluiten
           *[other] Tabbladen sluiten
        }
    .accesskey = T
tab-context-close-n-tabs =
    .label =
        { $tabCount ->
            [1] Tabblad sluiten
            [one] { $tabCount } tabblad sluiten
           *[other] { $tabCount } tabbladen sluiten
        }
    .accesskey = s
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Tabblad verplaatsen
            [one] Tabblad verplaatsen
           *[other] Tabbladen verplaatsen
        }
    .accesskey = v

tab-context-send-tabs-to-device =
    .label =
        { $tabCount ->
            [one] Tabblad naar apparaat verzenden
           *[other] { $tabCount } tabbladen naar apparaat verzenden
        }
    .accesskey = z
