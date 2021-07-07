# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (การเรียกดูแบบส่วนตัว)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (การเรียกดูแบบส่วนตัว)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox — (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } - (การเรียกดูแบบส่วนตัว)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (การเรียกดูแบบส่วนตัว)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = ดูข้อมูลไซต์

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = เปิดแผงข้อความการติดตั้ง
urlbar-web-notification-anchor =
    .tooltiptext = เลือกว่าคุณสามารถรับการแจ้งเตือนจากไซต์ได้หรือไม่
urlbar-midi-notification-anchor =
    .tooltiptext = เปิดแผง MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = จัดการการใช้ซอฟต์แวร์ DRM
urlbar-web-authn-anchor =
    .tooltiptext = เปิดแผง ​Web Authentication
urlbar-canvas-notification-anchor =
    .tooltiptext = จัดการสิทธิอนุญาตการส่งออกผืนผ้าใบ
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = จัดการการแบ่งปันไมโครโฟนของคุณกับไซต์
urlbar-default-notification-anchor =
    .tooltiptext = เปิดแผงข้อความ
urlbar-geolocation-notification-anchor =
    .tooltiptext = เปิดแผงคำขอตำแหน่งที่ตั้ง
urlbar-xr-notification-anchor =
    .tooltiptext = เปิดแผงสิทธิอนุญาตความจริงเสมือน
urlbar-storage-access-anchor =
    .tooltiptext = เปิดแผงสิทธิอนุญาตกิจกรรมการเรียกดู
urlbar-translate-notification-anchor =
    .tooltiptext = แปลหน้านี้
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = จัดการการแบ่งปันหน้าต่างหรือหน้าจอของคุณกับไซต์
urlbar-indexed-db-notification-anchor =
    .tooltiptext = เปิดแผงข้อความที่เก็บข้อมูลออฟไลน์
urlbar-password-notification-anchor =
    .tooltiptext = เปิดแผงข้อความบันทึกรหัสผ่าน
urlbar-translated-notification-anchor =
    .tooltiptext = จัดการการแปลหน้านี้
urlbar-plugins-notification-anchor =
    .tooltiptext = จัดการการใช้ปลั๊กอิน
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = จัดการการแบ่งปันกล้องและ/หรือไมโครโฟนของคุณกับไซต์
urlbar-autoplay-notification-anchor =
    .tooltiptext = เปิดแผงการเล่นอัตโนมัติ
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = จัดเก็บข้อมูลในที่เก็บข้อมูลถาวร
urlbar-addons-notification-anchor =
    .tooltiptext = เปิดแผงข้อความการติดตั้งส่วนเสริม
urlbar-tip-help-icon =
    .title = รับความช่วยเหลือ
urlbar-search-tips-confirm = ตกลง เข้าใจแล้ว
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = เคล็ดลับ:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = พิมพ์น้อยลง ค้นหามากขึ้น: ค้นหา { $engineName } โดยตรงจากแถบที่อยู่ของคุณ
urlbar-search-tips-redirect-2 = เริ่มการค้นหาของคุณในแถบที่อยู่เพื่อดูข้อเสนอแนะจาก { $engineName } และประวัติการเรียกดูของคุณ
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = เลือกทางลัดนี้เพื่อค้นหาสิ่งที่คุณต้องการได้เร็วขึ้น

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = ที่คั่นหน้า
urlbar-search-mode-tabs = แท็บ
urlbar-search-mode-history = ประวัติ

##

urlbar-geolocation-blocked =
    .tooltiptext = คุณได้ปิดกั้นข้อมูลตำแหน่งที่ตั้งสำหรับเว็บไซต์นี้
urlbar-xr-blocked =
    .tooltiptext = คุณได้ปิดกั้นการเข้าถึงอุปกรณ์ความจริงเสมือนสำหรับเว็บไซต์นี้
urlbar-web-notifications-blocked =
    .tooltiptext = คุณได้ปิดกั้นการแจ้งเตือนสำหรับเว็บไซต์นี้
