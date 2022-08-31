# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


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
return-to-amo-add-theme-label = Téma hozzáadása

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Első lépések: { $current }. képernyő / { $total }

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator2 =
    .aria-valuetext = Haladás: { $current }. / { $total } lépés
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
        [macos] A könnyű hozzáférés érdekében tartsa a { -brand-short-name(case: "accusative") } a Dokkon
       *[other] A könnyű hozzáférés érdekében rögzítse a { -brand-short-name(case: "accusative") } a tálcára
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Dokkban tartás
       *[other] Rögzítés a tálcára
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Kezdő lépések
mr1-onboarding-welcome-header = Üdvözli a { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = A { -brand-short-name } elsődleges böngészővé tétele
    .title = Beállítja elsődleges böngészőként a { -brand-short-name(case: "accusative") }, és kitűzi a tálcára
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
mr1-onboarding-theme-subtitle = A { -brand-short-name } személyre szabása egy témával.
mr1-onboarding-theme-primary-button-label = Téma mentése
mr1-onboarding-theme-secondary-button-label = Most nem
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Rendszertéma
mr1-onboarding-theme-label-light = Világos
mr1-onboarding-theme-label-dark = Sötét
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpesi fény
onboarding-theme-primary-button-label = Kész

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

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
mr2-onboarding-colorway-label = Fedezze fel a(z) { $colorwayName } színvilágokat.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Fedezze fel az alapértelmezett témákat.
# Selector description for default themes
mr2-onboarding-default-theme-label = Fedezze fel az alapértelmezett témákat.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Köszönjük, hogy minket választott
mr2-onboarding-thank-you-text = A { -brand-short-name } egy független böngésző, melyet egy nonprofit szervezet támogat. Együtt biztonságosabbá, egészségesebbé és privátabbá tesszük a világhálót.
mr2-onboarding-start-browsing-button-label = Böngészés megkezdése

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

onboarding-live-language-header = Válassza ki a nyelvét
mr2022-onboarding-live-language-text = A { -brand-short-name } az Ön nyelvét beszéli
mr2022-language-mismatch-subtitle = Közösségünknek köszönhetően a { -brand-short-name } több mint 90 nyelvre le van fordítva. Úgy tűnik, hogy a rendszer a(z) { $systemLanguage } nyelvet használja, a { -brand-short-name } pedig a(z) { $appLanguage } nyelvet.
onboarding-live-language-button-label-downloading = A(z) { $negotiatedLanguage } nyelvi csomag letöltése…
onboarding-live-language-waiting-button = Elérhető nyelvek lekérése…
onboarding-live-language-installing = A(z) { $negotiatedLanguage } nyelvi csomag telepítése…
mr2022-onboarding-live-language-switch-to = Váltás erre: { $negotiatedLanguage }
mr2022-onboarding-live-language-continue-in = Folytatás { $appLanguage } nyelven
onboarding-live-language-secondary-cancel-download = Mégse
onboarding-live-language-skip-button-label = Kihagyás

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
    <span data-l10n-name="zap">köszönet</span>
fx100-thank-you-subtitle = Ez a 100. kiadásunk! Köszönjük, hogy segít nekünk egy jobb, egészségesebb internet felépítésében.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] A { -brand-short-name } a Dokkban tartása
       *[other] A { -brand-short-name } rögzítése a tálcára
    }
fx100-upgrade-thanks-header = 100 köszönet
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = Ez a { -brand-short-name } 100. kiadása. Köszönjük <em>Önnek</em>, hogy segít nekünk egy jobb, egészségesebb internet felépítésében.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = Ez a 100. kiadásunk! Köszönjük, hogy segít a közösségünk tagja. Tartsa egy kattintásnyira a { -brand-short-name(case: "accusative") } a következő 100-hoz.
mr2022-onboarding-secondary-skip-button-label = Lépés kihagyása

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = Fedezzen fel egy csodálatos internetet
# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle = Indítsa el a { -brand-short-name(case: "accusative") } bárhonnan egyetlen kattintással. Minden alkalommal, amikor ezt teszi, egy nyitottabb és függetlenebb internetet választ.
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] A { -brand-short-name } Dokkban tartása
       *[other] A { -brand-short-name } rögzítése a tálcára
    }
