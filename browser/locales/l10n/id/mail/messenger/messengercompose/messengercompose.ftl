# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
       *[other] { $type } dengan { $count } alamat, gunakan panah kiri untuk memfokuskan.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
       *[other] { $email }, 1 dari { $count }: tekan Enter untuk mengedit, Delete untuk menghapus.
    }

pill-action-edit =
    .label = Edit Alamat
    .accesskey = E

pill-action-move-to =
    .label = Pindahkan ke Kepada
    .accesskey = k

pill-action-move-cc =
    .label = Pindahkan ke CC
    .accesskey = C

pill-action-move-bcc =
    .label = Pindahkan ke BCC
    .accesskey = B

# Attachment widget

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
           *[other] { $count } Lampiran
        }
    .accesskey = m

# Reorder Attachment Panel

button-return-receipt =
    .label = Tanda Terima
    .tooltiptext = Minta tanda terima untuk pesan ini

# Encryption

# Addressing Area


## Notifications

## Editing

# Tools