urlbar-camera-blocked =
    .tooltiptext = คุณได้ปิดกั้นกล้องของคุณสำหรับเว็บไซต์นี้
urlbar-microphone-blocked =
    .tooltiptext = คุณได้ปิดกั้นไมโครโฟนของคุณสำหรับเว็บไซต์นี้
urlbar-screen-blocked =
    .tooltiptext = คุณได้ปิดกั้นเว็บไซต์นี้จากการแบ่งปันหน้าจอของคุณ
urlbar-persistent-storage-blocked =
    .tooltiptext = คุณได้ปิดกั้นที่เก็บข้อมูลถาวรสำหรับเว็บไซต์นี้
urlbar-popup-blocked =
    .tooltiptext = คุณได้ปิดกั้นป๊อปอัปสำหรับเว็บไซต์นี้
urlbar-autoplay-media-blocked =
    .tooltiptext = คุณได้ปิดกั้นการเล่นสื่อพร้อมเสียงโดยอัตโนมัติสำหรับเว็บไซต์นี้
urlbar-canvas-blocked =
    .tooltiptext = คุณได้ปิดกั้นการส่งออกข้อมูลผืนผ้าใบสำหรับเว็บไซต์นี้
urlbar-midi-blocked =
    .tooltiptext = คุณได้ปิดกั้นการเข้าถึง MIDI สำหรับเว็บไซต์นี้
urlbar-install-blocked =
    .tooltiptext = คุณได้ปิดกั้นการติดตั้งส่วนเสริมสำหรับเว็บไซต์นี้
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = แก้ไขที่คั่นหน้านี้ ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = เพิ่มที่คั่นหน้าสำหรับหน้านี้ ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = เพิ่มลงในแถบที่อยู่
page-action-manage-extension =
    .label = จัดการส่วนขยาย…
page-action-remove-from-urlbar =
    .label = เอาออกจากแถบที่อยู่
page-action-remove-extension =
    .label = เอาส่วนขยายออก

## Page Action menu

# Variables
# $tabCount (integer) - Number of tabs selected
page-action-send-tabs-panel =
    .label = ส่ง { $tabCount } แท็บไปยังอุปกรณ์
page-action-send-tabs-urlbar =
    .tooltiptext = ส่ง { $tabCount } แท็บไปยังอุปกรณ์
page-action-copy-url-panel =
    .label = คัดลอกลิงก์
page-action-copy-url-urlbar =
    .tooltiptext = คัดลอกลิงก์
page-action-email-link-panel =
    .label = ส่งอีเมลลิงก์…
page-action-email-link-urlbar =
    .tooltiptext = ส่งอีเมลลิงก์…
page-action-share-url-panel =
    .label = แบ่งปัน
page-action-share-url-urlbar =
    .tooltiptext = แบ่งปัน
page-action-share-more-panel =
    .label = เพิ่มเติม…
page-action-send-tab-not-ready =
    .label = กำลังซิงค์อุปกรณ์…
# "Pin" is being used as a metaphor for expressing the fact that these tabs
# are "pinned" to the left edge of the tabstrip. Really we just want the
# string to express the idea that this is a lightweight and reversible
# action that keeps your tab where you can reach it easily.
page-action-pin-tab-panel =
    .label = ปักหมุดแท็บ
page-action-pin-tab-urlbar =
    .tooltiptext = ปักหมุดแท็บ
page-action-unpin-tab-panel =
    .label = ถอนหมุดแท็บ
page-action-unpin-tab-urlbar =
    .tooltiptext = ถอนหมุดแท็บ

## Auto-hide Context Menu

full-screen-autohide =
    .label = ซ่อนแถบเครื่องมือ
    .accesskey = น
full-screen-exit =
    .label = ออกจากโหมดเต็มหน้าจอ
    .accesskey = จ

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = คราวนี้ค้นหาด้วย:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = เปลี่ยนการตั้งค่าการค้นหา
search-one-offs-change-settings-compact-button =
    .tooltiptext = เปลี่ยนการตั้งค่าการค้นหา
