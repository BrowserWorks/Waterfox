# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = It fjild { $type } fuortsmite

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = It fjild { $type } fuortsmite

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } mei ien adres, brûk de linkerpylktoets om de fokus dêrop te setten.
       *[other] { $type } mei { $count } adressen, brûk de linkerpylktoets om de fokus dêrop te setten.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: druk Enter om te bewurkjen, Delete om fuort te smiten.
       *[other] { $email }, 1 fan { $count }: druk Enter om te bewurkjen, Delete om fuort te smiten.
    }

pill-action-edit =
    .label = Adres bewurkje
    .accesskey = d

pill-action-move-to =
    .label = Ferpleatse nei Oan
    .accesskey = O

pill-action-move-cc =
    .label = Ferpleatse nei Cc
    .accesskey = c

pill-action-move-bcc =
    .label = Ferpleatse nei Bcc
    .accesskey = B

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [one] { $count } bylage
           *[other] { $count } bylagen
        }
    .accesskey = l

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [one] { $count } bylage
           *[other] { $count } bylagen
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Untfangstbefêstiging
    .tooltiptext = In ûntfangstbefêstiging foar dit berjocht freegje
