# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = เปิดหน้าต่างส่วนตัว
    .accesskey = ส
about-private-browsing-search-placeholder = ค้นหาเว็บ
about-private-browsing-info-title = คุณอยู่ในหน้าต่างส่วนตัว
about-private-browsing-search-btn =
    .title = ค้นหาเว็บ
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = ค้นหาด้วย { $engine } หรือป้อนที่อยู่
about-private-browsing-handoff-no-engine =
    .title = ค้นหาหรือป้อนที่อยู่
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = ค้นหาด้วย { $engine } หรือป้อนที่อยู่
about-private-browsing-handoff-text-no-engine = ค้นหาหรือป้อนที่อยู่
about-private-browsing-not-private = ขณะนี้คุณไม่ได้อยู่ในหน้าต่างส่วนตัว
about-private-browsing-info-description-private-window = หน้าต่างส่วนตัว: { -brand-short-name } จะล้างประวัติการค้นหาและการเรียกดูของคุณเมื่อคุณปิดหน้าต่างส่วนตัวทั้งหมด แต่จะไม่สามารถปกปิดตัวตนของคุณได้
about-private-browsing-info-description-simplified = { -brand-short-name } จะล้างประวัติการค้นหาและการเรียกดูของคุณเมื่อคุณปิดหน้าต่างส่วนตัวทั้งหมด แต่จะไม่สามารถปกปิดตัวตนของคุณได้
about-private-browsing-learn-more-link = เรียนรู้เพิ่มเติม

about-private-browsing-hide-activity = ซ่อนกิจกรรมและตำแหน่งที่ตั้งของคุณในทุกที่ที่คุณเรียกดู
about-private-browsing-get-privacy = รับการปกป้องความเป็นส่วนตัวในทุกที่ที่คุณเรียกดู
about-private-browsing-hide-activity-1 = ซ่อนกิจกรรมการเรียกดูและตำแหน่งที่ตั้งด้วย { -mozilla-vpn-brand-name } สร้างการเชื่อมต่อที่ปลอดภัยในคลิกเดียวแม้ใช้ Wi-Fi สาธารณะ
about-private-browsing-prominent-cta = เป็นส่วนตัวอยู่เสมอด้วย { -mozilla-vpn-brand-name }

about-private-browsing-focus-promo-cta = ดาวน์โหลด { -focus-brand-name }
about-private-browsing-focus-promo-header = { -focus-brand-name }: การท่องเว็บแบบส่วนตัวขณะเดินทาง
about-private-browsing-focus-promo-text = แอพมือถือสำหรับการท่องเว็บแบบส่วนตัวของเราจะล้างประวัติและคุกกี้ของคุณทุกครั้ง

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = ท่องเว็บแบบส่วนตัวบนโทรศัพท์ของคุณ
about-private-browsing-focus-promo-text-b = ใช้ { -focus-brand-name } สำหรับการค้นหาส่วนตัวที่คุณไม่ต้องการให้เบราว์เซอร์มือถือหลักของคุณเห็น
about-private-browsing-focus-promo-header-c = ความเป็นส่วนตัวระดับถัดไปบนมือถือ
about-private-browsing-focus-promo-text-c = { -focus-brand-name } ล้างประวัติของคุณทุกครั้งในขณะที่ปิดกั้นโฆษณาและตัวติดตาม

# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } เป็นเครื่องมือค้นหาเริ่มต้นของคุณในหน้าต่างส่วนตัว
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] เพื่อเลือกเครื่องมือค้นหาอื่นให้ไปยัง <a data-l10n-name="link-options">ตัวเลือก</a>
       *[other] เพื่อเลือกเครื่องมือค้นหาอื่นให้ไปยัง <a data-l10n-name="link-options">การกำหนดลักษณะ</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = ปิด

about-private-browsing-promo-close-button =
    .title = ปิด