search-one-offs-context-open-new-tab =
    .label = ค้นหาในแท็บใหม่
    .accesskey = ค
search-one-offs-context-set-as-default =
    .label = ตั้งเป็นเครื่องมือค้นหาเริ่มต้น
    .accesskey = ต
search-one-offs-context-set-as-default-private =
    .label = ตั้งเป็นเครื่องมือค้นหาเริ่มต้นสำหรับหน้าต่างส่วนตัว
    .accesskey = ส
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })
# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = เพิ่ม “{ $engineName }”
    .tooltiptext = เพิ่มเครื่องมือค้นหา “{ $engineName }”
    .aria-label = เพิ่มเครื่องมือค้นหา “{ $engineName }”
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = เพิ่มเครื่องมือค้นหา

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = ที่คั่นหน้า ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = แท็บ ({ $restrict })
search-one-offs-history =
    .tooltiptext = ประวัติ ({ $restrict })

## Bookmark Panel

bookmarks-add-bookmark = เพิ่มที่คั่นหน้า
bookmarks-edit-bookmark = แก้ไขที่คั่นหน้า
bookmark-panel-cancel =
    .label = ยกเลิก
    .accesskey = ย
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label = เอา { $count } ที่คั่นหน้าออก
    .accesskey = อ
bookmark-panel-show-editor-checkbox =
    .label = แสดงตัวแก้ไขเมื่อบันทึก
    .accesskey = ส
bookmark-panel-done-button =
    .label = เสร็จสิ้น
bookmark-panel-save-button =
    .label = บันทึก
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = ข้อมูลไซต์สำหรับ { $host }
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = ความปลอดภัยของการเชื่อมต่อสำหรับ { $host }
identity-connection-not-secure = การเชื่อมต่อไม่ปลอดภัย
identity-connection-secure = การเชื่อมต่อปลอดภัย
identity-connection-failure = การเชื่อมต่อล้มเหลว
identity-connection-internal = นี่คือหน้า { -brand-short-name } ที่ปลอดภัย
identity-connection-file = หน้านี้ถูกจัดเก็บไว้ในคอมพิวเตอร์ของคุณ
identity-extension-page = หน้านี้ถูกโหลดจากส่วนขยาย
identity-active-blocked = { -brand-short-name } ได้ปิดกั้นบางส่วนของหน้านี้ที่ไม่ปลอดภัย
identity-custom-root = การเชื่อมต่อถูกตรวจสอบโดยผู้ออกใบรับรองที่ Mozilla ไม่รู้จัก
identity-passive-loaded = บางส่วนของหน้านี้ไม่ปลอดภัย (อย่างเช่น ภาพ)
identity-active-loaded = คุณได้ปิดใช้งานการป้องกันในหน้านี้
identity-weak-encryption = หน้านี้ใช้การเข้ารหัสที่อ่อนแอ
identity-insecure-login-forms = การเข้าสู่ระบบที่ป้อนบนหน้านี้อาจถูกบุกรุกได้
identity-permissions =
    .value = สิทธิอนุญาต
identity-https-only-connection-upgraded = (อัปเกรดเป็น HTTPS)
identity-https-only-label = โหมด HTTPS-Only
identity-https-only-dropdown-on =
    .label = เปิด
identity-https-only-dropdown-off =
    .label = ปิด
identity-https-only-dropdown-off-temporarily =
    .label = ปิดชั่วคราว
