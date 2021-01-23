# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Hiqe fushën { $type }

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Hiqe fushën { $type }

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } me një adresë, përdorni tastin shigjetë. majtas që të fokusi të kalohet në të
       *[other] { $type } me { $count } adresa, përdorni tastin shigjetë majtas që të fokusi të kalohet në to.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: shtypni tastin Enter që ta përpunoni, tastin Delete që të hiqet.
       *[other] { $email }: 1 nga { $count }: shtypni tastin Enter që ta përpunoni, tastin Delete që të hiqet.
    }

pill-action-edit =
    .label = Përpunoni Adresë
    .accesskey = P

pill-action-move-to =
    .label = Shpjere te Për
    .accesskey = ë

pill-action-move-cc =
    .label = Shpjere te Cc
    .accesskey = C

pill-action-move-bcc =
    .label = Shpjere te Bcc
    .accesskey = B

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } Bashkëngjitje
           *[other] { $count } Bashkëngjitje
        }
    .accesskey = B

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } Bashkëngjitje
            [one] { $count } Bashkëngjitje
           *[other] { $count } Bashkëngjitje
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Dëftesë
    .tooltiptext = Kërko një dëftesë kthimi për këtë mesazh
