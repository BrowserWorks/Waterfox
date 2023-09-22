# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = ยินดีต้อนรับสู่ { -brand-short-name }
onboarding-start-browsing-button-label = เริ่มการเรียกดู
onboarding-not-now-button-label = ไม่ใช่ตอนนี้
mr1-onboarding-get-started-primary-button-label = เริ่มต้น

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = เยี่ยม คุณได้ติดตั้ง { -brand-short-name } แล้ว
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = ตอนนี้มาติดตั้ง <img data-l10n-name="icon"/> <b>{ $addon-name }</b> กันเลย
return-to-amo-add-extension-label = เพิ่มส่วนขยาย
return-to-amo-add-theme-label = เพิ่มชุดรูปแบบ

##  Variables: $addon-name (String) - Name of the add-on to be installed

mr1-return-to-amo-subtitle = พบกับ { -brand-short-name }
mr1-return-to-amo-addon-title = คุณได้เบราว์เซอร์ที่รวดเร็วและเป็นส่วนตัวมาอยู่ในปลายนิ้วมือของคุณแล้ว ตอนนี้คุณสามารถเพิ่ม <b>{ $addon-name }</b> และทำสิ่งต่าง ๆ ได้มากขึ้นด้วย { -brand-short-name }
mr1-return-to-amo-add-extension-label = เพิ่ม { $addon-name }

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator-label =
    .aria-label = ความคืบหน้า: ขั้นตอนที่ { $current } จาก { $total }

# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = ปิดภาพเคลื่อนไหว

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

## Multistage MR1 onboarding strings (about:welcome pages)

# String for the Waterfox Accounts button
mr1-onboarding-sign-in-button-label = ลงชื่อเข้า

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

## Multistage MR1 onboarding strings (about:welcome pages)

# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = นำเข้าจาก { $previous }

mr1-onboarding-theme-header = ทำให้เป็นของคุณเอง
mr1-onboarding-theme-subtitle = ปรับแต่ง { -brand-short-name } ด้วยชุดรูปแบบ
mr1-onboarding-theme-secondary-button-label = ไม่ใช่ตอนนี้

# System theme uses operating system color settings
mr1-onboarding-theme-label-system = ชุดรูปแบบของระบบ

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
        ใช้ธีมสำหรับปุ่ม เมนู และหน้าต่าง
        ตามระบบปฏิบัติการ

# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        ใช้ธีมสำหรับปุ่ม เมนู และหน้าต่าง
        ตามระบบปฏิบัติการ

# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        ใช้ธีมแบบสว่างสำหรับปุ่ม
        เมนู และหน้าต่าง

# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        ใช้ธีมแบบสว่างสำหรับปุ่ม
        เมนู และหน้าต่าง

# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        ใช้ธีมแบบมืดสำหรับปุ่ม
        เมนู และหน้าต่าง

# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        ใช้ธีมแบบมืดสำหรับปุ่ม
        เมนู และหน้าต่าง

# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        ใช้ธีมแบบไดนามิกที่มีสีสันสำหรับปุ่ม
        เมนู และหน้าต่าง

# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        ใช้ธีมแบบไดนามิกที่มีสีสันสำหรับปุ่ม
        เมนู และหน้าต่าง

# Selector description for default themes
mr2-onboarding-default-theme-label = สำรวจชุดรูปแบบเริ่มต้น

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

mr2022-onboarding-live-language-text = ให้ { -brand-short-name } พูดภาษาของคุณ

mr2022-language-mismatch-subtitle = { -brand-short-name } ถูกแปลเป็นภาษาต่าง ๆ กว่า 90 ภาษาโดยชุมชนของเรา ดูเหมือนว่าระบบของคุณกำลังใช้ { $systemLanguage } และ { -brand-short-name } กำลังใช้ { $appLanguage }

onboarding-live-language-button-label-downloading = กำลังดาวน์โหลดชุดภาษาสำหรับ { $negotiatedLanguage }…
onboarding-live-language-waiting-button = กำลังขอข้อมูลเกี่ยวกับภาษาที่มีให้ใช้…
onboarding-live-language-installing = กำลังติดตั้งชุดภาษาสำหรับ { $negotiatedLanguage }…

mr2022-onboarding-live-language-switch-to = เปลี่ยนเป็น { $negotiatedLanguage }
mr2022-onboarding-live-language-continue-in = ใช้ { $appLanguage } ต่อไป

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

## MR2022 New User Easy Setup screen strings