identity-https-only-info-turn-on2 = เปิดโหมด HTTPS-Only หากคุณต้องการให้ { -brand-short-name } อัปเกรดการเชื่อมต่อเมื่อเป็นไปได้
identity-https-only-info-turn-off2 = หากหน้าดูเหมือนจะพัง คุณอาจต้องปิดโหมด HTTPS-Only สำหรับไซต์นี้เพื่อโหลดใหม่โดยใช้ HTTP ที่ไม่ปลอดภัย
identity-https-only-info-no-upgrade = ไม่สามารถอัปเกรดการเชื่อมต่อจาก HTTP ได้
identity-permissions-storage-access-header = คุกกี้ข้ามไซต์
identity-permissions-storage-access-hint = บุคคลเหล่านี้สามารถใช้คุกกี้ข้ามไซต์และข้อมูลไซต์ในขณะที่คุณอยู่บนไซต์นี้ได้
identity-permissions-storage-access-learn-more = เรียนรู้เพิ่มเติม
identity-permissions-reload-hint = คุณอาจจำเป็นต้องโหลดหน้าใหม่เพื่อให้การเปลี่ยนแปลงมีผล
identity-permissions-empty = คุณไม่ได้อนุญาตไซต์นี้ด้วยสิทธิอนุญาตพิเศษใด ๆ
identity-clear-site-data =
    .label = ล้างคุกกี้และข้อมูลไซต์…
identity-connection-not-secure-security-view = คุณไม่ได้เชื่อมต่ออย่างปลอดภัยไปยังไซต์นี้
identity-connection-verified = คุณได้เชื่อมต่ออย่างปลอดภัยไปยังไซต์นี้
identity-ev-owner-label = ออกใบรับรองให้กับ:
identity-description-custom-root = Mozilla ไม่รู้จักผู้ออกใบรับรองนี้ ซึ่งอาจถูกเพิ่มจากระบบปฏิบัติการของคุณหรือโดยผู้ดูแลระบบ <label data-l10n-name="link">เรียนรู้เพิ่มเติม</label>
identity-remove-cert-exception =
    .label = เอาข้อยกเว้นออก
    .accesskey = อ
identity-description-insecure = การเชื่อมต่อของคุณไปยังไซต์นี้ไม่เป็นส่วนตัว ข้อมูลที่คุณแบ่งปันกับไซต์นี้สามารถดูได้โดยผู้อื่น (เช่น รหัสผ่าน, ข้อความ, บัตรเครดิต ฯลฯ)
identity-description-insecure-login-forms = การเข้าสู่ระบบที่คุณป้อนบนหน้านี้ไม่ปลอดภัยและอาจถูกบุกรุกได้
identity-description-weak-cipher-intro = การเชื่อมต่อของคุณไปยังเว็บไซต์นี้ใช้การเข้ารหัสที่อ่อนแอและไม่เป็นส่วนตัว
identity-description-weak-cipher-risk = ผู้คนอื่น ๆ สามารถดูข้อมูลของคุณหรือเปลี่ยนแปลงลักษณะการทำงานของเว็บไซต์
identity-description-active-blocked = { -brand-short-name } ได้ปิดกั้นบางส่วนของหน้านี้ที่ไม่ปลอดภัย <label data-l10n-name="link">เรียนรู้เพิ่มเติม</label>
identity-description-passive-loaded = การเชื่อมต่อของคุณไม่เป็นส่วนตัวและข้อมูลที่คุณแบ่งปันกับเว็บไซต์คนอื่นสามารถดูได้
identity-description-passive-loaded-insecure = เว็บไซต์นี้มีเนื้อหาที่ไม่ปลอดภัย (อย่างเช่น ภาพ) <label data-l10n-name="link">เรียนรู้เพิ่มเติม</label>
identity-description-passive-loaded-mixed = ถึงแม้ว่า { -brand-short-name } ได้ปิดกั้นเนื้อหาบางส่วน แต่ก็ยังคงมีเนื้อหาในหน้าที่ไม่ปลอดภัย (อย่างเช่น ภาพ) <label data-l10n-name="link">เรียนรู้เพิ่มเติม</label>
identity-description-active-loaded = เว็บไซต์นี้ประกอบด้วยเนื้อหาที่เชื่อถือไม่ได้ (เช่น สคริปต์) และการเชื่อมต่อไปยังไซต์ก็ไม่เป็นส่วนตัว
identity-description-active-loaded-insecure = ข้อมูลที่คุณแบ่งปันกับไซต์นี้สามารถดูได้โดยผู้อื่น (เช่น รหัสผ่าน, ข้อความ, บัตรเครดิต ฯลฯ)
identity-learn-more =
    .value = เรียนรู้เพิ่มเติม
