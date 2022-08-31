# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = ยินดีต้อนรับสู่ { -brand-short-name }
onboarding-start-browsing-button-label = เริ่มการเรียกดู
onboarding-not-now-button-label = ไม่ใช่ตอนนี้

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = เยี่ยม คุณได้ติดตั้ง { -brand-short-name } แล้ว
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = ตอนนี้มาติดตั้ง <img data-l10n-name="icon"/> <b>{ $addon-name }</b> กันเลย
return-to-amo-add-extension-label = เพิ่มส่วนขยาย
return-to-amo-add-theme-label = เพิ่มชุดตกแต่ง

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = เริ่มต้นใช้งาน: หน้าจอ { $current } จาก { $total }

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

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
mr2-onboarding-colorway-header = Life in color
mr2-onboarding-colorway-subtitle = ชุดรูปแบบสีใหม่ที่สดใส มีให้ใช้ในช่วงเวลาจำกัด
mr2-onboarding-colorway-primary-button-label = บันทึกชุดรูปแบบสี
mr2-onboarding-colorway-secondary-button-label = ไม่ใช่ตอนนี้
mr2-onboarding-colorway-label-soft = Soft
mr2-onboarding-colorway-label-balanced = Balanced
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Bold
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = อัตโนมัติ
# This string will be used for Default theme
mr2-onboarding-theme-label-default = ค่าเริ่มต้น
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
onboarding-theme-primary-button-label = เสร็จสิ้น

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
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = ใช้ชุดรูปแบบสีนี้
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = ใช้ชุดรูปแบบสีนี้
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = สำรวจชุดรูปแบบสี { $colorwayName }
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-label = สำรวจชุดรูปแบบสี { $colorwayName }
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = สำรวจชุดตกแต่งเริ่มต้น
# Selector description for default themes
mr2-onboarding-default-theme-label = สำรวจชุดตกแต่งเริ่มต้น

## Strings for Thank You page

mr2-onboarding-thank-you-header = ขอบคุณที่เลือกเรา
mr2-onboarding-thank-you-text = { -brand-short-name } เป็นเบราว์เซอร์อิสระที่สนับสนุนโดยองค์กรไม่แสวงหาผลกำไร เรากำลังร่วมกันทำให้เว็บปลอดภัยขึ้น แข็งแกร่งขึ้น และเป็นส่วนตัวมากขึ้น
mr2-onboarding-start-browsing-button-label = เริ่มการเรียกดู

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"


## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"
##   $systemLanguage (String) - The name of the system language, e.g "Español (ES)"
##   $appLanguage (String) - The name of the language shipping in the browser build, e.g. "English (EN)"

onboarding-live-language-header = เลือกภาษาของคุณ
onboarding-live-language-button-label-downloading = กำลังดาวน์โหลดชุดภาษาสำหรับ { $negotiatedLanguage }…
onboarding-live-language-waiting-button = กำลังขอข้อมูลเกี่ยวกับภาษาที่มีให้ใช้…
onboarding-live-language-installing = กำลังติดตั้งชุดภาษาสำหรับ { $negotiatedLanguage }…
onboarding-live-language-secondary-cancel-download = ยกเลิก
onboarding-live-language-skip-button-label = ข้าม

## Waterfox 100 Thank You screens

# "Hero Text" displayed on left side of welcome screen. This text can be
# formatted to span multiple lines as needed. The <span data-l10n-name="zap">
# </span> in this string allows a "zap" underline style to be automatically
# added to the text inside it. "Yous" should stay inside the zap span, but
# "Thank" can be put inside instead if there's no "you" in the translation.
# The English text would normally be "100 Thank-Yous" i.e., plural noun, but for
# aesthetics of splitting it across multiple lines, the hyphen is omitted.
fx100-thank-you-hero-text =
    <span data-l10n-name="zap">ขอบคุณ</span>
    ครั้งที่
    100
fx100-thank-you-subtitle = นี่คือรุ่นที่ 100 ของเรา! ขอบคุณที่ช่วยเราสร้างอินเทอร์เน็ตที่ดีและแข็งแกร่งขึ้น
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] เก็บ { -brand-short-name } ไว้ใน Dock
       *[other] ปักหมุด { -brand-short-name } เข้ากับแถบงาน
    }
fx100-upgrade-thanks-header = 100 คำขอบคุณ
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = นี่คือ { -brand-short-name } รุ่นที่ 100 ของเรา <em>ขอบคุณ</em>ที่ช่วยเราสร้างอินเทอร์เน็ตที่ดีและแข็งแกร่งขึ้น
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = นี่คือรุ่นที่ 100 ของเรา! ขอบคุณที่ร่วมเป็นส่วนหนึ่งของชุมชนของเรา สร้างอินเทอร์เน็ตที่ดีและแข็งแกร่งขึ้น ร่วมเดินทางกับเราไปอีก 100 รุ่นด้วยการนำ { -brand-short-name } มาไว้ใกล้คุณแค่เพียงคลิกเดียว
mr2022-onboarding-secondary-skip-button-label = ข้ามขั้นตอนนี้

## MR2022 New User Pin Waterfox screen strings


## MR2022 Existing User Pin Waterfox Screen Strings


## MR2022 New User Set Default screen strings


## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.


## MR2022 Import Settings screen strings


## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.


## MR2022 Multistage Mobile Download screen strings


## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned


## MR2022 Privacy Segmentation screen strings


## MR2022 Multistage Gratitude screen strings

