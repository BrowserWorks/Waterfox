# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = รายการปิดกั้น
    .style = width: 55em

blocklist-description = เลือกรายการ { -brand-short-name } เพื่อใช้ในการปิดกั้นตัวติดตามออนไลน์ รายการนี้จัดหาให้โดย  <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = รายการ

blocklist-dialog =
    .buttonlabelaccept = บันทึกการเปลี่ยนแปลง
    .buttonaccesskeyaccept = บ


# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = รายการปิดกั้นระดับ 1 (แนะนำ)
blocklist-item-moz-std-description = อนุญาตตัวติดตามบางตัวเพื่อจะได้มีเว็บที่ใช้งานไม่ได้น้อยลง
blocklist-item-moz-full-listName = รายการปิดกั้นระดับ 2
blocklist-item-moz-full-description = ปิดกั้นตัวติดตามทั้งหมด บางเว็บไซต์หรือเนื้อหาอาจโหลดมาไม่ครบ
