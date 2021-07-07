# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = รายงานสำหรับ { $addon-name }

abuse-report-title-extension = รายงานส่วนขยายนี้ไปยัง { -vendor-short-name }
abuse-report-title-theme = รายงานชุดตกแต่งนี้ไปยัง { -vendor-short-name }
abuse-report-subtitle = มีปัญหาอะไร?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = โดย <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    ไม่มั่นใจว่าประเด็นอะไรที่จะเลือก?
    <a data-l10n-name="learnmore-link">เรียนรู้เพิ่มเติมเกี่ยวกับการรายงานส่วนขยายและธีม</a>

abuse-report-submit-description = อธิบายปัญหา (เพิ่มเติม)
abuse-report-textarea =
    .placeholder = เราจะสามารถแก้ไขปัญหาได้ง่ายขึ้นหากคุณระบุปัญหาที่เกิดขึ้นให้เราทราบ โปรดอธิบายปัญหาที่คุณพบ ขอบคุณที่ช่วยเรารักษาเว็บให้แข็งแรง
abuse-report-submit-note =
    หมายเหตุ: ไม่ต้องรวมข้อมูลส่วนบุคคล (เช่น ชื่อ ที่อยู่อีเมล เบอร์โทรศัพท์ ที่อยู่จริง)
    { -vendor-short-name } เป็นผู้เก็บบันทึกรายงานนี้ไว้อย่างถาวร

## Panel buttons.

abuse-report-cancel-button = ยกเลิก
abuse-report-next-button = ถัดไป
abuse-report-goback-button = ย้อนกลับ
abuse-report-submit-button = ส่ง

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = รายงานสำหรับ <span data-l10n-name="addon-name">{ $addon-name }</span> ถูกยกเลิก
abuse-report-messagebar-submitting = ส่งรายงานสำหรับ <span data-l10n-name="addon-name">{ $addon-name }</span>
abuse-report-messagebar-submitted = ขอบคุณที่ส่งรายงาน คุณต้องการลบ <span data-l10n-name="addon-name">{ $addon-name }</span> ไหม?
abuse-report-messagebar-submitted-noremove = ขอบคุณที่ส่งรายงาน
abuse-report-messagebar-removed-extension = ขอบคุณที่ส่งรายงาน คุณได้ลบส่วนขยาย <span data-l10n-name="addon-name">{ $addon-name }</span> แล้ว
abuse-report-messagebar-removed-theme = ขอบคุณที่ส่งรายงาน เราได้ลบธีม <span data-l10n-name="addon-name">{ $addon-name }</span> แล้ว
abuse-report-messagebar-error = เกิดข้อผิดพลาดขึ้นขณะส่งรายงานสำหรับ <span data-l10n-name="addon-name">{ $addon-name }</span>
abuse-report-messagebar-error-recent-submit = รายงานของ <span data-l10n-name="addon-name">{ $addon-name }</span> ไม่สามารถส่งได้เนื่องจากเพิ่งมีรายงานอีกฉบับถูกส่งไปเร็ว ๆ นี้

## Message bars actions.

abuse-report-messagebar-action-remove-extension = ใช่ เอาออก
abuse-report-messagebar-action-keep-extension = ไม่ เก็บไว้
abuse-report-messagebar-action-remove-theme = ใช่ เอาออก
abuse-report-messagebar-action-keep-theme = ไม่ เก็บไว้
abuse-report-messagebar-action-retry = ลองใหม่
abuse-report-messagebar-action-cancel = ยกเลิก

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = มันทำให้คอมพิวเตอร์หรือข้อมูลของฉันเสียหาย
abuse-report-damage-example = ตัวอย่างเช่น: สอดแทรกมัลแวร์หรือขโมยข้อมูล

abuse-report-spam-reason-v2 = มันมีสแปมหรือแทรกโฆษณาที่ไม่พึงประสงค์
abuse-report-spam-example = ตัวอย่างเช่น: ใส่โฆษณาบนหน้าเว็บ

abuse-report-settings-reason-v2 = มันเปลี่ยนเครื่องมือค้นหา, หน้าแรก, หรือแท็บใหม่ของฉันโดยไม่แจ้งหรือถามฉัน
abuse-report-settings-suggestions = ก่อนรายงานส่วนขยายนี้ คุณสามารถทดลองเปลี่ยนการตั้งค่าของคุณ:
abuse-report-settings-suggestions-search = เปลี่ยนการตั้งค่าการค้นหาเริ่มต้นของคุณ
abuse-report-settings-suggestions-homepage = เปลี่ยนหน้าแรกและแท็บใหม่ของคุณ

abuse-report-deceptive-reason-v2 = มันอ้างว่าเป็นอย่างอื่นที่มันไม่ได้เป็น
abuse-report-deceptive-example = ตัวอย่างเช่น: คำอธิบายหรือรูปภาพชี้นำไปในทางที่ผิด

abuse-report-broken-reason-extension-v2 = มันไม่ทำงาน, ทำให้เว็บไซต์ล่ม, หรือทำให้ { -brand-product-name } ช้าลง
abuse-report-broken-reason-theme-v2 = มันไม่ทำงานหรือทำให้การแสดงผลของเบราว์เซอร์เสียหาย
abuse-report-broken-example = ตัวอย่างเช่น: คุณลักษณะใช้งานได้ช้า ใช้งานได้ยาก หรือใช้งานไม่ได้เลย บางส่วนของเว็บไซต์ไม่โหลดหรือดูผิดปกติ
abuse-report-broken-suggestions-extension = ดูเหมือนคุณจะระบุบั๊กแล้ว นอกจากคุณจะส่งรายงานที่นี่แล้ว วิธีที่ดีที่สุดเพื่อให้ปัญหาเกี่ยวกับการทำงานได้รับการแก้ไขคือให้ติดต่อนักพัฒนาส่วนขยาย <a data-l10n-name="support-link">เยี่ยมชมเว็บไซต์ของส่วนขยาย</a>เพื่อดูข้อมูลเพิ่มเติมเกี่ยวกับนักพัฒนา
abuse-report-broken-suggestions-theme = ดูเหมือนคุณจะระบุบั๊กแล้ว นอกจากคุณจะส่งรายงานที่นี่แล้ว วิธีที่ดีที่สุดเพื่อให้ปัญหาเกี่ยวกับการทำงานได้รับการแก้ไขคือให้ติดต่อนักพัฒนาชุดตกแต่ง <a data-l10n-name="support-link">เยี่ยมชมเว็บไซต์ของชุดตกแต่ง</a>เพื่อดูข้อมูลเพิ่มเติมเกี่ยวกับนักพัฒนา

abuse-report-policy-reason-v2 = มันมีเนื้อหาที่แสดงความเกลียดชัง ความรุนแรง หรือผิดกฎหมาย
abuse-report-policy-suggestions = หมายเหตุ: ประเด็นด้านลิขสิทธิ์และเครื่องหมายการค้าจะต้องถูกรายงานในกระบวนการแยกจากนี้ <a data-l10n-name="report-infringement-link">ใช้คำแนะนำเหล่านี้</a>ในการรายงานปัญหา

abuse-report-unwanted-reason-v2 = ฉันไม่เคยต้องการมันและไม่รู้จะกำจัดมันได้อย่างไร
abuse-report-unwanted-example = ตัวอย่าง: แอปพลิเคชันติดตั้งส่วนขยายนี้โดยที่ฉันไม่อนุญาต

abuse-report-other-reason = อื่น ๆ

