# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Supprimer le champ { $type }

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Supprimer le champ { $type }

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } avec une adresse, utilisez la touche flèche gauche pour la sélectionner.
       *[other] { $type } avec { $count } adresses, utilisez la touche flèche gauche pour les sélectionner.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email } : appuyez sur Entrée pour modifier, ou Supprimer pour retirer.
       *[other] { $email }, 1 sur { $count } : appuyez sur Entrée pour modifier, ou Supprimer pour retirer.
    }

pill-action-edit =
    .label = Modifier l’adresse
    .accesskey = M

pill-action-move-to =
    .label = Déplacer vers Pour
    .accesskey = p

pill-action-move-cc =
    .label = Déplacer vers Copie à
    .accesskey = c

pill-action-move-bcc =
    .label = Déplacer vers Copie cachée à
    .accesskey = h

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } pièce jointe
           *[other] { $count } pièces jointes
        }
    .accesskey = o

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } pièce jointe
           *[other] { $count } pièces jointes
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Accusé de réception
    .tooltiptext = Demander un accusé de réception pour ce message
