# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Rejtarik znowego zacytaś
    .accesskey = R
select-all-tabs =
    .label = Wšykne rejtariki wubraś
    .accesskey = W
duplicate-tab =
    .label = Rejatark pódwójś
    .accesskey = R
duplicate-tabs =
    .label = Rejtariki pódwójś
    .accesskey = R
close-tabs-to-the-end =
    .label = Rejtariki napšawo zacyniś
    .accesskey = n
close-other-tabs =
    .label = Druge rejtariki zacyniś
    .accesskey = D
reload-tabs =
    .label = Rejtariki znowego zacytaś
    .accesskey = n
pin-tab =
    .label = Rejtarik pśipěś
    .accesskey = R
unpin-tab =
    .label = Rejtarik wótpěś
    .accesskey = w
pin-selected-tabs =
    .label = Rejtariki pśipěś
    .accesskey = R
unpin-selected-tabs =
    .label = Rejtariki wótpěś
    .accesskey = t
bookmark-selected-tabs =
    .label = Rejtariki ako cytańske znamjenja składowaś…
    .accesskey = k
bookmark-tab =
    .label = Rejtarik ako cytańske znamje składowaś
    .accesskey = t
reopen-in-container =
    .label = W kontejnerje znowego wócyniś
    .accesskey = k
move-to-start =
    .label = K zachopjeńkoju pśesunuś
    .accesskey = K
move-to-end =
    .label = Ku kóńcoju pśesunuś
    .accesskey = c
move-to-new-window =
    .label = Do nowego wokna pśesunuś
    .accesskey = n
tab-context-close-multiple-tabs =
    .label = Někotare rejtariki zacyniś
    .accesskey = N

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] { $tabCount } zacynjony rejtarik wócyniś
            [one] { $tabCount }  zacynjony rejtarik wócyniś
            [two] { $tabCount } zacynjonej rejtarika wócyniś
            [few] { $tabCount } zacynjone rejtariki wócyniś
           *[other] { $tabCount } zacynjonych rejtarikow wócyniś
        }
    .accesskey = z
close-tab =
    .label = Rejtarik zacyniś
    .accesskey = z
close-tabs =
    .label = Rejtariki zacyniś
    .accesskey = z
move-tabs =
    .label = Rejtariki pśesunuś
    .accesskey = s
move-tab =
    .label = Rejtarik pśesunuś
    .accesskey = s
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] { $tabCount } rejtarik zacyniś
            [one] { $tabCount } rejtarik zacyniś
            [two] { $tabCount } rejtarika zacyniś
            [few] { $tabCount } rejtariki zacyniś
           *[other] { $tabCount } rejtarikow zacyniś
        }
    .accesskey = r
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] { $tabCount } rejtarik pśesunuś
            [one] { $tabCount } rejtarik pśesunuś
            [two] { $tabCount } rejtarika pśesunuś
            [few] { $tabCount } rejtariki pśesunuś
           *[other] { $tabCount } rejtarikow pśesunuś
        }
    .accesskey = s
