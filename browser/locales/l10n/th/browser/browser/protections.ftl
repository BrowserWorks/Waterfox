# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
       *[other] { -brand-short-name } ปิดกั้นตัวติดตาม { $count } ตัวตลอดสัปดาห์ที่ผ่านมา
    }
# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
       *[other] ตัวติดตาม <b>{ $count }</b> ตัวถูกปิดกั้นตั้งแต่ { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }
# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } จะปิดกั้นตัวติดตามในหน้าต่างส่วนตัวต่อไป แต่จะไม่เก็บบันทึกสิ่งที่ถูกปิดกั้นไว้
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = ตัวติดตามที่ { -brand-short-name } ปิดกั้นในสัปดาห์นี้
protection-report-webpage-title = แดชบอร์ดการป้องกัน
protection-report-page-content-title = แดชบอร์ดการป้องกัน
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } สามารถปกป้องความเป็นส่วนตัวของคุณในเบื้องหลังขณะที่คุณเรียกดูได้ นี่คือข้อมูลสรุปส่วนตัวของการปกป้องเหล่านั้น รวมถึงเครื่องมือที่ใช้ควบคุมความปลอดภัยออนไลน์ของคุณ
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } จะปกป้องความเป็นส่วนตัวของคุณในเบื้องหลังขณะที่คุณเรียกดู นี่คือข้อมูลสรุปส่วนตัวของการปกป้องเหล่านั้น รวมถึงเครื่องมือที่ใช้ควบคุมความปลอดภัยออนไลน์ของคุณ
protection-report-settings-link = จัดการการตั้งค่าความเป็นส่วนตัวและความปลอดภัย
etp-card-title-always = การป้องกันการติดตามที่มากขึ้น: เปิดตลอด
etp-card-title-custom-not-blocking = การป้องกันการติดตามที่มากขึ้น: ปิด
etp-card-content-description = { -brand-short-name } จะหยุดบริษัทต่าง ๆ ไม่ให้ติดตามคุณอย่างลับ ๆ ขณะที่คุณท่องเว็บโดยอัตโนมัติ
protection-report-etp-card-content-custom-not-blocking = การป้องกันทั้งหมดถูกปิดในขณนี้ เลือกตัวติดตามที่จะปิดกั้นโดยจัดการการตั้งค่าการป้องกัน { -brand-short-name } ของคุณ
protection-report-manage-protections = จัดการการตั้งค่า
# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = วันนี้
# This string is used to describe the graph for screenreader users.
graph-legend-description = กราฟที่มีจำนวนตัวติดตามแต่ละชนิดทั้งหมดที่ถูกปิดกั้นในสัปดาห์นี้
social-tab-title = ตัวติดตามสังคมออนไลน์
social-tab-contant = เครือข่ายสังคมออนไลน์จะวางตัวติดตามบนเว็บไซต์อื่น ๆ เพื่อติดตามสิ่งที่คุณทำ และดูทางออนไลน์ ซึ่งทำให้บริษัทสังคมออนไลน์สามารถเรียนรู้เพิ่มเติมเกี่ยวกับคุณนอกเหนือจากที่คุณแบ่งปันในโปรไฟล์สังคมออนไลน์ของคุณ <a data-l10n-name="learn-more-link">เรียนรู้เพิ่มเติม</a>
cookie-tab-title = คุกกี้ติดตามข้ามไซต์
cookie-tab-content = คุกกี้เหล่านี้ติดตามคุณจากไซต์หนึ่งไปยังอีกไซต์หนึ่งเพื่อรวบรวมข้อมูลเกี่ยวกับสิ่งที่คุณทำทางออนไลน์ ซึ่งถูกตั้งค่าโดยบุคคลที่สาม เช่น ผู้โฆษณาและบริษัทการวิเคราะห์ การปิดกั้นคุกกี้ติดตามข้ามไซต์จะช่วยลดจำนวนโฆษณาที่ติดตามคุณไป <a data-l10n-name="learn-more-link">เรียนรู้เพิ่มเติม</a>
tracker-tab-title = ตัวติดตามเนื้อหา
tracker-tab-description = เว็บไซต์อาจโหลดโฆษณา วิดีโอ และเนื้อหาอื่น ๆ นอกเว็บที่มีโค้ดติดตาม การปิดกั้นเนื้อหาการติดตามจะทำให้เว็บไซต์โหลดเร็วขึ้น แต่ปุ่มบางปุ่ม ฟอร์ม และเขตข้อมูลการเข้าสู่ระบบอาจไม่ทำงาน <a data-l10n-name="learn-more-link">เรียนรู้เพิ่มเติม</a>
fingerprinter-tab-title = ลายนิ้วมือดิจิทัล
fingerprinter-tab-content = ลายนิ้วมือดิจิทัลรวบรวมการตั้งค่าจากเบราว์เซอร์และคอมพิวเตอร์ของคุณเพื่อสร้างโปรไฟล์ของคุณ การใช้ลายนิ้วมือดิจิทัลจะทำให้สามารถติดตามคุณผ่านเว็บไซต์ต่าง ๆ ได้ <a data-l10n-name="learn-more-link">เรียนรู้เพิ่มเติม</a>
cryptominer-tab-title = ตัวขุดเหรียญดิจิทัล
cryptominer-tab-content = ตัวขุดเหรียญคริปโตดิจิตอลใช้พลังการคำนวณของระบบของคุณเพื่อสร้างเงินคริปโตดิจิทัล สคริปต์ขุดเหรียญดิจิทัลจะทำให้พลังงานแบตเตอรี่ของคุณลดลง คอมพิวเตอร์ของคุณช้าลง และเพิ่มค่าไฟฟ้าของคุณได้ <a data-l10n-name="learn-more-link">เรียนรู้เพิ่มเติม</a>
protections-close-button2 =
    .aria-label = ปิด
    .title = ปิด
