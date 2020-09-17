# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Remover le campo { $type }

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Remover le campo { $type }

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } con un adresse, usa le clave flecha sinistre pro concentrar se sur illo.
       *[other] { $type } con { $count } adresses, usa le clave flecha sinistre pro concentrar se sur illos.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: pulsa Enter pro rediger, Deler pro eliminar
       *[other] { $email }, 1 de { $count }: pulsa Enter pro rediger, Deler pro eliminar.
    }

pill-action-edit =
    .label = Modificar le adresse
    .accesskey = M

pill-action-move-to =
    .label = Mover a A
    .accesskey = A

pill-action-move-cc =
    .label = Mover a Cc
    .accesskey = C

pill-action-move-bcc =
    .label = Mover a Ccn
    .accesskey = n

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } Attachamento
           *[other] { $count } Attachamentos
        }
    .accesskey = m

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } Attachamento
           *[other] { $count } Attachamentos
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Quitantia
    .tooltiptext = Requirer un quitantia de retorno pro iste message
