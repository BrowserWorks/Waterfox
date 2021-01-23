# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Уклоните { $type } поље

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Уклони поље { $type }

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } врста са једном адресом, користите леву стрелицу за фокус.
        [few] { $type } врста са { $count } адресе, користите леву стрелицу за фокус.
       *[other] { $type } врста са { $count } адреса, користите леву стрелицу за фокус.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: притисните Enter за уређивање, Delete за уклањање.
        [few] { $email }, 1 од { $count }: притисните Enter за уређивање, Delete за уклањање.
       *[other] { $email }, 1 од { $count }: притисните Enter за уређивање, Delete за уклањање.
    }

pill-action-edit =
    .label = Уредите адресу
    .accesskey = е

pill-action-move-to =
    .label = Преместите у За поље
    .accesskey = т

pill-action-move-cc =
    .label = Преместите у Коп поље
    .accesskey = К

pill-action-move-bcc =
    .label = Преместите у сКоп поље
    .accesskey = у

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] Један прилог
            [one] { $count } прилог
            [few] { $count } прилога
           *[other] { $count } прилога
        }
    .accesskey = г

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] Један прилог
            [one] { $count } прилог
            [few] { $count } прилога
           *[other] { $count } прилога
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Потврда
    .tooltiptext = Враћа потврду о пријему ове поруке
