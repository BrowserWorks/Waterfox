# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = ตัวจัดการส่วนเสริม
addons-page-title = ตัวจัดการส่วนเสริม
search-header =
    .placeholder = ค้นหา addons.mozilla.org
    .searchbuttonlabel = ค้นหา
search-header-shortcut =
    .key = f
list-empty-get-extensions-message = รับส่วนขยายและชุดตกแต่งบน <a data-l10n-name="get-extensions">{ $domain }</a>
list-empty-installed =
    .value = คุณไม่ได้ติดตั้งส่วนเสริมประเภทนี้ไว้
list-empty-available-updates =
    .value = ไม่พบการอัปเดต
list-empty-recent-updates =
    .value = คุณไม่ได้อัปเดตส่วนเสริมใด ๆ เมื่อเร็ว ๆ นี้
list-empty-find-updates =
    .label = ตรวจสอบการอัปเดต
list-empty-button =
    .label = เรียนรู้เพิ่มเติมเกี่ยวกับส่วนเสริม
help-button = การสนับสนุนของส่วนเสริม
sidebar-help-button-title =
    .title = การสนับสนุนของส่วนเสริม
preferences =
    { PLATFORM() ->
        [windows] ตัวเลือก { -brand-short-name }
       *[other] ค่ากำหนด { -brand-short-name }
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] ตัวเลือก { -brand-short-name }
           *[other] ค่ากำหนด { -brand-short-name }
        }
addons-settings-button = การตั้งค่า { -brand-short-name }
sidebar-settings-button-title =
    .title = การตั้งค่า { -brand-short-name }
show-unsigned-extensions-button =
    .label = ไม่สามารถยืนยันส่วนขยายบางตัว
show-all-extensions-button =
    .label = แสดงส่วนขยายทั้งหมด
cmd-show-details =
    .label = แสดงข้อมูลเพิ่มเติม
    .accesskey = ส
cmd-find-updates =
    .label = ค้นหาการอัปเดต
    .accesskey = น
cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] ตัวเลือก
           *[other] ค่ากำหนด
        }
    .accesskey =
        { PLATFORM() ->
            [windows] ต
           *[other] ค
        }
cmd-enable-theme =
    .label = ใช้ชุดตกแต่ง
    .accesskey = ช
cmd-disable-theme =
    .label = เลิกใช้ชุดตกแต่ง
    .accesskey = ช
cmd-install-addon =
    .label = ติดตั้ง
    .accesskey = ต
cmd-contribute =
    .label = มีส่วนร่วม
    .accesskey = ม
    .tooltiptext = มีส่วนร่วมกับการพัฒนาส่วนเสริมนี้
detail-version =
    .label = รุ่น
detail-last-updated =
    .label = อัปเดตล่าสุด
detail-contributions-description = นักพัฒนาส่วนเสริมนี้ใคร่ขอให้คุณช่วยสนับสนุนการพัฒนาอย่างต่อเนื่องโดยการสมทบทุนสักเล็กน้อย
detail-contributions-button = มีส่วนร่วม
    .title = มีส่วนร่วมกับการพัฒนาส่วนเสริมนี้
    .accesskey = ม
detail-update-type =
    .value = การอัปเดตอัตโนมัติ
detail-update-default =
    .label = ค่าเริ่มต้น
    .tooltiptext = ติดตั้งการอัปเดตโดยอัตโนมัติเฉพาะเมื่อเป็นค่าเริ่มต้น
detail-update-automatic =
    .label = เปิด
    .tooltiptext = ติดตั้งการอัปเดตโดยอัตโนมัติ
detail-update-manual =
    .label = ปิด
    .tooltiptext = ไม่ติดตั้งการอัปเดตโดยอัตโนมัติ
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = เรียกใช้ในหน้าต่างส่วนตัว
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = ไม่อนุญาตในหน้าต่างส่วนตัว
detail-private-disallowed-description2 = ส่วนขยายนี้จะไม่ทำงานในขณะที่เรียกดูแบบส่วนตัว<a data-l10n-name="learn-more">เรียนรู้เพิ่มเติม</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = จำเป็นต้องเข้าถึงหน้าต่างแบบส่วนตัว
detail-private-required-description2 = ส่วนขยายนี้สามารถเข้าถึงกิจกรรมออนไลน์ของคุณในขณะที่เรียกดูแบบส่วนตัว<a data-l10n-name="learn-more">เรียนรู้เพิ่มเติม</a>
detail-private-browsing-on =
    .label = อนุญาต
    .tooltiptext = เปิดใช้งานในการเรียกดูแบบส่วนตัว
