# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### "Glean" and "Glean SDK" should remain in English.

### "FOG", "Glean", and "Glean SDK" should remain in English.

-fog-brand-name = FOG
-glean-brand-name = Glean
glean-sdk-brand-name = { -glean-brand-name } SDK
glean-debug-ping-viewer-brand-name = ตัวแสดง Ping สำหรับดีบั๊กของ { -glean-brand-name }

about-glean-page-title2 = เกี่ยวกับ { -glean-brand-name }
about-glean-header = เกี่ยวกับ { -glean-brand-name }
about-glean-interface-description =
    <a data-l10n-name="glean-sdk-doc-link">{ glean-sdk-brand-name }</a>
    เป็นไลบรารีรวบรวมข้อมูลที่ใช้ในโครงการต่างๆ ของ { -vendor-short-name }
    อินเทอร์เฟซนี้ถูกออกแบบมาเพื่อให้นักพัฒนาและนักทดสอบใช้ในการ
    <a data-l10n-name="fog-link">กำหนดเครื่องมือที่จะใช้ในการทดสอบ</a>ด้วยตนเอง

about-glean-upload-enabled = เปิดใช้งานการอัปโหลดข้อมูลแล้ว
about-glean-upload-disabled = ปิดใช้งานการอัปโหลดข้อมูลแล้ว
about-glean-upload-enabled-local = เปิดใช้งานการอัปโหลดข้อมูลสำหรับส่งไปยังเซิร์ฟเวอร์เฉพาะที่เท่านั้น
about-glean-upload-fake-enabled =
    ปิดใช้งานการอัปโหลดข้อมูลแล้ว
    แต่เรากำลังหลอกและบอก { glean-sdk-brand-name } ว่าเปิดใช้งานอยู่
    เพื่อให้ข้อมูลถูกบันทึกไว้ในเครื่อง
    หมายเหตุ: หากคุณกำหนดแท็กการดีบั๊ก Ping ต่างๆ จะถูกอัปโหลดไปยัง
    <a data-l10n-name="glean-debug-ping-viewer">{ glean-debug-ping-viewer-brand-name }</a> โดยไม่คำนึงถึงการตั้งค่าใดๆ

# This message is followed by a bulleted list.
about-glean-prefs-and-defines = <a data-l10n-name="fog-prefs-and-defines-doc-link">การกำหนดลักษณะและค่ากำหนด</a>ที่เกี่ยวข้องประกอบด้วย:
# Variables:
#   $data-upload-pref-value (String): the value of the datareporting.healthreport.uploadEnabled pref. Typically "true", sometimes "false"
# Do not translate strings between <code> </code> tags.
about-glean-data-upload = <code>datareporting.healthreport.uploadEnabled</code>: { $data-upload-pref-value }
# Variables:
#   $local-port-pref-value (Integer): the value of the telemetry.fog.test.localhost_port pref. Typically 0. Can be negative.
# Do not translate strings between <code> </code> tags.
about-glean-local-port = <code>telemetry.fog.test.localhost_port</code>: { $local-port-pref-value }
# Variables:
#   $glean-android-define-value (Boolean): the value of the MOZ_GLEAN_ANDROID define. Typically "false", sometimes "true".
# Do not translate strings between <code> </code> tags.
about-glean-glean-android = <code>MOZ_GLEAN_ANDROID</code>: { $glean-android-define-value }
# Variables:
#   $moz-official-define-value (Boolean): the value of the MOZILLA_OFFICIAL define.
# Do not translate strings between <code> </code> tags.
about-glean-moz-official = <code>MOZILLA_OFFICIAL</code>: { $moz-official-define-value }

about-glean-about-testing-header = เกี่ยวกับการทดสอบ
# This message is followed by a numbered list.
about-glean-manual-testing =
    คำแนะนำแบบเต็มมีอยู่ใน
    <a data-l10n-name="fog-instrumentation-test-doc-link">คู่มือการทดสอบด้วยเครื่องมือที่กำหนดของ { -fog-brand-name }</a>
    และใน<a data-l10n-name="glean-sdk-doc-link">คู่มือของ { glean-sdk-brand-name }</a>
    แต่โดยสรุปแล้ว เมื่อต้องการทดสอบด้วยตนเองว่าเครื่องมือที่กำหนดของคุณใช้ได้หรือไม่ คุณควร:

