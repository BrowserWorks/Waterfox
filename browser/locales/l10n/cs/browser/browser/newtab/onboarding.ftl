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

onboarding-welcome-header = Vítá vás { -brand-short-name }
onboarding-start-browsing-button-label = Začít prohlížet
onboarding-not-now-button-label = Teď ne

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Skvěle, nyní máte aplikaci { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Teď zpět k doplňku <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Přidat rozšíření

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Vítá vás <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Rychlý, bezpečný a soukromý prohlížeč od neziskové organizace.
onboarding-multistage-welcome-primary-button-label = Nastavit
onboarding-multistage-welcome-secondary-button-label = Přihlášení
onboarding-multistage-welcome-secondary-button-text = Už máte účet?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = Nastavte si { -brand-short-name(case: "acc") } jako <span data-l10n-name="zap">výchozí</span>
onboarding-multistage-set-default-subtitle = Rychlost, bezpečnost a soukromí pro vaše prohlížení.
onboarding-multistage-set-default-primary-button-label = Nastavit jako výchozí
onboarding-multistage-set-default-secondary-button-label = Teď ne
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header =
    { -brand-short-name.gender ->
        [masculine] <span data-l10n-name="zap">{ -brand-short-name(case: "acc") }</span>
        [feminine] <span data-l10n-name="zap">{ -brand-short-name(case: "acc") }</span>
        [neuter] <span data-l10n-name="zap">{ -brand-short-name(case: "acc") }</span>
       *[other] Aplikaci <span data-l10n-name="zap">{ -brand-short-name }</span>
    } můžete mít na klik myší
onboarding-multistage-pin-default-subtitle = Rychlé, bezpečné a soukromé prohlížení kdykoliv jste na webu.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle =
    Po otevření systémového nastavení vyberte jako Webový prohlížeč { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    }
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text =
    Tím si { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } připnete na lištu a otevřete nastavení
onboarding-multistage-pin-default-primary-button-label =
    Nastavit { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } jako můj hlavní prohlížeč
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importujte svá hesla, <br/> záložky a <span data-l10n-name="zap">další data</span>
onboarding-multistage-import-subtitle =
    Přecházíte z jiného prohlížeče? Přenést data do { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    } je velmi snadné.
onboarding-multistage-import-primary-button-label = Spustit import
onboarding-multistage-import-secondary-button-label = Teď ne
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Na tomto zařízení byly nalezeny následující stránky. { -brand-short-name } si neuloží a nebude synchronizovat dat uložená v jiném prohlížeči, dokud mu nepovolíte je importovat.

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label =
        Úvod: strana { $current } { NUMBER($totla) ->
            [one] z { $total }
            [few] ze { $total }
           *[other] z { $total }
        }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Vyberte si <span data-l10n-name="zap">vzhled</span>
onboarding-multistage-theme-subtitle =
    Přizpůsobte si vzhled { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }
onboarding-multistage-theme-primary-button-label2 = Hotovo
onboarding-multistage-theme-secondary-button-label = Teď ne
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automatický
onboarding-multistage-theme-label-light = Světlý
onboarding-multistage-theme-label-dark = Tmavý
# "Waterfox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = Začínáme
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — návrhářka nábytku a fanynka Waterfoxu
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Vypnout animace

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos]
            { -brand-short-name.gender ->
                [masculine] Mějte { -brand-short-name(case: "acc") } na dosah připnutý ve svém docku.
                [feminine] Mějte { -brand-short-name(case: "acc") } na dosah připnutou ve svém docku.
                [neuter] Mějte { -brand-short-name(case: "acc") } na dosah připnuté ve svém docku.
               *[other] Mějte aplikaci { -brand-short-name } na dosah připnutou ve svém docku.
            }
       *[other]
            { -brand-short-name.gender ->
                [masculine] Mějte { -brand-short-name(case: "acc") } na dosah připnutý na své liště.
                [feminine] Mějte { -brand-short-name(case: "acc") } na dosah připnutou na své liště.
                [neuter] Mějte { -brand-short-name(case: "acc") } na dosah připnuté na své liště.
               *[other] Mějte aplikaci { -brand-short-name } na dosah připnutou na své liště.
            }
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Připnout do docku
       *[other] Připnout na lištu
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Jdeme na to
mr1-onboarding-welcome-header = Vítá vás { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label =
    Nastavit { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } jako můj hlavní prohlížeč
    .title =
        Nastaví { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "acc") }
            [feminine] { -brand-short-name(case: "acc") }
            [neuter] { -brand-short-name(case: "acc") }
           *[other] aplikaci { -brand-short-name }
        } jako výchozí prohlížeč a připne { -brand-short-name.gender ->
            [masculine] ho
            [feminine] ji
            [neuter] ho
           *[other] ji
        } na lištu
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label =
    Nastavit { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } jako můj výchozí prohlížeč