detail-private-browsing-off =
    .label = ไม่อนุญาต
    .tooltiptext = ปิดใช้งานในการเรียกดูแบบส่วนตัว
detail-home =
    .label = หน้าแรก
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = โปรไฟล์ส่วนเสริม
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = ตรวจสอบการอัปเดต
    .accesskey = ต
    .tooltiptext = ตรวจสอบการอัปเดตสำหรับส่วนเสริมนี้
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] ตัวเลือก
           *[other] ค่ากำหนด
        }
    .accesskey =
        { PLATFORM() ->
            [windows] ต
           *[other] ค
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] เปลี่ยนตัวเลือกของส่วนเสริมนี้
           *[other] เปลี่ยนค่ากำหนดของส่วนเสริมนี้
        }
detail-rating =
    .value = การจัดอันดับ
addon-restart-now =
    .label = เริ่มการทำงานใหม่ตอนนี้
disabled-unsigned-heading =
    .value = ส่วนเสริมบางตัวถูกปิดใช้งาน
disabled-unsigned-description = ส่วนเสริมดังต่อไปนี้ไม่ได้รับการยืนยันสำหรับใช้ใน { -brand-short-name } คุณสามารถ <label data-l10n-name="find-addons">ค้นหาตัวทดแทน</label> หรือขอนักพัฒนาให้นำส่วนเสริมไปรับการยืนยัน
disabled-unsigned-learn-more = เรียนรู้เพิ่มเติมเกี่ยวกับความพยายามของเราที่ช่วยให้คุณปลอดภัยขณะออนไลน์
disabled-unsigned-devinfo = นักพัฒนาที่สนใจนำส่วนเสริมของเขาไปรับการยืนยันสามารถดำเนินการต่อโดยอ่าน <label data-l10n-name="learn-more">ด้วยตนเอง</label>
plugin-deprecation-description = มีบางอย่างขาดหายไป? ปลั๊กอินบางตัวไม่ได้รับการสนับสนุนโดย { -brand-short-name } อีกต่อไป <label data-l10n-name="learn-more">เรียนรู้เพิ่มเติม</label>
legacy-warning-show-legacy = แสดงส่วนขยายแบบเก่า
legacy-extensions =
    .value = ส่วนขยายแบบเก่า
legacy-extensions-description = ส่วนขยายเหล่านี้ไม่ตรงตามมาตรฐานปัจจุบันของ { -brand-short-name } จึงถูกปิดใช้งาน <label data-l10n-name="legacy-learn-more">เรียนรู้เกี่ยวกับการเปลี่ยนแปลงกับส่วนเสริม</label>
private-browsing-description2 =
    { -brand-short-name } กำลังเปลี่ยนวิธีที่ส่วนขยายทำงานในขณะที่เรียกดูแบบส่วนตัว ส่วนขยายใด ๆ ที่คุณเพิ่มไปยัง { -brand-short-name }
    จะไม่ทำงานตามค่าเริ่มต้นในหน้าต่างแบบส่วนตัว นอกจากคุณจะอนุญาตในการตั้งค่า ส่วนขยายจะไม่ทำงาน
    ในขณะที่เรียกดูแบบส่วนตัว และจะไม่สามารถเข้าถึงกิจกรรมออนไลน์ของคุณที่นั่นได้ เราได้ทำการเปลี่ยนแปลง
    นี้เพื่อรักษาความเป็นส่วนตัวให้กับการเรียกดูแบบส่วนตัวของคุณ
    <label data-l10n-name="private-browsing-learn-more">เรียนรู้วิธีจัดการการตั้งค่าส่วนขยาย</label>
