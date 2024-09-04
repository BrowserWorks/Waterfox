# This Source Code Form is subject to the terms of the BrowserWorks Public
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

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = ابدأ

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

##  Variables: $addon-name (String) - Name of the add-on to be installed

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = عطّل الرسوم المتحركة

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-sign-in-button-label = لِج

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

## Multistage MR1 onboarding strings (about:welcome pages)

# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = استورِد من { $previous }

mr1-onboarding-theme-header = طوّعه كما ترغب
mr1-onboarding-theme-subtitle = خصّص { -brand-short-name } باستعمال سمة.
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

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"
##   $systemLanguage (String) - The name of the system language, e.g "Español (ES)"
##   $appLanguage (String) - The name of the language shipping in the browser build, e.g. "English (EN)"

## Waterfox 100 Thank You screens

## MR2022 New User Easy Setup screen strings

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

## Onboarding spotlight for infrequent users

## MR2022 Illustration alt tags
## Descriptive tags for illustrations used by screen readers and other assistive tech

## Device migration onboarding

