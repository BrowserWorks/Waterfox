# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Vítá vás { -brand-short-name }
onboarding-start-browsing-button-label = Začít prohlížet
onboarding-not-now-button-label = Teď ne
mr1-onboarding-get-started-primary-button-label = Jdeme na to

## Custom Return To AMO onboarding strings

return-to-amo-subtitle =
    { -brand-short-name.case-status ->
        [with-cases] Skvěle, nyní máte { -brand-short-name(case: "acc") }
       *[no-cases] Skvěle, nyní máte aplikaci { -brand-short-name }
    }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Teď zpět k doplňku <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Přidat rozšíření
return-to-amo-add-theme-label = Přidat motiv vzhledu

##  Variables: $addon-name (String) - Name of the add-on to be installed

mr1-return-to-amo-subtitle =
    { -brand-short-name.case-status ->
        [with-cases] Přivítejte { -brand-short-name(case: "acc") }
       *[no-cases] Přivítejte aplikaci { -brand-short-name }
    }
mr1-return-to-amo-addon-title =
    { -brand-short-name.case-status ->
        [with-cases] Máte rychlý a soukromý prohlížeč na dosah ruky. Nyní můžete přidat <b>{ $addon-name }</b> a dostat tak z { -brand-short-name(case: "gen") } ještě více.
       *[no-cases] Máte rychlý a soukromý prohlížeč na dosah ruky. Nyní můžete přidat <b>{ $addon-name }</b> a dostat tak z aplikace { -brand-short-name } ještě více.
    }
mr1-return-to-amo-add-extension-label = Přidat doplněk { $addon-name }

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator-label =
    .aria-label = Postup: krok { $current } z { $total }

# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Vypnout animace

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

## Multistage MR1 onboarding strings (about:welcome pages)

# String for the Waterfox Accounts button
mr1-onboarding-sign-in-button-label = Přihlásit se

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

## Multistage MR1 onboarding strings (about:welcome pages)

# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importovat z prohlížeče { $previous }

mr1-onboarding-theme-header = Přizpůsobení
mr1-onboarding-theme-subtitle =
    { -brand-short-name.case-status ->
        [with-cases] Přizpůsobte si vzhled { -brand-short-name(case: "gen") }
       *[no-cases] Přizpůsobte si vzhled aplikace { -brand-short-name }
    }
mr1-onboarding-theme-secondary-button-label = Teď ne

# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Podle systému

mr1-onboarding-theme-label-light = Světlý
mr1-onboarding-theme-label-dark = Tmavý
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow

onboarding-theme-primary-button-label = Hotovo

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

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

# Selector description for default themes
mr2-onboarding-default-theme-label = Vyzkoušet výchozí vzhledy.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Děkujeme, že jste si vybrali nás
mr2-onboarding-thank-you-text = { -brand-short-name } je nezávislý prohlížeč od neziskové organizace. Společně se snažíme udělat web bezpečnější, zdravější a s větším ohledem na soukromí.
mr2-onboarding-start-browsing-button-label = Začít prohlížet

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

onboarding-live-language-header = Výběr jazyka

mr2022-onboarding-live-language-text = { -brand-short-name } mluví vaším jazykem

mr2022-language-mismatch-subtitle =
    { -brand-short-name.gender ->
        [masculine] Díky naší komunitě je { -brand-short-name } přeložený do více než 90 jazyků. Zdá se, že váš systém je v jazyce { $systemLanguage }, a { -brand-short-name } používá jazyk { $appLanguage }.
        [feminine] Díky naší komunitě je { -brand-short-name } přeložená do více než 90 jazyků. Zdá se, že váš systém je v jazyce { $systemLanguage }, a { -brand-short-name } používá jazyk { $appLanguage }.
        [neuter] Díky naší komunitě je { -brand-short-name } přeložené do více než 90 jazyků. Zdá se, že váš systém je v jazyce { $systemLanguage }, a { -brand-short-name } používá jazyk { $appLanguage }.
       *[other] Díky naší komunitě je aplikace { -brand-short-name } přeložená do více než 90 jazyků. Zdá se, že váš systém je v jazyce { $systemLanguage }, a { -brand-short-name } používá jazyk { $appLanguage }.
    }

onboarding-live-language-button-label-downloading = Stahování jazykového balíčku pro jazyk { $negotiatedLanguage }…
onboarding-live-language-waiting-button = Získávání dostupných jazyků…
onboarding-live-language-installing = Instalace jazykového balíčku pro jazyk { $negotiatedLanguage }…