identity-disable-mixed-content-blocking =
    .label = ปิดใช้งานการป้องกันในตอนนี้
    .accesskey = ป
identity-enable-mixed-content-blocking =
    .label = เปิดใช้งานการป้องกัน
    .accesskey = ป
identity-more-info-link-text =
    .label = ข้อมูลเพิ่มเติม

## Window controls

browser-window-minimize-button =
    .tooltiptext = ย่อ
browser-window-maximize-button =
    .tooltiptext = ขยาย
browser-window-restore-down-button =
    .tooltiptext = คืนค่าลงล่าง
browser-window-close-button =
    .tooltiptext = ปิด

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = กำลังเล่น
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = ปิดเสียงอยู่
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = การเล่นอัตโนมัติถูกปิดกั้น
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = ภาพที่เล่นควบคู่

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] ปิดเสียงแท็บ
       *[other] ปิดเสียง { $count } แท็บ
    }
browser-tab-unmute =
    { $count ->
        [1] เลิกปิดเสียงแท็บ
       *[other] เลิกปิดเสียง { $count } แท็บ
    }
browser-tab-unblock =
    { $count ->
        [1] เล่นแท็บ
       *[other] เล่น { $count } แท็บ
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = นำเข้าที่คั่นหน้า…
    .tooltiptext = นำเข้าที่คั่นหน้าจากเบราว์เซอร์อื่นมายัง { -brand-short-name }
bookmarks-toolbar-empty-message = วางที่คั่นหน้าของคุณไว้ที่นี่บนแถบเครื่องมือที่คั่นหน้าเพื่อให้เข้าถึงได้อย่างรวดเร็ว <a data-l10n-name="manage-bookmarks">จัดการที่คั่นหน้า…</a>

## WebRTC Pop-up notifications

popup-select-camera =
    .value = กล้องที่แบ่งปัน:
    .accesskey = ก
popup-select-microphone =
    .value = ไมโครโฟนที่แบ่งปัน:
    .accesskey = ม
popup-select-camera-device =
    .value = กล้อง:
    .accesskey = ก
popup-select-camera-icon =
    .tooltiptext = กล้อง
popup-select-microphone-device =
    .value = ไมโครโฟน:
    .accesskey = ม
popup-select-microphone-icon =
    .tooltiptext = ไมโครโฟน
popup-select-speaker-icon =
    .tooltiptext = ลำโพง
popup-all-windows-shared = หน้าต่างที่ปรากฏอยู่ทั้งหมดบนหน้าจอของคุณจะถูกแบ่งปัน
popup-screen-sharing-not-now =
    .label = ไม่ใช่ตอนนี้
    .accesskey = w
popup-screen-sharing-never =
    .label = ไม่อนุญาตเสมอ
    .accesskey = ม
popup-silence-notifications-checkbox = ปิดใช้งานการแจ้งเตือนจาก { -brand-short-name } ขณะที่แบ่งปัน
popup-silence-notifications-checkbox-warning = { -brand-short-name } จะไม่แสดงการแจ้งเตือนขณะที่คุณกำลังแบ่งปัน
popup-screen-sharing-block =
    .label = ปิดกั้น
    .accesskey = ป
popup-screen-sharing-always-block =
    .label = ปิดกั้นเสมอ
    .accesskey = ส
popup-mute-notifications-checkbox = ปิดเสียงการแจ้งเตือนเว็บไซต์ขณะแบ่งปัน

## WebRTC window or screen share tab switch warning

sharing-warning-window = คุณกำลังแบ่งปัน { -brand-short-name } คนอื่น ๆ สามารถเห็นได้เมื่อคุณสลับไปยังแท็บใหม่
sharing-warning-screen = คุณกำลังแบ่งปันทั้งหน้าจอของคุณ คนอื่น ๆ สามารถเห็นได้เมื่อคุณสลับไปยังแท็บใหม่
sharing-warning-proceed-to-tab =
    .label = ไปยังแท็บต่อ
sharing-warning-disable-for-session =
    .label = ปิดใช้งานการป้องกันการแบ่งปันในวาระนี้

## DevTools F12 popup

enable-devtools-popup-description = หากต้องการใช้ทางลัด F12 ให้เปิด DevTools ก่อนผ่านเมนู Web Developer

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = ค้นหาหรือป้อนที่อยู่
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = ค้นหาหรือป้อนที่อยู่
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = ค้นหาเว็บ
    .aria-label = ค้นหาด้วย { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = ป้อนคำค้นหา
    .aria-label = ค้นหา { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = ป้อนคำค้นหา
    .aria-label = ค้นหาที่คั่นหน้า
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = ป้อนคำค้นหา
    .aria-label = ค้นหาประวัติ
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = ป้อนคำค้นหา
    .aria-label = ค้นหาแท็บ
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = ค้นหาด้วย { $name } หรือป้อนที่อยู่
urlbar-remote-control-notification-anchor =
    .tooltiptext = เบราว์เซอร์อยู่ภายใต้การควบคุมระยะไกล
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = เบราว์เซอร์อยู่ภายใต้การควบคุมระยะไกล (เหตุผล: { $component })
urlbar-permissions-granted =
    .tooltiptext = คุณได้อนุญาตไซต์นี้ด้วยสิทธิเพิ่มเติม
urlbar-switch-to-tab =
    .value = สลับไปยังแท็บ:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = ส่วนขยาย:
urlbar-go-button =
    .tooltiptext = ไปยังที่อยู่ในแถบตำแหน่งที่ตั้ง
urlbar-page-action-button =
    .tooltiptext = การกระทำหน้า
urlbar-pocket-button =
    .tooltiptext = บันทึกไปยัง { -pocket-brand-name }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = ค้นหาด้วย { $engine } ในหน้าต่างส่วนตัว
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = ค้นหาในหน้าต่างส่วนตัว
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = ค้นหาด้วย { $engine }
urlbar-result-action-sponsored = ได้รับการสนับสนุน
urlbar-result-action-switch-tab = สลับไปยังแท็บ
urlbar-result-action-visit = เยี่ยมชม
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = กด Tab เพื่อค้นหาด้วย { $engine }
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = กด Tab เพื่อค้นหา { $engine }
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = ค้นหาด้วย { $engine } โดยตรงจากแถบที่อยู่
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = ค้นหา { $engine } โดยตรงจากแถบที่อยู่
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = คัดลอก
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = ค้นหาที่คั่นหน้า
urlbar-result-action-search-history = ค้นหาประวัติ
urlbar-result-action-search-tabs = ค้นหาแท็บ

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> เต็มหน้าจออยู่
fullscreen-warning-no-domain = เอกสารนี้เต็มหน้าจออยู่
fullscreen-exit-button = ออกจากภาพเต็มหน้าจอ (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = ออกจากภาพเต็มหน้าจอ (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ได้ควบคุมตัวชี้ของคุณ กด Esc เพื่อดึงการควบคุมคืน
pointerlock-warning-no-domain = เอกสารชิ้นนี้ได้ควบคุมตัวชี้ของคุณ กด Esc เพื่อดึงการควบคุมคืน

## Subframe crash notification

crashed-subframe-message = <strong>เนื้อหาบางส่วนของหน้านี้ขัดข้อง</strong> หากต้องการแจ้งให้ { -brand-product-name } ทราบเกี่ยวกับปัญหานี้เพื่อให้ได้รับการแก้ไขเร็วขึ้น โปรดส่งรายงาน
crashed-subframe-learnmore-link =
    .value = เรียนรู้เพิ่มเติม
crashed-subframe-submit =
    .label = ส่งรายงาน
    .accesskey = ส

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = จัดการที่คั่นหน้า
bookmarks-recent-bookmarks-panel-subheader = ที่คั่นหน้าล่าสุด
bookmarks-toolbar-chevron =
    .tooltiptext = แสดงที่คั่นหน้าเพิ่มเติม
bookmarks-sidebar-content =
    .aria-label = ที่คั่นหน้า
bookmarks-menu-button =
    .label = เมนูที่คั่นหน้า
bookmarks-other-bookmarks-menu =
    .label = ที่คั่นหน้าอื่น ๆ
bookmarks-mobile-bookmarks-menu =
    .label = ที่คั่นหน้าในมือถือ
bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] ซ่อนแถบข้างที่คั่นหน้า
           *[other] ดูแถบข้างที่คั่นหน้า
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] ซ่อนแถบเครื่องมือที่คั่นหน้า
           *[other] ดูแถบเครื่องมือที่คั่นหน้า
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] ซ่อนแถบเครื่องมือที่คั่นหน้า
           *[other] แสดงแถบเครื่องมือที่คั่นหน้า
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] เอาเมนูที่คั่นหน้าออกจากแถบเครื่องมือ
           *[other] เพิ่มเมนูที่คั่นหน้าไปยังแถบเครื่องมือ
        }
