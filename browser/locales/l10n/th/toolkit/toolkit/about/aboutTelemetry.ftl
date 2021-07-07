# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = แหล่งข้อมูล Ping:
about-telemetry-show-current-data = ข้อมูลปัจจุบัน
about-telemetry-show-archived-ping-data = ข้อมูล ping ที่เก็บถาวร
about-telemetry-show-subsession-data = แสดงข้อมูลการส่ง
about-telemetry-choose-ping = เลือก ping:
about-telemetry-archive-ping-type = ชนิด Ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = วันนี้
about-telemetry-option-group-yesterday = เมื่อวานนี้
about-telemetry-option-group-older = เก่ากว่า
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = ข้อมูลการวัดและส่งข้อมูลทางไกล
about-telemetry-current-store = ส่วนจัดเก็บปัจจุบัน:
about-telemetry-more-information = กำลังมองหาข้อมูลเพิ่มเติม?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">เอกสารข้อมูล Waterfox</a> มีคำแนะนำเกี่ยวกับวิธีการทำงานกับเครื่องมือข้อมูลของเรา
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">เอกสารเกี่ยวกับไคลเอนต์การวัดและส่งข้อมูลทางไกลของ Waterfox</a> มีคำจำกัดความสำหรับหลักการทำงาน, เอกสาร API และการอ้างอิงข้อมูล
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">แดชบอร์ดการวัดและส่งข้อมูลทางไกล</a>ช่วยให้คุณเห็นภาพข้อมูลที่ Waterfox ได้รับผ่านการวัดและส่งข้อมูลทางไกล
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> มีรายละเอียดและคำอธิบายสำหรับโพรบที่รวบรวมโดยการวัดและส่งข้อมูลทางไกล
about-telemetry-show-in-Waterfox-json-viewer = เปิดในตัวดู JSON
about-telemetry-home-section = หน้าแรก
about-telemetry-general-data-section = ข้อมูลทั่วไป
about-telemetry-environment-data-section = ข้อมูลสภาพแวดล้อม
about-telemetry-session-info-section = ข้อมูลวาระ
about-telemetry-scalar-section = สเกลาร์
about-telemetry-keyed-scalar-section = สเกลาร์ที่สำคัญ
about-telemetry-histograms-section = ฮิสโทแกรม
about-telemetry-keyed-histogram-section = ฮิสโทแกรมที่สำคัญ
about-telemetry-events-section = เหตุการณ์
about-telemetry-simple-measurements-section = การวัดอย่างง่าย
about-telemetry-slow-sql-section = คำสั่ง SQL ที่ช้า
about-telemetry-addon-details-section = รายละเอียดส่วนเสริม
about-telemetry-captured-stacks-section = สแตกที่ถูกจับ
about-telemetry-late-writes-section = การเขียนทีหลัง
about-telemetry-raw-payload-section = ส่วนข้อมูลดิบ
about-telemetry-raw = ข้อมูลดิบ JSON
about-telemetry-full-sql-warning = หมายเหตุ: การดีบั๊ก SQL ที่ทำงานช้าถูกเปิดใช้งาน คำสั่ง SQL แบบเต็มอาจถูกแสดงไว้ด้านล่างแต่จะไม่ถูกส่งออกไป
about-telemetry-fetch-stack-symbols = ดึงข้อมูลชื่อของฟังก์ชันสำหรับสแตก
about-telemetry-hide-stack-symbols = แสดงข้อมูลสแตกดิบ
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] ข้อมูลการเปิดตัว
       *[prerelease] ข้อมูลก่อนเปิดตัว
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] เปิดใช้งานแล้ว
       *[disabled] ปิดใช้งานแล้ว
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
       *[other] { $sampleCount } ตัวอย่าง, เฉลี่ย = { $prettyAverage }, ผลรวม = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-page-subtitle = หน้านี้แสดงข้อมูลเกี่ยวกับประสิทธิภาพ, ฮาร์ดแวร์, การใช้งาน และการปรับแต่งที่เก็บรวบรวมไว้โดยตัววัดและส่งข้อมูลทางไกล ข้อมูลนี้จะถูกส่งไปยัง { $telemetryServerOwner } เพื่อช่วยปรับปรุง { -brand-full-name }
about-telemetry-settings-explanation = การวัดและส่งข้อมูลทางไกลกำลังรวบรวม { about-telemetry-data-type } และการอัปโหลด<a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = ข้อมูลแต่ละชิ้นจะถูกส่งไปรวมไว้ใน “<a data-l10n-name="ping-link">pings</a>” คุณกำลังดู ping { $name }, { $timestamp }
about-telemetry-data-details-current = ข้อมูลแต่ละชิ้นจะถูกส่งไปรวมไว้ใน “<a data-l10n-name="ping-link">pings</a>” คุณกำลังดูข้อมูลปัจจุบัน
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = ค้นหาใน { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = ค้นหาในส่วนทั้งหมด
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = ผลลัพธ์สำหรับ “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = ขออภัย! ไม่มีผลลัพธ์ใน { $sectionName } สำหรับ “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = ขออภัย! ไม่มีผลลัพธ์ในส่วนใด ๆ สำหรับ “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = ขออภัย! ขณะนี้ไม่มีข้อมูลใน “{ $sectionName }”
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = ข้อมูลปัจจุบัน
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = ทั้งหมด
# button label to copy the histogram
about-telemetry-histogram-copy = คัดลอก
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = คำสั่ง SQL ที่ช้าในเธรดหลัก
about-telemetry-slow-sql-other = คำสั่ง SQL ที่ช้าในเธรดตัวช่วย
about-telemetry-slow-sql-hits = ครั้ง
about-telemetry-slow-sql-average = เวลาเฉลี่ย (ms)
about-telemetry-slow-sql-statement = คำสั่ง
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID ส่วนเสริม
about-telemetry-addon-table-details = รายละเอียด
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = ผู้ให้บริการ { $addonProvider }
about-telemetry-keys-header = คุณสมบัติ
about-telemetry-names-header = ชื่อ
about-telemetry-values-header = ค่า
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (จำนวนครั้งที่จับ: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = การเขียนภายหลัง #{ $lateWriteCount }
about-telemetry-stack-title = สแตก:
about-telemetry-memory-map-title = ผังหน่วยความจำ:
about-telemetry-error-fetching-symbols = เกิดข้อผิดพลาดระหว่างการดึงข้อมูลสัญลักษณ์ ตรวจสอบว่าคุณเชื่อมต่อกับอินเทอร์เน็ตอยู่แล้วลองใหม่อีกครั้ง
about-telemetry-time-stamp-header = บันทึกเวลา
about-telemetry-category-header = หมวดหมู่
about-telemetry-method-header = วิธีการ
about-telemetry-object-header = วัตถุ
about-telemetry-extra-header = พิเศษ
about-telemetry-origin-section = Origin Telemetry
about-telemetry-origin-origin = ที่มา
about-telemetry-origin-count = จำนวน
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Waterfox Origin Telemetry</a> เข้ารหัสข้อูลทก่อนที่จะถูกส่งเพื่อให้ { $telemetryServerOwner } สามารถนับจำนวนสิ่งต่าง ๆ ได้ แต่จะไม่ทราบว่ามี { -brand-product-name } ที่ระบุใดมีส่วนร่วมกับการนับนั้น (<a data-l10n-name="prio-blog-link">เรียนรู้เพิ่มเติม</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = โปรเซส { $process }
