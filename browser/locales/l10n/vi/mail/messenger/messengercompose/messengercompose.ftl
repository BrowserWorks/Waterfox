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

