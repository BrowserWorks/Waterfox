# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tab-context-new-tab =
    .label = Ny flik
    .accesskey = N
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
# The following string is displayed on a menuitem that will close the tabs from the start of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Left" and in right-to-left languages this should use "Right".
close-tabs-to-the-start =
    .label = Stäng flikar till vänster
    .accesskey = v
# The following string is displayed on a menuitem that will close the tabs from the end of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Right" and in right-to-left languages this should use "Left".
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
    .label = Lösgör flik
    .accesskey = L
pin-selected-tabs =
    .label = Fäst flikar
    .accesskey = f
unpin-selected-tabs =
    .label = Lösgör flikar
    .accesskey = L
bookmark-selected-tabs =
    .label = Bokmärk flikar…
    .accesskey = k
bookmark-tab =
    .label = Bokmärk flik
    .accesskey = B
tab-context-open-in-new-container-tab =
    .label = Öppna i ny innehållsflik
    .accesskey = n
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
tab-context-share-url =
    .label = Dela
    .accesskey = D
tab-context-share-more =
    .label = Mer…

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-reopen-closed-tabs =
    .label =
        { $tabCount ->
            [1] Öppna stängd flik igen
           *[other] Öppna stängda flikar igen
        }
    .accesskey = p
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Stäng flik
            [one] Stäng flik
           *[other] Stäng flikar
        }
    .accesskey = S
tab-context-close-n-tabs =
    .label =
        { $tabCount ->
            [1] Stäng flik
           *[other] Stäng { $tabCount } flikar
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

tab-context-send-tabs-to-device =
    .label =
        { $tabCount ->
            [one] Skicka flik till enhet
           *[other] Skicka { $tabCount } flikar till enhet
        }
    .accesskey = n
