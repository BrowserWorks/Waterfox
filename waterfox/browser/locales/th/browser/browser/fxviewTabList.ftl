# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

fxviewtabrow-open-menu-button =
    .title = เปิดเมนู
# Variables:
#   $date (string) - Date to be formatted based on locale
fxviewtabrow-date = { DATETIME($date, dateStyle: "short") }
# Variables:
#   $time (string) - Time to be formatted based on locale
fxviewtabrow-time = { DATETIME($time, timeStyle: "short") }
# Variables:
#   $targetURI (string) - URL of tab that will be opened in the new tab
fxviewtabrow-tabs-list-tab =
    .title = เปิด { $targetURI } ในแท็บใหม่
# Variables:
#   $tabTitle (string) - Title of tab being dismissed
fxviewtabrow-dismiss-tab-button =
    .title = ปิด { $tabTitle }
# Used instead of the localized relative time when a timestamp is within a minute or so of now
fxviewtabrow-just-now-timestamp = เมื่อกี้นี้

# Strings below are used for context menu options within panel-list.
# For developers, this duplicates command because the label attribute is required.

fxviewtabrow-delete = ลบ
    .accesskey = ล
fxviewtabrow-forget-about-this-site = ลืมเกี่ยวกับไซต์นี้…
    .accesskey = ม
fxviewtabrow-open-in-window = เปิดในหน้าต่างใหม่
    .accesskey = ใ
fxviewtabrow-open-in-private-window = เปิดในหน้าต่างส่วนตัวใหม่
    .accesskey = ส
# “Bookmark” is a verb, as in "Bookmark this page" (add to bookmarks).
fxviewtabrow-add-bookmark = เพิ่มที่คั่นหน้า…
    .accesskey = ท
fxviewtabrow-save-to-pocket = บันทึกไปยัง { -pocket-brand-name }
    .accesskey = บ
fxviewtabrow-copy-link = คัดลอกลิงก์
    .accesskey = ง
fxviewtabrow-close-tab = ปิดแท็บ
    .accesskey = C
# Variables:
#   $tabTitle (string) - Title of the tab to which the context menu is associated
fxviewtabrow-options-menu-button =
    .title = ตัวเลือกสำหรับ { $tabTitle }