# Subtitle will be used when user already has Waterfox pinned, but
# has not set it as their default browser.
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-only-subtitle = Kezdje egy nonprofit szervezet által támogatott böngészővel. Megvédjük a magánszféráját, miközben a világhálón böngészik.

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header = Köszönjük, hogy szereti a { -brand-product-name(case: "accusative") }
# Subtitle is used on onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-subtitle = Indítson el egy egészségesebb internetet bárhonnan egyetlen kattintással. A legfrissebb frissítésünk tele van olyan új dolgokkal, amelyekről azt gondoljuk, hogy imádni fog.
# Subtitle will be used on the welcome screen for existing users
# when they already have Waterfox pinned but not set as default
mr2022-onboarding-existing-set-default-only-subtitle = Használjon olyan böngészőt, amely megvédi a magánszféráját, miközben a világhálón böngészik. Legújabb frissítésünk tele van olyan dolgokkal, amelyeket imádni fog.
mr2022-onboarding-existing-pin-checkbox-label = Adja hozzá a { -brand-short-name } privát böngészését is

## MR2022 New User Set Default screen strings

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title = Legyen a { -brand-short-name } a szokásos böngészője
mr2022-onboarding-set-default-primary-button-label = A { -brand-short-name } beállítása alapértelmezett böngészőként
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-subtitle = Használjon egy nonprofit szervezet által támogatott böngészőt. Megvédjük a magánszféráját, miközben a világhálón böngészik.

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-get-started-primary-subtitle = A legfrissebb verziónk Ön köré épül fel, így minden eddiginél egyszerűbb a világhálón szörfölés. Tele van olyan funkciókkal, amelyekről úgy gondoljuk, hogy imádni fog.
mr2022-onboarding-get-started-primary-button-label = Beállítás másodpercek alatt

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = Villámgyors beállítás
mr2022-onboarding-import-subtitle = Állítsa be úgy a { -brand-short-name(case: "accusative") }, ahogy Önnek tetszik. Adja hozzá könyvjelzőit, jelszavait és egyebeket a régi böngészőjéből.
mr2022-onboarding-import-primary-button-label-no-attribution = Importálás az előző böngészőből

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = Válassza ki azt a színt, amelyik inspirálja
mr2022-onboarding-colorway-subtitle = A független hangok megváltoztathatják a kultúrát.
mr2022-onboarding-colorway-primary-button-label = Színvilág beállítása
mr2022-onboarding-existing-colorway-checkbox-label = Legyen a { -firefox-home-brand-name } a színes kezdőlapja
mr2022-onboarding-colorway-label-default = Alapértelmezett
mr2022-onboarding-colorway-tooltip-default =
    .title = Alapértelmezett
mr2022-onboarding-colorway-description-default = <b>A { -brand-short-name } jelenlegi színeinek használata.</b>
mr2022-onboarding-colorway-label-playmaker = Játékmester
mr2022-onboarding-colorway-tooltip-playmaker =
    .title = Játékmester
mr2022-onboarding-colorway-description-playmaker = <b>Ön a játékmester.</b> Lehetőségeket teremt a győzelemre, és segít feldobni a többiek játékát.
mr2022-onboarding-colorway-label-expressionist = Expresszionista
mr2022-onboarding-colorway-tooltip-expressionist =
    .title = Expresszionista
mr2022-onboarding-colorway-description-expressionist = <b>Ön egy expresszionista.</b> Másképp látja a világot, és alkotásai felkavarják mások érzelmeit.
mr2022-onboarding-colorway-label-visionary = Látnok
mr2022-onboarding-colorway-tooltip-visionary =
    .title = Látnok
