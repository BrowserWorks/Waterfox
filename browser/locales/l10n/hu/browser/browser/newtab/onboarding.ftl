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

onboarding-welcome-header = Üdvözli a { -brand-short-name }
onboarding-start-browsing-button-label = Böngészés megkezdése
onboarding-not-now-button-label = Most nem

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Nagyszerű, már van { -brand-short-name }a
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Most pedig szerezze be a(z) <img data-l10n-name="icon"/> <b>{ $addon-name } kiegészítőt.</b>
return-to-amo-add-extension-label = Kiegészítő hozzáadása

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Üdvözli a <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = A gyors, biztonságos és privát böngésző, amelyet egy nonprofit szervezet támogat.
onboarding-multistage-welcome-primary-button-label = Beállítás indítása
onboarding-multistage-welcome-secondary-button-label = Bejelentkezés
onboarding-multistage-welcome-secondary-button-text = Van már fiókja?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = Legyen a { -brand-short-name } <span data-l10n-name="zap">az alapértelmezett böngészője</span>
onboarding-multistage-set-default-subtitle = Gyorsaság, biztonság és adatvédelem minden böngészés során.
onboarding-multistage-set-default-primary-button-label = Beállítás alapértelmezettként
onboarding-multistage-set-default-secondary-button-label = Most nem
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = Kezdje azzal, hogy a <span data-l10n-name="zap">{ -brand-short-name }</span> csak egy kattintásnyira legyen
onboarding-multistage-pin-default-subtitle = Gyors, biztonságos és privát böngészés minden alkalommal, amikor a világhálót használja.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = A beállítások megnyitásakor válassza a Webböngésző alatt a { -brand-short-name }ot
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = Ez kitűzi a { -brand-short-name }ot a a tálcára, és megnyitja a beállításokat
onboarding-multistage-pin-default-primary-button-label = Legyen a { -brand-short-name } az elsődleges böngészőm
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Jelszavak, könyvjelzők és <span data-l10n-name="zap">egyebek</span> importálása
onboarding-multistage-import-subtitle = Egy másik böngészőből érkezett? Könnyen áthozhat mindent a { -brand-short-name }ba.
onboarding-multistage-import-primary-button-label = Importálás indítása
onboarding-multistage-import-secondary-button-label = Most nem
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Az itt felsorolt webhelyek találhatók ezen az eszközön. A { -brand-short-name } nem menti vagy szinkronizálja az adatokat egy másik böngészőből, kivéve, ha úgy dönt, hogy importálja azokat.

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Első lépések: { $current }. képernyő / { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Válasszon egy <span data-l10n-name="zap">megjelenést</span>
onboarding-multistage-theme-subtitle = Tegye egyedivé a { -brand-short-name }ot egy témával.
onboarding-multistage-theme-primary-button-label2 = Kész
onboarding-multistage-theme-secondary-button-label = Most nem
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automatikus
onboarding-multistage-theme-label-light = Világos
onboarding-multistage-theme-label-dark = Sötét
# "Waterfox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = A tűz itt kezdődik
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio – Bútortevező, Waterfox rajongó
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Animációk kikapcsolása

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] A könnyű hozzáférés érdekében tartsa a { -brand-short-name } a Dokkon
       *[other] A könnyű hozzáférés érdekében rögzítse a { -brand-short-name } címet a tálcára
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Hozzáadás a Dokkhoz
       *[other] Rögzítés a tálcára
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Kezdő lépések
mr1-onboarding-welcome-header = Üdvözli a { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = A { -brand-short-name } elsődleges böngészővé tétele
    .title = Beállítja elsődleges böngészőként a { -brand-short-name }ot, és kitűzi a tálcára
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = A { -brand-short-name } alapértelmezett böngészővé tétele
mr1-onboarding-set-default-secondary-button-label = Most nem
mr1-onboarding-sign-in-button-label = Bejelentkezés

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = A { -brand-short-name } alapértelmezetté tétele
mr1-onboarding-default-subtitle = Tegye robotpilótára a sebességet, a biztonságot és az adatvédelmet
mr1-onboarding-default-primary-button-label = Alapértelmezett böngészővé tétel

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Hozzon mindent magával
mr1-onboarding-import-subtitle = Importálja jelszavait, <br/>könyvjelzőit és még sok mást.
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importálás innen: { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importálás az előző böngészőből
mr1-onboarding-import-secondary-button-label = Most nem
mr2-onboarding-colorway-header = Az élet színesben
mr2-onboarding-colorway-subtitle = Élénk új színvilágok. Korlátozott ideig elérhető.
mr2-onboarding-colorway-primary-button-label = Színvilág mentése
mr2-onboarding-colorway-secondary-button-label = Most nem
mr2-onboarding-colorway-label-soft = Puha
mr2-onboarding-colorway-label-balanced = Kiegyensúlyozott
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Élénk
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Automatikus
# This string will be used for Default theme
mr2-onboarding-theme-label-default = Alapértelmezett
mr1-onboarding-theme-header = Tegye a sajátjává
mr1-onboarding-theme-subtitle = Tegye egyedivé a { -brand-short-name }ot egy témával.
mr1-onboarding-theme-primary-button-label = Téma mentése
mr1-onboarding-theme-secondary-button-label = Most nem
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Rendszertéma
mr1-onboarding-theme-label-light = Világos
mr1-onboarding-theme-label-dark = Sötét
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpesi fény

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
        Az operációs rendszer megjelenésének öröklése a
        gomboknál, menüknél és ablakoknál.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Az operációs rendszer megjelenésének öröklése a
        gomboknál, menüknél és ablakoknál.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Világos megjelenés használata a gombokhoz,
        menükhöz és ablakokhoz.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Világos megjelenés használata a gombokhoz,
        menükhöz és ablakokhoz.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Sötét megjelenés használata a gombokhoz,
        menükhöz és ablakokhoz.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Sötét megjelenés használata a gombokhoz,
        menükhöz és ablakokhoz.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Színes megjelenés használata a gombokhoz,
        menükhöz és ablakokhoz.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Színes megjelenés használata a gombokhoz,
        menükhöz és ablakokhoz.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Az operációs rendszer témájának követése
        a gomboknál, menüknél és ablakoknál.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Az operációs rendszer témájának követése
        a gomboknál, menüknél és ablakoknál.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Világos téma használata a gombokhoz,
        menükhöz és ablakokhoz.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Világos téma használata a gombokhoz,
        menükhöz és ablakokhoz.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Sötét téma használata a gombokhoz,
        menükhöz és ablakokhoz.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Sötét téma használata a gombokhoz,
        menükhöz és ablakokhoz.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Dinamikus, színes téma használata a
        gombokhoz, menükhöz és ablakokhoz.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Dinamikus, színes téma használata a
        gombokhoz, menükhöz és ablakokhoz.
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Ezen színvilág használata.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Ezen színvilág használata.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = Fedezze fel a(z) { $colorwayName } színvilágokat.
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-description =
    .aria-description = Fedezze fel a(z) { $colorwayName } színvilágokat.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Fedezze fel az alapértelmezett témákat.
# Selector description for default themes
mr2-onboarding-default-theme-description =
    .aria-description = Fedezze fel az alapértelmezett témákat.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Köszönjük, hogy minket választott
mr2-onboarding-thank-you-text = A { -brand-short-name } egy független böngésző, melyet egy nonprofit szervezet támogat. Együtt biztonságosabbá, egészségesebbé és privátabbá tesszük a világhálót.
mr2-onboarding-start-browsing-button-label = Böngészés megkezdése
