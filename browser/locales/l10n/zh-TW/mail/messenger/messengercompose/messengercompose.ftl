# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = 移除 { $type } 欄位

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = 移除 { $type } 欄位

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
       *[other] { $type } 有 { $count } 個地址，使用鍵盤左方向鍵移動到該項目。
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: 按 Enter 編輯、按 Delete 刪除。
       *[other] { $email }，第 1 筆，共 { $count } 筆: 按 Enter 編輯、按 Delete 刪除。
    }

pill-action-edit =
    .label = 編輯地址
    .accesskey = e

pill-action-move-to =
    .label = 移到收件者
    .accesskey = t

pill-action-move-cc =
    .label = 移到副本
    .accesskey = c

pill-action-move-bcc =
    .label = 移到密件副本
    .accesskey = b

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [0] 沒有附件
           *[other] { $count } 個附件
        }
    .accesskey = m

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [0] 沒有附件
           *[other] { $count } 個附件
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = 收件回執
    .tooltiptext = 要求對方收信後寄發回執
