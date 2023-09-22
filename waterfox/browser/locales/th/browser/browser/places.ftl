# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = เปิด
    .accesskey = ป
places-open-in-tab =
    .label = เปิดในแท็บใหม่
    .accesskey = ใ
places-open-in-container-tab =
    .label = เปิดในแท็บแยกข้อมูลใหม่
    .accesskey = ย
places-open-all-bookmarks =
    .label = เปิดที่คั่นหน้าทั้งหมด
    .accesskey = ป
places-open-all-in-tabs =
    .label = เปิดทั้งหมดในแท็บ
    .accesskey = ป
places-open-in-window =
    .label = เปิดในหน้าต่างใหม่
    .accesskey = ห
places-open-in-private-window =
    .label = เปิดในหน้าต่างส่วนตัวใหม่
    .accesskey = ส

places-empty-bookmarks-folder =
    .label = (ว่าง)

places-add-bookmark =
    .label = เพิ่มที่คั่นหน้า…
    .accesskey = ท
places-add-folder-contextmenu =
    .label = เพิ่มโฟลเดอร์…
    .accesskey = ฟ
places-add-folder =
    .label = เพิ่มโฟลเดอร์…
    .accesskey = ล
places-add-separator =
    .label = เพิ่มตัวแบ่ง
    .accesskey = ต

places-view =
    .label = มุมมอง
    .accesskey = ม
places-by-date =
    .label = ตามวันที่
    .accesskey = ว
places-by-site =
    .label = ตามไซต์
    .accesskey = ม
places-by-most-visited =
    .label = ตามที่เยี่ยมชมมากที่สุด
    .accesskey = ท
places-by-last-visited =
    .label = ตามวันที่เยี่ยมชมล่าสุด
    .accesskey = ย
places-by-day-and-site =
    .label = ตามวันที่และไซต์
    .accesskey = ต

places-history-search =
    .placeholder = ค้นหาประวัติ
places-history =
    .aria-label = ประวัติ
places-bookmarks-search =
    .placeholder = ค้นหาที่คั่นหน้า

places-delete-domain-data =
    .label = ลืมเกี่ยวกับไซต์นี้
    .accesskey = ม
places-sortby-name =
    .label = เรียงตามชื่อ
    .accesskey = ร
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = แก้ไขที่คั่นหน้า…
    .accesskey = i
places-edit-generic =
    .label = แก้ไข…
    .accesskey = i
places-edit-folder2 =
    .label = แก้ไขโฟลเดอร์
    .accesskey = i
places-delete-folder =
    .label =
        { $count ->
            [1] ลบโฟลเดอร์
           *[other] ลบโฟลเดอร์
        }
    .accesskey = ล
# Variables:
#   $count (number) - The number of pages selected for removal.
places-delete-page =
    .label =
        { $count ->
            [1] ลบหน้า
           *[other] ลบหน้า
        }
    .accesskey = ล

# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = ที่คั่นหน้าที่ถูกจัดการ
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = โฟลเดอร์ย่อย

# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = ที่คั่นหน้าอื่น ๆ

places-show-in-folder =
    .label = แสดงในโฟลเดอร์
    .accesskey = ฟ

# Variables:
# $count (number) - The number of elements being selected for removal.
places-delete-bookmark =
    .label =
        { $count ->
            [1] ลบที่คั่นหน้า
           *[other] ลบที่คั่นหน้า
        }
    .accesskey = ล

# Variables:
#   $count (number) - The number of bookmarks being added.
places-create-bookmark =
    .label =
        { $count ->
            [1] เพิ่มที่คั่นหน้าสำหรับหน้า…
           *[other] เพิ่มที่คั่นหน้าสำหรับหน้า…
        }
    .accesskey = ท

places-untag-bookmark =
    .label = เอาแท็กออก
    .accesskey = อ

places-manage-bookmarks =
    .label = จัดการที่คั่นหน้า
    .accesskey = M

places-forget-about-this-site-confirmation-title = ลืมเกี่ยวกับไซต์นี้

# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-msg = การดำเนินการนี้จะลบข้อมูลที่เกี่ยวข้องกับ { $hostOrBaseDomain } รวมถึงประวัติ คุกกี้ แคช และการกำหนดลักษณะเนื้อหา ที่คั่นหน้าและรหัสผ่านที่เกี่ยวข้องจะไม่ถูกลบ คุณแน่ใจหรือไม่ว่าต้องการดำเนินการต่อ

places-forget-about-this-site-forget = ลืม

places-library3 =
    .title = ห้องสมุด

places-organize-button =
    .label = จัดระเบียบ
    .tooltiptext = จัดระเบียบที่คั่นหน้าของคุณ
    .accesskey = จ

