# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">เรียนรู้เพิ่มเติม</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์นี้เนื่องจากไม่ใช่ทั้งคอนเทนเนอร์แบบยืดหยุ่นหรือคอนเทนเนอร์แบบเส้นตาราง
inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์นี้เนื่องจากไม่ใช่ทั้งคอนเทนเนอร์แบบยืดหยุ่น คอนเทนเนอร์แบบเส้นตาราง หรือคอนเทนเนอร์แบบหลายคอลัมน์
inactive-css-not-multicol-container = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์นี้เนื่องจากไม่ใช่คอนเทนเนอร์แบบหลายคอลัมน์
inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์นี้เนื่องจากไม่ใช่รายการแบบเส้นตารางหรือแบบยืดหยุ่น
inactive-css-not-grid-item = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์นี้เนื่องจากไม่ใช่รายการแบบเส้นตาราง
inactive-css-not-grid-container = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์นี้เนื่องจากไม่ใช่คอนเทนเนอร์แบบเส้นตาราง
inactive-css-not-flex-item = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์นี้เนื่องจากไม่ใช่รายการแบบยืดหยุ่น
inactive-css-not-flex-container = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์นี้เนื่องจากไม่ใช่คอนเทนเนอร์แบบยืดหยุ่น
inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์นี้เนื่องจากไม่ใช่อิลิเมนต์แบบอินไลน์หรือแบบเซลล์ตาราง
inactive-css-first-line-pseudo-element-not-supported = ไม่รองรับ <strong>{ $property }</strong> บนซูโดอิลิเมนต์ ::first-line
inactive-css-first-letter-pseudo-element-not-supported = ไม่รองรับ <strong>{ $property }</strong> บนซูโดอิลิเมนต์ ::first-letter
inactive-css-placeholder-pseudo-element-not-supported = ไม่รองรับ <strong>{ $property }</strong> บนซูโดอิลิเมนต์ ::placeholder
inactive-css-property-because-of-display = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์นี้เนื่องจากมีค่าคุณสมบัติ display เป็น <strong>{ $display }</strong>
inactive-css-not-display-block-on-floated = ค่า <strong>display</strong> ได้ถูกเปลี่ยนโดยเอนจินเป็น <strong>block</strong> เนื่องจากมีอิลิเมนต์แบบ <strong>floated</strong>
inactive-css-property-is-impossible-to-override-in-visited = ไม่สามารถเขียนทับ <strong>{ $property }</strong> เนื่องจากข้อจำกัดของ <strong>:visited</strong>
inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> ไม่มีผลต่ออิลิเมนต์นี้เนื่องจากไม่ใช่อิลิเมนต์ที่ถูกจัดตำแหน่ง
inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> ไม่มีผลต่ออิลิเมนต์นี้เนื่องจากไม่ได้ตั้งค่า <strong>overflow:hidden</strong>
inactive-css-not-for-internal-table-elements = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์ตารางภายใน
inactive-css-not-for-internal-table-elements-except-table-cells = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์ตารางภายในยกเว้นเซลล์ตาราง
inactive-css-not-table = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์นี้เนื่องจากไม่ใช่ตาราง
inactive-css-not-table-cell = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์นี้เนื่องจากไม่ใช่เซลล์ตาราง
inactive-scroll-padding-when-not-scroll-container = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์นี้เนื่องจากไม่มีการเลื่อน
inactive-css-border-image = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์นี้ เนื่องจากไม่สามารถใช้กับอิลิเมนต์ตารางภายในที่ตั้งค่า <strong>border-collapse</strong> เป็น <strong>collapse</strong> บนอิลิเมนต์ตารางแม่ได้
inactive-css-ruby-element = <strong>{ $property }</strong> ไม่มีผลกับอิลิเมนต์นี้ เนื่องจากเป็นอิลิเมนต์ ruby ขนาดของอิลิเมนต์นี้ถูกกำหนดโดยขนาดตัวอักษรของข้อความ ruby
inactive-css-highlight-pseudo-elements-not-supported = ไม่รองรับ <strong>{ $property }</strong> บน highlight pseudo-elements
inactive-css-cue-pseudo-element-not-supported = ไม่รองรับ <strong>{ $property }</strong> บนซูโดอิลิเมนต์ ::cue

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = ลองเพิ่ม <strong>display:grid</strong> หรือ <strong>display:flex</strong> { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = ลองเพิ่ม <strong>display:grid</strong>, <strong>display:flex</strong>, หรือ <strong>columns:2</strong> { learn-more }
inactive-css-not-multicol-container-fix = ลองเพิ่ม <strong>column-count</strong> หรือ <strong>column-width</strong> { learn-more }
inactive-css-not-grid-or-flex-item-fix-3 = ลองเพิ่ม <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> หรือ <strong>display:inline-flex</strong> ไปยังอิลิเมนต์แม่ของอิลิเมนต์ { learn-more }
inactive-css-not-grid-item-fix-2 = ลองเพิ่ม <strong>display:grid</strong> หรือ <strong>display:inline-grid</strong> ไปยังอิลิเมนต์แม่ของอิลิเมนต์ { learn-more }
inactive-css-not-grid-container-fix = ลองเพิ่ม <strong>display:grid</strong> หรือ <strong>display:inline-grid</strong> { learn-more }
inactive-css-not-flex-item-fix-2 = ลองเพิ่ม <strong>display:flex</strong> หรือ <strong>display:inline-flex</strong> ไปยังอิลิเมนต์แม่ของอิลิเมนต์ { learn-more }
inactive-css-not-flex-container-fix = ลองเพิ่ม <strong>display:flex</strong> หรือ <strong>display:inline-flex</strong> { learn-more }
inactive-css-not-inline-or-tablecell-fix = ลองเพิ่ม <strong>display:inline</strong> หรือ <strong>display:table-cell</strong> { learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = ลองเพิ่ม <strong>display:inline-block</strong> หรือ <strong>display:block</strong> { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = ลองเพิ่ม <strong>display:inline-block</strong> { learn-more }
inactive-css-not-display-block-on-floated-fix = ลองเอา <strong>float</strong> ออกหรือเพิ่ม <strong>display:block</strong> { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = ลองตั้งค่าคุณสมบัติ <strong>position</strong> เป็นอย่างอื่นนอกจาก <strong>static</strong> { learn-more }
inactive-text-overflow-when-no-overflow-fix = ลองเพิ่ม <strong>overflow:hidden</strong> { learn-more }
inactive-css-not-for-internal-table-elements-fix = ลองตั้งค่าคุณสมบัติ <strong>display</strong> เป็นอย่างอื่นนอกจาก <strong>table-cell</strong>, <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong>, หรือ <strong>table-footer-group</strong> { learn-more }
inactive-css-not-for-internal-table-elements-except-table-cells-fix = ลองตั้งค่าคุณสมบัติ <strong>display</strong> เป็นอย่างอื่นนอกจาก <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong>, หรือ <strong>table-footer-group</strong> { learn-more }
inactive-css-not-table-fix = ลองเพิ่ม <strong>display:table</strong> หรือ <strong>display:inline-table</strong> { learn-more }
inactive-css-not-table-cell-fix = ลองเพิ่ม <strong>display:table-cell</strong> { learn-more }
inactive-scroll-padding-when-not-scroll-container-fix = ลองเพิ่ม <strong>overflow:auto</strong>, <strong>overflow:scroll</strong> หรือ <strong>overflow:hidden</strong> { learn-more }
inactive-css-border-image-fix = บนอิลิเมนต์ตารางแม่ ให้เอาคุณสมบัติออก หรือเปลี่ยนค่าของ <strong>border-collapse</strong> เป็นค่าอื่น ๆ ที่ไม่ใช่ <strong>collapse</strong> { learn-more }
inactive-css-ruby-element-fix = ลองเปลี่ยน <strong>font-size</strong> ของข้อความ ruby { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = ไม่รองรับ <strong>{ $property }</strong> ในเบราว์เซอร์ต่อไปนี้:
css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> เป็นคุณสมบัติทดลองซึ่งเลิกใช้แล้วตามมาตรฐาน W3C โดยไม่รองรับในเบราว์เซอร์ต่อไปนี้:
css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> เป็นคุณสมบัติทดลองซึ่งเลิกใช้แล้วตามมาตรฐาน W3C
css-compatibility-deprecated-message = <strong>{ $property }</strong> เลิกใช้แล้วตามมาตรฐาน W3C โดยไม่รองรับในเบราว์เซอร์ต่อไปนี้:
css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> เลิกใช้แล้วตามมาตรฐาน W3C
css-compatibility-experimental-message = <strong>{ $property }</strong> เป็นคุณสมบัติทดลอง โดยไม่รองรับในเบราว์เซอร์ต่อไปนี้:
css-compatibility-experimental-supported-message = <strong>{ $property }</strong> เป็นคุณสมบัติทดลอง
css-compatibility-learn-more-message = <span data-l10n-name="link">เรียนรู้เพิ่มเติม</span>เกี่ยวกับ <strong>{ $rootProperty }</strong>
