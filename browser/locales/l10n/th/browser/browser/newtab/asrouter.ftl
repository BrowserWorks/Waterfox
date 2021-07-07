# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = ส่วนขยายที่แนะนำ
cfr-doorhanger-feature-heading = คุณลักษณะที่แนะนำ
cfr-doorhanger-pintab-heading = ลองนี่: ปักหมุดแท็บ

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = ทำไมฉันจึงเห็นสิ่งนี้
cfr-doorhanger-extension-cancel-button = ไม่ใช่ตอนนี้
    .accesskey = ม
cfr-doorhanger-extension-ok-button = เพิ่มตอนนี้
    .accesskey = พ
cfr-doorhanger-pintab-ok-button = ปักหมุดแท็บนี้
    .accesskey = P
cfr-doorhanger-extension-manage-settings-button = จัดการการตั้งค่าคำแนะนำ
    .accesskey = จ
cfr-doorhanger-extension-never-show-recommendation = ไม่ต้องแสดงคำแนะนำนี้ให้ฉัน
    .accesskey = ส
cfr-doorhanger-extension-learn-more-link = เรียนรู้เพิ่มเติม
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = โดย { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = คำแนะนำ
cfr-doorhanger-extension-notification2 = แนะนำ
    .tooltiptext = ส่วนขยายที่แนะนำ
    .a11y-announcement = ส่วนขยายแนะนำที่มีอยู่
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = แนะนำ
    .tooltiptext = คุณลักษณะที่แนะนำ
    .a11y-announcement = คุณลักษณะแนะนำที่มีอยู่

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
           *[other] { $total } ดาว
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
       *[other] { $total } ผู้ใช้
    }
cfr-doorhanger-pintab-description = เข้าถึงเว็บที่คุณใช้บ่อยได้อย่างง่ายดาย เปิดเว็บไว้ในแท็บตลอดเวลา (แม้ว่าคุณจะเปิดปิดใหม่ก็ตาม)

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>คลิกขวา</b> บนแท็บที่คุณต้องการจะปัก
cfr-doorhanger-pintab-step2 = เลือก <b>ปักหมุดแท็บ</b> จากเมนู
cfr-doorhanger-pintab-step3 = หากเว็บไซต์มีการเปลี่ยนแปลง คุณจะได้เห็นจุดสีฟ้าบนแท็บที่ถูกปัก
cfr-doorhanger-pintab-animation-pause = หยุดชั่วคราว
cfr-doorhanger-pintab-animation-resume = ทำต่อ

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = ซิงค์ที่คั่นหน้าของคุณได้ทุกที่
cfr-doorhanger-bookmark-fxa-body = เยี่ยมมาก! ตอนนี้อย่าออกไปโดยไม่มีที่คั่นหน้านี้บนอุปกรณ์มือถือของคุณ เริ่มต้นกับ { -fxaccount-brand-name }
cfr-doorhanger-bookmark-fxa-link-text = ซิงค์ที่คั่นหน้าของคุณตอนนี้…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = ปุ่มปิด
    .title = ปิด

## Protections panel

cfr-protections-panel-header = เรียกดูโดยไม่ต้องมีใครมาติดตาม
cfr-protections-panel-body = เก็บข้อมูลของคุณไว้กับตัวคุณเอง { -brand-short-name } ปกป้องคุณจากตัวติดตามที่พบบ่อยที่สุดซึ่งติดตามสิ่งที่คุณทำทางออนไลน์
cfr-protections-panel-link-text = เรียนรู้เพิ่มเติม

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = คุณสมบัติใหม่:
cfr-whatsnew-button =
    .label = มีอะไรใหม่
    .tooltiptext = มีอะไรใหม่
cfr-whatsnew-panel-header = มีอะไรใหม่
cfr-whatsnew-release-notes-link-text = อ่านบันทึกประจำรุ่น
cfr-whatsnew-fx70-title = ตอนนี้ { -brand-short-name } ต่อสู้อย่างหนักขึ้นเพื่อความเป็นส่วนตัวของคุณ
cfr-whatsnew-fx70-body =
    การอัปเดตล่าสุดเพิ่มคุณลักษณะการป้องกันการติดตามและทำให้
    สร้างรหัสผ่านที่ปลอดภัยสำหรับทุกไซต์ได้ง่ายขึ้นกว่าที่เคย