mr2022-onboarding-live-language-switch-to = Přepnout na jazyk { $negotiatedLanguage }
mr2022-onboarding-live-language-continue-in = Ponechat jazyk { $appLanguage }

onboarding-live-language-secondary-cancel-download = Zrušit
onboarding-live-language-skip-button-label = Přeskočit

## Waterfox 100 Thank You screens

# "Hero Text" displayed on left side of welcome screen. This text can be
# formatted to span multiple lines as needed. The <span data-l10n-name="zap">
# </span> in this string allows a "zap" underline style to be automatically
# added to the text inside it. "Yous" should stay inside the zap span, but
# "Thank" can be put inside instead if there's no "you" in the translation.
# The English text would normally be "100 Thank-Yous" i.e., plural noun, but for
# aesthetics of splitting it across multiple lines, the hyphen is omitted.
fx100-thank-you-hero-text =
    Děkujeme
    <span data-l10n-name="zap">100krát</span>
fx100-thank-you-subtitle = Toto je 100. verze! Děkujeme vám, že pomáháte budovat lepší a zdravější internet.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos]
            { -brand-short-name.case-status ->
                [with-cases] Připnout { -brand-short-name(case: "acc") } do docku
               *[no-cases] Připnout aplikaci { -brand-short-name } do docku
            }
       *[other]
            { -brand-short-name.case-status ->
                [with-cases] Připnout { -brand-short-name(case: "acc") } na lištu
               *[no-cases] Připnout aplikaci { -brand-short-name } na lištu
            }
    }

fx100-upgrade-thanks-header = Děkujeme 100krát
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body =
    { -brand-short-name.case-status ->
        [with-cases] Toto je 100. vydání { -brand-short-name(case: "gen") }! Děkujeme <em>vám</em>, že pomáháte budovat lepší a zdravější internet.
       *[no-cases] Toto je 100. vydání aplikace { -brand-short-name }! Děkujeme <em>vám</em>, že pomáháte budovat lepší a zdravější internet.
    }
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body =
    { -brand-short-name.case-status ->
        [with-cases] Toto je 100. vydání! Mějte { -brand-short-name(case: "acc") } na dosah ještě dalších 100 vydání.
       *[no-cases] Toto je 100. vydání! Mějte aplikaci { -brand-short-name } na dosah ještě dalších 100 vydání.
    }

mr2022-onboarding-secondary-skip-button-label = Přeskočit tento krok

## MR2022 New User Easy Setup screen strings

# Primary button string used on new user onboarding first screen showing multiple actions such as Set Default, Import from previous browser.
mr2022-onboarding-easy-setup-primary-button-label = Uložit a pokračovat
# Set Default action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-set-default-checkbox-label =
    { -brand-short-name.case-status ->
        [with-cases] Nastavit { -brand-short-name(case: "acc") } jako výchozí prohlížeč
       *[no-cases] Nastavit aplikaci { -brand-short-name } jako výchozí prohlížeč
    }
# Import action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-import-checkbox-label = Importovat z dříve používaného prohlížeče

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = Objevte úžasný internet
# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle =
    { -brand-short-name.case-status ->
        [with-cases] Spusťte { -brand-short-name(case: "acc") } odkudkoli jediným klepnutím. Pokaždé, když to uděláte, volíte otevřenější a nezávislejší web.
       *[no-cases] Spusťte aplikaci { -brand-short-name } odkudkoli jediným klepnutím. Pokaždé, když to uděláte, volíte otevřenější a nezávislejší web.
    }
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos]
            { -brand-short-name.case-status ->
                [with-cases] Ponechat { -brand-short-name(case: "acc") } v docku
               *[no-cases] Ponechat aplikaci { -brand-short-name } v docku
            }
       *[other]
            { -brand-short-name.case-status ->
                [with-cases] Připnout { -brand-short-name(case: "acc") } na hlavní panel
               *[no-cases] Připnout aplikaci { -brand-short-name } na hlavní panel
            }
    }
# Subtitle will be used when user already has Waterfox pinned, but
# has not set it as their default browser.
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-only-subtitle = Začněte s prohlížečem podporovaným neziskovou organizací. Chráníme vaše soukromí, když se pohybujete po webu.

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header =
    { -brand-product-name.case-status ->
        [with-cases] Děkujeme, že máte rádi { -brand-product-name(case: "acc") }
       *[no-cases] Děkujeme, že máte rádi aplikaci { -brand-product-name }
    }
