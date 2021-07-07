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
remove-address-row-button =
    .title = 移除 { $type } 欄位
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
#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } 不是有效的電子郵件地址
#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } 不在您的通訊錄中
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
pill-action-expand-list =
    .label = 展開清單
    .accesskey = x

# Attachment widget

ctrl-cmd-shift-pretty-prefix =
    { PLATFORM() ->
        [macos] ⇧ ⌘{ " " }
       *[other] Ctrl+Shift+
    }
trigger-attachment-picker-key = A
toggle-attachment-pane-key = M
menuitem-toggle-attachment-pane =
    .label = 附件窗格
    .accesskey = m
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }
toolbar-button-add-attachment =
    .label = 附件
    .tooltiptext = 新增附件（{ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }）
add-attachment-notification-reminder =
    .label = 新增附件…
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
menuitem-attach-files =
    .label = 檔案…
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
context-menuitem-attach-files =
    .label = 附加檔案…
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
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
expand-attachment-pane-tooltip =
    .tooltiptext = 顯示附件窗格（{ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }）
collapse-attachment-pane-tooltip =
    .tooltiptext = 隱藏附件窗格（{ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }）
drop-file-label-attachment =
    { $count ->
       *[other] 新增為附件
    }
drop-file-label-inline =
    { $count ->
       *[other] 加到行內
    }

# Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = 移到第一個
move-attachment-left-panel-button =
    .label = 移到左邊
move-attachment-right-panel-button =
    .label = 移到右邊
move-attachment-last-panel-button =
    .label = 移到最後一個
button-return-receipt =
    .label = 收件回執
    .tooltiptext = 要求對方收信後寄發回執

# Addressing Area

to-compose-address-row-label =
    .value = 給
#   $key (String) - the shortcut key for this field
to-compose-show-address-row-menuitem =
    .label = 「{ to-compose-address-row-label.value }」欄位
    .accesskey = T
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
to-compose-show-address-row-label =
    .value = { to-compose-address-row-label.value }
    .tooltiptext = 顯示「{ to-compose-address-row-label.value }」欄位（{ to-compose-show-address-row-menuitem.acceltext }）
cc-compose-address-row-label =
    .value = 副本
#   $key (String) - the shortcut key for this field
cc-compose-show-address-row-menuitem =
    .label = 「{ cc-compose-address-row-label.value }」欄位
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
cc-compose-show-address-row-label =
    .value = { cc-compose-address-row-label.value }
    .tooltiptext = 顯示「{ cc-compose-address-row-label.value }」欄位（{ cc-compose-show-address-row-menuitem.acceltext }）
bcc-compose-address-row-label =
    .value = 密件副本
#   $key (String) - the shortcut key for this field
bcc-compose-show-address-row-menuitem =
    .label = 「{ bcc-compose-address-row-label.value }」欄位
    .accesskey = B
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
bcc-compose-show-address-row-label =
    .value = { bcc-compose-address-row-label.value }
    .tooltiptext = 顯示「{ bcc-compose-address-row-label.value }」欄位（{ bcc-compose-show-address-row-menuitem.acceltext }）
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-info = 「給」與「副本」收件者共有 { $count } 位，都可看到彼此的收件信箱。您可以改用「密件副本」來避免揭露收件者資訊。
many-public-recipients-bcc =
    .label = 改為密件副本收件者
    .accesskey = U
many-public-recipients-ignore =
    .label = 保持收件者名單公開
    .accesskey = K

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = 找不到寄件地址對應的唯一識別資料。將使用目前的寄件者欄位資料，以及 { $identity } 身份的設定來寄信。
encrypted-bcc-warning = 寄出加密郵件時，不會完全隱藏密件副本收件者。所有的收件者都可能識別出他們。
encrypted-bcc-ignore-button = 知道了！