cfr-whatsnew-tracking-protect-title = ป้องกันตัวคุณเองจากตัวติดตาม
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } บล็อกตัวติดตามสังคมออนไลน์และข้ามไซต์ทั่วไปจำนวนมากที่
    ติดตามสิ่งที่คุณทำออนไลน์
cfr-whatsnew-tracking-protect-link-text = ดูรายงานของคุณ
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
       *[other] ตัวติดตามที่ถูกปิดกั้น
    }
cfr-whatsnew-tracking-blocked-subtitle = ตั้งแต่ { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = ดูรายงาน
cfr-whatsnew-lockwise-backup-title = สำรองรหัสผ่านของคุณ
cfr-whatsnew-lockwise-backup-body = คุณสามารถสร้างรหัสผ่านที่ปลอดภัยซึ่งสามารถเข้าถึงได้ทุกที่ที่คุณลงชื่อเข้าได้แล้วตอนนี้
cfr-whatsnew-lockwise-backup-link-text = เปิดการสำรองข้อมูล
cfr-whatsnew-lockwise-take-title = นำรหัสผ่านของคุณไปกับคุณ
cfr-whatsnew-lockwise-take-body = แอปมือถือ { -lockwise-brand-short-name } ช่วยให้คุณเข้าถึงรหัสผ่านที่สำรองไว้ของคุณจากทุกที่ได้อย่างปลอดภัย
cfr-whatsnew-lockwise-take-link-text = รับแอป

## Search Bar

cfr-whatsnew-searchbar-title = ค้นหาได้มากขึ้นโดยพิมพ์น้อยลงในแถบที่อยู่
cfr-whatsnew-searchbar-body-topsites = เพียงเลือกแถบที่อยู่แล้วกล่องจะขยายออกพร้อมลิงก์ไปยังไซต์เด่นของคุณ

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = ไอคอนรูปแว่นขยาย

## Picture-in-Picture

cfr-whatsnew-pip-header = ดูวิดีโอขณะที่คุณเรียกดู
cfr-whatsnew-pip-body = ภาพที่เล่นควบคู่แสดงวิดีโอเป็นหน้าต่างลอยเพื่อให้คุณรับชมขณะทำงานในแท็บอื่น ๆ ได้
cfr-whatsnew-pip-cta = เรียนรู้เพิ่มเติม

## Permission Prompt

cfr-whatsnew-permission-prompt-header = ป๊อปอัปของไซต์ที่น่ารำคาญน้อยลง
cfr-whatsnew-permission-prompt-body = ขณะนี้ { -brand-shorter-name } ปิดกั้นไม่ให้ไซต์ถามเพื่อส่งข้อความป๊อปอัปถึงคุณโดยอัตโนมัติ
cfr-whatsnew-permission-prompt-cta = เรียนรู้เพิ่มเติม

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
       *[other] ลายนิ้วมือดิจิทัลถูกปิดกั้น
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } ปิดกั้นลายนิ้วมือดิจิทัลจำนวนมากที่แอบรวบรวมข้อมูลเกี่ยวกับอุปกรณ์และการใช้งานของคุณอย่างลับ ๆ เพื่อสร้างโปรไฟล์โฆษณาของคุณ
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = ลายนิ้วมือดิจิทัล
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } สามารถปิดกั้นลายนิ้วมือดิจิทัลจำนวนมากที่แอบรวบรวมข้อมูลเกี่ยวกับอุปกรณ์และการใช้งานของคุณอย่างลับ ๆ เพื่อสร้างโปรไฟล์โฆษณาของคุณได้

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = รับที่คั่นหน้านี้บนโทรศัพท์ของคุณ
cfr-doorhanger-sync-bookmarks-body = นำที่คั่นหน้า, รหัสผ่าน, ประวัติและอื่น ๆ ของคุณไปทุกที่ที่คุณลงชื่อเข้า { -brand-product-name }
cfr-doorhanger-sync-bookmarks-ok-button = เปิด { -sync-brand-short-name }
    .accesskey = ป

## Login Sync

