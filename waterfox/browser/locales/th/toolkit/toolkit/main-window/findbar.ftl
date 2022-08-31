# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = หาตำแหน่งถัดไปของวลี
findbar-previous =
    .tooltiptext = หาตำแหน่งก่อนหน้าของวลี

findbar-find-button-close =
    .tooltiptext = ปิดแถบค้นหา

findbar-highlight-all2 =
    .label = เน้นสีทั้งหมด
    .accesskey =
        { PLATFORM() ->
            [macos] l
           *[other] น
        }
    .tooltiptext = เน้นสีวลีที่พบทั้งหมด

findbar-case-sensitive =
    .label = ตัวพิมพ์ใหญ่เล็กตรงกัน
    .accesskey = ว
    .tooltiptext = ค้นหาโดยคำนึงถึงตัวพิมพ์ใหญ่เล็ก

findbar-match-diacritics =
    .label = เครื่องหมายกำกับการออกเสียงตรงกัน
    .accesskey = i
    .tooltiptext = แยกระหว่างตัวอักษรที่มีตัวเน้นเสียงและตัวอักษรฐาน (เช่น เมื่อค้นหาคำว่า “resume” ก็จะไม่ตรงกับคำว่า “résumé”)

findbar-entire-word =
    .label = ทั้งคำ
    .accesskey = ท
    .tooltiptext = ค้นหาทั้งคำเท่านั้น
