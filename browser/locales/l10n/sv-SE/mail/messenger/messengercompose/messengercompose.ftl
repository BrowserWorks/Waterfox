# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Ta bort fältet { $type }

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Ta bort { $type }-fältet

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } med en adress, använd vänster piltangent för att fokusera på den.
       *[other] { $type } med { $count } adresser, använd vänster piltangent för att fokusera på dem.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: tryck på Enter för att redigera, Ta bort för att ta bort.
       *[other] { $email }, 1 av { $count }: tryck på Enter för att redigera, Ta bort för att ta bort.
    }

pill-action-edit =
    .label = Redigera adress
    .accesskey = R

pill-action-move-to =
    .label = Flytta till Till
    .accesskey = T

pill-action-move-cc =
    .label = Flytta till Kopia
    .accesskey = K

pill-action-move-bcc =
    .label = Flytta till Dold kopia
    .accesskey = D

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } bilaga
            [one] { $count } bilaga
           *[other] { $count } bilagor
        }
    .accesskey = b

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] Bilagor
            [one] { $count } bilaga
           *[other] { $count } bilagor
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Kvitto
    .tooltiptext = Begär ett returkvitto för detta meddelande
