# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Elimina il campo { $type }

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Elimina il campo { $type }

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } con un indirizzo, usa il tasto freccia sinistra per porre il focus su di esso.
       *[other] { $type } con { $count } indirizzi, usa il tasto freccia sinistra per porre il focus su di essi.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: premi Invio per modificare, Canc per eliminare.
       *[other] { $email }, 1 di { $count }: premi Invio per modificare, Canc per eliminare.
    }

pill-action-edit =
    .label = Modifica indirizzo
    .accesskey = M

pill-action-move-to =
    .label = Sposta in A
    .accesskey = S

pill-action-move-cc =
    .label = Sposta in Cc
    .accesskey = c

pill-action-move-bcc =
    .label = Sposta in Ccn
    .accesskey = n

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [one] { $count } allegato
           *[other] { $count } allegati
        }
    .accesskey = a

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [one] { $count } allegato
           *[other] { $count } allegati
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Ricevuta
    .tooltiptext = Richiedi una ricevuta di ritorno per questo messaggio
