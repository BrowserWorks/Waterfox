# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Eliminar el campo { $type }

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Eliminar el campo { $type }

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label = { $count ->
    [0]     { $type }
    [one]   { $type } con una dirección, use la tecla Flecha izquierda para situarse en ella.
    *[other] { $type } con { $count } direcciones, use la tecla Flecha izquierda para situarse en ellas.
}

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label = { $count ->
    [one]   { $email }: pulse Enter para editar, Borrar para eliminar.
    *[other] { $email }, 1 de { $count }: pulse Enter para editar, Borrar para eliminar.
}

pill-action-edit =
    .label = Editar dirección
    .accesskey = e

pill-action-move-to =
    .label = Ir al campo Para
    .accesskey = P

pill-action-move-cc =
    .label = Ir al campo Cc
    .accesskey = c

pill-action-move-bcc =
    .label = Ir al campo Bcc
    .accesskey = b

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value = { $count ->
        [1]      { $count } adjunto
        *[other] { $count } adjuntos
    }
    .accesskey = d

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext = { $count ->
        [1]      { $count } adjunto
        *[other] { $count } adjuntos
    }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Recibo
    .tooltiptext = Solicitar un recibo de respuesta de este mensaje
