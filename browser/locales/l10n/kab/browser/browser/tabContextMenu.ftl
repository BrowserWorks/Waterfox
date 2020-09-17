# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Smiren iccer
    .accesskey = M
select-all-tabs =
    .label = Fren akk accaren
    .accesskey = M
duplicate-tab =
    .label = Sleg iccer
    .accesskey = N
duplicate-tabs =
    .label = Sleg iccaren
    .accesskey = S
close-tabs-to-the-end =
    .label = Mdel accaren n uyeffus
    .accesskey = M
close-other-tabs =
    .label = Mdel accaren-nniḍen
    .accesskey = M
reload-tabs =
    .label = Smiren iccaren
    .accesskey = S
pin-tab =
    .label = Rzi iccer-a
    .accesskey = Q
unpin-tab =
    .label = Serreḥ i yiccer-a
    .accesskey = S
pin-selected-tabs =
    .label = Siggez icarren
    .accesskey = g
unpin-selected-tabs =
    .label = Serreḥ i yiccaren
    .accesskey = r
bookmark-selected-tabs =
    .label = Creḍ akk accaren…
    .accesskey = k
bookmark-tab =
    .label = Iccer n tecraḍ n yisebtar
    .accesskey = C
reopen-in-container =
    .label = Ldi-d tikelt-nneḍen amagbar
    .accesskey = d
move-to-start =
    .label = Senkez akken ad tebḍuḍ
    .accesskey = B
move-to-end =
    .label = Senkez akken ad tfakeḍ
    .accesskey = F
move-to-new-window =
    .label = Senkez ɣer usfaylu amaynut
    .accesskey = m
tab-context-close-multiple-tabs =
    .label = Mdel aṭas n waccaren
    .accesskey = M

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Sefsex amdal n yiccer
            [one] Sefsex amdal n yiccer
           *[other] Sefsex amdal n waccaren
        }
    .accesskey = U
close-tab =
    .label = Mdel iccer
    .accesskey = M
close-tabs =
    .label = Mdel Iccaren
    .accesskey = M
move-tabs =
    .label = Senkez iccaren
    .accesskey = n
move-tab =
    .label = Senkez iccer
    .accesskey = n
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Mdel iccer
            [one] Mdel Iccer
           *[other] Mdel Iccaren
        }
    .accesskey = M
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Senkez iccer
            [one] Senkez iccer
           *[other] Senkez iccaren
        }
    .accesskey = S
