# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = { $type } alanını kaldır

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = { $type } alanını kaldır

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] Tek adresli { $type } satırına odaklanmak için sol ok tuşunu kullanın.
       *[other] { $count } adresli { $type } satırlarına odaklanmak için sol ok tuşunu kullanın.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: Düzenlemek için Enter'a, silmek için Delete'e basın.
       *[other] { $email }, 1/{ $count }: Düzenlemek için Enter'a, silmek için Delete'e basın.
    }

pill-action-edit =
    .label = Adresi düzenle
    .accesskey = d

pill-action-move-to =
    .label = Kime alanına taşı
    .accesskey = m

pill-action-move-cc =
    .label = Cc alanına taşı
    .accesskey = C

pill-action-move-bcc =
    .label = Bcc alanına taşı
    .accesskey = B

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } ek
            [one] { $count } ek
           *[other] { $count } ek
        }
    .accesskey = e

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } ek
            [one] { $count } ek
           *[other] { $count } ek
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Alındı onayı
    .tooltiptext = Bu ileti için alındı onayı iste
