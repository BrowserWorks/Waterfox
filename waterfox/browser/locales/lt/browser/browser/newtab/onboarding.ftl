# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Sveiki, čia „{ -brand-short-name }“
onboarding-start-browsing-button-label = Pradėti naršymą
onboarding-not-now-button-label = Ne dabar

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Pradėti

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Puiku, jūs turite „{ -brand-short-name }“
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Dabar įdiekime jums <img data-l10n-name="icon"/> <b>„{ $addon-name }“</b>.
return-to-amo-add-extension-label = Įdiegti priedą
return-to-amo-add-theme-label = Pridėti grafinį apvalkalą

##  Variables: $addon-name (String) - Name of the add-on to be installed

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Išjungti animacijas

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-sign-in-button-label = Prisijungti

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

## Multistage MR1 onboarding strings (about:welcome pages)

# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importuoti iš „{ $previous }“

mr1-onboarding-theme-header = Pritaikykite sau
mr1-onboarding-theme-subtitle = Individualizuokite „{ -brand-short-name }“ su grafiniu apvalkalu.
mr1-onboarding-theme-secondary-button-label = Ne dabar

# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Sistemos grafinis apvalkalas

mr1-onboarding-theme-label-light = Šviesus
mr1-onboarding-theme-label-dark = Tamsus
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow

onboarding-theme-primary-button-label = Atlikta

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Atsižvelgti į operacinės sistemos grafinį
        apvalkalą mygtukams, meniu, ir langams.

# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Atsižvelgti į operacinės sistemos grafinį
        apvalkalą mygtukams, meniu, ir langams.

# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Naudoti šviesų grafinį apvalkalą
        mygtukams, meniu, ir langams.

# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Naudoti šviesų grafinį apvalkalą
        mygtukams, meniu, ir langams.

# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Naudoti tamsų grafinį apvalkalą
        mygtukams, meniu, ir langams.

# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Naudoti tamsų grafinį apvalkalą
        mygtukams, meniu, ir langams.

# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Naudoti dinamišką, spalvingą grafinį apvalkalą
        mygtukams, meniu, ir langams.

# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Naudoti dinamišką, spalvingą grafinį apvalkalą
        mygtukams, meniu, ir langams.

# Selector description for default themes
mr2-onboarding-default-theme-label = Atraskite numatytuosius grafinius apvalkalus.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Ačiū, kad pasirinkote mus
mr2-onboarding-thank-you-text = „{ -brand-short-name }“ yra nepriklausoma naršyklė, remiama ne pelno siekiančios organizacijos. Kartu mes kuriame saugesnį, sveikesnį, privatesnį internetą.
mr2-onboarding-start-browsing-button-label = Pradėti naršymą

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

onboarding-live-language-header = Pasirinkite savo kalbą

onboarding-live-language-button-label-downloading = Atsiunčiamas { $negotiatedLanguage } kalbos paketas…
onboarding-live-language-waiting-button = Gaunamos galimos kalbos…
onboarding-live-language-installing = Diegiamas { $negotiatedLanguage } kalbos paketas…

onboarding-live-language-secondary-cancel-download = Atsisakyti
onboarding-live-language-skip-button-label = Praleisti

## Waterfox 100 Thank You screens

# "Hero Text" displayed on left side of welcome screen. This text can be
# formatted to span multiple lines as needed. The <span data-l10n-name="zap">
# </span> in this string allows a "zap" underline style to be automatically
# added to the text inside it. "Yous" should stay inside the zap span, but
# "Thank" can be put inside instead if there's no "you" in the translation.
# The English text would normally be "100 Thank-Yous" i.e., plural noun, but for
# aesthetics of splitting it across multiple lines, the hyphen is omitted.
fx100-thank-you-hero-text =
    100
    Padėkų
    <span data-l10n-name="zap">Jums</span>
fx100-thank-you-subtitle = Tai mūsų 100-asis leidimas! Dėkojame, kad padedate mums kurti geresnį ir sveikesnį internetą.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Laikyti „{ -brand-short-name }“ užduočių juostoje
       *[other] Įsegti „{ -brand-short-name }“ į užduočių juostą
    }

fx100-upgrade-thanks-header = 100 padėkų jums
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = Tai 100-asis „{ -brand-short-name }“ leidimas. Dėkojame <em>jums</em>, kad padedate mums kurti geresnį ir sveikesnį internetą.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = Tai mūsų 100-asis leidimas! Ačiū, kad esate mūsų bendruomenės dalis. Likite su „{ -brand-short-name }“ dar kitam 100.

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

