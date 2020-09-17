# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Հեռացնել { $type } դաշտը

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Հեռացնել { $type } դաշտը

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } հասցեներով, օգտագործեք ձախ սլաքի ստեղնը `դրանց վրա կենտրոնանալու համար:
       *[other] { $type } { $count } հասցեներով, օգտագործեք ձախ սլաքի ստեղնը `դրանց վրա կենտրոնանալու համար:
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }. սեղմեք Enter՝ խմբագրելու, Ջնջել՝ ջնջելու համար:
       *[other] { $email }, 1-ը { $count }-ից. սեղմեք Enter՝ խմբագրելու, Ջնջել՝ ջնջելու համար:
    }

pill-action-edit =
    .label = Խմբագրել հասցեն
    .accesskey = e

pill-action-move-to =
    .label = Տեղափոխել Ում
    .accesskey = T

pill-action-move-cc =
    .label = Տեղափոխել Cc
    .accesskey = C

pill-action-move-bcc =
    .label = Տեղափոխել Bcc
    .accesskey = B

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } կցորդ
            [one] { $count } կցորդ
           *[other] { $count } կցորդներ
        }
    .accesskey = m

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } կցորդ
            [one] { $count } կցորդ
           *[other] { $count } կցորդ
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Ստացական
    .tooltiptext = Հետադարձ ստացական հայցել նամակի համար
