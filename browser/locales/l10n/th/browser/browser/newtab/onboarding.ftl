# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

## Welcome modal dialog strings


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.

## Welcome page strings

onboarding-welcome-header = ยินดีต้อนรับสู่ { -brand-short-name }

onboarding-start-browsing-button-label = เริ่มการเรียกดู

## Welcome full page string

## Waterfox Sync modal dialog strings.

## This is part of the line "Enter your email to continue to Waterfox Sync"


## These are individual benefit messages shown with an image, title and
## description.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

## Message strings belonging to the Return to AMO flow

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

## Multistage onboarding strings (about:welcome pages)

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
# "Waterfox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text =
    ทุกอย่างเริ่มจาก
    ที่นี่

# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — นักออกแบบเฟอร์นิเจอร์ แฟน Waterfox

# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = ปิดภาพเคลื่อนไหว

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] เก็บ { -brand-short-name } ไว้ใน Dock ของคุณเพื่อให้เข้าถึงได้อย่างง่ายดาย
       *[other] ปักหมุด { -brand-short-name } เข้ากับแถบงานของคุณเพื่อให้เข้าถึงได้อย่างง่ายดาย
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] เก็บไว้ใน Dock
       *[other] ปักหมุดเข้ากับแถบงาน
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = เริ่มต้น

mr1-onboarding-welcome-header = ยินดีต้อนรับสู่ { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = ทำให้ { -brand-short-name } เป็นเบราว์เซอร์หลักของฉัน
    .title = ตั้ง { -brand-short-name } เป็นเบราว์เซอร์หลักและปักหมุดเข้ากับแถบงาน

# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = ทำให้ { -brand-short-name } เป็นเบราว์เซอร์เริ่มต้นของฉัน
mr1-onboarding-set-default-secondary-button-label = ไม่ใช่ตอนนี้
mr1-onboarding-sign-in-button-label = ลงชื่อเข้า

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = ทำให้ { -brand-short-name } เป็นค่าเริ่มต้นของคุณ
mr1-onboarding-default-subtitle = พบกับความเร็ว ความปลอดภัย และความเป็นส่วนตัวแบบอัตโนมัติ
mr1-onboarding-default-primary-button-label = ทำให้เป็นเบราว์เซอร์เริ่มต้น

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = นำทุกอย่างติดตัวไปด้วย
mr1-onboarding-import-subtitle = นำเข้ารหัสผ่าน <br/>ที่คั่นหน้า และอื่น ๆ ของคุณ

# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
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
