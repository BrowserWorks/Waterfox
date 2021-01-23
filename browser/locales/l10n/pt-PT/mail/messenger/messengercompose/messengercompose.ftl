# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Remover o campo { $type }

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Remover o campo { $type }

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } com um endereço, utilize a tecla seta esquerda para focar o mesmo.
       *[other] { $type } com { $count } endereços, utilize a tecla seta esquerda para focar os mesmos.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: pressione Enter para editar, Eliminar para remover.
       *[other] { $email }, 1 de { $count }: pressione Enter para editar, Eliminar para remover.
    }

pill-action-edit =
    .label = Editar endereço
    .accesskey = e

pill-action-move-to =
    .label = Mover para Para
    .accesskey = p

pill-action-move-cc =
    .label = Mover para Cc
    .accesskey = c

pill-action-move-bcc =
    .label = Mover para Bcc
    .accesskey = B

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } anexo
           *[other] { $count } anexos
        }
    .accesskey = x

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } anexo
            [one] { $count } anexo
           *[other] { $count } anexos
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Recibo
    .tooltiptext = Solicitar um recibo de leitura para esta mensagem