cfr-doorhanger-sync-logins-header = ไม่ต้องกลัวทำรหัสผ่านหายอีกต่อไป
cfr-doorhanger-sync-logins-body = เก็บและซิงค์รหัสผ่านของคุณกับอุปกรณ์ทั้งหมดอย่างปลอดภัย
cfr-doorhanger-sync-logins-ok-button = เปิด { -sync-brand-short-name }
    .accesskey = ป

## Send Tab

cfr-doorhanger-send-tab-header = อ่านสิ่งนี้ได้ทุกที่
cfr-doorhanger-send-tab-recipe-header = นำสูตรอาหารนี้ไปที่ห้องครัว
cfr-doorhanger-send-tab-body = คุณลักษณะการส่งแท็บช่วยให้คุณสามารถแบ่งปันลิงก์นี้ไปที่โทรศัพท์ของคุณหรือที่ไหนก็ได้ที่คุณลงชื่อเข้า { -brand-product-name } ได้อย่างง่ายดาย
cfr-doorhanger-send-tab-ok-button = ลองใช้คุณลักษณะการส่งแท็บ
    .accesskey = ล

## Firefox Send

cfr-doorhanger-firefox-send-header = แบ่งปัน PDF นี้อย่างปลอดภัย
cfr-doorhanger-firefox-send-body = รักษาเอกสารสำคัญของคุณให้ปลอดภัยจากการสอดส่องด้วยการเข้ารหัสจากต้นทางถึงปลายทางและลิงก์ที่จะหายไปเมื่อคุณทำงานกับเอกสารเหล่านั้นเสร็จแล้ว
cfr-doorhanger-firefox-send-ok-button = ลองใช้ { -send-brand-name }
    .accesskey = ล

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = ดูการป้องกัน
    .accesskey = ด
cfr-doorhanger-socialtracking-close-button = ปิด
    .accesskey = ป
cfr-doorhanger-socialtracking-dont-show-again = ไม่ต้องแสดงข้อความเช่นนี้ให้ฉันอีก
    .accesskey = ม
