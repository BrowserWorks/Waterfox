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

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Velkomen til <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Den raske, trygge og private nettlesaren som er støtta av ein ideell organisasjon.
onboarding-multistage-welcome-primary-button-label = Start oppsett
onboarding-multistage-welcome-secondary-button-label = Logg inn
onboarding-multistage-welcome-secondary-button-text = Har du allereie ein konto?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = Bruk { -brand-short-name } som <span data-l10n-name="zap">standard</span>
onboarding-multistage-set-default-subtitle = Fart, sikkerheit og personvern kvar gong du surfar.
onboarding-multistage-set-default-primary-button-label = Vel som standard
onboarding-multistage-set-default-secondary-button-label = Ikkje no
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = Start med å gjere <span data-l10n-name="zap">{ -brand-short-name }</span> tilgjengeleg med eitt klikk
onboarding-multistage-pin-default-subtitle = Rask, sikker og privat nettlesing kvar gong du brukar nettet.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = Vel { -brand-short-name } under nettlesar når innstillingane dine vert opna
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = Dette vil feste { -brand-short-name } til oppgåvelinja og opne innstillingar
onboarding-multistage-pin-default-primary-button-label = Vel { -brand-short-name } som primærnettlesar
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importer passord, bokmerke og <span data-l10n-name="zap">meir</span>
onboarding-multistage-import-subtitle = Kjem du frå ein annan nettlesar? Det er enkelt å ta alt med til { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Start Import
onboarding-multistage-import-secondary-button-label = Ikkje no
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer =
    Nettstadane som er oppførte her vart funne på denne eininga.
    { -brand-short-name } lagrar eller synkroniserer
    ikkje data frå ein annan nettlesar med mindre du
    vel å importere dei.

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Kome i gang: Skjermbilde { $current } av { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Vel ein <span data-l10n-name="zap">utsjånad</span>
onboarding-multistage-theme-subtitle = Tilpass { -brand-short-name } med eit tema.
onboarding-multistage-theme-primary-button-label2 = Ferdig
onboarding-multistage-theme-secondary-button-label = Ikkje no
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automatisk
onboarding-multistage-theme-label-light = Lyst
onboarding-multistage-theme-label-dark = Mørkt
# "Waterfox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow
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

mr1-onboarding-default-header = Bruk { -brand-short-name } som standard
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
mr2-onboarding-colorway-primary-button-label = Lagre fargesamansetjing
mr2-onboarding-colorway-secondary-button-label = Ikkje no
mr2-onboarding-colorway-label-soft = Mjuk
mr2-onboarding-colorway-label-balanced = Balansert
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
        Arv utsjånad frå operativsystemet
        for knapper, menyer og vinduer.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Arv utsjånad frå operativsystemet
        for knapper, menyer og vinduer.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Bruk ein lys utsjånad for knappar,
        menyer og vinduer.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Bruk ein lys utsjånad for knappar,
        menyer og vinduer.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Bruk ein mørk utsjånad for knappar,
        menyer og vinduer.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Bruk ein mørk utsjånad for knappar,
        menyer og vinduer.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Bruk ein fargerik utsjånad for knappar,
        menyer og vinduer.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Bruk ein fargerik utsjånad for knappar,
        menyer og vinduer.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

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
mr2-onboarding-colorway-description =
    .aria-description = Utforsk { $colorwayName }-fargesamansetjingar.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Utforsk standardtema.

## Strings for Thank You page

