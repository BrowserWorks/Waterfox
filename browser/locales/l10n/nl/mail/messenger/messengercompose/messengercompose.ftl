# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Het veld { $type } verwijderen
#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Het veld { $type } verwijderen
#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } met een adres, gebruik de linkerpijltoets om de focus erop te zetten.
       *[other] { $type } met { $count } adressen, gebruik de linkerpijltoets om de focus erop te zetten.
    }
#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: druk Enter om te bewerken, Delete om te verwijderen.
       *[other] { $email }, 1 van { $count }: druk Enter om te bewerken, Delete om te verwijderen.
    }
pill-action-edit =
    .label = Adres bewerken
    .accesskey = d
pill-action-move-to =
    .label = Verplaatsen naar Aan
    .accesskey = A
pill-action-move-cc =
    .label = Verplaatsen naar Cc
    .accesskey = c
pill-action-move-bcc =
    .label = Verplaatsen naar Bcc
    .accesskey = B
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [one] { $count } bijlage
           *[other] { $count } bijlagen
        }
    .accesskey = l
#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [one] { $count } bijlage
           *[other] { $count } bijlagen
        }
#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }
button-return-receipt =
    .label = Ontvangstbevestiging
    .tooltiptext = Een ontvangstbevestiging voor dit bericht vragen
