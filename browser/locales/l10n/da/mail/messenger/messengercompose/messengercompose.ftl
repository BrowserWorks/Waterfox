# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Fjern feltet { $type }

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } med én adresse, brug venstre piletast for at flytte fokus til den.
       *[other] { $type } med { $count } adresser, brug venstre piletast for at flytte fokus til dem.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: tryk på Enter-tasten for at redigere, Tryk på Slet-tasten for at fjerne.
       *[other] { $email }, 1 af { $count }: tryk på Enter-tasten for at redigere, Tryk på Slet-tasten for at fjerne.
    }

pill-action-edit =
    .label = Rediger adresse
    .accesskey = R

pill-action-move-to =
    .label = Flyt til Til
    .accesskey = T

pill-action-move-cc =
    .label = Flyt til Kopi til (Cc)
    .accesskey = C

pill-action-move-bcc =
    .label = Flyt til Skjult kopi til (Bcc)
    .accesskey = B

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [one] { $count } vedhæftet fil
           *[other] { $count } vedhæftede filer
        }
    .accesskey = æ

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } vedhæftet fil
           *[other] { $count } vedhæftede filer
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Kvittering
    .tooltiptext = Bed om en kvittering for modtagelse af denne meddelelse
