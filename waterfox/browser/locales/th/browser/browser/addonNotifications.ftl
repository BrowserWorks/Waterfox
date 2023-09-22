# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = { -brand-short-name } ได้ป้องกันไม่ให้ไซต์นี้ขอคุณเพื่อติดตั้งซอฟต์แวร์ลงในคอมพิวเตอร์ของคุณ

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = อนุญาตให้ { $host } ติดตั้งส่วนเสริมหรือไม่?
xpinstall-prompt-message = คุณกำลังพยายามติดตั้งส่วนเสริมจาก { $host } ตรวจสอบให้แน่ใจว่าคุณเชื่อถือไซต์นี้ก่อนดำเนินการต่อ

##

xpinstall-prompt-header-unknown = อนุญาตให้ไซต์ที่ไม่รู้จักติดตั้งส่วนเสริม?
xpinstall-prompt-message-unknown = คุณกำลังพยายามติดตั้งส่วนเสริมจากไซต์ที่ไม่รู้จัก ตรวจสอบให้แน่ใจว่าคุณเชื่อถือไซต์นี้ก่อนดำเนินการต่อ
xpinstall-prompt-dont-allow =
    .label = ไม่อนุญาต
    .accesskey = ไ
xpinstall-prompt-never-allow =
    .label = ไม่อนุญาตเสมอ
    .accesskey = ม
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = รายงานไซต์ที่น่าสงสัย
    .accesskey = ร
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = ดำเนินการติดตั้งต่อไป
    .accesskey = ด

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = ไซต์นี้กำลังขอเข้าถึงอุปกรณ์ MIDI (Musical Instrument Digital Interface) ของคุณ ซึ่งสามารถเปิดการเข้าถึงอุปกรณ์ได้ด้วยการติดตั้งส่วนเสริม
site-permission-install-first-prompt-midi-message = ไม่รับประกันว่าการเข้าถึงนี้จะปลอดภัย ให้ดำเนินการต่อหากคุณไว้ใจไซต์นี้เท่านั้น

##

xpinstall-disabled-locked = การติดตั้งซอฟต์แวร์ถูกปิดใช้งานโดยผู้ดูแลระบบของคุณ
xpinstall-disabled = การติดตั้งซอฟต์แวร์ถูกปิดใช้งานอยู่ในขณะนี้ คลิก เปิดใช้งาน แล้วลองอีกครั้ง
xpinstall-disabled-button =
    .label = เปิดใช้งาน
    .accesskey = ป
# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = { $addonName } ({ $addonId }) ถูกปิดกั้นโดยผู้ดูแลระบบของคุณ
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = ผู้ดูแลระบบของคุณได้ป้องกันไม่ให้ไซต์นี้ขอคุณเพื่อติดตั้งซอฟต์แวร์ลงในคอมพิวเตอร์ของคุณ
addon-install-full-screen-blocked = ไม่อนุญาตให้ติดตั้งส่วนเสริมขณะอยู่ในหรือก่อนเข้าสู่โหมดเต็มหน้าจอ
# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = เพิ่ม { $addonName } ลงใน { -brand-short-name } แล้ว
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = { $addonName } ต้องการสิทธิอนุญาตใหม่
# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons = เสร็จสิ้นการติดตั้งส่วนขยายที่นำเข้าไปยัง { -brand-short-name }

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = ต้องการเอา { $name } ออกหรือไม่?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = เอา { $name } ออกจาก { -brand-shorter-name }?
addon-removal-button = เอาออก
addon-removal-abuse-report-checkbox = รายงานส่วนขยายนี้ไปยัง { -vendor-short-name }
# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying = กำลังดาวน์โหลดและยืนยัน { $addonCount } ส่วนเสริม…
addon-download-verifying = กำลังยืนยัน
addon-install-cancel-button =
    .label = ยกเลิก
    .accesskey = ย
addon-install-accept-button =
    .label = เพิ่ม
    .accesskey = พ

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message = ไซต์นี้ต้องการติดตั้ง { $addonCount } ส่วนเสริมใน { -brand-short-name }:
addon-confirm-install-unsigned-message = ข้อควรระวัง: ไซต์นี้ต้องการติดตั้ง { $addonCount } ส่วนเสริมที่ไม่ได้รับการยืนยันใน { -brand-short-name } ดำเนินการต่อโดยรับความเสี่ยงของคุณเอง
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message = ข้อควรระวัง: ไซต์นี้ต้องการติดตั้ง { $addonCount } ส่วนเสริมใน { -brand-short-name } บางส่วนไม่ได้รับการยืนยัน ดำเนินการต่อโดยรับความเสี่ยงของคุณเอง

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = ไม่สามารถดาวน์โหลดส่วนเสริมเนื่องจากการเชื่อมต่อล้มเหลว
addon-install-error-incorrect-hash = ไม่สามารถติดตั้งส่วนเสริมเนื่องจากไม่ตรงกับส่วนเสริมที่ { -brand-short-name } ต้องการ
addon-install-error-corrupt-file = ไม่สามารถติดตั้งส่วนเสริมที่ดาวน์โหลดจากไซต์นี้เนื่องจากส่วนเสริมดูเหมือนจะเสียหาย
addon-install-error-file-access = ไม่สามารถติดตั้ง { $addonName } เนื่องจาก { -brand-short-name } ไม่สามารถแก้ไขไฟล์ที่จำเป็น
addon-install-error-not-signed = { -brand-short-name } ได้ป้องกันไม่ให้ไซต์นี้ติดตั้งส่วนเสริมที่ไม่ได้รับการยืนยัน
addon-install-error-invalid-domain = ไม่สามารถติดตั้งส่วนเสริม { $addonName } จากตำแหน่งที่ตั้งนี้ได้
addon-local-install-error-network-failure = ไม่สามารถติดตั้งส่วนเสริมนี้เนื่องจากข้อผิดพลาดระบบไฟล์
addon-local-install-error-incorrect-hash = ไม่สามารถติดตั้งส่วนเสริมนี้เนื่องจากไม่ตรงกับส่วนเสริมที่ { -brand-short-name } ต้องการ
addon-local-install-error-corrupt-file = ไม่สามารถติดตั้งส่วนเสริมนี้เนื่องจากส่วนเสริมดูเหมือนจะเสียหาย
addon-local-install-error-file-access = ไม่สามารถติดตั้ง { $addonName } เนื่องจาก { -brand-short-name } ไม่สามารถแก้ไขไฟล์ที่จำเป็น
addon-local-install-error-not-signed = ไม่สามารถติดตั้งส่วนเสริมนี้เนื่องจากส่วนเสริมไม่ได้รับการยืนยัน
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = ไม่สามารถติดตั้ง { $addonName } เนื่องจากเข้ากันไม่ได้กับ { -brand-short-name } { $appVersion }
addon-install-error-blocklisted = ไม่สามารถติดตั้ง { $addonName } เนื่องจากมีความเสี่ยงสูงที่จะก่อให้เกิดปัญหาด้านเสถียรภาพหรือความปลอดภัย
