# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Allontanar il champ { $type }

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Allontanar il champ { $type }

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } cun ina adressa, duvrar la tasta cun frizza a sanestra per focussar.
       *[other] { $type } cun { $count } adressas, duvrar la tasta cun frizza a sanestra per focussar.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: smatgar Enter per modifitgar, Delete per allontanar.
       *[other] { $email }, 1 da { $count }: smatgar Enter per modifitgar, Delete per allontanar.
    }

pill-action-edit =
    .label = Modifitgar l'adressa
    .accesskey = e

pill-action-move-to =
    .label = Spustar a «a»
    .accesskey = a

pill-action-move-cc =
    .label = Spustar a «cc»
    .accesskey = c

pill-action-move-bcc =
    .label = Spustar a «bcc»
    .accesskey = b

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } agiunta
            [one] { $count } agiunta
           *[other] { $count } agiuntas
        }
    .accesskey = n

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } agiunta
            [one] { $count } agiunta
           *[other] { $count } agiuntas
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Retschavida
    .tooltiptext = Dumandar ina conferma da retschavida per quest messadi