# This message is an option in a dropdown filled with untranslated names of pings.
about-glean-no-ping-label = (ไม่ต้องส่ง Ping ใดๆ)
# An in-line text input field precedes this string.
about-glean-label-for-tag-pings = ตรวจดูให้แน่ใจว่ามีแท็กการดีบั๊กที่จำง่ายในฟิลด์ที่นำหน้าเพื่อให้คุณสามารถพบ Ping ของคุณภายหลังได้
# An in-line drop down list precedes this string.
# Do not translate strings between <code> </code> tags.
about-glean-label-for-ping-names =
    เลือก Ping ที่มีเครื่องมือที่ใช้ทดสอบของคุณอยู่จากรายชื่อก่อนหน้านี้
    หากเครื่องมือนั้นอยู่ใน <a data-l10n-name="custom-ping-link">Ping ที่กำหนดเอง</a> ให้เลือกเครื่องมือนั้น
    หรือมิฉะนั้น ค่าเริ่มต้นสำหรับเมตริก <code>event</code> คือ
    Ping <code>events</code>
    และค่าเริ่มต้นสำหรับเมตริกทั้งหมดคือ
    Ping <code>metrics</code>
# An in-line check box precedes this string.
about-glean-label-for-log-pings =
    (ไม่บังคับ ทำเครื่องหมายที่ช่องก่อนหน้าหากคุณต้องการให้ Ping ถูกบันทึกเมื่อมีการส่ง
    คุณจะต้อง<a data-l10n-name="enable-logging-link">เปิดใช้งานการบันทึก</a>เพิ่มเติม)
# Variables
#   $debug-tag (String): The user-set value of the debug tag input on this page. Like "about-glean-kV"
# An in-line button labeled "Apply settings and submit ping" precedes this string.
about-glean-label-for-controls-submit =
    กดปุ่มก่อนหน้าเพื่อแท็ก { -glean-brand-name } ping ทั้งหมดด้วยแท็กของคุณ และส่ง Ping ที่เลือก
    (Ping ทั้งหมดที่ส่งมานับจากนั้นจนกว่าคุณจะเริ่มแอปพลิเคชันใหม่จะถูกแท็กด้วย
    <code>{ $debug-tag }</code>)
about-glean-li-for-visit-gdpv =
    <a data-l10n-name="gdpv-tagged-pings-link">เข้าไปที่หน้า { glean-debug-ping-viewer-brand-name } เพื่อส่ง Ping กับแท็กของคุณ</a>
    ปกติจะใช้เวลาเพียงไม่กี่วินาทีในการกดปุ่มจนกว่า Ping ของคุณจะมาถึง
    แต่บางครั้งก็อาจใช้เวลามากเพียงไม่กี่นาที

# Do not translate strings between <code> </code> tags.
about-glean-adhoc-explanation =
    สำหรับการทดสอบ<i>เฉพาะกิจ</i>เพิ่มเติม
    คุณยังสามารถกำหนดค่าปัจจุบันของเครื่องมือเฉพาะชิ้นได้อีกด้วย
    โดยเปิดคอนโซล devtools ที่นี่ใน <code>about:glean</code>
    และใช้ <code>testGetValue()</code> API เช่น
    <code>Glean.metricCategory.metricName.testGetValue()</code>


controls-button-label-verbose = นำการตั้งค่าไปใช้และส่ง ping

about-glean-about-data-header = เกี่ยวกับข้อมูล
about-glean-about-data-explanation =
    หากต้องการเรียกดูรายการข้อมูลที่รวบรวม โปรดดูที่
    <a data-l10n-name="glean-dictionary-link">{ -glean-brand-name } Dictionary</a>
