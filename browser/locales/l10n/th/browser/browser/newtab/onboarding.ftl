# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = เรียนรู้เพิ่มเติม
onboarding-button-label-get-started = เริ่มต้นใช้งาน

## Welcome modal dialog strings


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = ยินดีต้อนรับสู่ { -brand-short-name }
onboarding-welcome-body = คุณมีเบราว์เซอร์แล้ว<br/>ชมคุณสมบัติอื่นที่เหลือของ { -brand-product-name }
onboarding-welcome-learn-more = เรียนรู้เพิ่มเติมเกี่ยวกับประโยชน์
onboarding-welcome-modal-get-body = คุณมีเบราว์เซอร์แล้ว<br/>มาทำให้ { -brand-product-name } ใช้งานได้อย่างเต็มประสิทธิภาพกัน
onboarding-welcome-modal-supercharge-body = เพิ่มความคุ้มครองความเป็นส่วนตัวของคุณให้มากขึ้น
onboarding-welcome-modal-privacy-body = คุณมีเบราว์เซอร์ มาเพิ่มการปกป้องความเป็นส่วนตัวกัน
onboarding-welcome-modal-family-learn-more = เรียนรู้เกี่ยวกับผลิตภัณฑ์ในตระกูล { -brand-product-name }
onboarding-welcome-form-header = เริ่มที่นี่
onboarding-join-form-body = ป้อนที่อยู่อีเมลของคุณเพื่อเริ่มต้นใช้งาน
onboarding-join-form-email =
    .placeholder = ป้อนอีเมล
onboarding-join-form-email-error = จำเป็นต้องกรอกอีเมลที่ถูกต้อง
onboarding-join-form-legal = การดำเนินการต่อถือว่าคุณยอมรับ<a data-l10n-name="terms">เงื่อนไขการใช้บริการ</a>และ<a data-l10n-name="privacy">ข้อกำหนดความเป็นส่วนตัว</a>
onboarding-join-form-continue = ดำเนินการต่อ
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = มีบัญชีอยู่แล้วใช่หรือไม่
# Text for link to submit the sign in form
onboarding-join-form-signin = ลงชื่อเข้า
onboarding-start-browsing-button-label = เริ่มการเรียกดู
onboarding-cards-dismiss =
    .title = ยกเลิก
    .aria-label = ยกเลิก

## Welcome full page string

onboarding-fullpage-welcome-subheader = มาเริ่มสำรวจทุกอย่างที่คุณทำได้กัน
onboarding-fullpage-form-email =
    .placeholder = ที่อยู่อีเมลของคุณ…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = นำ { -brand-product-name } ไปกับคุณ
onboarding-sync-welcome-content = รับที่คั่นหน้า ประวัติ รหัสผ่าน และการตั้งค่าอื่น ๆ ของคุณในอุปกรณ์ทั้งหมดของคุณ
onboarding-sync-welcome-learn-more-link = เรียนรู้เพิ่มเติมเกี่ยวกับบัญชี Firefox
onboarding-sync-form-input =
    .placeholder = อีเมล
