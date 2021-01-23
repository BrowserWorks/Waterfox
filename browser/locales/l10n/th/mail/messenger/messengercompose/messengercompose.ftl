# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = เอาช่อง { $type } ออก

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = เอาช่อง { $type } ออก

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
       *[other] { $type } มี { $count } ที่อยู่ ใช้แป้นลูกศรเพื่อเลือก
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
       *[other] { $email } มี 1 จาก { $count }: กด Enter เพื่อแก้ไข กด Delete เพื่อเอาออก
    }

pill-action-edit =
    .label = แก้ไขที่อยู่
    .accesskey = อ

pill-action-move-to =
    .label = ย้ายไปยัง ถึง
    .accesskey = ป

pill-action-move-cc =
    .label = ย้ายไปยัง สำเนาถึง
    .accesskey = ถ

pill-action-move-bcc =
    .label = ย้ายไปยัง สำเนาลับถึง
    .accesskey = ล

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } สิ่งที่แนบมา
           *[other] { $count } สิ่งที่แนบมา
        }
    .accesskey = น

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } สิ่งที่แนบมา
           *[other] { $count } สิ่งที่แนบมา
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = การแจ้งเตือน
    .tooltiptext = จำเป็นต้องมีการแจ้งเตือนการเปิดอ่านสำหรับข้อความนี้
