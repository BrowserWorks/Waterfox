# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Elimine el campo { $type }

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Eliminar el campo { $type }

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } con una dirección { $count }, use la tecla de flecha izquierda para enfocarse en la misma.
       *[other] { $type } con las direcciones { $count }, use la tecla de flecha izquierda para enfocarse en las mismas.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: presione Entrar para editar, Supr para eliminar
       *[other] { $email }, 1 de { $count }: presione Entrar para editar, Supr para eliminar.
    }

pill-action-edit =
    .label = Editar dirección
    .accesskey = e

pill-action-move-to =
    .label = Mover a
    .accesskey = t

pill-action-move-cc =
    .label = Mover a CC
    .accesskey = c

pill-action-move-bcc =
    .label = Mover a CCO
    .accesskey = b

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } archivo adjunto
            [one] { $count } archivos adjuntos
           *[other] { $count } archivos adjuntos
        }
    .accesskey = m

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } archivo adjunto
            [one] { $count } archivos adjuntos
           *[other] { $count } archivos adjuntos
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Recibo
    .tooltiptext = Pedir recibo por este mensaje