onboarding-sync-form-continue-button = ดำเนินการต่อ
onboarding-sync-form-skip-login-button = ข้ามขั้นตอนนี้

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = ป้อนอีเมลของคุณ
onboarding-sync-form-sub-header = เพื่อดำเนินการต่อไปยัง { -sync-brand-name }

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = ทำสิ่งต่าง ๆ ให้สำเร็จด้วยเครื่องมือมากมายที่เคารพความเป็นส่วนตัวของคุณบนอุปกรณ์ทุกเครื่องของคุณ
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = ทุกสิ่งที่เราทำเคารพต่อคำมั่นสัญญาด้านข้อมูลส่วนบุคคลของเรา: เก็บให้น้อย รักษาให้ปลอดภัย ไม่มีความลับ
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = นำที่คั่นหน้า รหัสผ่าน ประวัติ และอื่น ๆ ทุกที่ที่คุณใช้ { -brand-product-name }
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = รับการแจ้งเตือนเมื่อข้อมูลส่วนบุคคลของคุณอยู่ในการรั่วไหลข้อมูลที่รู้จัก
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = จัดการรหัสผ่านของคุณให้ปลอดภัยและพกพาได้

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = การป้องกันจากการติดตาม
onboarding-tracking-protection-text2 = { -brand-short-name } ช่วยหยุดเว็บไซต์ไม่ให้ติดตามคุณออนไลน์ ทำให้โฆษณาติดตามคุณไปทั่วทั้งเว็บได้ยากขึ้น
onboarding-tracking-protection-button2 = วิธีการทำงาน
onboarding-data-sync-title = นำการตั้งค่าของคุณไปกับคุณ
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = ซิงค์ที่คั่นหน้า, รหัสผ่าน, และอื่น ๆ ทุกที่ที่คุณใช้ { -brand-product-name }
onboarding-data-sync-button2 = ลงชื่อเข้า { -sync-brand-short-name }
onboarding-firefox-monitor-title = รับการแจ้งเตือนเกี่ยวกับการละเมิดข้อมูล
onboarding-firefox-monitor-text2 = { -monitor-brand-name } จะเฝ้าดูว่าอีเมลของคุณปรากฏในการละเมิดข้อมูลหรือไม่และจะแจ้งเตือนคุณหากปรากฏในการละเมิดใหม่
onboarding-firefox-monitor-button = สมัครรับการแจ้งเตือน
onboarding-browse-privately-title = เรียกดูอย่างเป็นส่วนตัว
onboarding-browse-privately-text = การท่องเส้นแบบส่วนตัวจะล้างประวัติการค้นหาและประวัติการเข้าชมของคุณเพื่อปกปิดเป็นความลับไม่ให้ใครก็ตามที่ใช้คอมพิวเตอร์ของคุณมาเห็น
onboarding-browse-privately-button = เปิดหน้าต่างส่วนตัว
onboarding-firefox-send-title = ทำให้ไฟล์ที่แบ่งปันของคุณเป็นส่วนตัว
onboarding-firefox-send-text2 = อัปโหลดไฟล์ของคุณไปที่ { -send-brand-name } เพื่อแบ่งปันไฟล์ด้วยการเข้ารหัสแบบครบวงจรและลิงก์ที่หมดอายุโดยอัตโนมัติ
onboarding-firefox-send-button = ลอง { -send-brand-name }
onboarding-mobile-phone-title = รับ { -brand-product-name } ในโทรศัพท์ของคุณ
onboarding-mobile-phone-text = ดาวน์โหลด { -brand-product-name } สำหรับ iOS หรือ Android และซิงค์ข้อมูลของคุณผ่านอุปกรณ์ต่าง ๆ
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = ดาวน์โหลดเบราว์เซอร์สำหรับมือถือ
onboarding-send-tabs-title = ส่งแท็บให้ตัวคุณเองทันที
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = แบ่งปันหน้าระหว่างอุปกรณ์ของคุณทันทีโดยไม่ต้องคัดลอกลิงก์หรือออกจากเบราว์เซอร์
onboarding-send-tabs-button = เริ่มใช้ Send Tabs
onboarding-pocket-anywhere-title = อ่านและฟังได้ทุกที่
onboarding-pocket-anywhere-text2 = บันทึกเนื้อหาโปรดของคุณแบบออฟไลน์ด้วยแอป { -pocket-brand-name } และอ่าน ฟัง และดูเมื่อใดก็ตามที่คุณสะดวก
onboarding-pocket-anywhere-button = ลอง { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = สร้างและจัดเก็บรหัสผ่านที่คาดเดายาก
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } ช่วยสร้างรหัสผ่านที่คาดเดาได้ยากในทันทีและบันทึกรหัสผ่านทั้งหมดในที่เดียว
onboarding-lockwise-strong-passwords-button = จัดการการเข้าสู่ระบบของคุณ
onboarding-facebook-container-title = ตั้งค่าขอบเขตให้กับ Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } แยกโปรไฟล์ของคุณออกจากสิ่งอื่น ทำให้ Facebook ติดตามคุณทั่วทั้งเว็บได้ยาก
onboarding-facebook-container-button = เพิ่มส่วนขยาย
onboarding-import-browser-settings-title = นำเข้าที่คั่นหน้า, รหัสผ่าน, และอื่น ๆ
onboarding-import-browser-settings-text = ลองใช้กันเลย นำไซต์และการตั้งค่า Chrome ของคุณไปกับคุณได้อย่างง่ายดาย
onboarding-import-browser-settings-button = นำเข้าข้อมูล Chrome
onboarding-personal-data-promise-title = ออกแบบมาให้เป็นส่วนตัว
onboarding-personal-data-promise-text = { -brand-product-name } ปฏิบัติต่อข้อมูลของคุณด้วยความเคารพโดยใช้ให้น้อย ปกป้อง และมีความชัดเจนเกี่ยวกับวิธีที่เราใช้
onboarding-personal-data-promise-button = อ่านคำสัญญาของเรา

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = เยี่ยม คุณได้รับ { -brand-short-name } แล้ว
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = ตอนนี้ให้คุณโหลด <icon></icon><b>{ $addon-name }</b> ได้เลย
return-to-amo-extension-button = เพิ่มส่วนขยาย
return-to-amo-get-started-button = เริ่มต้นใช้งานกับ { -brand-short-name }
onboarding-not-now-button-label = ไม่ใช่ตอนนี้

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = เยี่ยม คุณได้ติดตั้ง { -brand-short-name } แล้ว
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = ตอนนี้มาติดตั้ง <img data-l10n-name="icon"/> <b>{ $addon-name }</b> กันเลย
return-to-amo-add-extension-label = เพิ่มส่วนขยาย

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = ยินดีต้อนรับสู่ <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = เบราว์เซอร์ที่รวดเร็ว ปลอดภัย และเป็นส่วนตัวที่ได้รับการสนับสนุนโดยองค์กรไม่แสวงหาผลกำไร
onboarding-multistage-welcome-primary-button-label = เริ่มตั้งค่า
onboarding-multistage-welcome-secondary-button-label = ลงชื่อเข้า
onboarding-multistage-welcome-secondary-button-text = มีบัญชีแล้วใช่หรือไม่
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = ทำให้ { -brand-short-name } เป็น<span data-l10n-name="zap">ค่าเริ่มต้น</span>ของคุณ
onboarding-multistage-set-default-subtitle = รวดเร็ว ปลอดภัย และเป็นส่วนตัวในทุกครั้งที่คุณเรียกดู
onboarding-multistage-set-default-primary-button-label = ทำให้เป็นค่าเริ่มต้น
onboarding-multistage-set-default-secondary-button-label = ไม่ใช่ตอนนี้
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = เริ่มใช้งานโดยการทำให้ <span data-l10n-name="zap">{ -brand-short-name }</span> เป็นเบราว์เซอร์หลักเพียงคลิกเดียว
onboarding-multistage-pin-default-subtitle = ให้คุณใช้เว็บได้อย่างรวดเร็ว ปลอดภัย และเป็นส่วนตัวในทุกครั้ง
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = เลือก { -brand-short-name } ภายใต้ เว็บเบราว์เซอร์ เมื่อการตั้งค่าของคุณเปิด
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = การดำเนินการนี้จะปักหมุด { -brand-short-name } ที่แถบงานและเปิดการตั้งค่า
onboarding-multistage-pin-default-primary-button-label = ทำให้ { -brand-short-name } เป็นเบราว์เซอร์หลักของฉัน
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = นำเข้ารหัสผ่าน <br/>ที่คั่นหน้า และ<span data-l10n-name="zap">อื่น ๆ</span>
onboarding-multistage-import-subtitle = มาจากเบราว์เซอร์อื่นหรือไม่? คุณสามารถนำทุกอย่างมาสู่ { -brand-short-name } ได้ง่าย ๆ
onboarding-multistage-import-primary-button-label = เริ่มการนำเข้า
onboarding-multistage-import-secondary-button-label = ไม่ใช่ตอนนี้
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = ไซต์ที่แสดงที่นี่ถูกพบบนอุปกรณ์นี้ { -brand-short-name } จะไม่บันทึกหรือซิงค์ข้อมูลจากเบราว์เซอร์อื่นเว้นแต่คุณจะเลือกนำเข้า
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = เริ่มต้นใช้งาน: หน้าจอ { $current } จาก { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = เลือก<span data-l10n-name="zap">รูปลักษณ์</span>
onboarding-multistage-theme-subtitle = ปรับแต่ง { -brand-short-name } ด้วยชุดตกแต่ง
onboarding-multistage-theme-primary-button-label2 = เสร็จสิ้น
onboarding-multistage-theme-secondary-button-label = ไม่ใช่ตอนนี้
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = อัตโนมัติ
onboarding-multistage-theme-label-light = สว่าง
onboarding-multistage-theme-label-dark = มืด
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        สืบทอดรูปลักษณ์ของระบบปฏิบัติการของคุณ
        สำหรับปุ่ม เมนู และหน้าต่าง
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        สืบทอดรูปลักษณ์ของระบบปฏิบัติการของคุณ
        สำหรับปุ่ม เมนู และหน้าต่าง
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        ใช้ลักษณะที่ปรากฏแบบสีอ่อนสำหรับปุ่ม
        เมนู และหน้าต่าง
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        ใช้ลักษณะที่ปรากฏแบบสีอ่อนสำหรับปุ่ม
        เมนู และหน้าต่าง
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        ใช้ลักษณะที่ปรากฏแบบสีเข้มสำหรับปุ่ม
        เมนู และหน้าต่าง
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        ใช้ลักษณะที่ปรากฏแบบสีเข้มสำหรับปุ่ม
        เมนู และหน้าต่าง
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        ใช้ลักษณะที่ปรากฏแบบสีสันสำหรับปุ่ม
        เมนู และหน้าต่าง
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        ใช้ลักษณะที่ปรากฏแบบสีสันสำหรับปุ่ม
        เมนู และหน้าต่าง

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Firefox".
# It also signals the passion users bring to Firefox, how they use
# Firefox to pursue those passions, as well as the boldness in their
# choice to use Firefox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text =
    ทุกอย่างเริ่มจาก
    ที่นี่
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — นักออกแบบเฟอร์นิเจอร์ แฟน Firefox
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = ปิดภาพเคลื่อนไหว

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Firefox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] เก็บ { -brand-short-name } ไว้ใน Dock ของคุณเพื่อให้เข้าถึงได้อย่างง่ายดาย
       *[other] ปักหมุด { -brand-short-name } เข้ากับแถบงานของคุณเพื่อให้เข้าถึงได้อย่างง่ายดาย
    }
