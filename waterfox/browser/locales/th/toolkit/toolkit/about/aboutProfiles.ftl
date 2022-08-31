# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = เกี่ยวกับโปรไฟล์
profiles-subtitle = หน้านี้ช่วยให้คุณจัดการโปรไฟล์ของคุณ แต่ละโปรไฟล์นั้นเป็นโลกที่แบ่งแยกออกจากกันซึ่งมีประวัติ, ที่คั่นหน้า, การตั้งค่า และส่วนเสริมที่แยกกัน
profiles-create = สร้างโปรไฟล์ใหม่
profiles-restart-title = เริ่มการทำงานใหม่
profiles-restart-in-safe-mode = เริ่มการทำงานใหม่พร้อมปิดใช้งานส่วนเสริม…
profiles-restart-normal = เริ่มการทำงานใหม่ปกติ…
profiles-conflict = สำเนาอื่นของ { -brand-product-name } ได้ทำการเปลี่ยนแปลงกับโปรไฟล์ คุณต้องเริ่มการทำงาน { -brand-short-name } ใหม่ก่อนจึงจะสามารถทำการเปลี่ยนแปลงเพิ่มเติมได้
profiles-flush-fail-title = ไม่ได้บันทึกการเปลี่ยนแปลง
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = ข้อผิดพลาดที่ไม่คาดคิดได้ขัดขวางการบันทึกการเปลี่ยนแปลงของคุณ
profiles-flush-restart-button = เริ่มการทำงาน { -brand-short-name } ใหม่

# Variables:
#   $name (String) - Name of the profile
profiles-name = โปรไฟล์: { $name }
profiles-is-default = โปรไฟล์เริ่มต้น
profiles-rootdir = ไดเรกทอรีราก

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = ไดเรกทอรีในเครื่อง
profiles-current-profile = นี่เป็นโปรไฟล์ที่ใช้งานอยู่และไม่สามารถลบได้
profiles-in-use-profile = โปรไฟล์นี้ถูกใช้งานในแอปพลิเคชันอื่นและไม่สามารถลบได้

profiles-rename = เปลี่ยนชื่อ
profiles-remove = เอาออก
profiles-set-as-default = ตั้งเป็นโปรไฟล์เริ่มต้น
profiles-launch-profile = เปิดโปรไฟล์ในเบราว์เซอร์ใหม่

profiles-cannot-set-as-default-title = ไม่สามารถตั้งค่าเริ่มต้น
profiles-cannot-set-as-default-message = ไม่สามารถเปลี่ยนแปลงโปรไฟล์เริ่มต้นสำหรับ { -brand-short-name }

profiles-yes = ใช่
profiles-no = ไม่

profiles-rename-profile-title = เปลี่ยนชื่อโปรไฟล์
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = เปลี่ยนชื่อโปรไฟล์ { $name }

profiles-invalid-profile-name-title = ชื่อโปรไฟล์ไม่ถูกต้อง
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = ไม่อนุญาตให้ใช้ชื่อโปรไฟล์ “{ $name }”

profiles-delete-profile-title = ลบโปรไฟล์
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    การลบโปรไฟล์จะเอาโปรไฟล์ออกจากรายการโปรไฟล์ที่มีและไม่สามารถเลิกทำได้
    คุณยังอาจเลือกที่จะลบไฟล์ข้อมูลของโปรไฟล์ รวมไปถึงการตั้งค่า, ใบรับรอง และข้อมูลที่เกี่ยวข้องกับผู้ใช้ ตัวเลือกนี้จะลบโฟลเดอร์ “{ $dir }” และไม่สามารถเลิกทำได้
    คุณต้องการลบไฟล์ข้อมูลของโปรไฟล์หรือไม่?
profiles-delete-files = ลบไฟล์
profiles-dont-delete-files = ไม่ลบไฟล์

profiles-delete-profile-failed-title = ข้อผิดพลาด
profiles-delete-profile-failed-message = เกิดข้อผิดพลาดขณะพยายามลบโปรไฟล์นี้


profiles-opendir =
    { PLATFORM() ->
        [macos] แสดงใน Finder
        [windows] เปิดโฟลเดอร์
       *[other] เปิดไดเรกทอรี
    }
