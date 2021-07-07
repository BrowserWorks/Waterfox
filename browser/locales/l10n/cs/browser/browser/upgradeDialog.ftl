# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title =
    Vítá vás { -brand-short-name.gender ->
        [masculine] nový { -brand-short-name }
        [feminine] nová { -brand-short-name }
        [neuter] nové { -brand-short-name }
       *[other] nová aplikace { -brand-short-name }
    }
upgrade-dialog-new-subtitle = Prohlížeč, který vás vezme, kam potřebujete, a rychle
upgrade-dialog-new-item-menu-title = Nové lišty a nabídky pro snazší ovládání
upgrade-dialog-new-item-menu-description = Dávají přednost důležitým věcem, takže najdete, co potřebujete.
upgrade-dialog-new-item-tabs-title = Moderní vzhled panelů
upgrade-dialog-new-item-tabs-description = Obsahuje ty správné informace, nevyrušuje a přizpůsobí se vašim potřebám.
upgrade-dialog-new-item-icons-title = Svěží ikony a jasné popisky
upgrade-dialog-new-item-icons-description = Pomohou vám najít, co potřebujete, i na dotykové obrazovce.
upgrade-dialog-new-primary-default-button =
    Nastavit { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } jako můj výchozí prohlížeč
upgrade-dialog-new-primary-theme-button = Vybrat vzhled
upgrade-dialog-new-secondary-button = Teď ne
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = Ok, rozumím

## Pin Waterfox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos]
            Připnout { -brand-short-name.gender ->
                [masculine] { -brand-short-name(case: "acc") }
                [feminine] { -brand-short-name(case: "acc") }
                [neuter] { -brand-short-name(case: "acc") }
               *[other] aplikaci { -brand-short-name }
            } do docku
       *[other]
            Připnout { -brand-short-name.gender ->
                [masculine] { -brand-short-name(case: "acc") }
                [feminine] { -brand-short-name(case: "acc") }
                [neuter] { -brand-short-name(case: "acc") }
               *[other] aplikaci { -brand-short-name }
            } na lištu
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    Mějte nejnovější { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } stále na dosah.
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] Připnout do docku
       *[other] Připnout na lištu
    }
upgrade-dialog-pin-secondary-button = Teď ne

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 =
    Nastavit { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } jako výchozí prohlížeč
upgrade-dialog-default-subtitle-2 = Rychlost, bezpečnost a soukromí především.
upgrade-dialog-default-primary-button-2 = Nastavit jako výchozí prohlížeč
upgrade-dialog-default-secondary-button = Teď ne

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Začněte s čistým a novým vzhledem
upgrade-dialog-theme-system = Podle systému
    .title = Vzhled s barevným tématem podle nastavení operačního systému.

## Start screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-start-title = Život v barvách
upgrade-dialog-start-subtitle = Nové palety barev dostupné po omezenou dobu.
upgrade-dialog-start-primary-button = Vyzkoušet palety barev
upgrade-dialog-start-secondary-button = Teď ne

## Colorway screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-colorway-title = Vyberte si paletu
upgrade-dialog-colorway-home-checkbox = Přepnout na domovskou stránku Waterfoxu s tématem na pozadí
upgrade-dialog-colorway-primary-button = Uložit paletu barev
upgrade-dialog-colorway-secondary-button = Ponechat předchozí vzhled
upgrade-dialog-colorway-theme-tooltip =
    .title = Vyzkoušet výchozí vzhledy
# $colorwayName (String) - Name of colorway, e.g., Abstract, Cheers
upgrade-dialog-colorway-colorway-tooltip =
    .title = Vyzkoušet paletu barev { $colorwayName }
upgrade-dialog-colorway-default-theme = Výchozí
# "Auto" is short for "Automatic"
upgrade-dialog-colorway-theme-auto = Automaticky
    .title = Vzhled s barvami tlačítek, nabídek a oken podle nastavení operačního systému
upgrade-dialog-theme-light = Světlý
    .title = Vzhled se světlým barevným tématem.
upgrade-dialog-theme-dark = Tmavý
    .title = Vzhled s tmavým barevným tématem.
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = Vzhled s barevným tématem pro tlačítka, nabídky a okna.
upgrade-dialog-theme-keep = Ponechat předchozí
    .title =
        Ponechat vzhled používaný před aktualizací { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "gen") }
            [feminine] { -brand-short-name(case: "gen") }
            [neuter] { -brand-short-name(case: "gen") }
           *[other] aplikace { -brand-short-name }
        }
upgrade-dialog-theme-primary-button = Uložit vzhled
upgrade-dialog-theme-secondary-button = Teď ne
upgrade-dialog-colorway-variation-soft = Jemná
    .title = Použít tuto paletu barev
upgrade-dialog-colorway-variation-balanced = Vyvážená
    .title = Použít tuto paletu barev
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
upgrade-dialog-colorway-variation-bold = Výrazná
    .title = Použít tuto paletu barev

## Thank you screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-thankyou-title = Děkujeme, že jste si vybrali nás
upgrade-dialog-thankyou-subtitle = { -brand-short-name } je nezávislý prohlížeč od neziskové organizace. Společně se snažíme udělat web bezpečnější, zdravější a s větším ohledem na soukromí.
upgrade-dialog-thankyou-primary-button = Začít prohlížet