bookmarks-search =
    .label = ค้นหาที่คั่นหน้า
bookmarks-tools =
    .label = เครื่องมือที่คั่นหน้า
bookmarks-bookmark-edit-panel =
    .label = แก้ไขที่คั่นหน้านี้
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = แถบเครื่องมือที่คั่นหน้า
    .accesskey = บ
    .aria-label = ที่คั่นหน้า
bookmarks-toolbar-menu =
    .label = แถบเครื่องมือที่คั่นหน้า
bookmarks-toolbar-placeholder =
    .title = รายการแถบเครื่องมือที่คั่นหน้า
bookmarks-toolbar-placeholder-button =
    .label = รายการแถบเครื่องมือที่คั่นหน้า
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-current-tab =
    .label = เพิ่มที่คั่นหน้าแท็บปัจจุบัน

## Library Panel items

library-bookmarks-menu =
    .label = ที่คั่นหน้า
library-recent-activity-title =
    .value = กิจกรรมล่าสุด

## Pocket toolbar button

save-to-pocket-button =
    .label = บันทึกไปยัง { -pocket-brand-name }
    .tooltiptext = บันทึกไปยัง { -pocket-brand-name }

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = ซ่อมแซมรหัสอักขระข้อความ
    .tooltiptext = คาดเดารหัสอักขระข้อความที่ถูกต้องจากเนื้อหาในหน้า

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open the add-ons manager
toolbar-addons-themes-button =
    .label = ส่วนเสริมและชุดตกแต่ง
    .tooltiptext = จัดการส่วนเสริมและชุดตกแต่งของคุณ ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = การตั้งค่า
    .tooltiptext =
        { PLATFORM() ->
            [macos] เปิดการตั้งค่า ({ $shortcut })
           *[other] เปิดการตั้งค่า
        }

## More items

more-menu-go-offline =
    .label = ทำงานออฟไลน์
    .accesskey = ฟ

## EME notification panel

eme-notifications-drm-content-playing = เสียงหรือวิดีโอบางส่วนในไซต์นี้ใช้ซอฟต์แวร์ DRM ซึ่งอาจจะจำกัดสิ่งที่ { -brand-short-name } สามารถให้คุณทำได้
eme-notifications-drm-content-playing-manage = จัดการการตั้งค่า
eme-notifications-drm-content-playing-manage-accesskey = จ
eme-notifications-drm-content-playing-dismiss = ปิด
eme-notifications-drm-content-playing-dismiss-accesskey = ด

## Password save/update panel

panel-save-update-username = ชื่อผู้ใช้
panel-save-update-password = รหัสผ่าน

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = ต้องการเอา { $name } ออกหรือไม่?
addon-removal-abuse-report-checkbox = รายงานส่วนขยายนี้ไปยัง { -vendor-short-name }

## Remote / Synced tabs

remote-tabs-manage-account =
    .label = จัดการบัญชี
remote-tabs-sync-now = ซิงค์ตอนนี้