mobile-app-title = ปิดกั้นตัวติดตามโฆษณาในอุปกรณ์อื่น ๆ
mobile-app-card-content = ใช้เบราว์เซอร์มือถือที่มีการป้องกันจากติดติดตามโฆษณา
mobile-app-links = เบราว์เซอร์ { -brand-product-name } สำหรับ <a data-l10n-name="android-mobile-inline-link">Android</a>และ<a data-l10n-name="ios-mobile-inline-link">iOS</a>
lockwise-title = จะไม่ลืมรหัสผ่านอีก
lockwise-title-logged-in2 = การจัดการรหัสผ่าน
lockwise-header-content = { -lockwise-brand-name } เก็บรหัสผ่านของคุณอย่างปลอดภัยในเบราว์เซอร์ของคุณ
lockwise-header-content-logged-in = เก็บและซิงค์รหัสผ่านของคุณกับอุปกรณ์ทั้งหมดอย่างปลอดภัย
protection-report-save-passwords-button = บันทึกรหัสผ่าน
    .title = บันทึกรหัสผ่านบน { -lockwise-brand-short-name }
protection-report-manage-passwords-button = จัดการรหัสผ่าน
    .title = จัดการรหัสผ่านบน { -lockwise-brand-short-name }
lockwise-mobile-app-title = นำรหัสผ่านของคุณไปทุกที่
lockwise-no-logins-card-content = ใช้รหัสผ่านที่บันทึกใน { -brand-short-name } บนอุปกรณ์อื่น
lockwise-app-links = { -lockwise-brand-name } สำหรับ <a data-l10n-name="lockwise-android-inline-link">Android</a>และ<a data-l10n-name="lockwise-ios-inline-link">iOS</a>
# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
       *[other] { $count } รหัสผ่านอาจถูกเปิดเผยในข้อมูลที่รั่วไหล
    }
# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
       *[other] รหัสผ่านของคุณถูกเก็บอย่างปลอดภัย
    }
lockwise-how-it-works-link = วิธีการทำงาน
turn-on-sync = เปิด { -sync-brand-short-name }…
    .title = ไปที่ค่ากำหนดการซิงค์
monitor-title = ให้เราช่วยคอยเฝ้าระวังดูการละเมิดข้อมูล
monitor-link = วิธีการทำงาน
monitor-header-content-no-account = ตรวจสอบ { -monitor-brand-name } เพื่อดูว่าคุณเป็นส่วนหนึ่งของการรั่วไหลข้อมูลหรือไม่ และรับการแจ้งเตือนเกี่ยวกับข้อมูลที่รั่วไหลใหม่
monitor-header-content-signed-in = { -monitor-brand-name } จะเตือนคุณหากข้อมูลของคุณปรากฏในการรั่วไหลข้อมูล
monitor-sign-up-link = ลงทะเบียนเพื่อรับการเตือนการรั่วไหล
    .title = ลงทะเบียนเพื่อรับการเตือนการรั่วไหลบน { -monitor-brand-name }
