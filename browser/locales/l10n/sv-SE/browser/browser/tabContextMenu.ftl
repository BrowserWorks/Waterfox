# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Uppdatera flik
    .accesskey = U
select-all-tabs =
    .label = Välj alla flikar
    .accesskey = V
duplicate-tab =
    .label = Duplicera flik
    .accesskey = D
duplicate-tabs =
    .label = Duplicera flikar
    .accesskey = D
close-tabs-to-the-end =
    .label = Stäng flikar till höger
    .accesskey = h
close-other-tabs =
    .label = Stäng alla andra flikar
    .accesskey = ä
reload-tabs =
    .label = Uppdatera flikar
    .accesskey = U
pin-tab =
    .label = Fäst flik
    .accesskey = F
unpin-tab =
    .label = Gör om till vanlig flik
    .accesskey = G
pin-selected-tabs =
    .label = Fäst flikar
    .accesskey = f
unpin-selected-tabs =
    .label = Gör om till vanliga flikar
    .accesskey = f
bookmark-selected-tabs =
    .label = Bokmärk flikar…
    .accesskey = k
bookmark-tab =
    .label = Bokmärk flik
    .accesskey = B
reopen-in-container =
    .label = Återöppna i innehållsflik
    .accesskey = i
move-to-start =
    .label = Flytta till början
    .accesskey = b
move-to-end =
    .label = Flytta till slut
    .accesskey = s
move-to-new-window =
    .label = Flytta till nytt fönster
    .accesskey = t
tab-context-close-multiple-tabs =
    .label = Stäng flera flikar
    .accesskey = f

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Ångra Stäng flik
            [one] Ångra Stäng flik
           *[other] Ångra Stäng flikar
        }
    .accesskey = n
close-tab =
    .label = Stäng flik
    .accesskey = S
close-tabs =
    .label = Stäng flikar
    .accesskey = S
move-tabs =
    .label = Flytta flikar
    .accesskey = t
move-tab =
    .label = Flytta flik
    .accesskey = t
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Stäng flik
            [one] Stäng flik
           *[other] Stäng flikar
        }
    .accesskey = S
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Flytta flik
            [one] Flytta flik
           *[other] Flytta flikar
        }
    .accesskey = t
