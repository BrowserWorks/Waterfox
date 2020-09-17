# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Atsiųsti kortelės tinklalapį iš naujo
    .accesskey = n
select-all-tabs =
    .label = Pasirinkti visas korteles
    .accesskey = P
duplicate-tab =
    .label = Dubliuoti kortelę
    .accesskey = D
duplicate-tabs =
    .label = Dubliuoti korteles
    .accesskey = D
close-tabs-to-the-end =
    .label = Užverti korteles dešinėje
    .accesskey = d
close-other-tabs =
    .label = Užverti kitas korteles
    .accesskey = k
reload-tabs =
    .label = Įkelti korteles iš naujo
    .accesskey = k
pin-tab =
    .label = Įsegti kortelę
    .accesskey = s
unpin-tab =
    .label = Išsegti kortelę
    .accesskey = s
pin-selected-tabs =
    .label = Įsegti korteles
    .accesskey = s
unpin-selected-tabs =
    .label = Išsegti korteles
    .accesskey = g
bookmark-selected-tabs =
    .label = Korteles įtraukti į adresyną…
    .accesskey = t
bookmark-tab =
    .label = Įrašyti kortelę į adresyną
    .accesskey = r
reopen-in-container =
    .label = Atverti iš naujo sudėtiniame rodinyje
    .accesskey = e
move-to-start =
    .label = Perkelti į pradžią
    .accesskey = p
move-to-end =
    .label = Perkelti į pabaigą
    .accesskey = b
move-to-new-window =
    .label = Perkelti į naują langą
    .accesskey = l
tab-context-close-multiple-tabs =
    .label = Užverti keletą kortelių
    .accesskey = k

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Atšaukti kortelės užvėrimą
            [one] Atšaukti kortelės užvėrimą
            [few] Atšaukti kortelių užvėrimus
           *[other] Atšaukti kortelių užvėrimus
        }
    .accesskey = t
close-tab =
    .label = Užverti kortelę
    .accesskey = U
close-tabs =
    .label = Užverti korteles
    .accesskey = e
move-tabs =
    .label = Perkelti korteles
    .accesskey = t
move-tab =
    .label = Perkelti kortelę
    .accesskey = t
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Užverti kortelę
            [one] Užverti kortelę
            [few] Užverti korteles
           *[other] Užverti kortelių
        }
    .accesskey = U
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Perkelti kortelę
            [one] Perkelti kortelę
            [few] Perkelti korteles
           *[other] Perkelti kortelių
        }
    .accesskey = k
