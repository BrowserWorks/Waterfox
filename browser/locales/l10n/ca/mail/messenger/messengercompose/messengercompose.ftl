# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Elimina el camp { $type }

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } amb una adreça, utilitzeu la tecla de fletxa esquerra per seleccionar-la.
       *[other] { $type } amb { $count } adreces, utilitzeu la tecla de fletxa esquerra per seleccionar-les.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: premeu Retorn per editar, Supr per eliminar.
       *[other] { $email }, 1 de { $count }: premeu Retorn per editar, Supr per eliminar.
    }

pill-action-edit =
    .label = Edita l'adreça
    .accesskey = E

pill-action-move-to =
    .label = Mou a
    .accesskey = M

pill-action-move-cc =
    .label = Mou a Cc
    .accesskey = C

pill-action-move-bcc =
    .label = Mou a Cco
    .accesskey = o

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } adjunció
            [one] { $count } adjunció
           *[other] { $count } adjuncions
        }
    .accesskey = n

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } adjunció
            [one] { $count } adjunció
           *[other] { $count } adjuncions
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Confirmació de recepció
    .tooltiptext = Sol·licita una confirmació de recepció per a aquest missatge
