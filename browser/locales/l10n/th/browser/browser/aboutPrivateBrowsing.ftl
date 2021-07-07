# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = เปิดหน้าต่างส่วนตัว
    .accesskey = ส
about-private-browsing-search-placeholder = ค้นหาเว็บ
about-private-browsing-info-title = คุณอยู่ในหน้าต่างส่วนตัว
about-private-browsing-info-myths = ความเข้าใจผิดที่พบบ่อยเกี่ยวกับการท่องเว็บแบบส่วนตัว
about-private-browsing =
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
about-private-browsing-info-description = { -brand-short-name } จะล้างประวัติการค้นหาและประวัติการท่องเว็บของคุณเมื่อคุณออกจากแอปหรือปิดแท็บและหน้าต่างการท่องเว็บแบบส่วนตัวทั้งหมด แม้ว่าสิ่งนี้จะไม่ทำให้คุณปิดบังตัวตนกับเว็บไซต์หรือผู้ให้บริการอินเทอร์เน็ตของคุณ แต่จะทำให้การรักษาความเป็นส่วนตัวของสิ่งที่คุณทำออนไลน์จากผู้อื่นที่ใช้คอมพิวเตอร์เครื่องนี้ง่ายขึ้น
about-private-browsing-need-more-privacy = ต้องการความเป็นส่วนตัวมากขึ้น?
about-private-browsing-turn-on-vpn = ลองใช้ { -mozilla-vpn-brand-name }
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } เป็นเครื่องมือค้นหาเริ่มต้นของคุณในหน้าต่างส่วนตัว
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] หากต้องการเลือกเครื่องมือค้นหาอื่นให้ไปที่ <a data-l10n-name="link-options">ตัวเลือก</a>
       *[other] หากต้องการเลือกเครื่องมือค้นหาอื่นให้ไปที่ <a data-l10n-name="link-options">ค่ากำหนด</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = ปิด
