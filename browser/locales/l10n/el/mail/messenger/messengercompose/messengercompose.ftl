# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Αφαίρεση πεδίου "{ $type }"
#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Αφαίρεση πεδίου "{ $type }"
#   $type (String) - the type of the addressing row
remove-address-row-button =
    .title = Αφαίρεση πεδίου "{ $type }"
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
    .label = Μετακίνηση στο Προς
    .accesskey = τ
pill-action-move-cc =
    .label = Μετακίνηση σε "Κοιν."
    .accesskey = κ
pill-action-move-bcc =
    .label = Μετακίνηση σε "Κρυφή κοιν."
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
    .label = Προβολή συνημμένων
    .accesskey = μ
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }
toolbar-button-add-attachment =
    .label = Επισύναψη
    .tooltiptext = Προσθήκη συνημμένου ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })
add-attachment-notification-reminder =
    .label = Προσθήκη συνημμένου…
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
    .value =
        { $count ->
            [1] { $count } συνημμένο
           *[other] { $count } συνημμένα
        }
    .accesskey = μ
#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } συνημμένο
           *[other] { $count } συνημμένα
        }
#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }
expand-attachment-pane-tooltip =
    .tooltiptext = Εμφάνιση του πίνακα συνημμένων ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
collapse-attachment-pane-tooltip =
    .tooltiptext = Απόκρυψη του πίνακα συνημμένων ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
drop-file-label-attachment =
    { $count ->
        [one] Προσθήκη ως συνημμένο
       *[other] Προσθήκη ως συνημμένα
    }
drop-file-label-inline =
    { $count ->
        [one] Προσθήκη ένθετα
       *[other] Προσθήκη ένθετα
    }

# Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = Μετακίνηση στο Πρώτο
move-attachment-left-panel-button =
    .label = Μετακίνηση Αριστερά
move-attachment-right-panel-button =
    .label = Μετακίνηση Δεξιά
move-attachment-last-panel-button =
    .label = Μετακίνηση στο Τελευταίο
button-return-receipt =
    .label = Αποδεικτικό
    .tooltiptext = Απαίτηση αποδεικτικού προβολής για αυτό το μήνυμα

# Addressing Area

to-compose-address-row-label =
    .value = Προς
#   $key (String) - the shortcut key for this field
to-compose-show-address-row-menuitem =
    .label = Πεδίο "{ to-compose-address-row-label.value }"
    .accesskey = Π
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
to-compose-show-address-row-label =
    .value = { to-compose-address-row-label.value }
    .tooltiptext = Εμφάνιση πεδίου "{ to-compose-address-row-label.value }" ({ to-compose-show-address-row-menuitem.acceltext })
cc-compose-address-row-label =
    .value = Κοιν.
#   $key (String) - the shortcut key for this field
cc-compose-show-address-row-menuitem =
    .label = Πεδίο "{ cc-compose-address-row-label.value }"
    .accesskey = δ
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
cc-compose-show-address-row-label =
    .value = { cc-compose-address-row-label.value }
    .tooltiptext = Εμφάνιση πεδίου "{ cc-compose-address-row-label.value }" ({ cc-compose-show-address-row-menuitem.acceltext })
bcc-compose-address-row-label =
    .value = Κρυφή κοιν.
#   $key (String) - the shortcut key for this field
bcc-compose-show-address-row-menuitem =
    .label = Πεδίο "{ bcc-compose-address-row-label.value }"
    .accesskey = ο
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
bcc-compose-show-address-row-label =
    .value = { bcc-compose-address-row-label.value }
    .tooltiptext = Εμφάνιση πεδίου "{ bcc-compose-address-row-label.value }" ({ bcc-compose-show-address-row-menuitem.acceltext })
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-info = Οι { $count } παραλήπτες στα πεδία "Προς" και "Κοιν." θα βλέπουν τις διευθύνσεις των υπολοίπων. Μπορείτε να αποφύγετε την αποκάλυψη των παραληπτών με το πεδίο "Κρυφή κοιν.".
many-public-recipients-bcc =
    .label = Χρήση "Κρυφή κοιν."
    .accesskey = Χ
many-public-recipients-ignore =
    .label = Διατήρηση ορατών παραληπτών
    .accesskey = Δ

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = Δεν βρέθηκε μοναδική ταυτότητα που να αντιστοιχεί στη διεύθυνση "Από". Το μήνυμα θα αποσταλεί με το τρέχον πεδίο "Από" και τις ρυθμίσεις της ταυτότητας "{ $identity }".
encrypted-bcc-ignore-button = Κατάλαβα
