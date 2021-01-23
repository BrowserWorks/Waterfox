# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Rajtark znowa začitać
    .accesskey = R
select-all-tabs =
    .label = Wšě rajtarki wubrać
    .accesskey = r
duplicate-tab =
    .label = Rajtark podwojić
    .accesskey = T
duplicate-tabs =
    .label = Rajtarki podwojić
    .accesskey = R
close-tabs-to-the-end =
    .label = Rajtarki naprawo začinić
    .accesskey = n
close-other-tabs =
    .label = Druhe rajtarki začinić
    .accesskey = D
reload-tabs =
    .label = Rajtarki znowa začitać
    .accesskey = R
pin-tab =
    .label = Rajtark připinyć
    .accesskey = R
unpin-tab =
    .label = Rajtark wotpinyć
    .accesskey = w
pin-selected-tabs =
    .label = Rajtarki připinyć
    .accesskey = R
unpin-selected-tabs =
    .label = Rajtarki wotpinyć
    .accesskey = t
bookmark-selected-tabs =
    .label = Rajtarki jako zapołožki składować…
    .accesskey = k
bookmark-tab =
    .label = Rajtark jako zapołožku składować
    .accesskey = z
reopen-in-container =
    .label = W kontejnerje znowa wočinić
    .accesskey = k
move-to-start =
    .label = K spočatkej přesunyć
    .accesskey = K
move-to-end =
    .label = Ke kóncej přesunyć
    .accesskey = c
move-to-new-window =
    .label = Do noweho wokna přesunyć
    .accesskey = n
tab-context-close-multiple-tabs =
    .label = Wjacore rajtarki začinić
    .accesskey = W

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] { $tabCount } začinjeny rajtark wočinić
            [one] { $tabCount } začinjeny rajtark wočinić
            [two] { $tabCount } začinjenej rajtarkaj wočinić
            [few] { $tabCount } začinjene rajtarki wočinić
           *[other] { $tabCount } začinjene rajtarki wočinić
        }
    .accesskey = z
close-tab =
    .label = Rajtark začinić
    .accesskey = z
close-tabs =
    .label = Rajtarki začinić
    .accesskey = z
move-tabs =
    .label = Rajtarki přesunyć
    .accesskey = s
move-tab =
    .label = Rajtark přesunyć
    .accesskey = s
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] { $tabCount } rajtark začinić
            [one] { $tabCount } rajtark začinić
            [two] { $tabCount } rajtarkaj začinić
            [few] { $tabCount } rajtarki začinić
           *[other] { $tabCount } rajtarkow začinić
        }
    .accesskey = r
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] { $tabCount } rajtark přesunyć
            [one] { $tabCount } rajtark přesunyć
            [two] { $tabCount } rajtarkaj přesunyć
            [few] { $tabCount } rajtarki přesunyć
           *[other] { $tabCount } rajtarkow přesunyć
        }
    .accesskey = s
