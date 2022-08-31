# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = مرحبًا بك في { -brand-short-name }
onboarding-start-browsing-button-label = ابدأ التصفح
onboarding-not-now-button-label = ليس الآن

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = هذا رائع، لديك الآن { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = هيا نثبّت لك <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = أضِف الامتداد

## Multistage 3-screen onboarding flow strings (about:welcome pages)

return-to-amo-add-theme-label = أضِف السمة

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = البداية: شاشة { $current } من أصل { $total }

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = من هنا تبدأ الرحلة

# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = سورايا أوسوريو - مصمّمة أثاث، من هواة Waterfox

# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = عطّل الرسوم المتحركة

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] أضِف { -brand-short-name } إلى شريط Dock للوصول إليه بسرعة
       *[other] ثبّت { -brand-short-name } في شريط المهام للوصول إليه بسرعة
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] ضَعه في شريط Dock
       *[other] ثبّت في شريط المهام
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = ابدأ

mr1-onboarding-welcome-header = مرحبًا بك في { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = اضبط { -brand-short-name } ليكون متصفّحي الأساسي
    .title = يتيح لك الخيار ضبط { -brand-short-name } ليكون المتصفّح المبدئي ويثبّته في شريط المهام

# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = اضبط { -brand-short-name } ليكون متصفّحي المبدئي
mr1-onboarding-set-default-secondary-button-label = ليس الآن
mr1-onboarding-sign-in-button-label = لِج

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = اضبط { -brand-short-name } ليكون المبدئي
mr1-onboarding-default-subtitle = اجعل السرعة والأمان والخصوصية تعمل تلقائيا.
mr1-onboarding-default-primary-button-label = اجعله المتصفح المبدئي

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = خُذ كل شي معك
mr1-onboarding-import-subtitle = استورِد كلمات السر<br/>والعلامات وغيرها المزيد.

# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = استورِد من { $previous }

# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = استورِدها من المتصفّح السابق
mr1-onboarding-import-secondary-button-label = ليس الآن

mr2-onboarding-colorway-header = الحياة ألوان
mr2-onboarding-colorway-subtitle = أطقم ألوان جديدة وحيوية. متاحة لوقت محدود.
mr2-onboarding-colorway-primary-button-label = احفظ طقم الألوان
mr2-onboarding-colorway-secondary-button-label = ليس الآن

mr1-onboarding-theme-header = طوّعه كما ترغب
mr1-onboarding-theme-subtitle = خصّص { -brand-short-name } باستعمال سمة.
mr1-onboarding-theme-primary-button-label = احفظ السمة
mr1-onboarding-theme-secondary-button-label = ليس الآن

# System theme uses operating system color settings
mr1-onboarding-theme-label-system = سمة النظام

mr1-onboarding-theme-label-light = فاتحة
mr1-onboarding-theme-label-dark = داكنة
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = شفق ألبي (Alpenglow)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.


## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        اتبع سمة نظام التشغيل لعرض
        الأزرار والقوائم والنوافذ.

# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        اتبع سمة نظام التشغيل لعرض
        الأزرار والقوائم والنوافذ.

# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        استعمل سمة فاتحة لعرض
        الأزرار والقوائم والنوافذ.

# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        استعمل سمة فاتحة لعرض
        الأزرار والقوائم والنوافذ.

# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        استعمل سمة داكنة لعرض
        الأزرار والقوائم والنوافذ.

# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        استعمل سمة داكنة لعرض
        الأزرار والقوائم والنوافذ.

# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        استعمل سمة مفعمة بالألوان
        لعرض الأزرار والقوائم والنوافذ.

# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        استعمل سمة مفعمة بالألوان
        لعرض الأزرار والقوائم والنوافذ.

# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = استعمل طقم الألوان هذا.

# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = استعمل طقم الألوان هذا.

# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = استكشف أطقم الألوان { $colorwayName }.

# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-label = استكشف أطقم الألوان { $colorwayName }.

# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = استكشف السمات المبدئية.

# Selector description for default themes
mr2-onboarding-default-theme-label = استكشف السمات المبدئية.

## Strings for Thank You page

mr2-onboarding-thank-you-header = شكرًا لكم على اختيارنا
mr2-onboarding-thank-you-text = متصفّح { -brand-short-name } هو متصفّح مستقل تدعمه مؤسسة غير ربحية. نعمل معكم لنبني منظومة وِب آمنة وصحية وخاصة.
mr2-onboarding-start-browsing-button-label = ابدأ التصفح

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"

## Waterfox 100 Thank You screens

