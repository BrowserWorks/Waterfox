# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-button =
    .title = Remove the { $type } field
#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } with one address, use left arrow key to focus on it.
       *[other] { $type } with { $count } addresses, use left arrow key to focus on them.
    }
#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: press Enter to edit, Delete to remove.
       *[other] { $email }, 1 of { $count }: press Enter to edit, Delete to remove.
    }
#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } is not a valid e-mail address
#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } is not in your address book
pill-action-edit =
    .label = Edit Address
    .accesskey = E
pill-action-move-to =
    .label = Move to To
    .accesskey = t
pill-action-move-cc =
    .label = Move to Cc
    .accesskey = C
pill-action-move-bcc =
    .label = Move to Bcc
    .accesskey = B
pill-action-expand-list =
    .label = Expand List
    .accesskey = x

# Attachment widget

ctrl-cmd-shift-pretty-prefix =
    { PLATFORM() ->
        [macos] ⇧ ⌘{ " " }
       *[other] Ctrl+Shift+
    }
trigger-attachment-picker-key = A
toggle-attachment-pane-key = M
menuitem-toggle-attachment-pane =
    .label = Attachment Pane
    .accesskey = m
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }
toolbar-button-add-attachment =
    .label = Attach
    .tooltiptext = Add an Attachment ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })
add-attachment-notification-reminder =
    .label = Add Attachment…
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
add-attachment-notification-reminder2 =
    .label = Add Attachment…
    .accesskey = A
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
menuitem-attach-files =
    .label = File(s)…
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
context-menuitem-attach-files =
    .label = Attach File(s)…
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } Attachment
           *[other] { $count } Attachments
        }
    .accesskey = m
expand-attachment-pane-tooltip =
    .tooltiptext = Show the attachment pane ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
collapse-attachment-pane-tooltip =
    .tooltiptext = Hide the attachment pane ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
attachment-area-show =
    .title = Show the attachment pane ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
attachment-area-hide =
    .title = Hide the attachment pane ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
drop-file-label-attachment =
    { $count ->
        [one] Add as Attachment
       *[other] Add as Attachments
    }
drop-file-label-inline =
    { $count ->
        [one] Append inline
       *[other] Append inline
    }

# Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = Move First
move-attachment-left-panel-button =
    .label = Move Left
move-attachment-right-panel-button =
    .label = Move Right
move-attachment-last-panel-button =
    .label = Move Last
button-return-receipt =
    .label = Receipt
    .tooltiptext = Request a return receipt for this message

# Encryption

message-to-be-signed-icon =
    .alt = Sign message
message-to-be-encrypted-icon =
    .alt = Encrypt message

# Addressing Area

to-compose-address-row-label =
    .value = To
#   $key (String) - the shortcut key for this field
to-compose-show-address-row-menuitem =
    .label = { to-compose-address-row-label.value } Field
    .accesskey = T
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
to-compose-show-address-row-label =
    .value = { to-compose-address-row-label.value }
    .tooltiptext = Show { to-compose-address-row-label.value } Field ({ to-compose-show-address-row-menuitem.acceltext })
cc-compose-address-row-label =
    .value = Cc
#   $key (String) - the shortcut key for this field
cc-compose-show-address-row-menuitem =
    .label = { cc-compose-address-row-label.value } Field
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
cc-compose-show-address-row-label =
    .value = { cc-compose-address-row-label.value }
    .tooltiptext = Show { cc-compose-address-row-label.value } Field ({ cc-compose-show-address-row-menuitem.acceltext })
bcc-compose-address-row-label =
    .value = Bcc
#   $key (String) - the shortcut key for this field
bcc-compose-show-address-row-menuitem =
    .label = { bcc-compose-address-row-label.value } Field
    .accesskey = B
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
bcc-compose-show-address-row-label =
    .value = { bcc-compose-address-row-label.value }
    .tooltiptext = Show { bcc-compose-address-row-label.value } Field ({ bcc-compose-show-address-row-menuitem.acceltext })
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-info = The { $count } recipients in To and Cc will see each other’s address. You can avoid disclosing recipients by using Bcc instead.
to-address-row-label =
    .value = To
#   $key (String) - the shortcut key for this field
show-to-row-main-menuitem =
    .label = To Field
    .accesskey = T
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-to-row-button text.
show-to-row-extra-menuitem =
    .label = To
    .accesskey = T
#   $key (String) - the shortcut key for this field
show-to-row-button = To
    .title = Show To Field ({ ctrl-cmd-shift-pretty-prefix }{ $key })
cc-address-row-label =
    .value = Cc
#   $key (String) - the shortcut key for this field
show-cc-row-main-menuitem =
    .label = Cc Field
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-cc-row-button text.
show-cc-row-extra-menuitem =
    .label = Cc
    .accesskey = C
#   $key (String) - the shortcut key for this field
show-cc-row-button = Cc
    .title = Show Cc Field ({ ctrl-cmd-shift-pretty-prefix }{ $key })
bcc-address-row-label =
    .value = Bcc
#   $key (String) - the shortcut key for this field
show-bcc-row-main-menuitem =
    .label = Bcc Field
    .accesskey = B
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-bcc-row-button text.
show-bcc-row-extra-menuitem =
    .label = Bcc
    .accesskey = B
#   $key (String) - the shortcut key for this field
show-bcc-row-button = Bcc
    .title = Show Bcc Field ({ ctrl-cmd-shift-pretty-prefix }{ $key })
extra-address-rows-menu-button =
    .title = Other addressing fields to show
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-notice =
    { $count ->
        [one] Your message has a public recipient. You can avoid disclosing recipients by using Bcc instead.
       *[other] The { $count } recipients in To and Cc will see each other’s address. You can avoid disclosing recipients by using Bcc instead.
    }
many-public-recipients-bcc =
    .label = Use Bcc Instead
    .accesskey = U
many-public-recipients-ignore =
    .label = Keep Recipients Public
    .accesskey = K
many-public-recipients-prompt-title = Too Many Public Recipients
#   $count (Number) - the count of addresses in the public recipients fields.
many-public-recipients-prompt-msg =
    { $count ->
        [one] Your message has a public recipient. This may be a privacy concern. You can avoid this by moving the recipient from To/Cc to Bcc instead.
       *[other] Your message has { $count } public recipients, who will be able to see each other’s addresses. This may be a privacy concern. You can avoid disclosing recipients by moving recipients from To/Cc to Bcc instead.
    }
many-public-recipients-prompt-cancel = Cancel Sending
many-public-recipients-prompt-send = Send Anyway

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = A unique identity matching the From address was not found. The message will be sent using the current From field and settings from identity { $identity }.
encrypted-bcc-warning = When sending an encrypted message, recipients in Bcc are not fully hidden. All recipients may be able to identify them.
encrypted-bcc-ignore-button = Understood

## Editing


# Tools

compose-tool-button-remove-text-styling =
    .tooltiptext = Remove Text Styling