mr2022-onboarding-colorway-description-visionary = <b>Ön egy látnok.</b> Megkérdőjelezi a status quót, és arra késztet másokat, hogy képzeljenek el egy jobb jövőt.
mr2022-onboarding-colorway-label-activist = Aktivista
mr2022-onboarding-colorway-tooltip-activist =
    .title = Aktivista
mr2022-onboarding-colorway-description-activist = <b>Ön egy aktivista.</b> Jobb állapotban hagyja a világot, mint ahogyan találta, és arra vezet másokat is, hogy higgyenek.
mr2022-onboarding-colorway-label-dreamer = Álmodozó
mr2022-onboarding-colorway-tooltip-dreamer =
    .title = Álmodozó
mr2022-onboarding-colorway-description-dreamer = <b>Ön egy álmodozó.</b> Úgy hiszi, hogy bátraké a szerencse, és másokat is bátorságra ösztönöz.
mr2022-onboarding-colorway-label-innovator = Újító
mr2022-onboarding-colorway-tooltip-innovator =
    .title = Újító
mr2022-onboarding-colorway-description-innovator = <b>Ön egy újító.</b> Mindenhol a lehetőségeket látja, és hatással van a körülötte élők életére.

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = Ugorjon át a laptopjáról a telefonjára és vissza
mr2022-onboarding-mobile-download-subtitle = Vegyen át lapokat az egyik eszközéről, és folytassa egy másik eszközön ott, ahol abbahagyta. Ezenkívül szinkronizálhatja könyvjelzőit és jelszavait bárhol, ahol { -brand-product-name(case: "accusative") } használ.
mr2022-onboarding-mobile-download-cta-text = Olvassa le a QR-kódot, hogy megkapja a mobilos { -brand-product-name(case: "accusative") }, vagy <a data-l10n-name="download-label">küldjön magának egy letöltési hivatkozást.</a>
mr2022-onboarding-no-mobile-download-cta-text = Olvassa le a QR-kódot, hogy beszerezze a { -brand-product-name(case: "accusative") } a mobiljára.

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = Kapja meg a privát böngészés szabadságát egyetlen kattintással
mr2022-upgrade-onboarding-pin-private-window-subtitle = Nincsenek mentett sütik vagy előzmények, közvetlenül az asztaláról. Böngésszen úgy, mintha senki sem nézné.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] A { -brand-short-name } privát böngészés Dokkban tartása
       *[other] A { -brand-short-name } privát böngészés rögzítése a tálcára
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = Mindig tiszteletben tartjuk a magánszféráját
mr2022-onboarding-privacy-segmentation-subtitle = Az intelligens javaslatoktól az okos keresésig, folyamatosan dolgozunk egy jobb, személyesebb { -brand-product-name } létrehozásán.
mr2022-onboarding-privacy-segmentation-text-cta = Mit szeretne látni, amikor olyan új szolgáltatásokat kínálunk, amelyek az Ön adatait használják fel a böngészés javítása érdekében?
mr2022-onboarding-privacy-segmentation-button-primary-label = A { -brand-product-name } javaslatainak használata
mr2022-onboarding-privacy-segmentation-button-secondary-label = Részletes információk megjelenítése

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = Segít nekünk egy jobb világháló felépítésében.
mr2022-onboarding-gratitude-subtitle = Köszönjük, hogy a { -brand-short-name(case: "accusative") } használja, amelyet a Waterfox Alapítvány támogat. Az Ön támogatásával azon dolgozunk, hogy az internetet mindenki számára nyitottabbá, hozzáférhetőbbé és jobbá tegyük.
mr2022-onboarding-gratitude-primary-button-label = Nézze meg az újdonságokat
mr2022-onboarding-gratitude-secondary-button-label = Böngészés megkezdése
