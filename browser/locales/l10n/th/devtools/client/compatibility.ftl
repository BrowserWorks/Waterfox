# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = องค์ประกอบที่ถูกเลือก
compatibility-all-elements-header = ปัญหาทั้งหมด

## Message used as labels for the type of issue

compatibility-issue-deprecated = (เลิกใช้)
compatibility-issue-experimental = (ทดลอง)
compatibility-issue-prefixneeded = (จำเป็นต้องใส่คำนำหน้า)
compatibility-issue-deprecated-experimental = (เลิกใช้, ทดลอง)

compatibility-issue-deprecated-prefixneeded = (เลิกใช้แล้ว และจำเป็นต้องใส่คำนำหน้า)
compatibility-issue-experimental-prefixneeded = (เป็นคุณลักษณะทดลอง และจำเป็นต้องใส่คำนำหน้า)
compatibility-issue-deprecated-experimental-prefixneeded = (เลิกใช้แล้ว เป็นคุณลักษณะทดลอง และจำเป็นต้องใส่คำนำหน้า)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = การตั้งค่า
compatibility-settings-button-title =
    .title = การตั้งค่า
compatibility-feedback-button-label = ข้อเสนอแนะ
compatibility-feedback-button-title =
    .title = ข้อเสนอแนะ

## Messages used as headers in settings pane

compatibility-settings-header = การตั้งค่า
compatibility-target-browsers-header = เบราว์เซอร์เป้าหมาย

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
       *[other] { $number } ครั้งที่ปรากฏ
    }

compatibility-no-issues-found = ไม่พบปัญหาความเข้ากันได้
compatibility-close-settings-button =
    .title = ปิดการตั้งค่า
