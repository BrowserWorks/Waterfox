# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Polo typa { $type } wotstronić

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Polo typa { $type } wotstronić

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } z jednej adresu, wužiwajće lěwu šipkowy tastu, zo byšće fokus stajił.
        [two] { $type } z { $count } adresomaj, wužiwajće lěwu šipkowej tastu, zo byšće fokus stajił.
        [few] { $type } z { $count } adresami, wužiwajće lěwu šipkowu tastu, zo byšće fokus stajił.
       *[other] { $type } z { $count } adresami, wužiwajće lěwu šipkowu tastu, zo byšće fokus stajił.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: Tłóčće Enter, zo byšće wobdźěłował, Entf, zo byšće wotstronił.
        [two] { $email }, 1 z { $count }: Tłóčće Enter, zo byšće wobdźěłował, Entf, zo byšće wotstronił.
        [few] { $email }, 1 z { $count }: Tłóčće Enter, zo byšće wobdźěłował, Entf, zo byšće wotstronił.
       *[other] { $email }, 1 z { $count }: Tłóčće Enter, zo byšće wobdźěłował, Entf, zo byšće wotstronił.
    }

pill-action-edit =
    .label = Adresu wobdźěłać
    .accesskey = A

pill-action-move-to =
    .label = Do Komu přesunyć
    .accesskey = K

pill-action-move-cc =
    .label = Do kopije přesunyć
    .accesskey = p

pill-action-move-bcc =
    .label = Do schowaneje kopije přesunyć
    .accesskey = s

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } přidatk
            [one] { $count } přidatk
            [two] { $count } přidatkaj
            [few] { $count } přidatki
           *[other] { $count } přidatkow
        }
    .accesskey = d

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } přidatk
            [one] { $count } přidatk
            [two] { $count } přidatkaj
            [few] { $count } přidatki
           *[other] { $count } přidatkow
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Kwitowanka
    .tooltiptext = Kwitowanku za tutu powěsć požadać