# Primary button string used on welcome page when Firefox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] เก็บไว้ใน Dock
       *[other] ปักหมุดเข้ากับแถบงาน
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Firefox is both pinned and default
mr1-onboarding-get-started-primary-button-label = เริ่มต้น
mr1-onboarding-welcome-header = ยินดีต้อนรับสู่ { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = ทำให้ { -brand-short-name } เป็นเบราว์เซอร์หลักของฉัน
    .title = ตั้ง { -brand-short-name } เป็นเบราว์เซอร์หลักและปักหมุดเข้ากับแถบงาน
# This string will be used on welcome page primary button label
# when Firefox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = ทำให้ { -brand-short-name } เป็นเบราว์เซอร์เริ่มต้นของฉัน
mr1-onboarding-set-default-secondary-button-label = ไม่ใช่ตอนนี้
mr1-onboarding-sign-in-button-label = ลงชื่อเข้า

## Title, subtitle and primary button string used on set default onboarding screen
## when Firefox is not default browser

mr1-onboarding-default-header = ทำให้ { -brand-short-name } เป็นค่าเริ่มต้นของคุณ
mr1-onboarding-default-subtitle = พบกับความเร็ว ความปลอดภัย และความเป็นส่วนตัวแบบอัตโนมัติ
mr1-onboarding-default-primary-button-label = ทำให้เป็นเบราว์เซอร์เริ่มต้น

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = นำทุกอย่างติดตัวไปด้วย
mr1-onboarding-import-subtitle = นำเข้ารหัสผ่าน <br/>ที่คั่นหน้า และอื่น ๆ ของคุณ
# The primary import button label will depend on whether we can detect which browser was used to download Firefox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = นำเข้าจาก { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = นำเข้าจากเบราว์เซอร์ก่อนหน้า
mr1-onboarding-import-secondary-button-label = ไม่ใช่ตอนนี้
mr1-onboarding-theme-header = ทำให้เป็นของคุณเอง
mr1-onboarding-theme-subtitle = ปรับแต่ง { -brand-short-name } ด้วยชุดตกแต่ง
mr1-onboarding-theme-primary-button-label = บันทึกชุดตกแต่ง
mr1-onboarding-theme-secondary-button-label = ไม่ใช่ตอนนี้
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = ชุดตกแต่งระบบ
mr1-onboarding-theme-label-light = สว่าง
mr1-onboarding-theme-label-dark = มืด
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        ใช้ชุดตกแต่งสำหรับปุ่ม เมนู และหน้าต่าง
        ตามระบบปฏิบัติการ
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        ใช้ชุดตกแต่งสำหรับปุ่ม เมนู และหน้าต่าง
        ตามระบบปฏิบัติการ
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        ใช้ชุดตกแต่งแบบสว่างสำหรับปุ่ม
        เมนู และหน้าต่าง
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        ใช้ชุดตกแต่งแบบสว่างสำหรับปุ่ม
        เมนู และหน้าต่าง
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        ใช้ชุดตกแต่งแบบมืดสำหรับปุ่ม
        เมนู และหน้าต่าง
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        ใช้ชุดตกแต่งแบบมืดสำหรับปุ่ม
        เมนู และหน้าต่าง
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        ใช้ชุดตกแต่งแบบไดนามิกที่มีสีสันสำหรับปุ่ม
        เมนู และหน้าต่าง
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        ใช้ชุดตกแต่งแบบไดนามิกที่มีสีสันสำหรับปุ่ม
        เมนู และหน้าต่าง