places-organize-button-mac =
    .label = จัดระเบียบ
    .tooltiptext = จัดระเบียบที่คั่นหน้าของคุณ

places-file-close =
    .label = ปิด
    .accesskey = ป

places-cmd-close =
    .key = w

places-view-button =
    .label = มุมมอง
    .tooltiptext = เปลี่ยนมุมมองของคุณ
    .accesskey = ม

places-view-button-mac =
    .label = มุมมอง
    .tooltiptext = เปลี่ยนมุมมองของคุณ

places-view-menu-columns =
    .label = แสดงคอลัมน์
    .accesskey = ส

places-view-menu-sort =
    .label = เรียง
    .accesskey = ร

places-view-sort-unsorted =
    .label = ไม่เรียง
    .accesskey = ม

places-view-sort-ascending =
    .label = เรียงลำดับ A > Z
    .accesskey = A

places-view-sort-descending =
    .label = เรียงลำดับ Z > A
    .accesskey = Z

places-maintenance-button =
    .label = นำเข้าและสำรองข้อมูล
    .tooltiptext = นำเข้าและสำรองที่คั่นหน้าของคุณ
    .accesskey = น

places-maintenance-button-mac =
    .label = นำเข้าและสำรองข้อมูล
    .tooltiptext = นำเข้าและสำรองที่คั่นหน้าของคุณ

places-cmd-backup =
    .label = สำรองข้อมูล…
    .accesskey = ง

places-cmd-restore =
    .label = เรียกคืน
    .accesskey = ร

places-cmd-restore-from-file =
    .label = เลือกไฟล์…
    .accesskey = ล

places-import-bookmarks-from-html =
    .label = นำเข้าที่คั่นหน้าจาก HTML…
    .accesskey = น

places-export-bookmarks-to-html =
    .label = ส่งออกที่คั่นหน้าเป็น HTML…
    .accesskey = ส

places-import-other-browser =
    .label = นำเข้าข้อมูลจากเบราว์เซอร์อื่น…
    .accesskey = อ

places-view-sort-col-name =
    .label = ชื่อ

places-view-sort-col-tags =
    .label = แท็ก

places-view-sort-col-url =
    .label = ตำแหน่งที่ตั้ง

places-view-sort-col-most-recent-visit =
    .label = วันที่เยี่ยมชมล่าสุด

places-view-sort-col-visit-count =
    .label = จำนวนการเข้าชม

places-view-sort-col-date-added =
    .label = วันที่เพิ่ม

places-view-sort-col-last-modified =
    .label = วันที่เปลี่ยนแปลงล่าสุด

places-view-sortby-name =
    .label = เรียงตามชื่อ
    .accesskey = ร
places-view-sortby-url =
    .label = เรียงตามตำแหน่งที่ตั้ง
    .accesskey = ง
places-view-sortby-date =
    .label = เรียงตามวันที่เยี่ยมชมล่าสุด
    .accesskey = ต
places-view-sortby-visit-count =
    .label = เรียงตามจำนวนการเข้าชม
    .accesskey = ม
places-view-sortby-date-added =
    .label = เรียงตามวันที่เพิ่ม
    .accesskey = ว
places-view-sortby-last-modified =
    .label = เรียงตามวันที่เปลี่ยนแปลงล่าสุด
    .accesskey = น
places-view-sortby-tags =
    .label = เรียงตามป้ายกำกับ
    .accesskey = ย

places-cmd-find-key =
    .key = f

places-back-button =
    .tooltiptext = ย้อนกลับ

places-forward-button =
    .tooltiptext = เดินหน้า

places-details-pane-select-an-item-description = เลือกรายการเพื่อดูและแก้ไขคุณสมบัติ

places-details-pane-no-items =
    .value = ไม่มีรายการ
# Variables:
#   $count (Number): number of items
places-details-pane-items-count =
    .value = { $count } รายการ

## Strings used as a placeholder in the Library search field. For example,
## "Search History" stands for "Search through the browser's history".

places-search-bookmarks =
    .placeholder = ค้นหาที่คั่นหน้า
places-search-history =
    .placeholder = ค้นหาประวัติ
places-search-downloads =
    .placeholder = ค้นหาการดาวน์โหลด

##

places-locked-prompt = ระบบที่คั่นหน้าและประวัติจะไม่ทำงานเนื่องจากหนึ่งในไฟล์ของ { -brand-short-name } มีการใช้งานโดยแอปพลิเคชันอื่น ซอฟต์แวร์ความปลอดภัยบางตัวสามารถก่อให้เกิดปัญหานี้