auto-scan = สแกนอัตโนมัติเมื่อวันนี้
monitor-emails-tooltip =
    .title = ดูที่อยู่อีเมลที่เฝ้าระวังบน { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = ดูข้อมูลที่รั่วไหลที่ทราบบน { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = ดูรหัสผ่านที่ถูกเปิดเผยบน { -monitor-brand-short-name }
# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
       *[other] ที่อยู่อีเมลที่ถูกตรวจสอบ
    }
# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
       *[other] การรั่วไหลของข้อมูลที่เรารู้เกิดขึ้นที่ได้เปิดเผยข้อมูลของคุณ
    }
# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
       *[other] ข้อมูลที่รั่วไหลที่พบถูกทำเครื่องหมายว่าแก้ไขแล้ว
    }
# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
       *[other] รหัสผ่านที่ถูกเปิดเผยในช่องโหว่ทั้งหมด
    }
# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
       *[other] รหัสผ่านที่ถูกเปิดเผยในข้อมูลที่รั่วไหลที่ยังไม่ถูกแก้ไข
    }
monitor-no-breaches-title = ข่าวดี!
monitor-no-breaches-description = คุณไม่มีการรั่วไหลที่พบ หากมีการเปลี่ยนแปลง เราจะแจ้งให้คุณทราบ
monitor-view-report-link = ดูรายงาน
    .title = แก้ไขการรั่วไหลบน { -monitor-brand-short-name }
monitor-breaches-unresolved-title = แก้ไขการรั่วไหลของคุณ
monitor-breaches-unresolved-description = หลังจากตรวจสอบรายละเอียดของการรั่วไหลและดำเนินการเพื่อปกป้องข้อมูลของคุณแล้ว คุณสามารถทำเครื่องหมายการรั่วไหลว่าแก้ไขแล้วได้
monitor-manage-breaches-link = จัดการการรั่วไหล
    .title = จัดการการรั่วไหลบน { -monitor-brand-short-name }
monitor-breaches-resolved-title = ดี! คุณได้แก้ไขการรั่วไหลที่พบทั้งหมดแล้ว
monitor-breaches-resolved-description = หากอีเมลของคุณปรากฏในการรั่วไหลใหม่ใด ๆ เราจะแจ้งให้คุณทราบ
# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
       *[other] { $numBreachesResolved } จาก { $numBreaches } การรั่วไหลถูกทำเครื่องหมายว่าแก้ไขแล้ว
    }
# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% เสร็จสมบูรณ์
monitor-partial-breaches-motivation-title-start = เริ่มต้นใช้งาน!
monitor-partial-breaches-motivation-title-middle = ทำต่อไป!
monitor-partial-breaches-motivation-title-end = เกือบเสร็จแล้ว! ทำต่อไป
monitor-partial-breaches-motivation-description = แก้ไขการรั่วไหลของคุณที่เหลือบน { -monitor-brand-short-name }
monitor-resolve-breaches-link = แก้ไขการรั่วไหล
    .title = แก้ไขการรั่วไหลบน { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = ตัวติดตามสังคมออนไลน์
    .aria-label =
        { $count ->
           *[other] { $count } ตัวติดตามสังคมออนไลน์ ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = คุกกี้ติดตามข้ามไซต์
    .aria-label =
        { $count ->
           *[other] { $count } คุกกี้ติดตามข้ามไซต์ ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = ตัวติดตามเนื้อหา
    .aria-label =
        { $count ->
           *[other] { $count } ตัวติดตามเนื้อหา ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = ลายนิ้วมือดิจิทัล
    .aria-label =
        { $count ->
           *[other] { $count } ลายนิ้วมือดิจิทัล ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = ตัวขุดเหรียญดิจิทัล
    .aria-label =
        { $count ->
           *[other] { $count } ตัวขุดเหรียญดิจิทัล ({ $percentage }%)
        }
