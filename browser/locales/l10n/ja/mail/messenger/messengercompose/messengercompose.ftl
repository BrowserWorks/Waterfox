# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-button =
    .title = { $type } フィールドを削除します
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
#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } は有効なメールアドレスではありません
#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } はアドレス帳に存在しません
pill-action-edit =
    .label = アドレスを編集
    .accesskey = E
pill-action-move-to =
    .label = To へ移動
    .accesskey = T
pill-action-move-cc =
    .label = Cc へ移動
    .accesskey = C
pill-action-move-bcc =
    .label = Bcc へ移動
    .accesskey = B
pill-action-expand-list =
    .label = リストを展開
    .accesskey = x

## Attachment widget

ctrl-cmd-shift-pretty-prefix = {
  PLATFORM() ->
    [macos] ⇧ ⌘{" "}
   *[other] Ctrl+Shift+
}
trigger-attachment-picker-key = A
toggle-attachment-pane-key = M
menuitem-toggle-attachment-pane =
    .label = 添付ペイン
    .accesskey = m
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }
toolbar-button-add-attachment =
    .label = 添付
    .tooltiptext = 添付ファイルを追加します ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })
add-attachment-notification-reminder =
    .label = 添付ファイルを追加...
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
add-attachment-notification-reminder2 =
    .label = 添付ファイルを追加...
    .accesskey = A
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
menuitem-attach-files =
    .label = ファイル...
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
context-menuitem-attach-files =
    .label = ファイルを添付...
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count = 添付ファイル { $count } 個
expand-attachment-pane-tooltip =
    .tooltiptext = 添付ペインを表示します ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
collapse-attachment-pane-tooltip =
    .tooltiptext = 添付ペインを隠します ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
drop-file-label-attachment = 添付に追加する
drop-file-label-inline = インラインに挿入する

## Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = 先頭へ移動
move-attachment-left-panel-button =
    .label = 左へ移動
move-attachment-right-panel-button =
    .label = 右へ移動
move-attachment-last-panel-button =
    .label = 末尾へ移動
button-return-receipt =
    .label = 開封確認
    .tooltiptext = このメッセージの開封確認の返送を求めます
# Encryption
message-to-be-signed-icon =
    .alt = メッセージに署名
message-to-be-encrypted-icon =
    .alt = メッセージを暗号化

## Addressing Area

to-compose-address-row-label =
    .value = 宛先
#   $key (String) - the shortcut key for this field
to-compose-show-address-row-menuitem =
    .label = { to-compose-address-row-label.value } フィールド
    .accesskey = T
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
to-compose-show-address-row-label =
    .value = { to-compose-address-row-label.value }
    .tooltiptext = { to-compose-address-row-label.value } フィールドを表示します ({ to-compose-show-address-row-menuitem.acceltext })
cc-compose-address-row-label =
    .value = Cc
#   $key (String) - the shortcut key for this field
cc-compose-show-address-row-menuitem =
    .label = { cc-compose-address-row-label.value } フィールド
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
cc-compose-show-address-row-label =
    .value = { cc-compose-address-row-label.value }
    .tooltiptext = { cc-compose-address-row-label.value } フィールドを表示します ({ cc-compose-show-address-row-menuitem.acceltext })
bcc-compose-address-row-label =
    .value = Bcc
#   $key (String) - the shortcut key for this field
bcc-compose-show-address-row-menuitem =
    .label = { bcc-compose-address-row-label.value } フィールド
    .accesskey = B
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
bcc-compose-show-address-row-label =
    .value = { bcc-compose-address-row-label.value }
    .tooltiptext = { bcc-compose-address-row-label.value } フィールドを表示します ({ bcc-compose-show-address-row-menuitem.acceltext })
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-info = 宛先および Cc フィールドの {$count} 件の受信者は互いのアドレスを見られます。代わりに Bcc フィールドを使用すると受信者アドレスの開示を避けられます。
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
to-address-row-label =
    .value = 宛先
#   $key (String) - the shortcut key for this field
show-to-row-main-menuitem =
    .label = 宛先フィールド
    .accesskey = T
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-to-row-button text.
show-to-row-extra-menuitem =
    .label = 宛先
    .accesskey = T
#   $key (String) - the shortcut key for this field
show-to-row-button = 宛先
    .title = 宛先フィールドを表示します ({ ctrl-cmd-shift-pretty-prefix }{ $key })
cc-address-row-label =
    .value = Cc
#   $key (String) - the shortcut key for this field
show-cc-row-main-menuitem =
    .label = Cc フィールド
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-cc-row-button text.
show-cc-row-extra-menuitem =
    .label = Cc
    .accesskey = C
#   $key (String) - the shortcut key for this field
show-cc-row-button = Cc
    .title = Cc フィールドを表示します ({ ctrl-cmd-shift-pretty-prefix }{ $key })
bcc-address-row-label =
    .value = Bcc
#   $key (String) - the shortcut key for this field
show-bcc-row-main-menuitem =
    .label = Bcc フィールド
    .accesskey = B
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-bcc-row-button text.
show-bcc-row-extra-menuitem =
    .label = Bcc
    .accesskey = B
#   $key (String) - the shortcut key for this field
show-bcc-row-button = Bcc
    .title = Bcc フィールドを表示します ({ ctrl-cmd-shift-pretty-prefix }{ $key })
extra-address-rows-menu-button =
    .title = 他のアドレス入力フィールドを表示します
many-public-recipients-notice = { $count ->
    [one] あなたのメッセージの受信者は開示されています。代わりに Bcc フィールドを使用すると受信者アドレスの開示を避けられます。
    *[other] 宛先および Cc フィールドの {$count} 件の受信者アドレスは開示されており、受信者が互いにこれらのアドレスを見られます。代わりに Bcc フィールドを使用すると受信者アドレスの開示を避けられます。
}
many-public-recipients-bcc =
    .label = 代わりに Bcc を使用する
    .accesskey = U
many-public-recipients-ignore =
    .label = 受信者を開示したままにする
    .accesskey  = K
many-public-recipients-prompt-title = 開示された受信者が多すぎます
#   $count (Number) - the count of addresses in the public recipients fields.
many-public-recipients-prompt-msg = { $count ->
    [one] あなたのメッセージの受信者は開示されており、プライバシー上の懸念が生じる可能性があります。受信者を宛先または Cc フィールドから Bcc フィールドへ移動することで受信者アドレスの開示を避けられます。
    *[other] あなたのメッセージは {$count} 件の受信者が開示されており、受信者が互いにこれらのアドレスを見られるため、プライバシー上の懸念が生じる可能性があります。受信者を宛先または Cc フィールドから Bcc フィールドへ移動することで受信者アドレスの開示を避けられます。
}
many-public-recipients-prompt-cancel = 送信をキャンセル
many-public-recipients-prompt-send = 強制送信

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = 差出人アドレスと一致する一意の ID が見つかりませんでした。メッセージは現在の差出人フィールドと { $identity } の差出人情報の設定を使用して送信されます。
encrypted-bcc-warning = 暗号化したメッセージの送信する場合、Bcc の受信者は完全に秘匿されません。すべての受信者が Bcc の受信者を認識できます。
encrypted-bcc-ignore-button = 了解

## Editing

# Tools

compose-tool-button-remove-text-styling =
    .tooltiptext = テキストのスタイル付けを削除します
