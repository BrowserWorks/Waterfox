# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = การเลิกโหลดแท็บ
about-unloads-intro =
    { -brand-short-name } มีคุณลักษณะที่สามารถเลิกโหลดแท็บโดยอัตโนมัติ
    เพื่อไม่ให้แอปพลิเคชันขัดข้องเมื่อหน่วยความจำที่พร้อมใช้งานของระบบไม่เพียงพอ
    แอปพลิเคชันจะเลือกแท็บถัดไปที่จะเลิกโหลดตามแอตทริบิวต์หลายอย่าง
    หน้านี้แสดงวิธีที่ { -brand-short-name } จัดลำดับความสำคัญของแท็บต่าง ๆ
    และแท็บที่จะเลิกโหลดเมื่อมีการทริกเกอร์การเลิกโหลดแท็บ คุณสามารถทริกเกอร์
    การเลิกโหลดแท็บได้ด้วยตนเองโดยคลิกปุ่ม <em>เลิกโหลด</em> ด้านล่าง

# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more =
    ดูที่ <a data-l10n-name="doc-link">Tab Unloading</a> เพื่อเรียนรู้เพิ่มเติม
    เกี่ยวกับคุณลักษณะและหน้านี้

about-unloads-last-updated = วันที่อัปเดตล่าสุด: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = เลิกโหลด
    .title = เลิกโหลดแท็บที่มีลำดับความสำคัญสูงที่สุด
about-unloads-no-unloadable-tab = ไม่มีแท็บที่สามารถเลิกโหลดได้

about-unloads-column-priority = ความสำคัญ
about-unloads-column-host = โฮสต์
about-unloads-column-last-accessed = เข้าถึงล่าสุด
about-unloads-column-weight = น้ำหนักฐาน
    .title = แท็บจะถูกเรียงลำดับตามค่านี้ก่อน ซึ่งมาจากแอตทริบิวต์พิเศษบางอย่าง เช่น การเล่นเสียง, WebRTC, และอื่น ๆ
about-unloads-column-sortweight = น้ำหนักรอง
    .title = หากพร้อมใช้งาน แท็บจะถูกเรียงลำดับตามค่านี้หลังจากที่เรียงลำดับตามน้ำหนักฐานแล้ว ค่านี้มาจากการใช้หน่วยความจำของแท็บและจำนวนกระบวนการ
about-unloads-column-memory = หน่วยความจำ
    .title = การใช้หน่วยความจำโดยประมาณของแท็บ
about-unloads-column-processes = ID กระบวนการ
    .title = ID ของกระบวนการที่โฮสต์เนื้อหาของแท็บ

about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
