# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Send Format

# Addressing widget

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

#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } ไม่ใช่ที่อยู่อีเมลที่ถูกต้อง

#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } ไม่อยู่ในสมุดรายชื่อของคุณ

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

# Attachment widget

# Reorder Attachment Panel

button-return-receipt =
    .label = การแจ้งเตือน
    .tooltiptext = จำเป็นต้องมีการแจ้งเตือนการเปิดอ่านสำหรับข้อความนี้

# Encryption

# Addressing Area


## Notifications

## Editing

# Tools

## Filelink

# Placeholder file

# Template

# Messages

## Link Preview

## Dictionary selection popup

