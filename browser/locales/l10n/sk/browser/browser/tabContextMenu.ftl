# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Obnoviť kartu
    .accesskey = O
select-all-tabs =
    .label = Vybrať všetky karty
    .accesskey = v
duplicate-tab =
    .label = Duplikovať kartu
    .accesskey = D
duplicate-tabs =
    .label = Duplikovať karty
    .accesskey = D
close-tabs-to-the-end =
    .label = Zavrieť karty napravo
    .accesskey = n
close-other-tabs =
    .label = Zavrieť ostatné karty
    .accesskey = e
reload-tabs =
    .label = Obnoviť karty
    .accesskey = r
pin-tab =
    .label = Pripnúť kartu
    .accesskey = r
unpin-tab =
    .label = Zrušiť pripnutie karty
    .accesskey = r
pin-selected-tabs =
    .label = Pripnúť karty
    .accesskey = P
unpin-selected-tabs =
    .label = Zrušiť pripnutie kariet
    .accesskey = r
bookmark-selected-tabs =
    .label = Pridať karty medzi záložky…
    .accesskey = k
bookmark-tab =
    .label = Pridať kartu medzi záložky
    .accesskey = z
reopen-in-container =
    .label = Otvoriť v kontajneri
    .accesskey = e
move-to-start =
    .label = Presunúť na začiatok
    .accesskey = z
move-to-end =
    .label = Presunúť na koniec
    .accesskey = k
move-to-new-window =
    .label = Presunúť do nového okna
    .accesskey = d
tab-context-close-multiple-tabs =
    .label = Zavrieť viaceré karty
    .accesskey = c

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Obnoviť zatvorenú kartu
            [one] Obnoviť zatvorenú kartu
            [few] Obnoviť zatvorené karty
           *[other] Obnoviť zatvorené karty
        }
    .accesskey = O
close-tab =
    .label = Zavrieť kartu
    .accesskey = Z
close-tabs =
    .label = Zavrieť karty
    .accesskey = Z
move-tabs =
    .label = Presunúť karty
    .accesskey = s
move-tab =
    .label = Presunúť kartu
    .accesskey = u
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Zavrieť kartu
           *[other] Zavrieť karty
        }
    .accesskey = Z
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Presunúť kartu
           *[other] Presunúť karty
        }
    .accesskey = u
