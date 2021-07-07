# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = เครื่องมือนักพัฒนาเริ่มต้น
# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * ไม่รองรับในชุดเครื่องมือปัจจุบัน
# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = เครื่องมือนักพัฒนาที่ติดตั้งผ่านส่วนเสริม
# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = ปุ่มกล่องเครื่องมือที่มี
# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = ชุดตกแต่ง

## Inspector section

# The heading
options-context-inspector = ตัวตรวจสอบ
# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = แสดงลักษณะของเบราว์เซอร์
options-show-user-agent-styles-tooltip =
    .title = การเปิดสิ่งนี้จะแสดงลักษณะเริ่มต้นที่ถูกโหลดโดยเบราว์เซอร์
# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = ตัดทอนแอตทริบิวต์ DOM
options-collapse-attrs-tooltip =
    .title = ตัดทอนแอตทริบิวต์แบบยาวในตัวตรวจสอบ

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = หน่วยสีเริ่มต้น
options-default-color-unit-authored = ตามหน่วยเดิม
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = ชื่อสี

## Style Editor section

# The heading
options-styleeditor-label = ตัวแก้ไขลักษณะ
# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = เติมเต็ม CSS อัตโนมัติ
options-stylesheet-autocompletion-tooltip =
    .title = เติมเต็ม CSS อัตโนมัติ คุณสมบัติ ค่า และตัวเลือกในตัวแก้ไขสไตล์ตามที่คุณพิมพ์

## Screenshot section

# The heading
options-screenshot-label = ลักษณะการทำงานของภาพหน้าจอ
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = จับภาพหน้าจอไปยังคลิปบอร์ด
options-screenshot-clipboard-tooltip =
    .title = บันทึกไปที่ภาพหน้าจอโดยตรงไปยังคลิปบอร์ด
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = จับภาพหน้าจอไปยังคลิปบอร์ดเท่านั้น
options-screenshot-clipboard-tooltip2 =
    .title = บันทึกภาพหน้าจอโดยตรงไปยังคลิปบอร์ด
# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = เล่นเสียงชัตเตอร์กล้อง
options-screenshot-audio-tooltip =
    .title = เปิดใช้งานเสียงกล้องเมื่อถ่ายภาพหน้าจอ

## Editor section

# The heading
options-sourceeditor-label = ค่ากำหนดตัวแก้ไข
options-sourceeditor-detectindentation-tooltip =
    .title = กะประมาณการเยื้องขึ้นอยู่กับเนื้อหาต้นฉบับ
options-sourceeditor-detectindentation-label = ตรวจสอบการเยื้อง
options-sourceeditor-autoclosebrackets-tooltip =
    .title = ใส่วงเล็บปิดอัตโนมัติ
options-sourceeditor-autoclosebrackets-label = ปิดวงเล็บอัตโนมัติ
options-sourceeditor-expandtab-tooltip =
    .title = ใช้ช่องว่างแทนอักขระแท็บ
options-sourceeditor-expandtab-label = เยื้องโดยใช้ช่องว่าง
options-sourceeditor-tabsize-label = ขนาดแท็บ
options-sourceeditor-keybinding-label = ปุ่มลัด
options-sourceeditor-keybinding-default-label = ค่าเริ่มต้น

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = การตั้งค่าขั้นสูง
# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = ปิดใช้งานแคช HTTP (เมื่อกล่องเครื่องมือเปิดอยู่)
options-disable-http-cache-tooltip =
    .title = การเปิดตัวเลือกนี้จะเป็นการปิดการใช้งานแคช HTTP สำหรับแท็บทั้งหมดที่เปิดกล่องเครื่องมือ ตัวทำงานบริการจะไม่ได้รับผลกระทบจากตัวเลือกนี้
# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = ปิดใช้งาน JavaScript *
options-disable-javascript-tooltip =
    .title = การเปิดใช้ตัวเลือกนี้จะปิดใช้งาน JavaScript ในแท็บปัจจุบัน ถ้าแท็บนี้ถูกปิดไป ค่าที่ตั้งนี้จะถูกล้าง
# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = เปิดใช้งานเบราว์เซอร์ chrome และกล่องเครื่องมือการดีบั๊กส่วนเสริม
options-enable-chrome-tooltip =
    .title = การเปิดตัวเลือกนี้จะช่วยให้คุณสามารถใช้เครื่องมือนักพัฒนาในบริบทของเบราว์เซอร์ได้ (ผ่าน เครื่องมือ > นักพัฒนาเว็บ > กล่องเครื่องมือเบราว์เซอร์) และดีบั๊กส่วนเสริมจากตัวจัดการส่วนเสริม
# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = เปิดใช้งานการดีบั๊กระยะไกล
options-enable-remote-tooltip2 =
    .title = การเปิดตัวเลือกนี้จะอนุญาตให้สามารถดีบั๊กอินสแตนซ์เบราว์เซอร์นี้จากระยะไกลได้
# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = เปิดใช้งานตัวทำงานบริการผ่าน HTTP (เมื่อกล่องเครื่องมือเปิดอยู่)
options-enable-service-workers-http-tooltip =
    .title = การเปิดตัวเลือกนี้จะเป็นการเปิดใช้งานตัวทำงานบริการผ่าน HTTP สำหรับแท็บทั้งหมดที่เปิดกล่องเครื่องมือ
# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = เปิดใช้งานการแมปต้นฉบับ
options-source-maps-tooltip =
    .title = หากคุณเปิดใช้งานตัวเลือกนี้ ต้นฉบับจะถูกแมปในเครื่องมือ
# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = *เรียกหน้าเว็บใหม่เฉพาะวาระปัจจุบันเท่านั้น
# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = แสดงข้อมูลแพลตฟอร์ม Gecko
options-show-platform-data-tooltip =
    .title = ถ้าคุณเปิดใช้งานตัวเลือกนี้ รายงานตัวเก็บประวัติ JavaScript จะรวมสัญลักษณ์ของ Gecko platform เข้าไปด้วย
