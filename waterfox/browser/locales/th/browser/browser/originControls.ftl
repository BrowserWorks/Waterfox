# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = ส่วนขยายไม่สามารถอ่านและเปลี่ยนแปลงข้อมูลได้
origin-controls-quarantined =
    .label = ส่วนขยายไม่ได้รับอนุญาตให้อ่านและเปลี่ยนแปลงข้อมูล
origin-controls-quarantined-status =
    .label = ไม่อนุญาตให้ใช้ส่วนขยายบนไซต์ที่ถูกจำกัด
origin-controls-quarantined-allow =
    .label = อนุญาตให้ใช้บนไซต์ที่ถูกจำกัด
origin-controls-options =
    .label = ส่วนขยายสามารถอ่านและเปลี่ยนแปลงข้อมูลต่อไปนี้ได้:
origin-controls-option-all-domains =
    .label = บนทุกไซต์
origin-controls-option-when-clicked =
    .label = เมื่อคลิกเท่านั้น
# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = อนุญาตเสมอใน { $domain }

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = ไม่สามารถอ่านและเปลี่ยนแปลงข้อมูลบนไซต์นี้ได้
origin-controls-state-quarantined = ไม่ได้รับอนุญาตโดย { -vendor-short-name } บนไซต์นี้
origin-controls-state-always-on = สามารถอ่านและเปลี่ยนแปลงข้อมูลบนไซต์นี้ได้เสมอ
origin-controls-state-when-clicked = ต้องการสิทธิอนุญาตในการอ่านและเปลี่ยนแปลงข้อมูล
origin-controls-state-hover-run-visit-only = เรียกใช้ตอนเยี่ยมชมครั้งนี้เท่านั้น
origin-controls-state-runnable-hover-open = เปิดส่วนขยาย
origin-controls-state-runnable-hover-run = เรียกใช้ส่วนขยาย
origin-controls-state-temporary-access = สามารถอ่านและเปลี่ยนแปลงข้อมูลเฉพาะตอนเยี่ยมชมครั้งนี้เท่านั้น

## Extension's toolbar button.
## Variables:
##   $extensionTitle (String) - Extension name or title message.

origin-controls-toolbar-button =
    .label = { $extensionTitle }
    .tooltiptext = { $extensionTitle }
# Extension's toolbar button when permission is needed.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-permission-needed =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        ต้องการสิทธิอนุญาต
# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        ไม่ได้รับอนุญาตโดย { -vendor-short-name } บนไซต์นี้
