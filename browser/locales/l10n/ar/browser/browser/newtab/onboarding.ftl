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

onboarding-welcome-header = مرحبًا بك في { -brand-short-name }
onboarding-start-browsing-button-label = ابدأ التصفح

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

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = مرحبًا في <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = المتصفّح السريع والآمن والخاص وتدعمه مؤسسة غير ربحية.
onboarding-multistage-welcome-primary-button-label = ابدأ الإعداد
onboarding-multistage-welcome-secondary-button-label = لِج
onboarding-multistage-welcome-secondary-button-text = ألديك حسابًا؟

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = اضبط { -brand-short-name } ليكون <span data-l10n-name="zap">المبدئي</span>
onboarding-multistage-set-default-subtitle = السرعة والأمان والخصوصية في كل مرة تتصفح فيها.
onboarding-multistage-set-default-primary-button-label = اجعله المبدئي
onboarding-multistage-set-default-secondary-button-label = ليس الآن

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = ابدأ أولًا بتسهيل الوصول إلى <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-pin-default-subtitle = تصفّح سريع وآمن وخاص كلّما استعملت الوِب.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = اختر { -brand-short-name } من ”مستعرض الويب“ حين تظهر الإعدادات
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = هذا سيُثبّت { -brand-short-name } في شريط المهام ويفتح الإعدادات
onboarding-multistage-pin-default-primary-button-label = اضبط { -brand-short-name } ليكون متصفّحي الأساسي

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = استورِد كلمات السر <br/>والعلامات و<span data-l10n-name="zap">غيرها</span>
onboarding-multistage-import-subtitle = انتقلت إلى { -brand-short-name } من متصفّح آخر؟ نقل أمورك إلى هنا أسهل مما تتخيل.
onboarding-multistage-import-primary-button-label = ابدأ الاستيراد
onboarding-multistage-import-secondary-button-label = ليس الآن

# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = وجدنا المواقع أسفله في هذا الجهاز. لا يحفظ { -brand-short-name } البيانات ولا يُزامنها من متصفّحاتك الأخرى إلّا بموافقتك على استيرادها.

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = البداية: شاشة { $current } من أصل { $total }

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = اختر <span data-l10n-name="zap">مظهرًا</span>
onboarding-multistage-theme-subtitle = خصّص { -brand-short-name } باستعمال سمة.
onboarding-multistage-theme-primary-button-label2 = تمّ
onboarding-multistage-theme-secondary-button-label = ليس الآن

# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = تلقائي

onboarding-multistage-theme-label-light = فاتحة
onboarding-multistage-theme-label-dark = داكنة
# "Waterfox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow

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

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        استعمل مظهر نظام التشغيل
        لعرض الأزرار والقوائم والنوافذ.

# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        استعمل مظهر نظام التشغيل
        لعرض الأزرار والقوائم والنوافذ.

# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        استعمل مظهرًا فاتحًا لعرض
        الأزرار والقوائم والنوافذ.

# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        استعمل مظهرًا فاتحًا لعرض
        الأزرار والقوائم والنوافذ.

# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        استعمل مظهرًا داكنًا لعرض
        الأزرار والقوائم والنوافذ.

# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        استعمل مظهرًا داكنًا لعرض
        الأزرار والقوائم والنوافذ.

# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        استعمل مظهرًا ملونًا لعرض
        الأزرار والقوائم والنوافذ.

# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        استعمل مظهرًا ملونًا لعرض
        الأزرار والقوائم والنوافذ.

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
