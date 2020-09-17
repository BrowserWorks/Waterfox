# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Kendu { $type } eremua

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Kendu { $type } eremua

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } helbide batekin, erabili ezker gezia fokua bertan jartzeko.
       *[other] { $type } { $count } helbidekin, erabili ezker gezia fokua beraiengan jartzeko.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: sakatu Sartu editatzeko, Ezabatu kentzeko.
       *[other] { $email } 1 { $count }-tik:  sakatu Sartu editatzeko, Ezabatu kentzeko.
    }

pill-action-edit =
    .label = Editatu helbidea
    .accesskey = E

pill-action-move-to =
    .label = Eraman hona
    .accesskey = m

pill-action-move-cc =
    .label = Eraman Cc-ra
    .accesskey = c

pill-action-move-bcc =
    .label = Eraman Bcc-ra
    .accesskey = B

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] Eranskin { $count }
            [one] Eranskin { $count }
           *[other] { $count } eranskin
        }
    .accesskey = e

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] Eranskin { $count }
            [one] Eranskin { $count }
           *[other] { $count } eranskin
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Hartu-agiria
    .tooltiptext = Eskatu hartu-agiria mezu honetarako