addon-category-discover = คำแนะนำ
addon-category-discover-title =
    .title = คำแนะนำ
addon-category-extension = ส่วนขยาย
addon-category-extension-title =
    .title = ส่วนขยาย
addon-category-theme = ชุดตกแต่ง
addon-category-theme-title =
    .title = ชุดตกแต่ง
addon-category-plugin = ปลั๊กอิน
addon-category-plugin-title =
    .title = ปลั๊กอิน
addon-category-dictionary = พจนานุกรม
addon-category-dictionary-title =
    .title = พจนานุกรม
addon-category-locale = ภาษา
addon-category-locale-title =
    .title = ภาษา
addon-category-available-updates = การอัปเดตที่มี
addon-category-available-updates-title =
    .title = การอัปเดตที่มี
addon-category-recent-updates = การอัปเดตล่าสุด
addon-category-recent-updates-title =
    .title = การอัปเดตล่าสุด

## These are global warnings

extensions-warning-safe-mode = ส่วนเสริมทั้งหมดถูกปิดใช้งานโดยโหมดปลอดภัย
extensions-warning-check-compatibility = การตรวจสอบความเข้ากันได้ของส่วนเสริมถูกปิดใช้งาน คุณอาจมีส่วนเสริมที่เข้ากันไม่ได้
extensions-warning-check-compatibility-button = เปิดใช้งาน
    .title = เปิดใช้งานการตรวจสอบความเข้ากันได้ของส่วนเสริม
extensions-warning-update-security = การตรวจสอบความปลอดภัยของการอัปเดตส่วนเสริมถูกปิดใช้งาน คุณอาจถูกบุกรุกโดยการอัปเดต
extensions-warning-update-security-button = เปิดใช้งาน
    .title = เปิดใช้งานการตรวจสอบความปลอดภัยของการอัปเดตส่วนเสริม

## Strings connected to add-on updates

addon-updates-check-for-updates = ตรวจสอบการอัปเดต
    .accesskey = ต
addon-updates-view-updates = ดูการอัปเดตล่าสุด
    .accesskey = ด

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = อัปเดตส่วนเสริมโดยอัตโนมัติ
    .accesskey = อ

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = กลับค่าเดิมของส่วนเสริมทั้งหมดเป็นอัปเดตโดยอัตโนมัติ
    .accesskey = ก
addon-updates-reset-updates-to-manual = กลับค่าเดิมของส่วนเสริมทั้งหมดเป็นอัปเดตด้วยตนเอง
    .accesskey = ก

## Status messages displayed when updating add-ons

addon-updates-updating = กำลังอัปเดตส่วนเสริม
addon-updates-installed = อัปเดตส่วนเสริมของคุณแล้ว
addon-updates-none-found = ไม่พบการอัปเดต
addon-updates-manual-updates-found = ดูการอัปเดตที่มี

## Add-on install/debug strings for page options menu

addon-install-from-file = ติดตั้งส่วนเสริมจากไฟล์…
    .accesskey = ง
addon-install-from-file-dialog-title = เลือกส่วนเสริมที่จะติดตั้ง
addon-install-from-file-filter-name = ส่วนเสริม
addon-open-about-debugging = ดีบั๊กส่วนเสริม
    .accesskey = บ

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = จัดการทางลัดส่วนขยาย
    .accesskey = จ
shortcuts-no-addons = คุณไม่ได้เปิดใช้งานส่วนขยายใด ๆ
shortcuts-no-commands = ส่วนขยายดังต่อไปนี้ไม่มีทางลัด:
shortcuts-input =
    .placeholder = พิมพ์ทางลัด