# Subtitle is used on onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-subtitle = Spusťte zdravější internet odkudkoli jediným klepnutím. Naše nejnovější aktualizace je plná nových věcí, o kterých si myslíme, že si je zamilujete.
# Subtitle will be used on the welcome screen for existing users
# when they already have Waterfox pinned but not set as default
mr2022-onboarding-existing-set-default-only-subtitle = Používejte prohlížeč, který chrání vaše soukromí při procházení webu. Naše nejnovější aktualizace je plná věcí, které si zamilujete.
mr2022-onboarding-existing-pin-checkbox-label =
    { -brand-short-name.case-status ->
        [with-cases] Přidat též anonymní prohlížení { -brand-short-name(case: "gen") }
       *[no-cases] Přidat též anonymní prohlížení aplikace { -brand-short-name }
    }

## MR2022 New User Set Default screen strings

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title =
    { -brand-short-name.case-status ->
        [with-cases] Nastavte si { -brand-short-name(case: "acc") } jako váš prohlížeč
       *[no-cases] Nastavte si aplikaci { -brand-short-name } jako váš prohlížeč
    }
mr2022-onboarding-set-default-primary-button-label =
    { -brand-short-name.case-status ->
        [with-cases] Nastavit { -brand-short-name(case: "acc") } jako výchozí prohlížeč
       *[no-cases] Nastavit aplikaci { -brand-short-name } jako výchozí prohlížeč
    }
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-subtitle = Používejte prohlížeč podporovaný neziskovou organizací. Chráníme vaše soukromí, když se pohybujete po webu.

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-get-started-primary-subtitle = Naše nejnovější verze je postavená podle vás, díky čemuž je procházení webu snazší než kdykoli předtím. Je nabitá funkcemi, které si podle nás zamilujete.
mr2022-onboarding-get-started-primary-button-label = Nastavení během okamžiku

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = Bleskové nastaveni
mr2022-onboarding-import-subtitle =
    { -brand-short-name.case-status ->
        [with-cases] Nastavte si { -brand-short-name(case: "acc") } podle svých představ. Přidejte si do něj své záložky, hesla a další položky ze svého starého prohlížeče.
       *[no-cases] Nastavte si aplikaci { -brand-short-name } podle svých představ. Přidejte si do ní své záložky, hesla a další položky ze svého starého prohlížeče.
    }
mr2022-onboarding-import-primary-button-label-no-attribution = Importovat z dříve používaného prohlížeče

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = Vyberte si barvu, která vás inspiruje
mr2022-onboarding-colorway-subtitle = Hlasy nezávislosti mohou změnit kulturu.
mr2022-onboarding-colorway-primary-button-label-continue = Nastavit a pokračovat
mr2022-onboarding-existing-colorway-checkbox-label = Nastavte si barvy { -firefox-home-brand-name(case: "gen", capitalization: "lower") } podle svého

mr2022-onboarding-colorway-label-default = Výchozí
mr2022-onboarding-colorway-tooltip-default2 =
    .title =
        { -brand-short-name.case-status ->
            [with-cases] Aktuální barvy { -brand-short-name(case: "gen") }
           *[no-cases] Aktuální barvy aplikace { -brand-short-name }
        }
mr2022-onboarding-colorway-description-default =
    { -brand-short-name.case-status ->
        [with-cases] <b>Použít mé současné barvy { -brand-short-name(case: "gen") }.</b>
       *[no-cases] <b>Použít mé současné barvy aplikace { -brand-short-name }.</b>
    }

mr2022-onboarding-colorway-label-playmaker = Tvůrce hry
mr2022-onboarding-colorway-tooltip-playmaker2 =
    .title = Tvůrce hry (červená)
mr2022-onboarding-colorway-description-playmaker = <b>Tvůrce hry:</b> Vytváříte příležitosti pro vítězství a pomáháte každému okolo vás pozvednout jejich hru.

mr2022-onboarding-colorway-label-expressionist = Expresionista
mr2022-onboarding-colorway-tooltip-expressionist2 =
    .title = Expresionista (žlutá)
mr2022-onboarding-colorway-description-expressionist = <b>Expresionista:</b> Vidíte svět jinak a vaše výtvory vzbuzují v ostatních emoce.

mr2022-onboarding-colorway-label-visionary = Vizionář
mr2022-onboarding-colorway-tooltip-visionary2 =
    .title = Vizionář (zelená)
mr2022-onboarding-colorway-description-visionary = <b>Vizionář:</b> Zpochybňujete status quo a nutíte ostatní, aby mysleli na lepší budoucnost.

