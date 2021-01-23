# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = { $type } フィールドを削除

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = { $type } フィールドを削除します

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label = { $count ->
    [0]     { $type }
    [one]   { $type } のアドレス 1 件、フォーカスするには左矢印キーを押してください。
    *[other] { $type } のアドレス { $count } 件、フォーカスするには左矢印キーを押してください。
}

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label = { $count ->
    [one]   { $email }: 編集は Enter キー、削除は Delete キーを押してください。
    *[other] { $email }, 1 / { $count }: 編集は Enter キー、削除は Delete キーを押してください。
}

pill-action-edit =
    .label = アドレスを編集
    .accesskey = e

pill-action-move-to =
    .label = To へ移動
    .accesskey = T

pill-action-move-cc =
    .label = Cc へ移動
    .accesskey = C

pill-action-move-bcc =
    .label = Bcc へ移動
    .accesskey = B

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value = 添付ファイル { $count } 個
    .accesskey = m

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext = 添付ファイル { $count } 個

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = 開封確認
    .tooltiptext = このメッセージの開封確認の返送を求めます