mr1-onboarding-set-default-secondary-button-label = Teď ne
mr1-onboarding-sign-in-button-label = Přihlásit se

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header =
    Nastavit { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } jako výchozí prohlížeč
mr1-onboarding-default-subtitle = Rychlost, bezpečnost a soukromí především.
mr1-onboarding-default-primary-button-label = Nastavit jako výchozí prohlížeč

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Všechno, vždy a po ruce
mr1-onboarding-import-subtitle = Importujte svá hesla, <br/>záložky a další
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importovat z prohlížeče { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importovat z dříve používaného prohlížeče
mr1-onboarding-import-secondary-button-label = Teď ne
mr2-onboarding-colorway-header = Život v barvách
mr2-onboarding-colorway-subtitle = Nové palety barev dostupné po omezenou dobu.
mr2-onboarding-colorway-primary-button-label = Uložit paletu barev
mr2-onboarding-colorway-secondary-button-label = Teď ne
mr2-onboarding-colorway-label-soft = Jemná
mr2-onboarding-colorway-label-balanced = Vyvážená
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Výrazná
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Automatický
# This string will be used for Default theme
mr2-onboarding-theme-label-default = Výchozí
mr1-onboarding-theme-header = Přizpůsobení
mr1-onboarding-theme-subtitle =
    Přizpůsobte si vzhled { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }
mr1-onboarding-theme-primary-button-label = Uložit vzhled
mr1-onboarding-theme-secondary-button-label = Teď ne
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Podle systému
mr1-onboarding-theme-label-light = Světlý
mr1-onboarding-theme-label-dark = Tmavý
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
    .title = Použije vzhled tlačítek, nabídek a oken podle nastavení vašeho operačního systému.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description = Použije vzhled tlačítek, nabídek a oken podle nastavení vašeho operačního systému.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title = Použije světlý vzhled tlačítek, nabídek a oken.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description = Použije světlý vzhled tlačítek, nabídek a oken.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title = Použije tmavý vzhled tlačítek, nabídek a oken.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description = Použije tmavý vzhled tlačítek, nabídek a oken.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title = Použije barevný vzhled tlačítek, nabídek a oken.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description = Použije barevný vzhled tlačítek, nabídek a oken.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Vzhled s barevným tématem
        podle nastavení operačního systému.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Vzhled s barevným tématem
        podle nastavení operačního systému.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Vzhled se světlým barevným tématem
        pro tlačítka, nabídky a okna.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Vzhled se světlým barevným tématem
        pro tlačítka, nabídky a okna.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Vzhled s tmavým barevným tématem
        pro tlačítka, nabídky a okna.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Vzhled s tmavým barevným tématem
        pro tlačítka, nabídky a okna.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Vzhled s barevným tématem
        pro tlačítka, nabídky a okna.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Vzhled s barevným tématem
        pro tlačítka, nabídky a okna.
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Použije tuto paletu barev.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Použít tuto paletu barev.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = Vyzkoušet paletu barev { $colorwayName }.
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-description =
    .aria-description = Vyzkoušet paletu barev { $colorwayName }.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Vyzkoušet výchozí vzhledy.
# Selector description for default themes
mr2-onboarding-default-theme-description =
    .aria-description = Vyzkoušet výchozí vzhledy.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Děkujeme, že jste si vybrali nás
mr2-onboarding-thank-you-text = { -brand-short-name } je nezávislý prohlížeč od neziskové organizace. Společně se snažíme udělat web bezpečnější, zdravější a s větším ohledem na soukromí.
mr2-onboarding-start-browsing-button-label = Začít prohlížet