mr2022-onboarding-colorway-label-activist = Aktivista
mr2022-onboarding-colorway-tooltip-activist2 =
    .title = Aktivista (modrá)
mr2022-onboarding-colorway-description-activist = <b>Aktivista:</b> Přetváříte svět v lepší místo, než jste ho našli, a vedete ostatní k tomu, aby v něj věřili.

mr2022-onboarding-colorway-label-dreamer = Snílek
mr2022-onboarding-colorway-tooltip-dreamer2 =
    .title = Snílek (fialová)
mr2022-onboarding-colorway-description-dreamer = <b>Snílek:</b> Věříte, že štěstí přeje odvážným, a inspirujete ostatní, aby odvážní byli.

mr2022-onboarding-colorway-label-innovator = Inovátor
mr2022-onboarding-colorway-tooltip-innovator2 =
    .title = Inovátor (oranžová)
mr2022-onboarding-colorway-description-innovator = <b>Inovátor:</b> Všude vidíte příležitosti a ovlivňujete životy všech kolem sebe.

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = Přecházejte mezi notebookem a telefonem
mr2022-onboarding-mobile-download-subtitle =
    { -brand-product-name.case-status ->
        [with-cases] Vezměte si panely z jednoho zařízení a pokračujte na jiném tam, kde jste skončili. Navíc můžete synchronizovat své záložky a hesla kdekoli, kde používáte { -brand-product-name(case: "acc") }.
       *[no-cases] Vezměte si panely z jednoho zařízení a pokračujte na jiném tam, kde jste skončili. Navíc můžete synchronizovat své záložky a hesla kdekoli, kde používáte aplikaci { -brand-product-name }.
    }
mr2022-onboarding-mobile-download-cta-text =
    { -brand-product-name.case-status ->
        [with-cases] Naskenujte QR kód a získejte { -brand-product-name(case: "acc") } pro mobily nebo si <a data-l10n-name="download-label">pošlete odkaz ke stažení</a>.
       *[no-cases] Naskenujte QR kód a získejte aplikaci { -brand-product-name } pro mobily nebo si <a data-l10n-name="download-label">pošlete odkaz ke stažení</a>.
    }
mr2022-onboarding-no-mobile-download-cta-text =
    { -brand-product-name.case-status ->
        [with-cases] Naskenujte QR kód a získejte { -brand-product-name(case: "acc") } pro mobily.
       *[no-cases] Naskenujte QR kód a získejte aplikaci { -brand-product-name } pro mobily.
    }

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = Získejte svobodu soukromého prohlížení jediným klepnutím
mr2022-upgrade-onboarding-pin-private-window-subtitle = Žádné uložené cookies ani historie, přímo z vaší plochy. Prohlížejte, jako když se nikdo nedívá.Žádné uložené soubory cookies ani historie, přímo z vaší plochy. Prohlížejte, jako by se nikdo nedíval.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos]
            { -brand-short-name.case-status ->
                [with-cases] Ponechat anonymní prohlížení { -brand-short-name(case: "gen") } v docku
               *[no-cases] Ponechat anonymní prohlížení aplikace { -brand-short-name } v docku
            }
       *[other]
            { -brand-short-name.case-status ->
                [with-cases] Připnout anonymní prohlížení { -brand-short-name(case: "gen") } na hlavní panel
               *[no-cases] Připnout anonymní prohlížení aplikace { -brand-short-name } na hlavní panel
            }
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = Vždy respektujeme vaše soukromí
mr2022-onboarding-privacy-segmentation-subtitle =
    { -brand-product-name.gender ->
        [masculine] Od inteligentních návrhů po inteligentnější vyhledávání. Neustále pracujeme na vytvoření lepšího a osobnějšího { -brand-product-name(case: "gen") }.
        [feminine] Od inteligentních návrhů po inteligentnější vyhledávání. Neustále pracujeme na vytvoření lepší a osobnější { -brand-product-name(case: "gen") }.
        [neuter] Od inteligentních návrhů po inteligentnější vyhledávání. Neustále pracujeme na vytvoření lepšího a osobnějšího { -brand-product-name(case: "gen") }.
       *[other] Od inteligentních návrhů po inteligentnější vyhledávání. Neustále pracujeme na vytvoření lepší a osobnější aplikace { -brand-product-name }.
    }
mr2022-onboarding-privacy-segmentation-text-cta = Co chcete vidět, když nabízíme nové funkce, které využívají vaše data k vylepšení vašeho prohlížení?
mr2022-onboarding-privacy-segmentation-button-primary-label =
    { -brand-product-name.case-status ->
        [with-cases] Použít doporučení { -brand-product-name(case: "gen") }
       *[no-cases] Použít doporučení aplikace { -brand-product-name }
    }
