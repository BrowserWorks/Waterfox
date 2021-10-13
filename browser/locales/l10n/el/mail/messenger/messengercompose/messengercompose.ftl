# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-button =
    .title = Αφαίρεση πεδίου «{ $type }»
#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } με μια διεύθυνση, κάντε εστίαση με το πλήκτρο αριστερού βέλους.
       *[other] { $type } με { $count } διευθύνσεις, κάντε εστίαση με το πλήκτρο αριστερού βέλους.
    }
#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: πατήστε Enter για επεξεργασία, Delete για αφαίρεση.
       *[other] { $email }, 1 από { $count }: πατήστε Enter για επεξεργασία, Delete για αφαίρεση.
    }
#   $email (String) - the email address
pill-tooltip-invalid-address = Το { $email } δεν είναι έγκυρη διεύθυνση email
#   $email (String) - the email address
pill-tooltip-not-in-address-book = Το { $email } δεν βρίσκεται στο ευρετήριό σας
pill-action-edit =
    .label = Επεξεργασία διεύθυνσης
    .accesskey = ε
pill-action-move-to =
    .label = Μετακίνηση σε «Προς»
    .accesskey = τ
pill-action-move-cc =
    .label = Μετακίνηση σε «Κοιν.»
    .accesskey = κ
pill-action-move-bcc =
    .label = Μετακίνηση σε «Κρυφή κοιν.»
    .accesskey = ν
pill-action-expand-list =
    .label = Ανάπτυξη λίστας
    .accesskey = ν

# Attachment widget

ctrl-cmd-shift-pretty-prefix =
    { PLATFORM() ->
        [macos] ⇧ ⌘{ " " }
       *[other] Ctrl+Shift+
    }
trigger-attachment-picker-key = A
toggle-attachment-pane-key = M
menuitem-toggle-attachment-pane =
    .label = Πίνακας συνημμένων
    .accesskey = μ
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }
toolbar-button-add-attachment =
    .label = Επισύναψη
    .tooltiptext = Προσθήκη συνημμένου ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })
add-attachment-notification-reminder =
    .label = Προσθήκη συνημμένου…
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
add-attachment-notification-reminder2 =
    .label = Προσθήκη συνημμένου…
    .accesskey = Π
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
menuitem-attach-files =
    .label = Αρχεία…
    .accesskey = Α
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
context-menuitem-attach-files =
    .label = Επισύναψη αρχείων…
    .accesskey = ψ
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    { $count ->
        [1] { $count } συνημμένο
       *[other] { $count } συνημμένα
    }
expand-attachment-pane-tooltip =
    .tooltiptext = Εμφάνιση του πίνακα συνημμένων ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
collapse-attachment-pane-tooltip =
    .tooltiptext = Απόκρυψη του πίνακα συνημμένων ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
attachment-area-show =
    .title = Εμφάνιση πίνακα συνημμένων ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
attachment-area-hide =
    .title = Απόκρυψη πίνακα συνημμένων ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
drop-file-label-attachment =
    { $count ->
        [one] Προσθήκη ως συνημμένο
       *[other] Προσθήκη ως συνημμένα
    }
drop-file-label-inline =
    { $count ->
        [one] Εισαγωγή εντός μηνύματος
       *[other] Εισαγωγή εντός μηνύματος
    }

# Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = Μετακίνηση στην αρχή
move-attachment-left-panel-button =
    .label = Μετακίνηση αριστερά
move-attachment-right-panel-button =
    .label = Μετακίνηση δεξιά
move-attachment-last-panel-button =
    .label = Μετακίνηση στο τέλος
button-return-receipt =
    .label = Αποδεικτικό
    .tooltiptext = Απαίτηση αποδεικτικού προβολής για αυτό το μήνυμα

# Encryption

message-to-be-signed-icon =
    .alt = Υπογραφή μηνύματος
message-to-be-encrypted-icon =
    .alt = Κρυπτογράφηση μηνύματος

# Addressing Area

to-compose-address-row-label =
    .value = Προς
#   $key (String) - the shortcut key for this field
to-compose-show-address-row-menuitem =
    .label = Πεδίο «{ to-compose-address-row-label.value }»
    .accesskey = Π
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
to-compose-show-address-row-label =
    .value = { to-compose-address-row-label.value }
    .tooltiptext = Εμφάνιση πεδίου «{ to-compose-address-row-label.value }» ({ to-compose-show-address-row-menuitem.acceltext })
cc-compose-address-row-label =
    .value = Κοιν.
#   $key (String) - the shortcut key for this field
cc-compose-show-address-row-menuitem =
    .label = Πεδίο «{ cc-compose-address-row-label.value }»
    .accesskey = δ
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
cc-compose-show-address-row-label =
    .value = { cc-compose-address-row-label.value }
    .tooltiptext = Εμφάνιση πεδίου «{ cc-compose-address-row-label.value }» ({ cc-compose-show-address-row-menuitem.acceltext })
bcc-compose-address-row-label =
    .value = Κρυφή κοιν.
