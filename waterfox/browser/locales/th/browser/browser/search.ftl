# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = การติดตั้งผิดพลาด
opensearch-error-duplicate-desc = { -brand-short-name } ไม่สามารถติดตั้งส่วนเสริมการค้นหาจาก “{ $location-url }” เพราะมีเครื่องมือค้นหาที่ใช้ชื่อเดียวกันอยู่แล้ว

opensearch-error-format-title = รูปแบบผิดพลาด
opensearch-error-format-desc = { -brand-short-name } ไม่สามารถติดตั้งเครื่องค้นหาจาก: { $location-url }

opensearch-error-download-title = ข้อผิดพลาดการดาวน์โหลด
opensearch-error-download-desc = { -brand-short-name } ไม่สามารถดาวน์โหลดส่วนเสริมการค้นหาจาก: { $location-url }

##

searchbar-submit =
    .tooltiptext = ค้นหา

# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = ค้นหา

searchbar-icon =
    .tooltiptext = ค้นหา

## Infobar shown when search engine is removed and replaced.
## Variables
## $oldEngine (String) - the search engine to be removed.
## $newEngine (String) - the search engine to replace the removed search engine.

removed-search-engine-message = <strong>เครื่องมือค้นหาเริ่มต้นของคุณได้ถูกเปลี่ยนแล้ว</strong> เนื่องจากใน { -brand-short-name } ไม่มี { $oldEngine } ให้ใช้เป็นเครื่องมือค้นหาเริ่มต้นอีกต่อไป ขณะนี้ { $newEngine } คือเครื่องมือค้นหาเริ่มต้นของคุณ เมื่อต้องการเปลี่ยนเป็นเครื่องมือค้นหาเริ่มต้นอื่น ให้ไปที่การตั้งค่า <label data-l10n-name="remove-search-engine-article">เรียนรู้เพิ่มเติม</label>
remove-search-engine-button = ตกลง
