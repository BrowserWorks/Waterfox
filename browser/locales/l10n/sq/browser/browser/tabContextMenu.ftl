# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Ringarkoje Skedën
    .accesskey = R
select-all-tabs =
    .label = Përzgjidhi Krejt Skedat
    .accesskey = P
duplicate-tab =
    .label = Përsëdyte Skedën
    .accesskey = P
duplicate-tabs =
    .label = Përsëdytni Skeda
    .accesskey = P
close-tabs-to-the-end =
    .label = Mbyll Skedat në të Djathtë
    .accesskey = D
close-other-tabs =
    .label = Mbylli Skedat e Tjera
    .accesskey = T
reload-tabs =
    .label = Ringarko Skedat
    .accesskey = R
pin-tab =
    .label = Fiksoje Skedën
    .accesskey = F
unpin-tab =
    .label = Shfiksoje Skedën
    .accesskey = f
pin-selected-tabs =
    .label = Fiksoji Skedat
    .accesskey = F
unpin-selected-tabs =
    .label = Shfiksoji Skedat
    .accesskey = S
bookmark-selected-tabs =
    .label = Faqeruani Skeda…
    .accesskey = q
bookmark-tab =
    .label = Faqeruaje Skedën
    .accesskey = q
reopen-in-container =
    .label = Rihape në Kontejner
    .accesskey = h
move-to-start =
    .label = Shpjere në Fillim
    .accesskey = i
move-to-end =
    .label = Shpjere në Fund
    .accesskey = u
move-to-new-window =
    .label = Kaloje në Dritare të Re
    .accesskey = D
tab-context-close-multiple-tabs =
    .label = Mbyll Skeda të Shumta
    .accesskey = u

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Zhbëje Mbylljen e Skedës
            [one] Zhbëje Mbylljen e Skedës
           *[other] Zhbëje Mbylljen e Skedave
        }
    .accesskey = Z
close-tab =
    .label = Mbylleni Skedën
    .accesskey = M
close-tabs =
    .label = Mbylli Skedat
    .accesskey = S
move-tabs =
    .label = Lëvizni Skeda
    .accesskey = v
move-tab =
    .label = Lëvizeni Skedën
    .accesskey = v
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Mbylle Skedën
            [one] Mbylle Skedën
           *[other] Mbylli Skedat
        }
    .accesskey = M
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Lëvize Skedën
            [one] Lëvize Skedën
           *[other] Lëvizni Skeda
        }
    .accesskey = L