#   $key (String) - the shortcut key for this field
bcc-compose-show-address-row-menuitem =
    .label = Πεδίο «{ bcc-compose-address-row-label.value }»
    .accesskey = ο
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
bcc-compose-show-address-row-label =
    .value = { bcc-compose-address-row-label.value }
    .tooltiptext = Εμφάνιση πεδίου «{ bcc-compose-address-row-label.value }» ({ bcc-compose-show-address-row-menuitem.acceltext })
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-info = Οι { $count } παραλήπτες στα πεδία «Προς» και «Κοιν.» θα βλέπουν τις διευθύνσεις των υπολοίπων. Μπορείτε να αποφύγετε την αποκάλυψη των παραληπτών με το πεδίο «Κρυφή κοιν.».
to-address-row-label =
    .value = Προς
#   $key (String) - the shortcut key for this field
show-to-row-main-menuitem =
    .label = Πεδίο «Προς»
    .accesskey = Π
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-to-row-button text.
show-to-row-extra-menuitem =
    .label = Προς
    .accesskey = Π
#   $key (String) - the shortcut key for this field
show-to-row-button = Προς
    .title = Εμφάνιση πεδίου «Προς» ({ ctrl-cmd-shift-pretty-prefix }{ $key })
cc-address-row-label =
    .value = Κοιν.
#   $key (String) - the shortcut key for this field
show-cc-row-main-menuitem =
    .label = Πεδίο «Κοιν.»
    .accesskey = Κ
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-cc-row-button text.
show-cc-row-extra-menuitem =
    .label = Κοιν.
    .accesskey = Κ
#   $key (String) - the shortcut key for this field
show-cc-row-button = Κοιν.
    .title = Εμφάνιση πεδίου «Κοιν.» ({ ctrl-cmd-shift-pretty-prefix }{ $key })
bcc-address-row-label =
    .value = Κρυφή κοιν.
#   $key (String) - the shortcut key for this field
show-bcc-row-main-menuitem =
    .label = Πεδίο «Κρυφή κοιν.»
    .accesskey = ρ
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-bcc-row-button text.
show-bcc-row-extra-menuitem =
    .label = Κρυφή κοιν.
    .accesskey = ρ
#   $key (String) - the shortcut key for this field
show-bcc-row-button = Κρυφή κοιν.
    .title = Εμφάνιση πεδίου «Κρυφή κοιν.» ({ ctrl-cmd-shift-pretty-prefix }{ $key })
extra-address-rows-menu-button =
    .title = Άλλα πεδία διευθυνσιοδότησης για εμφάνιση
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-notice =
    { $count ->
        [one] Το μήνυμά σας έχει έναν δημόσιο παραλήπτη. Μπορείτε να αποφύγετε την αποκάλυψη των παραληπτών με το πεδίο «Κρυφή κοιν.».
       *[other] Οι { $count } παραλήπτες στα πεδία «Προς» και «Κοιν.» θα βλέπουν τις διευθύνσεις των υπολοίπων. Μπορείτε να αποφύγετε την αποκάλυψη των παραληπτών με το πεδίο «Κρυφή κοιν.».
    }
many-public-recipients-bcc =
    .label = Χρήση «Κρυφή κοιν.»
    .accesskey = Χ
many-public-recipients-ignore =
    .label = Διατήρηση ορατών παραληπτών
    .accesskey = Δ
many-public-recipients-prompt-title = Πάρα πολλοί δημόσιοι παραλήπτες
#   $count (Number) - the count of addresses in the public recipients fields.
many-public-recipients-prompt-msg =
    { $count ->
        [one] Το μήνυμά σας έχει έναν δημόσιο παραλήπτη. Αυτό ίσως βλάψει το απόρρητό σας. Μπορείτε να το αποφύγετε αυτό μετακινώντας τον παραλήπτη από το πεδίο «Προς»/«Κοιν.» στο «Κρυφή κοιν.».
       *[other] Το μήνυμά σας έχει { $count } δημόσιους παραλήπτες, που θα μπορούν να δουν τις διευθύνσεις των υπολοίπων. Αυτό ίσως βλάψει το απόρρητό σας. Μπορείτε να αποφύγετε την αποκάλυψη των παραληπτών μετακινώντας τους από το το πεδίο «Προς»/«Κοιν.» στο «Κρυφή κοιν.».
    }
many-public-recipients-prompt-cancel = Ακύρωση αποστολής
many-public-recipients-prompt-send = Αποστολή ούτως ή άλλως

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = Δεν βρέθηκε μοναδική ταυτότητα που να αντιστοιχεί στη διεύθυνση «Από». Το μήνυμα θα αποσταλεί με το τρέχον πεδίο «Από» και τις ρυθμίσεις της ταυτότητας «{ $identity }».
encrypted-bcc-warning = Κατά την αποστολή ενός κρυπτογραφημένου μηνύματος, οι παραλήπτες στο πεδίο «Κρυφή Κοιν.» δεν αποκρύπτονται πλήρως. Όλοι οι παραλήπτες ενδέχεται να μπορέσουν να τους αναγνωρίσουν.
encrypted-bcc-ignore-button = Κατάλαβα

## Editing


# Tools

compose-tool-button-remove-text-styling =
    .tooltiptext = Κατάργηση μορφοποίησης κειμένου
