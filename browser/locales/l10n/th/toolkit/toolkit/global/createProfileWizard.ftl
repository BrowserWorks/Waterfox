# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = ตัวช่วยสร้างโปรไฟล์
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] หน้าแนะนำ
       *[other] ยินดีต้อนรับสู่ { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } จัดเก็บข้อมูลเกี่ยวกับการตั้งค่าและค่ากำหนดของคุณในโปรไฟล์ส่วนบุคคลของคุณ

profile-creation-explanation-2 = หากคุณกำลังใช้สำเนานี้ของ { -brand-short-name } ร่วมกับผู้ใช้อื่น ๆ คุณสามารถใช้โปรไฟล์เพื่อเก็บข้อมูลของผู้ใช้แต่ละคนแยกกัน เพื่อทำสิ่งนี้ ผู้ใช้แต่ละคนควรสร้างโปรไฟล์ของตนเอง

profile-creation-explanation-3 = หากคุณเป็นเพียงคนเดียวที่ใช้สำเนานี้ของ { -brand-short-name } คุณต้องมีอย่างน้อยหนึ่งโปรไฟล์ หากคุณต้องการ คุณสามารถสร้างโปรไฟล์หลายชุดสำหรับคุณเองเพื่อจัดเก็บชุดของการตั้งค่าและค่ากำหนดที่ต่างกัน ตัวอย่างเช่น คุณอาจต้องการมีโปรไฟล์แยกสำหรับการใช้งานทางธุรกิจและส่วนบุคคล

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] เพื่อเริ่มสร้างโปรไฟล์ของคุณ คลิก ดำเนินการต่อ
       *[other] เพื่อเริ่มสร้างโปรไฟล์ของคุณ คลิก ถัดไป
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] หน้าสรุป
       *[other] เสร็จสิ้นการ { create-profile-window.title }
    }

profile-creation-intro = หากคุณสร้างหลายโปรไฟล์ คุณสามารถแยกแยะโปรไฟล์ได้โดยชื่อโปรไฟล์ คุณอาจใช้ชื่อที่ให้มานี้หรือใช้ชื่อของคุณเอง

profile-prompt = ป้อนชื่อโปรไฟล์ใหม่:
    .accesskey = ป

profile-default-name =
    .value = ผู้ใช้เริ่มต้น

profile-directory-explanation = การตั้งค่า, ค่ากำหนด และข้อมูลผู้ใช้ที่เกี่ยวข้องอื่น ๆ จะถูกจัดเก็บไว้ใน:

create-profile-choose-folder =
    .label = เลือกโฟลเดอร์…
    .accesskey = ล

create-profile-use-default =
    .label = ใช้โฟลเดอร์เริ่มต้น
    .accesskey = ช
