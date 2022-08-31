# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = เกิดข้อผิดพลาดในการส่งรายงาน โปรดลองอีกครั้งในภายหลัง

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = ไซต์ถูกซ่อมแซม? ส่งรายงาน

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = เข้มงวด
    .label = เข้มงวด
protections-popup-footer-protection-label-custom = กำหนดเอง
    .label = กำหนดเอง
protections-popup-footer-protection-label-standard = มาตรฐาน
    .label = มาตรฐาน

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = รายละเอียดเพิ่มเติมเกี่ยวกับการป้องกันการติดตามที่มากขึ้น

protections-panel-etp-on-header = การป้องกันการติดตามที่มากขึ้นถูก เปิด สำหรับไซต์นี้
protections-panel-etp-off-header = การป้องกันการติดตามที่มากขึ้นถูก ปิด สำหรับไซต์นี้

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = ไซต์ไม่ทำงาน?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = ไซต์ไม่ทำงาน?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = ทำไม?
protections-panel-not-blocking-why-etp-on-tooltip = การปิดกั้นคุณลักษณะเหล่านี้อาจทำให้องค์ประกอบของบางเว็บไซต์เสียหายได้ หากไม่มีตัวติดตาม ปุ่ม แบบฟอร์ม และฟิลด์การเข้าสู่ระบบบางส่วนอาจไม่ทำงาน
protections-panel-not-blocking-why-etp-off-tooltip = ตัวติดตามทั้งหมดในไซต์นี้ถูกโหลดเนื่องจากการป้องกันถูกปิด

##

protections-panel-no-trackers-found = ไม่มีตัวติดตามที่ { -brand-short-name } รู้จักถูกตรวจพบที่หน้านี้

protections-panel-content-blocking-tracking-protection = ตัวติดตามเนื้อหา

protections-panel-content-blocking-socialblock = ตัวติดตามสังคมออนไลน์
protections-panel-content-blocking-cryptominers-label = ตัวขุดเหรียญดิจิทัล
protections-panel-content-blocking-fingerprinters-label = ลายนิ้วมือดิจิทัล

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = ปิดกั้นแล้ว
protections-panel-not-blocking-label = อนุญาตแล้ว
protections-panel-not-found-label = ตรวจไม่พบ

##

protections-panel-settings-label = การตั้งค่าการป้องกัน
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = แดชบอร์ดการป้องกัน

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = ปิดการป้องกันหากคุณมีปัญหากับ:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = ช่องเข้าสู่ระบบ
protections-panel-site-not-working-view-issue-list-forms = แบบฟอร์ม
protections-panel-site-not-working-view-issue-list-payments = การชำระเงิน
protections-panel-site-not-working-view-issue-list-comments = ความคิดเห็น
protections-panel-site-not-working-view-issue-list-videos = วิดีโอ

protections-panel-site-not-working-view-send-report = ส่งรายงาน

##

protections-panel-cross-site-tracking-cookies = คุกกี้เหล่านี้ติดตามคุณจากไซต์หนึ่งไปยังอีกไซต์หนึ่งเพื่อรวบรวมข้อมูลเกี่ยวกับสิ่งที่คุณทำทางออนไลน์ พวกมันถูกตั้งค่าโดยบุคคลที่สามเช่น นักโฆษณาและบริษัทวิเคราะห์
protections-panel-cryptominers = ตัวขุดเหรียญคริปโตดิจิตอลใช้พลังการคำนวณของระบบของคุณเพื่อสร้างเงินคริปโตดิจิทัล สคริปต์ขุดเหรียญดิจิทัลจะทำให้พลังงานแบตเตอรี่ของคุณลดลง คอมพิวเตอร์ของคุณช้าลง และเพิ่มค่าไฟฟ้าของคุณได้
protections-panel-fingerprinters = ลายนิ้วมือดิจิทัลรวบรวมการตั้งค่าจากเบราว์เซอร์และคอมพิวเตอร์ของคุณเพื่อสร้างโปรไฟล์ของคุณ การใช้ลายนิ้วมือดิจิทัลจะทำให้สามารถติดตามคุณผ่านเว็บไซต์ต่าง ๆ ได้
protections-panel-tracking-content = เว็บไซต์อาจโหลดโฆษณา วิดีโอ และเนื้อหาอื่น ๆ นอกเว็บที่มีโค้ดติดตาม การปิดกั้นเนื้อหาการติดตามจะทำให้เว็บไซต์โหลดเร็วขึ้น แต่ปุ่มบางปุ่ม ฟอร์ม และเขตข้อมูลการเข้าสู่ระบบอาจไม่ทำงาน
protections-panel-social-media-trackers = เครือข่ายสังคมออนไลน์จะวางตัวติดตามบนเว็บไซต์อื่น ๆ เพื่อติดตามสิ่งที่คุณทำ และดูทางออนไลน์ ซึ่งทำให้บริษัทสังคมออนไลน์สามารถเรียนรู้เพิ่มเติมเกี่ยวกับคุณนอกเหนือจากที่คุณแบ่งปันในโปรไฟล์สังคมออนไลน์ของคุณ

protections-panel-description-shim-allowed = ตัวติดตามบางตัวที่ถูกทำเครื่องหมายไว้ด้านล่างนี้ได้ถูกเลิกปิดกั้นบนหน้านี้เนื่องจากคุณมีการโต้ตอบกับตัวติดตามเหล่านั้น
protections-panel-description-shim-allowed-learn-more = เรียนรู้เพิ่มเติม
protections-panel-shim-allowed-indicator =
    .tooltiptext = เลิกปิดกั้นตัวติดตามบางส่วนแล้ว

protections-panel-content-blocking-manage-settings =
    .label = จัดการการตั้งค่าการป้องกัน
    .accesskey = M

protections-panel-content-blocking-breakage-report-view =
    .title = รายงานไซต์ที่ใช้งานไม่ได้
protections-panel-content-blocking-breakage-report-view-description = การปิดกั้นตัวติดตามบางตัวอาจทำให้เกิดปัญหากับบางเว็บไซต์ได้ การรายงานปัญหา ก็เท่ากับคุณช่วยทำให้ { -brand-short-name } ดีขึ้นสำหรับทุก ๆ คน การรายงานนี้จะส่ง URL พร้อมทั้งข้อมูลเกี่ยวกับการตั้งค่าเบราว์เซอร์ของคุณไปให้กับ Waterfox <label data-l10n-name="learn-more">เรียนรู้เพิ่มเติม</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = ทางเลือก: อธิบายปัญหา
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = ทางเลือก: อธิบายปัญหา
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = ยกเลิก
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = ส่งรายงาน