# Primary button string used on new user onboarding first screen showing multiple actions such as Set Default, Import from previous browser.
mr2022-onboarding-easy-setup-primary-button-label = บันทึกและดำเนินการต่อ
# Set Default action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-set-default-checkbox-label = ตั้ง { -brand-short-name } เป็นเบราว์เซอร์เริ่มต้น
# Import action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-import-checkbox-label = นำเข้าจากเบราว์เซอร์ก่อนหน้า

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = เปิดโลกสู่อินเทอร์เน็ตที่น่าทึ่ง
# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle = เปิดใช้งาน { -brand-short-name } ได้จากทุกที่แค่เพียงคลิกเดียว ทุกครั้งที่คุณทำ คุณเลือกเว็บที่เปิดกว้างและเป็นอิสระยิ่งขึ้น
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] เก็บ { -brand-short-name } ลงใน Dock
       *[other] ปักหมุด { -brand-short-name } เข้ากับแถบงาน
    }
# Subtitle will be used when user already has Waterfox pinned, but
# has not set it as their default browser.
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-only-subtitle = เปลี่ยนมาใช้เบราว์เซอร์ที่สนับสนุนโดยองค์กรไม่แสวงหาผลกำไร เราจะปกป้องความเป็นส่วนตัวของคุณในขณะที่คุณท่องเว็บ

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header = ขอบคุณที่หลงรัก { -brand-product-name }
# Subtitle is used on onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-subtitle = เข้าสู่โลกอินเทอร์เน็ตอันแข็งแกร่งได้จากทุกที่แค่เพียงคลิกเดียว ในรุ่นล่าสุดของเรามีสิ่งใหม่ ๆ หลายอย่างที่เราคิดว่าคุณจะต้องชอบแน่
# Subtitle will be used on the welcome screen for existing users
# when they already have Waterfox pinned but not set as default
mr2022-onboarding-existing-set-default-only-subtitle = ใช้เบราว์เซอร์ที่ปกป้องความเป็นส่วนตัวของคุณในขณะที่คุณท่องเว็บ รุ่นล่าสุดของเรามีสิ่งต่าง ๆ หลายอย่างที่คุณจะต้องชอบแน่
mr2022-onboarding-existing-pin-checkbox-label = เพิ่มการเรียกดูแบบส่วนตัวของ { -brand-short-name } ด้วย

## MR2022 New User Set Default screen strings

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title = ทำให้ { -brand-short-name } เป็นเบราว์เซอร์เริ่มต้นของคุณ
mr2022-onboarding-set-default-primary-button-label = ตั้ง { -brand-short-name } เป็นเบราว์เซอร์เริ่มต้น
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-subtitle = ใช้เบราว์เซอร์ที่สนับสนุนโดยองค์กรไม่แสวงหาผลกำไร เราจะปกป้องความเป็นส่วนตัวของคุณในขณะที่คุณท่องเว็บ

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-get-started-primary-subtitle = รุ่นล่าสุดของเราถูกสร้างขึ้นจากสิ่งต่าง ๆ รอบตัวคุณ ซึ่งจะทำให้คุณท่องเว็บได้ง่ายกว่าเดิม รุ่นล่าสุดนี้มาพร้อมกับคุณลักษณะต่าง ๆ ที่เราคิดว่าคุณจะต้องชอบแน่
mr2022-onboarding-get-started-primary-button-label = ตั้งค่าในไม่กี่วินาที

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = ตั้งค่าต่าง ๆ ได้อย่างรวดเร็วทันใจ
mr2022-onboarding-import-subtitle = ตั้งค่า { -brand-short-name } ในแบบที่คุณต้องการ เพิ่มที่คั่นหน้า รหัสผ่าน และอื่น ๆ จากเบราว์เซอร์ตัวเดิมของคุณ
mr2022-onboarding-import-primary-button-label-no-attribution = นำเข้าจากเบราว์เซอร์ก่อนหน้า

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = เลือกสีที่โดนใจคุณ
mr2022-onboarding-colorway-subtitle = เสียงที่เป็นอิสระสามารถเปลี่ยนวัฒนธรรมได้
mr2022-onboarding-colorway-primary-button-label-continue = ตั้งค่าและดำเนินการต่อ
mr2022-onboarding-existing-colorway-checkbox-label = ทำให้ { -firefox-home-brand-name } เป็นหน้าแรกที่เต็มไปด้วยสีสันของคุณ

mr2022-onboarding-colorway-label-default = ค่าเริ่มต้น
mr2022-onboarding-colorway-tooltip-default2 =
    .title = สี { -brand-short-name } ปัจจุบัน
mr2022-onboarding-colorway-description-default = <b>ใช้สี { -brand-short-name } ปัจจุบันของฉัน</b>

