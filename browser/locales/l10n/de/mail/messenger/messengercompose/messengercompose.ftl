# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = { $type }-Eingabefeld entfernen

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label = { $count ->
    [0]     { $type }
    [one]   { $type } mit einer Adresse, Pfeil-nach-links-Taste zum Auswählen verwenden
    *[other] { $type } mit { $count } Adressen, Pfeil-nach-links-Taste zum Auswählen verwenden
}

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label = { $count ->
    [one]   { $email }: zum Bearbeiten Eingabetaste drücken, Entfernen-Taste zum Entfernen.
    *[other] { $email }, 1 von { $count }: zum Bearbeiten Eingabetaste drücken, Entfernen-Taste zum Entfernen.
}

pill-action-edit =
    .label = Adresse bearbeiten
    .accesskey = r

pill-action-move-to =
    .label = Verschieben zu An
    .accesskey = A

pill-action-move-cc =
    .label = Verschieben zu Kopie (CC)
    .accesskey = C

pill-action-move-bcc =
    .label = Verschieben zu Blindkopie (BCC)
    .accesskey = B

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value = { $count ->
        [1]      { $count } Anhang
        *[other] { $count } Anhänge
    }
    .accesskey = g

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext = { $count ->
        [1]      { $count } Anhang
        *[other] { $count } Anhänge
    }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Empfangsbestätigung
    .tooltiptext = Eine Empfangsbestätigung für diese Nachricht anfordern