shortcuts-browserAction2 = เปิดใช้งานปุ่มแถบเครื่องมือ
shortcuts-pageAction = เปิดใช้งานการกระทำหน้า
shortcuts-sidebarAction = เปิด/ปิดแถบข้าง
shortcuts-modifier-mac = รวม Ctrl, Alt หรือ ⌘
shortcuts-modifier-other = รวม Ctrl หรือ Alt
shortcuts-invalid = ลำดับแป้นพิมพ์ไม่ถูกต้อง
shortcuts-letter = พิมพ์ตัวอักษร
shortcuts-system = ไม่สามารถเขียนทับทางลัด { -brand-short-name }
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = ทางลัดซ้ำกัน
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } กำลังถูกใช้เป็นทางลัดในกรณีมากกว่าหนึ่งกรณี ทางลัดที่ซ้ำกันอาจทำให้เกิดลักษณะการทำงานที่ไม่คาดคิด
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = มีการใช้งานอยู่แล้วโดย { $addon }
shortcuts-card-expand-button =
    { $numberToShow ->
       *[other] แสดงเพิ่มเติมอีก { $numberToShow }
    }
shortcuts-card-collapse-button = แสดงน้อยลง
header-back-button =
    .title = ย้อนกลับ

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    ส่วนขยายและชุดตกแต่งเป็นเหมือนแอปสำหรับเบราว์เซอร์ของคุณ ซึ่งให้คุณป้องกัน
    รหัสผ่าน, ดาวน์โหลดวิดีโอ, ค้นหาดีล, ปิดกั้นโฆษณาที่น่ารำคาญ, เปลี่ยนรูปลักษณ์ของ
    เบราว์เซอร์ของคุณ, และอื่น ๆ อีกมากมาย โปรแกรมซอฟต์แวร์ขนาดเล็กเหล่านั้นมักถูก
    พัฒนาโดยบุคคลที่สาม นี่คือตัวเลือกที่ { -brand-product-name } <a data-l10n-name="learn-more-trigger">แนะนำ</a>เพื่อ
    ความปลอดภัย, ประสิทธิภาพ, และการทำงานที่ดีกว่า
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    บางคำแนะนำเหล่านี้ถูกปรับเปลี่ยนตามแบบส่วนบุคคล ซึ่งขึ้นอยู่กับส่วนขยายอื่นที่คุณติดตั้ง,
    ค่ากำหนดโปรไฟล์, และสถิติการใช้งาน
discopane-notice-learn-more = เรียนรู้เพิ่มเติม
privacy-policy = นโยบายความเป็นส่วนตัว
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = โดย <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = ผู้ใช้: { $dailyUsers }
install-extension-button = เพิ่มลงใน { -brand-product-name }
install-theme-button = ติดตั้งชุดตกแต่ง
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = จัดการ
find-more-addons = ค้นหาส่วนเสริมเพิ่มเติม
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = ตัวเลือกเพิ่มเติม

## Add-on actions

report-addon-button = รายงาน
remove-addon-button = เอาออก
# The link will always be shown after the other text.
remove-addon-disabled-button = ไม่สามารถเอาออกได้ <a data-l10n-name="link">ทำไม?</a>
disable-addon-button = ปิดใช้งาน
enable-addon-button = เปิดใช้งาน
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = เปิดใช้งาน
preferences-addon-button =
    { PLATFORM() ->
        [windows] ตัวเลือก
       *[other] ค่ากำหนด
    }