mr2022-onboarding-colorway-label-playmaker = เพลย์เมคเกอร์
mr2022-onboarding-colorway-tooltip-playmaker2 =
    .title = เพลย์เมคเกอร์ (แดง)
mr2022-onboarding-colorway-description-playmaker = <b>คุณคือเพลย์เมคเกอร์</b> คุณสร้างโอกาสในการชนะและช่วยทุกคนรอบตัวคุณยกระดับความสามารถในการเล่นเกมของพวกเขา

mr2022-onboarding-colorway-label-expressionist = นักแสดงออก
mr2022-onboarding-colorway-tooltip-expressionist2 =
    .title = นักแสดงออก (เหลือง)
mr2022-onboarding-colorway-description-expressionist = <b>คุณคือนักแสดงออก</b> คุณมองโลกแตกต่างออกไปและการสร้างสรรค์ของคุณก็กระตุ้นอารมณ์ของผู้อื่น

mr2022-onboarding-colorway-label-visionary = ผู้มีวิสัยทัศน์
mr2022-onboarding-colorway-tooltip-visionary2 =
    .title = ผู้มีวิสัยทัศน์ (เขียว)
mr2022-onboarding-colorway-description-visionary = <b>คุณคือผู้มีวิสัยทัศน์</b> คุณตั้งคำถามกับสภาพที่เป็นอยู่และกระตุ้นให้ผู้อื่นจินตนาการถึงอนาคตที่ดีกว่า

mr2022-onboarding-colorway-label-activist = นักกิจกรรม
mr2022-onboarding-colorway-tooltip-activist2 =
    .title = นักกิจกรรม (น้ำเงิน)
mr2022-onboarding-colorway-description-activist = <b>คุณคือนักกิจกรรม</b> คุณทำให้โลกนี้เป็นสถานที่ที่ดียิ่งขึ้นและชักนำให้ผู้อื่นเชื่อคุณ

mr2022-onboarding-colorway-label-dreamer = คนช่างฝัน
mr2022-onboarding-colorway-tooltip-dreamer2 =
    .title = คนช่างฝัน (ม่วง)
mr2022-onboarding-colorway-description-dreamer = <b>คุณคือคนช่างฝัน</b> คุณเชื่อว่าโชคเข้าข้างผู้กล้าเสมอและเป็นแรงบันดาลใจให้ผู้อื่นกล้า

mr2022-onboarding-colorway-label-innovator = นักนวัตกรรม
mr2022-onboarding-colorway-tooltip-innovator2 =
    .title = นักนวัตกรรม (ส้ม)
mr2022-onboarding-colorway-description-innovator = <b>คุณคือนักนวัตกรรม</b> คุณมองเห็นโอกาสทุกที่และสร้างอิทธิพลต่อชีวิตของทุกคนรอบตัวคุณ

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = สับเปลี่ยนไปมาระหว่างแล็ปท็อปกับโทรศัพท์
mr2022-onboarding-mobile-download-subtitle = นำแท็บจากอุปกรณ์เครื่องหนึ่งไปเปิดต่อจากที่ค้างไว้ในอีกเครื่องหนึ่ง รวมทั้งซิงค์ที่คั่นหน้าและรหัสผ่านของคุณได้จากทุกที่ที่คุณใช้ { -brand-product-name }
mr2022-onboarding-mobile-download-cta-text = สแกนคิวอาร์โค้ดเพื่อดาวน์โหลด { -brand-product-name } สำหรับมือถือ หรือ<a data-l10n-name="download-label">ส่งลิงก์ดาวน์โหลดให้ตัวคุณเอง</a>
mr2022-onboarding-no-mobile-download-cta-text = สแกนคิวอาร์โค้ดเพื่อดาวน์โหลด { -brand-product-name } สำหรับมือถือ

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = อิสระในการเรียกดูแบบส่วนตัวในคลิกเดียว
mr2022-upgrade-onboarding-pin-private-window-subtitle = ไม่เก็บคุกกี้หรือประวัติที่บันทึกไว้จากเดสก์ท็อปของคุณ ให้คุณเรียกดูโดยไม่มีใครแอบมอง
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] เก็บการเรียกดูแบบส่วนตัวของ { -brand-short-name } ลงใน Dock
       *[other] ปักหมุดการเรียกดูแบบส่วนตัวของ { -brand-short-name } เข้ากับแถบงาน
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = เราเคารพความเป็นส่วนตัวของคุณเสมอ
mr2022-onboarding-privacy-segmentation-subtitle = ไม่ว่าจะเป็นคำแนะนำที่ชาญฉลาดหรือการค้นหาที่ชาญฉลาดยิ่งขึ้น เรากำลังทำงานอย่างต่อเนื่องเพื่อสร้าง { -brand-product-name } ที่ดีและเป็นส่วนตัวมากขึ้น
mr2022-onboarding-privacy-segmentation-text-cta = คุณต้องการเห็นอะไรเมื่อเรานำเสนอคุณลักษณะใหม่ที่ใช้ข้อมูลของคุณเพื่อทำให้การท่องเว็บของคุณดีขึ้น?
mr2022-onboarding-privacy-segmentation-button-primary-label = ใช้คำแนะนำจาก { -brand-product-name }
mr2022-onboarding-privacy-segmentation-button-secondary-label = แสดงข้อมูลโดยละเอียด

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = คุณกำลังช่วยเราสร้างเว็บที่ดีขึ้น
mr2022-onboarding-gratitude-subtitle = ขอบคุณที่ใช้ { -brand-short-name } ซึ่งสนับสนุนโดย BrowserWorks ด้วยการสนับสนุนของคุณ เรากำลังทำงานเพื่อให้อินเทอร์เน็ตเปิดกว้าง เข้าถึงได้ และดียิ่งขึ้นสำหรับทุกคน
mr2022-onboarding-gratitude-primary-button-label = ดูว่ามีอะไรใหม่
mr2022-onboarding-gratitude-secondary-button-label = เริ่มเรียกดู