mr2022-onboarding-privacy-segmentation-button-secondary-label = Zobrazit podrobnosti

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = Pomáháte nám vytvářet lepší web
mr2022-onboarding-gratitude-subtitle =
    { -brand-short-name.gender ->
        [masculine] Děkujeme, že používáte { -brand-short-name(case: "acc") }, za kterým stojí BrowserWorks. S vaší podporou pracujeme na tom, aby byl internet otevřenější, přístupnější a lepší pro všechny.
        [feminine] Děkujeme, že používáte { -brand-short-name(case: "acc") }, za kterou stojí BrowserWorks. S vaší podporou pracujeme na tom, aby byl internet otevřenější, přístupnější a lepší pro všechny.
        [neuter] Děkujeme, že používáte { -brand-short-name(case: "acc") }, za kterým stojí BrowserWorks. S vaší podporou pracujeme na tom, aby byl internet otevřenější, přístupnější a lepší pro všechny.
       *[other] Děkujeme, že používáte aplikaci { -brand-short-name }, za kterou stojí BrowserWorks. S vaší podporou pracujeme na tom, aby byl internet otevřenější, přístupnější a lepší pro všechny.
    }
mr2022-onboarding-gratitude-primary-button-label = Co je nového
mr2022-onboarding-gratitude-secondary-button-label = Začít prohlížet

## Onboarding spotlight for infrequent users

onboarding-infrequent-import-title = Buďte se jako doma
onboarding-infrequent-import-subtitle = Ať už se zabydlujete, nebo se jen zastavujete, nezapomeňte, že můžete naimportovat své záložky, hesla a další položky.
onboarding-infrequent-import-primary-button =
    { -brand-short-name.case-status ->
        [with-cases] Importovat do { -brand-short-name(case: "gen") }
       *[no-cases] Importovat do aplikace { -brand-short-name }
    }

## MR2022 Illustration alt tags
## Descriptive tags for illustrations used by screen readers and other assistive tech

mr2022-onboarding-pin-image-alt =
    .aria-label = Osoba pracující na notebooku obklopená hvězdami a květinami
mr2022-onboarding-default-image-alt =
    .aria-label =
        { -brand-product-name.case-status ->
            [with-cases] Osoba objímající logo { -brand-product-name(case: "gen") }
           *[no-cases] Osoba objímající logo aplikace { -brand-product-name }
        }
mr2022-onboarding-import-image-alt =
    .aria-label = Osoba na skateboardu s krabicí softwarových ikon
mr2022-onboarding-mobile-download-image-alt =
    .aria-label =
        { -brand-product-name.case-status ->
            [with-cases] Žáby poskakující po leknínech s QR kódem pro stažení { -brand-product-name(case: "gen") } do mobilu uprostřed.
           *[no-cases] Žáby poskakující po leknínech s QR kódem pro stažení aplikace { -brand-product-name } do mobilu uprostřed.
        }
mr2022-onboarding-pin-private-image-alt =
    .aria-label =
        { -brand-product-name.case-status ->
            [with-cases] Kouzelná hůlka způsobí, že se z klobouku objeví logo soukromého prohlížení { -brand-product-name(case: "gen") }
           *[no-cases] Kouzelná hůlka způsobí, že se z klobouku objeví logo soukromého prohlížení aplikace { -brand-product-name }
        }
mr2022-onboarding-privacy-segmentation-image-alt =
    .aria-label = Ruce světlé a tmavé pleti si plácnou
mr2022-onboarding-gratitude-image-alt =
    .aria-label = Pohled na západ slunce oknem s liškou a pokojovou rostlinou na parapetu
mr2022-onboarding-colorways-image-alt =
    .aria-label = Ruční sprej maluje barevnou koláž zeleného oka, oranžové boty, červeného basketbalového míče, fialových sluchátek, modrého srdce a žluté koruny

## Device migration onboarding

onboarding-device-migration-image-alt =
    .aria-label = Liška na obrazovce přenosného počítače mává. V notebooku je připojena myš.
onboarding-device-migration-title = Vítejte zpět!
onboarding-device-migration-subtitle = Přihlaste se ke svému { -fxaccount-brand-name(capitalization: "sentence", case: "dat") } a přeneste si své záložky, hesla a historii do nového zařízení.
onboarding-device-migration-primary-button-label = Přihlásit se