details-addon-button = รายละเอียด
release-notes-addon-button = บันทึกประจำรุ่น
permissions-addon-button = การอนุญาต
extension-enabled-heading = ถูกเปิดใช้งาน
extension-disabled-heading = ถูกปิดใช้งาน
theme-enabled-heading = ถูกเปิดใช้งาน
theme-disabled-heading = ถูกปิดใช้งาน
plugin-enabled-heading = ถูกเปิดใช้งาน
plugin-disabled-heading = ถูกปิดใช้งาน
dictionary-enabled-heading = ถูกเปิดใช้งาน
dictionary-disabled-heading = ถูกปิดใช้งาน
locale-enabled-heading = ถูกเปิดใช้งาน
locale-disabled-heading = ถูกปิดใช้งาน
ask-to-activate-button = ถามเพื่อเปิดใช้งาน
always-activate-button = เปิดใช้งานเสมอ
never-activate-button = ไม่เปิดใช้งานเสมอ
addon-detail-author-label = ผู้สร้าง
addon-detail-version-label = รุ่น
addon-detail-last-updated-label = อัปเดตล่าสุด
addon-detail-homepage-label = หน้าแรก
addon-detail-rating-label = การจัดอันดับ
# Message for add-ons with a staged pending update.
install-postponed-message = ส่วนขยายนี้จะถูกอัปเดตเมื่อ { -brand-short-name } เริ่มการทำงานใหม่
install-postponed-button = อัปเดตตอนนี้
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = ได้รับการจัดอันดับ { NUMBER($rating, maximumFractionDigits: 1) } จาก 5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (ปิดใช้งานอยู่)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
       *[other] { $numberOfReviews } บทวิจารณ์
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = เอา <span data-l10n-name="addon-name">{ $addon }</span> ออกแล้ว
pending-uninstall-undo-button = เลิกทำ
addon-detail-updates-label = อนุญาตให้อัปเดตโดยอัตโนมัติ
addon-detail-updates-radio-default = ค่าเริ่มต้น
addon-detail-updates-radio-on = เปิด
addon-detail-updates-radio-off = ปิด
addon-detail-update-check-label = ตรวจสอบการอัปเดต
install-update-button = อัปเดต
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = อนุญาตในหน้าต่างส่วนตัวแล้ว
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = เมื่อได้รับอนุญาต ส่วนขยายจะสามารถเข้าถึงกิจกรรมออนไลน์ของคุณได้ในขณะที่เรียกดูแบบส่วนตัว <a data-l10n-name="learn-more">เรียนรู้เพิ่มเติม</a>
addon-detail-private-browsing-allow = อนุญาต
addon-detail-private-browsing-disallow = ไม่อนุญาต

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = { -brand-product-name } แนะนำเฉพาะส่วนขยายที่ตรงตามมาตรฐานของเราเท่านั้นเพื่อความปลอดภัยและประสิทธิภาพ
    .aria-label = { addon-badge-recommended2.title }
# We hard code "Mozilla" in the string below because the extensions are built
# by Mozilla and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = ส่วนขยายอย่างเป็นทางการที่สร้างขึ้นโดย Mozilla ซึ่งตรงตามมาตรฐานความปลอดภัยและประสิทธิภาพ
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = ส่วนขยายนี้ได้รับการตรวจสอบว่าเป็นไปตามมาตรฐานด้านความปลอดภัยและประสิทธิภาพของเรา
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = การอัปเดตที่มี
recent-updates-heading = การอัปเดตล่าสุด
release-notes-loading = กำลังโหลด…
release-notes-error = ขออภัย แต่เกิดข้อผิดพลาดในการโหลดบันทึกประจำรุ่น
addon-permissions-empty = ส่วนขยายนี้ไม่ต้องการการอนุญาตใด ๆ
addon-permissions-required = สิทธิอนุญาตที่ต้องการสำหรับฟังก์ชันการทำงานหลัก:
addon-permissions-optional = สิทธิอนุญาตที่เลือกได้สำหรับฟังก์ชันการทำงานที่เพิ่ม:
addon-permissions-learnmore = เรียนรู้เพิ่มเติมเกี่ยวกับสิทธิอนุญาต
recommended-extensions-heading = ส่วนขยายที่แนะนำ
recommended-themes-heading = ชุดตกแต่งที่แนะนำ
# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = รู้สึกสร้างสรรค์ใช่ไหม? <a data-l10n-name="link">สร้างชุดตกแต่งในรูปแบบของคุณเองด้วย Firefox Color</a>

## Page headings

extension-heading = จัดการส่วนขยายของคุณ
theme-heading = จัดการชุดตกแต่งของคุณ
plugin-heading = จัดการปลั๊กอินของคุณ
dictionary-heading = จัดการพจนานุกรมของคุณ
locale-heading = จัดการภาษาของคุณ
updates-heading = จัดการการอัปเดตของคุณ
discover-heading = ปรับแต่ง { -brand-short-name } ของคุณ
shortcuts-heading = จัดการทางลัดส่วนขยาย
default-heading-search-label = ค้นหาส่วนเสริมเพิ่มเติม
addons-heading-search-input =
    .placeholder = ค้นหา addons.mozilla.org
addon-page-options-button =
    .title = เครื่องมือสำหรับส่วนเสริมทั้งหมด