## Onboarding spotlight for infrequent users

onboarding-infrequent-import-title = ทำตัวตามสบาย
onboarding-infrequent-import-subtitle = ไม่ว่าคุณจะต้องการใช้งานไปตลอดหรือแค่แวะมาลองใช้เพียงนิดหน่อยก็ตาม โปรดทราบว่าคุณสามารถนำเข้าที่คั่นหน้า รหัสผ่าน และอื่นๆ ของคุณได้
onboarding-infrequent-import-primary-button = นำเข้าไปยัง { -brand-short-name }

## MR2022 Illustration alt tags
## Descriptive tags for illustrations used by screen readers and other assistive tech

mr2022-onboarding-pin-image-alt =
    .aria-label = คนกำลังทำงานบนแล็ปท็อปล้อมรอบด้วยดาวและดอกไม้
mr2022-onboarding-default-image-alt =
    .aria-label = คนกำลังกอดโลโก้ { -brand-product-name }
mr2022-onboarding-import-image-alt =
    .aria-label = คนกำลังขี่สเก็ตบอร์ดพร้อมกล่องไอคอนซอฟต์แวร์
mr2022-onboarding-mobile-download-image-alt =
    .aria-label = กบกำลังกระโดดข้ามใบบัวไปมาพร้อมคิวอาร์โค้ดสำหรับดาวน์โหลด { -brand-product-name } สำหรับมือถืออยู่ตรงกลาง
mr2022-onboarding-pin-private-image-alt =
    .aria-label = ไม้กายสิทธิ์กำลังทำให้โลโก้การเรียกดูแบบส่วนตัวของ { -brand-product-name } ปรากฏออกมานอกหมวก
mr2022-onboarding-privacy-segmentation-image-alt =
    .aria-label = มือผิวอ่อนและผิวคล้ำไฮไฟฟ์กัน
mr2022-onboarding-gratitude-image-alt =
    .aria-label = ภาพวิวดวงอาทิตย์ตกที่หน้าต่างพร้อมสุนัขจิ้งจอกและพืชในบ้านบนขอบหน้าต่าง
mr2022-onboarding-colorways-image-alt =
    .aria-label = สเปรย์มือวาดภาพคอลลาจที่เต็มไปด้วยสีสันซึ่งประกอบด้วยดวงตาสีเขียว รองเท้าสีส้ม ลูกบาสเกตบอลสีแดง หูฟังสีม่วง หัวใจสีน้ำเงิน และมงกุฎสีเหลือง

## Device migration onboarding

onboarding-device-migration-image-alt =
    .aria-label = สุนัขจิ้งจอกบนหน้าจอคอมพิวเตอร์แล็ปท็อปโบกมือ แล็ปท็อปมีเมาส์เสียบอยู่
onboarding-device-migration-title = ยินดีต้อนรับกลับมา!
onboarding-device-migration-subtitle = ลงชื่อเข้าใช้ { -fxaccount-brand-name(capitalization: "sentence") } ของคุณเพื่อนำที่คั่นหน้า รหัสผ่าน และประวัติติดตัวไปด้วยบนอุปกรณ์เครื่องใหม่ของคุณ
onboarding-device-migration-primary-button-label = ลงชื่อเข้า
