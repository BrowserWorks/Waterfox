# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = ยกเลิกการดาวน์โหลดทั้งหมด?

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] หากคุณออกตอนนี้ 1 การดาวน์โหลดจะถูกยกเลิก คุณแน่ใจหรือไม่ว่าต้องการออก?
       *[other] หากคุณออกตอนนี้ { $downloadsCount } การดาวน์โหลดจะถูกยกเลิก คุณแน่ใจหรือไม่ว่าต้องการออก?
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] หากคุณออกตอนนี้ 1 การดาวน์โหลดจะถูกยกเลิก คุณแน่ใจหรือไม่ว่าต้องการออก?
       *[other] หากคุณออกตอนนี้ { $downloadsCount } การดาวน์โหลดจะถูกยกเลิก คุณแน่ใจหรือไม่ว่าต้องการออก?
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] ไม่ออก
       *[other] ไม่ออก
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] หากคุณออฟไลน์ตอนนี้ 1 การดาวน์โหลดจะถูกยกเลิก คุณแน่ใจหรือไม่ว่าต้องการออฟไลน์?
       *[other] หากคุณออฟไลน์ตอนนี้ { $downloadsCount } การดาวน์โหลดจะถูกยกเลิก คุณแน่ใจหรือไม่ว่าต้องการออฟไลน์?
    }
download-ui-dont-go-offline-button = คงการออนไลน์

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] หากคุณปิดหน้าต่างเรียกดูแบบส่วนตัวทั้งหมดตอนนี้ 1 การดาวน์โหลดจะถูกยกเลิก คุณแน่ใจหรือไม่ว่าต้องการออกจากการเรียกดูแบบส่วนตัว?
       *[other] หากคุณปิดหน้าต่างเรียกดูแบบส่วนตัวทั้งหมดตอนนี้ { $downloadsCount } การดาวน์โหลดจะถูกยกเลิก คุณแน่ใจหรือไม่ว่าต้องการออกจากการเรียกดูแบบส่วนตัว?
    }
download-ui-dont-leave-private-browsing-button = คงอยู่ในการเรียกดูแบบส่วนตัว

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] ยกเลิก 1 การดาวน์โหลด
       *[other] ยกเลิก { $downloadsCount } การดาวน์โหลด
    }

##

download-ui-file-executable-security-warning-title = เปิดไฟล์ปฏิบัติการ?
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = “{ $executable }” เป็นไฟล์ปฏิบัติการ ไฟล์ปฏิบัติการอาจมีไวรัสหรือโค้ดที่ประสงค์ร้ายอื่นที่อาจเป็นอันตรายต่อคอมพิวเตอร์ของคุณ ใช้ความระมัดระวังเมื่อเปิดไฟล์นี้ คุณแน่ใจหรือไม่ว่าต้องการเปิด “{ $executable }”?
