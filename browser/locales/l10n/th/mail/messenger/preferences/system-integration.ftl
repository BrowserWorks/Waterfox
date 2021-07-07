# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = การผนวกรวมระบบ

system-integration-dialog =
    .buttonlabelaccept = ตั้งเป็นค่าเริ่มต้น
    .buttonlabelcancel = ข้ามการผนวกรวม
    .buttonlabelcancel2 = ยกเลิก

default-client-intro = ใช้ { -brand-short-name } เป็นไคลเอนต์เริ่มต้นสำหรับ:

unset-default-tooltip = ไม่สามารถเลิกตั้ง { -brand-short-name } เป็นไคลเอนต์เริ่มต้นภายใน { -brand-short-name } เมื่อต้องการทำให้แอปพลิเคชันอื่นเป็นค่าเริ่มต้น คุณต้องใช้กล่องโต้ตอบ 'ตั้งเป็นค่าเริ่มต้น'

checkbox-email-label =
    .label = อีเมล
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = กลุ่มข่าว
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = ฟีด
    .tooltiptext = { unset-default-tooltip }

checkbox-calendar-label =
    .label = ปฏิทิน
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }

system-search-integration-label =
    .label = อนุญาตให้ { system-search-engine-name } ค้นหาข้อความ
    .accesskey = อ

check-on-startup-label =
    .label = ตรวจสอบเช่นนี้เสมอเมื่อเริ่ม { -brand-short-name }
    .accesskey = ต
