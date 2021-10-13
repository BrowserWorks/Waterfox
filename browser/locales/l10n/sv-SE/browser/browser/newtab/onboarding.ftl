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

onboarding-welcome-header = Välkommen till { -brand-short-name }
onboarding-start-browsing-button-label = Börja surfa
onboarding-not-now-button-label = Inte nu

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Toppen, du har { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Låt oss nu hämta <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Lägg till tillägget

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Välkommen till <span data-l10n-name="zap"> { -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Den snabba, säkra och privata webbläsaren som stöds av en ideell organisation.
onboarding-multistage-welcome-primary-button-label = Starta konfiguration
onboarding-multistage-welcome-secondary-button-label = Logga in
onboarding-multistage-welcome-secondary-button-text = Har du ett konto?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = Gör { -brand-short-name } till din <span data-l10n-name="zap">standardwebbläsare</span>
onboarding-multistage-set-default-subtitle = Hastighet, säkerhet och integritet varje gång du surfar.
onboarding-multistage-set-default-primary-button-label = Gör till standard
onboarding-multistage-set-default-secondary-button-label = Inte nu
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = Börja med att göra <span data-l10n-name="zap">{ -brand-short-name }</span> tillgänglig med ett klick
onboarding-multistage-pin-default-subtitle = Snabb, säker och privat surfning varje gång du använder webben.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = Välj { -brand-short-name } under Webbläsare när dina inställningar öppnas
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = Detta kommer att fästa { -brand-short-name } i aktivitetsfältet och öppna inställningar
onboarding-multistage-pin-default-primary-button-label = Gör { -brand-short-name } till min primära webbläsare
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importera dina lösenord, bokmärken och <span data-l10n-name = "zap">mer</span>
onboarding-multistage-import-subtitle = Kommer du från en annan webbläsare? Det är enkelt att ta med allt till { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Börja import
onboarding-multistage-import-secondary-button-label = Inte nu
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer =
    De webbplatser som visas här hittades på den här enheten.
    { -brand-short-name } sparar eller synkroniserar inte data från
    en annan webbläsare såvida du inte väljer att importera den.

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Kom igång:  skärm { $current } av { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Välj ett <span data-l10n-name = "zap">utseende</span>
onboarding-multistage-theme-subtitle = Anpassa { -brand-short-name } med ett tema.
onboarding-multistage-theme-primary-button-label2 = Klar
onboarding-multistage-theme-secondary-button-label = Inte nu
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automatiskt
onboarding-multistage-theme-label-light = Ljust
onboarding-multistage-theme-label-dark = Mörkt
# "Waterfox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = Det börjar här
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — Möbeldesigner, Waterfox-fan
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Stäng av animationer

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Behåll { -brand-short-name } i Dock för enkel åtkomst
       *[other] Fäst { -brand-short-name } i ditt aktivitetsfält för enkel åtkomst
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Behåll i Dock
       *[other] Fäst till aktivitetsfältet
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Kom igång
mr1-onboarding-welcome-header = Välkommen till { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Gör { -brand-short-name } till min primära webbläsare
    .title = Ställer in { -brand-short-name } som standardwebbläsare och fäster den i aktivitetsfältet
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Gör { -brand-short-name } till min standardwebbläsare
mr1-onboarding-set-default-secondary-button-label = Inte nu
mr1-onboarding-sign-in-button-label = Logga in

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = Gör { -brand-short-name } till din standardwebbläsare
mr1-onboarding-default-subtitle = Sätt hastighet, säkerhet och integritet på autopilot.
mr1-onboarding-default-primary-button-label = Gör till standardwebbläsare

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Ta med dig allt
mr1-onboarding-import-subtitle = Importera dina lösenord, <br/>bokmärken och mer.
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importera från { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importera från tidigare webbläsare
mr1-onboarding-import-secondary-button-label = Inte nu
mr2-onboarding-colorway-header = Ett liv i färg
mr2-onboarding-colorway-subtitle = Levande nya colorways. Tillgängliga under en begränsad tid.
mr2-onboarding-colorway-primary-button-label = Spara colorway
mr2-onboarding-colorway-secondary-button-label = Inte nu
mr2-onboarding-colorway-label-soft = Mjuk
mr2-onboarding-colorway-label-balanced = Balanserad
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Djärv
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Automatisk
# This string will be used for Default theme
mr2-onboarding-theme-label-default = Standard
mr1-onboarding-theme-header = Gör den till din egen
mr1-onboarding-theme-subtitle = Anpassa { -brand-short-name } med ett tema.
mr1-onboarding-theme-primary-button-label = Spara tema
mr1-onboarding-theme-secondary-button-label = Inte nu
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Systemtema
mr1-onboarding-theme-label-light = Ljust
mr1-onboarding-theme-label-dark = Mörkt
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
        Anpassa utseendet på knappar, menyer
        och fönster efter operativsystemet.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Anpassa utseendet på knappar, menyer
        och fönster efter operativsystemet.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Använd ett ljust utseende för knappar,
        menyer och fönster.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Använd ett ljust utseende för knappar,
        menyer och fönster.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Använd ett mörkt utseende för knappar,
        menyer och fönster.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Använd ett mörkt utseende för knappar,
        menyer och fönster.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Använd ett färgglatt utseende för knappar,
        menyer och fönster.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Använd ett färgglatt utseende för knappar,
        menyer och fönster.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Använder samma färgschema som operativsystemet
        för knappar, menyer och fönster.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Använder samma färgtema som operativsystemet
        för knappar, menyer och fönster.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Använd ett ljust tema för knappar,
        menyer och fönster.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Använd ett ljust tema för knappar,
        menyer och fönster.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Använd ett mörkt tema för knappar,
        menyer och fönster.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Använd ett mörkt tema för knappar,
        menyer och fönster.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Använd ett dynamiskt färgglatt tema för knappar,
        menyer och fönster.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Använd ett dynamiskt färgglatt tema för knappar,
        menyer och fönster.
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Använd denna colorway.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Använd denna colorway.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = Utforska colorways { $colorwayName }.
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-description =
    .aria-description = Utforska colorways { $colorwayName }.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Utforska standardteman.
# Selector description for default themes
mr2-onboarding-default-theme-description =
    .aria-description = Utforska standardteman.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Tack för att du väljer oss
mr2-onboarding-thank-you-text = { -brand-short-name } är en oberoende webbläsare som stöds av en ideell organisation. Tillsammans gör vi webben säkrare, hälsosammare och mer privat.
mr2-onboarding-start-browsing-button-label = Börja surfa
