# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = สี
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = ข้อความและพื้นหลัง

text-color-label =
    .value = ข้อความ:
    .accesskey = ข

background-color-label =
    .value = พื้นหลัง:
    .accesskey = พ

use-system-colors =
    .label = ใช้สีของระบบ
    .accesskey = ช

colors-link-legend = สีลิงก์

link-color-label =
    .value = ลิงก์ที่ยังไม่เคยเยี่ยมชม:
    .accesskey = ย

visited-link-color-label =
    .value = ลิงก์ที่เยี่ยมชมแล้ว:
    .accesskey = ล

underline-link-checkbox =
    .label = ขีดเส้นใต้ลิงก์
    .accesskey = ด

override-color-label =
    .value = เขียนทับสีที่ระบุโดยเนื้อหาด้วยที่ฉันเลือกไว้ด้านบน:
    .accesskey = ข

override-color-always =
    .label = เสมอ

override-color-auto =
    .label = เฉพาะกับชุดตกแต่งความคมชัดสูงเท่านั้น

override-color-never =
    .label = ไม่เลย