cfr-doorhanger-socialtracking-heading = { -brand-short-name } ได้หยุดเครือข่ายสังคมไม่ให้ติดตามคุณที่นี่
cfr-doorhanger-socialtracking-description = ความเป็นส่วนตัวของคุณสำคัญ { -brand-short-name } จะปิดกั้นตัวติดตามสื่อสังคมออนไลน์ทั่วไป โดยจำกัดจำนวนข้อมูลที่สามารถรวบรวมเกี่ยวกับสิ่งที่คุณทำทางออนไลน์
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } ได้ปิดกั้นลายนิ้วมือดิจิทัลบนหน้านี้
cfr-doorhanger-fingerprinters-description = ความเป็นส่วนตัวของคุณสำคัญ { -brand-short-name } จะปิดกั้นลายนิ้วมือดิจิทัล ซึ่งรวบรวมข้อมูลที่ไม่ซ้ำกันเกี่ยวกับอุปกรณ์ของคุณเพื่อติดตามคุณ
cfr-doorhanger-cryptominers-heading = { -brand-short-name } ได้ปิดกั้นตัวชุดเหรียญดิจิทัลบนหน้านี้
cfr-doorhanger-cryptominers-description = ความเป็นส่วนตัวของคุณมีความสำคัญ { -brand-short-name } จะปิดกั้นตัวขุดเหรียญดิจิทัล ซึ่งใช้พลังการคำนวณของระบบของคุณเพื่อสร้างรายได้ดิจิทัล

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] { -brand-short-name } ปิดกั้นตัวติดตามไปแล้ว <b>{ $blockedCount }</b> ตัวตั้งแต่ { $date }!
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] { -brand-short-name } ได้ปิดกั้นตัวติดตามมากกว่า <b>{ $blockedCount }</b> ตัวตั้งแต่ { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = ดูทั้งหมด
    .accesskey = ด

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = สร้างรหัสผ่านที่ปลอดภัยได้อย่างง่ายดาย
cfr-whatsnew-lockwise-body = การคิดรหัสผ่านที่ไม่ซ้ำใครและปลอดภัยสำหรับทุกบัญชีนั้นเป็นเรื่องยาก เมื่อสร้างรหัสผ่าน ให้เลือกช่องกรอกรหัสผ่านเพื่อใช้รหัสผ่านที่ปลอดภัยซึ่งสร้างขึ้นจาก { -brand-shorter-name }
cfr-whatsnew-lockwise-icon-alt = ไอคอน { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = รับการแจ้งเตือนเกี่ยวกับรหัสผ่านที่อ่อนแอ
cfr-whatsnew-passwords-body = แฮกเกอร์รู้ว่าผู้คนใช้รหัสผ่านเดียวกันซ้ำ หากคุณใช้รหัสผ่านเดียวกันในหลาย ๆ ไซต์และหนึ่งในเว็บไซต์เหล่านั้นอยู่ในการรั่วไหลของข้อมูล คุณจะเห็นการแจ้งเตือนใน { -lockwise-brand-short-name } เพื่อเปลี่ยนรหัสผ่านของคุณบนไซต์เหล่านั้น
cfr-whatsnew-passwords-icon-alt = ไอคอนกุญแจรหัสผ่านที่อ่อนแอ

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = เปิดภาพที่เล่นควบคู่แบบเต็มหน้าจอ
cfr-whatsnew-pip-fullscreen-body = เมื่อคุณเปิดวิดีโอในหน้าต่างลอย คุณสามารถคลิกสองครั้งที่หน้าต่างนั้นเพื่อแสดงแบบเต็มหน้าจอได้
cfr-whatsnew-pip-fullscreen-icon-alt = ไอคอนภาพที่เล่นควบคู่

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = ปิด
    .accesskey = C

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = ภาพรวมการป้องกัน
cfr-whatsnew-protections-body = แดชบอร์ดการป้องกันมีรายงานสรุปเกี่ยวกับข้อมูลที่รั่วไหลและการจัดการรหัสผ่าน โดยตอนนี้คุณสามารถติดตามได้ว่าคุณแก้ไขการรั่วไหลไปกี่รายการแล้ว และดูได้ว่ารหัสผ่านที่คุณบันทึกไว้รหัสใดรหัสหนึ่งมีโอกาสที่จะถูกเปิดเผยในข้อมูลที่รั่วไหลหรือไม่
cfr-whatsnew-protections-cta-link = ดูแดชบอร์ดการป้องกัน
cfr-whatsnew-protections-icon-alt = ไอคอนโล่

## Better PDF message

cfr-whatsnew-better-pdf-header = ประสบการณ์ PDF ที่ดีขึ้น
cfr-whatsnew-better-pdf-body = ตอนนี้คุณสามารถเปิดเอกสาร PDF ได้โดยตรงใน { -brand-short-name } ช่วยให้คุณทำงานได้อย่างง่ายดาย

## DOH Message

cfr-doorhanger-doh-body = ความเป็นส่วนตัวของคุณสำคัญ ตอนนี้ { -brand-short-name } จะกำหนดเส้นทางคำขอ DNS ของคุณให้กับบริการพาร์ทเนอร์อย่างปลอดภัยเมื่อใดก็ตามที่เป็นไปได้เพื่อปกป้องคุณในขณะที่คุณเรียกดู
cfr-doorhanger-doh-header = การค้นหา DNS ที่เข้ารหัสและปลอดภัยยิ่งขึ้น
cfr-doorhanger-doh-primary-button-2 = ตกลง
    .accesskey = ต
cfr-doorhanger-doh-secondary-button = ปิดใช้งาน
    .accesskey = D

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = ความเป็นส่วนตัวของคุณสำคัญ ขณะนี้ { -brand-short-name } จะแยกหรือแซนด์บ็อกซ์เว็บไซต์ออกจากกัน เพื่อให้แฮกเกอร์ขโมยรหัสผ่าน หมายเลขบัตรเครดิต และข้อมูลที่ละเอียดอ่อนอื่น ๆ ได้ยากขึ้น
cfr-doorhanger-fission-header = การแยกไซต์
cfr-doorhanger-fission-primary-button = ตกลง เข้าใจแล้ว
    .accesskey = O
cfr-doorhanger-fission-secondary-button = เรียนรู้เพิ่มเติม
    .accesskey = L

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = การป้องกันจากกลยุทธ์การติดตามอันเจ้าเล่ห์อัตโนมัติ
cfr-whatsnew-clear-cookies-body = ตัวติดตามบางตัวจะเปลี่ยนเส้นทางคุณไปยังเว็บไซต์อื่น ๆ ที่ตั้งค่าคุกกี้อย่างลับ ๆ ตอนนี้ { -brand-short-name } จะล้างคุกกี้เหล่านั้นโดยอัตโนมัติเพื่อไม่ให้คุณถูกตามรอย
cfr-whatsnew-clear-cookies-image-alt = ภาพประกอบคุกกี้ที่ถูกปิดกั้น

## What's new: Media controls message

cfr-whatsnew-media-keys-header = การควบคุมสื่อเพิ่มเติม
cfr-whatsnew-media-keys-body = เล่นและหยุดเสียงหรือวิดีโอชั่วคราวได้โดยตรงจากแป้นพิมพ์หรือชุดหูฟังของคุณ เพื่อให้ควบคุมสื่อจากแท็บอื่น โปรแกรมอื่น หรือแม้คอมพิวเตอร์ของคุณล็อกอยู่ได้ คุณยังสามารถเปลี่ยนแทร็กไปมาได้โดยกดแป้นเดินหน้าและย้อนกลับ
cfr-whatsnew-media-keys-button = เรียนรู้วิธี

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = ทางลัดการค้นหาในแถบที่อยู่
cfr-whatsnew-search-shortcuts-body = ตอนนี้ เมื่อคุณพิมพ์เครื่องมือค้นหาตัวใดตัวหนึ่งหรือไซต์ใดไซต์หนึ่งในแถบที่อยู่ ทางลัดสีน้ำเงินจะปรากฏด้านล่างคำแนะนำการค้นหา ให้เลือกทางลัดนั้นเพื่อค้นหาให้เสร็จสมบูรณ์โดยตรงจากแถบที่อยู่

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = การป้องกันซูเปอร์คุกกี้ที่เป็นอันตราย
cfr-whatsnew-supercookies-body = เว็บไซต์อาจแนบ “ซูเปอร์คุกกี้” กับเบราว์เซอร์ของคุณอย่างลับ ๆ ซึ่งสามารถติดตามคุณในระหว่างที่ใช้เว็บได้ ถึงแม้ว่าคุณจะล้างคุกกี้ของคุณก็ตาม ตอนนี้ { -brand-short-name } มีการป้องกันซูเปอร์คุกกี้เพื่อไม่ให้นำมาใช้ติดตามกิจกรรมออนไลน์ของคุณจากไซต์หนึ่งไปอีกไซต์หนึ่งได้

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = การจัดการที่คั่นหน้าที่ดีขึ้น
cfr-whatsnew-bookmarking-body = คุณสามารถติดตามไซต์โปรดของคุณได้ง่ายขึ้น ตอนนี้ { -brand-short-name } จะจำตำแหน่งที่คุณต้องการสำหรับที่คั่นหน้าที่บันทึกไว้ แสดงแถบเครื่องมือที่คั่นหน้าตามค่าเริ่มต้นบนแท็บใหม่ และให้คุณเข้าถึงที่คั่นหน้าที่เหลือของคุณผ่านโฟลเดอร์แถบเครื่องมือได้อย่างง่ายดาย

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = การป้องกันแบบครอบคลุมจากการติดตามคุกกี้ข้ามไซต์
cfr-whatsnew-cross-site-tracking-body = คุณสามารถเลือกใช้การป้องกันที่ดีขึ้นจากการติดตามคุกกี้ได้แล้วในขณะนี้ { -brand-short-name } สามารถแยกกิจกรรมและข้อมูลของคุณไปที่ไซต์ที่คุณกำลังใช้งานอยู่ในขณะนี้เพื่อให้ข้อมูลที่เก็บอยู่ในเบราว์เซอร์ไม่ถูกแบ่งปันระหว่างเว็บไซต์ต่าง ๆ

## Full Video Support CFR message

cfr-doorhanger-video-support-body = วิดีโอบนไซต์นี้อาจเล่นไม่ถูกต้องใน { -brand-short-name } เวอร์ชันนี้ สำหรับการสนับสนุนวิดีโอเต็มรูปแบบ อัปเดต { -brand-short-name } ทันที
cfr-doorhanger-video-support-header = อัปเดต { -brand-short-name } เพื่อเล่นวิดีโอ
cfr-doorhanger-video-support-primary-button = อัปเดตตอนนี้
    .accesskey = U
