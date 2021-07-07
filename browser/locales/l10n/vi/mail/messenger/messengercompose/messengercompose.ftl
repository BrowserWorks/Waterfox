# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Xóa trường { $type }
#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Xóa trường { $type }
#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
       *[other] { $type } với { $count } địa chỉ, sử dụng phím mũi tên trái để chọn chúng.
    }
#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
       *[other] { $email }, 1 của { $count }: nhấn Enter để chỉnh sửa, Delete để xóa.
    }
#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } không phải là địa chỉ e-mail hợp lệ
#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } không có trong sổ địa chỉ của bạn
pill-action-edit =
    .label = Chỉnh sửa địa chỉ
    .accesskey = e
pill-action-move-to =
    .label = Chuyển sang Đến
    .accesskey = t
pill-action-move-cc =
    .label = Chuyển sang Cc
    .accesskey = c
pill-action-move-bcc =
    .label = Chuyển sang Bcc
    .accesskey = b

# Attachment widget

ctrl-cmd-shift-pretty-prefix =
    { PLATFORM() ->
        [macos] ⇧ ⌘{ " " }
       *[other] Ctrl+Shift+
    }
trigger-attachment-picker-key = A
toggle-attachment-pane-key = M
menuitem-toggle-attachment-pane =
    .label = Ngăn đính kèm
    .accesskey = m
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }
toolbar-button-add-attachment =
    .label = Đính kèm
    .tooltiptext = Thêm một đính kèm ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })
add-attachment-notification-reminder =
    .label = Thêm đính kèm…
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
menuitem-attach-files =
    .label = Tập tin…
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
context-menuitem-attach-files =
    .label = Đính kèm tập tin…
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } đính kèm
           *[other] { $count } đính kèm
        }
    .accesskey = m
#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } đính kèm
           *[other] { $count } đính kèm
        }
#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }
expand-attachment-pane-tooltip =
    .tooltiptext = Hiển thị ngăn đính kèm ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
collapse-attachment-pane-tooltip =
    .tooltiptext = Ẩn ngăn đính kèm ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
drop-file-label-attachment =
    { $count ->
       *[other] Thêm dưới dạng đính kèm
    }

# Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = Di chuyển lên đầu
move-attachment-left-panel-button =
    .label = Di chuyển sang trái
move-attachment-right-panel-button =
    .label = Di chuyển sang phải
move-attachment-last-panel-button =
    .label = Di chuyển xuống cuối
button-return-receipt =
    .label = Biên nhận
    .tooltiptext = Yêu cầu biên nhận trả lại cho thư này
