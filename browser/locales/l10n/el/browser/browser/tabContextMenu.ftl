# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Ανανέωση καρτέλας
    .accesskey = Α
select-all-tabs =
    .label = Επιλογή όλων των καρτελών
    .accesskey = Ε
duplicate-tab =
    .label = Αντιγραφή καρτέλας
    .accesskey = Α
duplicate-tabs =
    .label = Αντιγραφή καρτελών
    .accesskey = Α
close-tabs-to-the-end =
    .label = Κλείσιμο καρτελών στα δεξιά
    .accesskey = ξ
close-other-tabs =
    .label = Κλείσιμο των άλλων καρτελών
    .accesskey = ω
reload-tabs =
    .label = Ανανέωση καρτελών
    .accesskey = Α
pin-tab =
    .label = Καρφίτσωμα καρτέλας
    .accesskey = ρ
unpin-tab =
    .label = Ξεκαρφίτσωμα καρτέλας
    .accesskey = κ
pin-selected-tabs =
    .label = Καρφίτσωμα καρτελών
    .accesskey = Κ
unpin-selected-tabs =
    .label = Ξεκαρφίτσωμα καρτελών
    .accesskey = λ
bookmark-selected-tabs =
    .label = Αποθήκευση καρτελών…
    .accesskey = Α
bookmark-tab =
    .label = Αποθήκευση καρτέλας
    .accesskey = Α
reopen-in-container =
    .label = Άνοιγμα ξανά σε θεματική καρτέλα
    .accesskey = ξ
move-to-start =
    .label = Μετακίνηση στην αρχή
    .accesskey = α
move-to-end =
    .label = Μετακίνηση στο τέλος
    .accesskey = τ
move-to-new-window =
    .label = Μετακίνηση σε νέο παράθυρο
    .accesskey = π
tab-context-close-multiple-tabs =
    .label = Κλείσιμο πολλαπλών καρτελών
    .accesskey = π

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Αναίρεση κλεισίματος καρτέλας
            [one] Αναίρεση κλεισίματος καρτέλας
           *[other] Αναίρεση κλεισίματος καρτελών
        }
    .accesskey = Α
close-tab =
    .label = Κλείσιμο καρτέλας
    .accesskey = Κ
close-tabs =
    .label = Κλείσιμο καρτελών
    .accesskey = ν
move-tabs =
    .label = Μετακίνηση καρτελών
    .accesskey = ν
move-tab =
    .label = Μετακίνηση καρτέλας
    .accesskey = ν
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Κλείσιμο καρτέλας
           *[other] Κλείσιμο καρτελών
        }
    .accesskey = Κ
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Μετακίνηση καρτέλας
           *[other] Μετακίνηση καρτελών
        }
    .accesskey = τ
