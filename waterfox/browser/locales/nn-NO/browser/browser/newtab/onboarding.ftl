# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Velkomen til { -brand-short-name }
onboarding-start-browsing-button-label = Start nettlesing
onboarding-not-now-button-label = Ikkje no

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Bra, du har { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Lat oss no hente <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Legg til utvidinga
return-to-amo-add-theme-label = Legg til temaet

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Kome i gang: Skjermbilde { $current } av { $total }

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator2 =
    .aria-valuetext = Framdrift: steg { $current } av { $total }
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = Det byrjar her
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — Møbeldesignar, Waterfox-fan
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Slå av animasjonar

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Behald { -brand-short-name } i Dock for enkel tilgang
       *[other] Fest { -brand-short-name } til oppgåvelinja for enkel tilgang
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Behald i Dock
       *[other] Fest til oppgåvelinje
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Kom i gang
mr1-onboarding-welcome-header = Velkomen til { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Vel { -brand-short-name } som primærnettlesar
    .title = Stiller inn { -brand-short-name } som standardnettlesar og festar han til oppgåvelinja
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Vel { -brand-short-name } som stanardnettlesar
mr1-onboarding-set-default-secondary-button-label = Ikkje no
mr1-onboarding-sign-in-button-label = Logg inn

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = Bruk { -brand-short-name } som standardnettlesar
mr1-onboarding-default-subtitle = Set fart, sikkerheit og personvern på autopilot.
mr1-onboarding-default-primary-button-label = Bruk som standardnettlesar

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Ta med deg alt
mr1-onboarding-import-subtitle = Importer passorda dine, <br/>bokmerke og meir.
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importer frå { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importer frå tidlegare nettlesar
mr1-onboarding-import-secondary-button-label = Ikkje no
mr2-onboarding-colorway-header = Livet i fargar
mr2-onboarding-colorway-subtitle = Levande nye fargesamansetjingar. Tilgjengeleg i ein avgrensa periode.
mr2-onboarding-colorway-primary-button-label = Lagre fargesamansetjing
mr2-onboarding-colorway-secondary-button-label = Ikkje no
mr2-onboarding-colorway-label-soft = Mjuk
mr2-onboarding-colorway-label-balanced = Balansert
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Modig
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Automatisk
# This string will be used for Default theme
mr2-onboarding-theme-label-default = Standard
mr1-onboarding-theme-header = Gjer han til din eigen
mr1-onboarding-theme-subtitle = Tilpass { -brand-short-name } med eit tema.
mr1-onboarding-theme-primary-button-label = Lagre tema
mr1-onboarding-theme-secondary-button-label = Ikkje no
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Systemtema
mr1-onboarding-theme-label-light = Lyst
mr1-onboarding-theme-label-dark = Mørkt
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow
onboarding-theme-primary-button-label = Ferdig

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Brukar same fargeskjema som operativsystemet
        for knappar, menyar og vindauge.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Brukar same fargetema som operativsystemet
        for knappar, menyar og vindauge.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Bruk eit lyst tema for knappar,
        menyar og vindauge.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Bruk eit lyst tema for knappar,
        menyar og vindauge.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Bruk eit mørt tema for knappar,
        menyar og vindauge.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Bruk eit mørt tema for knappar,
        menyar og vindauge.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Bruk eit dynamisk, fargerikt tema for knappar,
        menyar og vindauge.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Bruk eit dynamisk, fargerikt tema for knappar,
        menyar og vindauge.
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Bruk denne fargesamansetjinga.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Bruk denne fargesamansetjinga.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = Utforsk { $colorwayName }-fargesamansetjingar.
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-label = Utforsk { $colorwayName }-fargesamansetjingar.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Utforsk standardtema.
# Selector description for default themes
mr2-onboarding-default-theme-label = Utforsk standardtema.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Takk for at du valde oss
mr2-onboarding-thank-you-text = { -brand-short-name } er ein uavhengig nettlesar som er støtta av ein ideell organisasjon. Saman gjer vi nettet tryggare, sunnare og meir privat.
mr2-onboarding-start-browsing-button-label = Byrj surfinga

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"

onboarding-live-language-header = Vel ditt språk
onboarding-live-language-button-label-downloading = Lastar ned språkpakke for { $negotiatedLanguage }…
onboarding-live-language-waiting-button = Hentar tilgjengelege språk…
onboarding-live-language-installing = Installerer språkpakken for { $negotiatedLanguage }…
onboarding-live-language-secondary-cancel-download = Avbryt
onboarding-live-language-skip-button-label = Hopp over

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
    <span data-l10n-name="zap">tusen takk</span>
fx100-thank-you-subtitle = Dette er utgjeving nummer 100! Takk for at du hjelper oss med å byggje eit betre og sunnare internett.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Behald { -brand-short-name } i Dock
       *[other] Fest { -brand-short-name } til oppgåvelinja
    }
fx100-upgrade-thanks-header = 100 tusen takk
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = Dette er utgjeving nummer 100 av { -brand-short-name }. Tusen takk for at <em>du</em> hjelper oss med å byggje eit betre og sunnare internett.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = Dette er utgjeving nummer 100! Takk for at du er ein del av samfunnet vårt. Ha { -brand-short-name } eitt klikk unna for dei neste 100.
