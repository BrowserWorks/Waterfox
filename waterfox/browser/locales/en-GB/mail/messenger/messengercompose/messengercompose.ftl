# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Send Format

compose-send-format-menu =
    .label = Sending Format
    .accesskey = F
compose-send-auto-menu-item =
    .label = Automatic
    .accesskey = A
compose-send-both-menu-item =
    .label = Both HTML and Plain Text
    .accesskey = B
compose-send-html-menu-item =
    .label = Only HTML
    .accesskey = H
compose-send-plain-menu-item =
    .label = Only Plain Text
    .accesskey = P

## Addressing widget

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
#   $type (String) - the type of the addressing row, e.g. Cc, Bcc, etc.
pill-action-select-all-sibling-pills =
    .label = Select All Addresses in { $type }
    .accesskey = A
pill-action-select-all-pills =
    .label = Select All Addresses
    .accesskey = S
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

## Attachment widget

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
# Note: Do not translate the term 'vCard'.
context-menuitem-attach-vcard =
    .label = My vCard
    .accesskey = C
context-menuitem-attach-openpgp-key =
    .label = My OpenPGP Public Key
    .accesskey = K
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count-value =
    { $count ->
        [1] { $count } Attachment
       *[other] { $count } Attachments
    }
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

## Reorder Attachment Panel

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

## Encryption

encryption-menu =
    .label = Security
    .accesskey = c
encryption-toggle =
    .label = Encrypt
    .tooltiptext = Use end-to-end encryption for this message
encryption-options-openpgp =
    .label = OpenPGP
    .tooltiptext = View or change OpenPGP encryption settings
encryption-options-smime =
    .label = S/MIME
    .tooltiptext = View or change S/MIME encryption settings
signing-toggle =
    .label = Sign
    .tooltiptext = Use digital signing for this message
menu-openpgp =
    .label = OpenPGP
    .accesskey = O
menu-smime =
    .label = S/MIME
    .accesskey = S
menu-encrypt =
    .label = Encrypt
    .accesskey = E
menu-encrypt-subject =
    .label = Encrypt Subject
    .accesskey = B
menu-sign =
    .label = Digitally Sign
    .accesskey = i
menu-manage-keys =
    .label = Key Assistant
    .accesskey = A
menu-view-certificates =
    .label = View Certificates Of Recipients
    .accesskey = V
menu-open-key-manager =
    .label = Key Manager
    .accesskey = M
openpgp-key-issue-notification-one = End-to-end encryption requires resolving key issues for { $addr }
openpgp-key-issue-notification-many = End-to-end encryption requires resolving key issues for { $count } recipients.
smime-cert-issue-notification-one = End-to-end encryption requires resolving certificate issues for { $addr }.
smime-cert-issue-notification-many = End-to-end encryption requires resolving certificate issues for { $count } recipients.
key-notification-disable-encryption =
    .label = Do Not Encrypt
    .accesskey = D
    .tooltiptext = Disable end-to-end encryption
key-notification-resolve =
    .label = Resolve…
    .accesskey = R
    .tooltiptext = Open the OpenPGP Key Assistant
can-encrypt-smime-notification = S/MIME end-to-end encryption is possible.
can-encrypt-openpgp-notification = OpenPGP end-to-end encryption is possible.
can-e2e-encrypt-button =
    .label = Encrypt
    .accesskey = E

## Addressing Area

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

## Filelink

# A text used in a tooltip of Filelink attachments, whose account has been
# removed or is unknown.
cloud-file-unknown-account-tooltip = Uploaded to an unknown Filelink account.

# Placeholder file

# Title for the html placeholder file.
# $filename - name of the file
cloud-file-placeholder-title = { $filename } - Filelink Attachment
# A text describing that the file was attached as a Filelink and can be downloaded
# from the link shown below.
# $filename - name of the file
cloud-file-placeholder-intro = The file { $filename } was attached as a Filelink. It can be downloaded from the link below.

# Template

# A line of text describing how many uploaded files have been appended to this
# message. Emphasis should be on sharing as opposed to attaching. This item is
# used as a header to a list, hence the colon.
cloud-file-count-header =
    { $count ->
        [one] I've linked { $count } file to this email:
       *[other] I've linked { $count } files to this email:
    }
# A text used in a footer, instructing the reader where to find additional
# information about the used service provider.
# $link (string) - html a-tag for a link pointing to the web page of the provider
cloud-file-service-provider-footer-single = Learn more about { $link }.
# A text used in a footer, instructing the reader where to find additional
# information about the used service providers. Links for the used providers are
# split into a comma separated list of the first n-1 providers and a single entry
# at the end.
# $firstLinks (string) - comma separated list of html a-tags pointing to web pages
#                        of the first n-1 used providers
# $lastLink (string) - html a-tag pointing the web page of the n-th used provider
cloud-file-service-provider-footer-multiple = Learn more about { $firstLinks } and { $lastLink }.
# Tooltip for an icon, indicating that the link is protected by a password.
cloud-file-tooltip-password-protected-link = Password protected link
# Used in a list of stats about a specific file
# Service - the used service provider to host the file (Filelink Service: BOX.com)
# Size - the size of the file (Size: 4.2 MB)
# Link - the link to the file (Link: https://some.provider.com)
# Expiry Date - stating the date the link will expire (Expiry Date: 12.12.2022)
# Download Limit - stating the maximum allowed downloads, before the link becomes invalid
#                  (Download Limit: 6)
cloud-file-template-service-name = Filelink Service:
cloud-file-template-size = Size:
cloud-file-template-link = Link:
cloud-file-template-password-protected-link = Password Protected Link:
cloud-file-template-expiry-date = Expiry Date:
cloud-file-template-download-limit = Download Limit:

# Messages

# $provider (string) - name of the online storage service that reported the error
cloud-file-connection-error-title = Connection Error
cloud-file-connection-error = { -brand-short-name } is offline. Could not connect to { $provider }.
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was uploaded and caused the error
cloud-file-upload-error-with-custom-message-title = Uploading { $filename } to { $provider } Failed
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-rename-error-title = Rename Error
cloud-file-rename-error = There was a problem renaming { $filename } on { $provider }.
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-rename-error-with-custom-message-title = Renaming { $filename } on { $provider } Failed
# $provider (string) - name of the online storage service that reported the error
cloud-file-rename-not-supported = { $provider } does not support renaming already uploaded files.
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-attachment-error-title = Filelink Attachment Error
cloud-file-attachment-error = Failed to update the Filelink attachment { $filename }, because its local file has been moved or deleted.
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-account-error-title = Filelink Account Error
cloud-file-account-error = Failed to update the Filelink attachment { $filename }, because its Filelink account has been deleted.

## Link Preview

link-preview-title = Link Preview
link-preview-description = { -brand-short-name } can add an embedded preview when pasting links.
link-preview-autoadd = Automatically add link previews when possible
link-preview-replace-now = Add a Link Preview for this link?
link-preview-yes-replace = Yes

## Dictionary selection popup

spell-add-dictionaries =
    .label = Add Dictionaries…
    .accesskey = A
