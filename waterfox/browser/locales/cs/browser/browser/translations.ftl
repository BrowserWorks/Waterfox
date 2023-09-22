# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The button for "Waterfox Translations" in the url bar.
urlbar-translations-button =
    .tooltiptext = Přeložit tuto stránku
# The button for "Waterfox Translations" in the url bar. Note that here "Beta" should
# not be translated, as it is a reflection of the un-localized BETA icon that is in the
# panel.
urlbar-translations-button2 =
    .tooltiptext = Přeloží tuto stránku (beta)
# Note that here "Beta" should not be translated, as it is a reflection of the
# un-localized BETA icon that is in the panel.
urlbar-translations-button-intro =
    .tooltiptext =
        { -brand-shorter-name.case-status ->
            [with-cases] Vyzkoušejte anonymní překlady ve { -brand-shorter-name(case: "loc") } (Beta)
           *[no-cases] Vyzkoušejte anonymní překlady v aplikaci { -brand-shorter-name } (Beta)
        }
# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `Page translated from: { $fromLanguage }. Current target language: { $toLanguage }`
#
# Variables:
#   $fromLanguage (string) - The original language of the document.
#   $toLanguage (string) - The target language of the translation.
urlbar-translations-button-translated =
    .tooltiptext = Stránka přeložena z { $fromLanguage } do { $toLanguage }
urlbar-translations-button-loading =
    .tooltiptext = Probíhá překlad
translations-panel-settings-button =
    .aria-label = Spravovat nastavení překladu
# Text displayed on a language dropdown when the language is in beta
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-displayname-beta =
    .label = { $language } BETA

## Options in the Waterfox Translations settings.

translations-panel-settings-manage-languages =
    .label = Správa jazyků
translations-panel-settings-about =
    { -brand-shorter-name.case-status ->
        [with-cases] O překladech ve { -brand-shorter-name(case: "loc") }
       *[no-cases] O překladech v aplikaci { -brand-shorter-name }
    }
translations-panel-settings-about2 =
    .label =
        { -brand-shorter-name.case-status ->
            [with-cases] O překladech ve { -brand-shorter-name(case: "loc") }
           *[no-cases] O překladech v aplikaci { -brand-shorter-name }
        }
# Text displayed for the option to always translate a given language
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-settings-always-translate-language =
    .label = Vždy překládat z jazyka { $language }
translations-panel-settings-always-translate-unknown-language =
    .label = Vždy překládat z tohoto jazyka
translations-panel-settings-always-offer-translation =
    .label = Vždy nabídnout překlad
# Text displayed for the option to never translate a given language
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-settings-never-translate-language =
    .label = Nikdy nepřekládat z jazyka { $language }
translations-panel-settings-never-translate-unknown-language =
    .label = Nikdy nepřekládat tento jazyk
# Text displayed for the option to never translate this website
translations-panel-settings-never-translate-site =
    .label = Nikdy nepřekládat tuto stránku

## The translation panel appears from the url bar, and this view is the default
## translation view.

translations-panel-header = Chcete tuto stránku přeložit?
translations-panel-translate-button =
    .label = Přeložit
translations-panel-translate-button-loading =
    .label = Čekejte prosím…
translations-panel-translate-cancel =
    .label = Zrušit
translations-panel-learn-more-link = Zjistit více
translations-panel-intro-header =
    { -brand-shorter-name.case-status ->
        [with-cases] Vyzkoušejte anonymní překlady ve { -brand-shorter-name(case: "loc") }
       *[no-cases] Vyzkoušejte anonymní překlady v aplikaci { -brand-shorter-name }
    }
translations-panel-intro-description = V zájmu ochrany vašeho soukromí překlady nikdy neopouštějí vaše zařízení. Nové jazyky a vylepšení již brzy!
translations-panel-error-translating = Při překladu došlo k chybě. Zkuste to prosím znovu.
translations-panel-error-load-languages = Nepodařilo se načíst jazyky
translations-panel-error-load-languages-hint = Zkontrolujte své připojení k internetu a zkuste to znovu.
translations-panel-error-load-languages-hint-button =
    .label = Zkusit znovu
translations-panel-error-unsupported = Překlad pro tuto stránku není k dispozici
translations-panel-error-dismiss-button =
    .label = Rozumím
translations-panel-error-change-button =
    .label = Změnit zdrojový jazyk
# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `Sorry, we don't support the language yet: { $language }
#
# Variables:
#   $language (string) - The language of the document.
translations-panel-error-unsupported-hint-known = Omlouváme se, ale jazyk { $language } zatím není podporován.
translations-panel-error-unsupported-hint-unknown = Omlouváme se, ale tento jazyk zatím není podporován.

## Each label is followed, on a new line, by a dropdown list of language names.
## If this structure is problematic for your locale, an alternative way is to
## translate them as `Source language:` and `Target language:`

translations-panel-from-label = Překlad z
translations-panel-to-label = Překlad do

## The translation panel appears from the url bar, and this view is the "restore" view
## that lets a user restore a page to the original language, or translate into another
## language.

# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `The page is translated from: { $fromLanguage }. Current target language: { $toLanguage }`
#
# Variables:
#   $fromLanguage (string) - The original language of the document.
#   $toLanguage (string) - The target language of the translation.
translations-panel-revisit-header = Tato stránka je přeložena z jazyka { $fromLanguage } do jazyka { $toLanguage }.
translations-panel-choose-language =
    .label = Zvolit jazyk
translations-panel-restore-button =
    .label = Zobrazit původní

## Waterfox Translations language management in about:preferences.

translations-manage-header = Překlady
translations-manage-settings-button =
    .label = Nastavení…
    .accesskey = t
translations-manage-description = Stažení jazyků pro offline překlad.
translations-manage-all-language = Všechny jazyky
translations-manage-download-button = Stáhnout
translations-manage-delete-button = Smazat
translations-manage-error-download = Při stahování jazykových souborů se vyskytl problém. Zkuste to prosím znovu.
translations-manage-error-delete = Při odstraňování jazykových souborů se vyskytl problém. Zkuste to prosím znovu.
translations-manage-intro = Nastavte předvolby jazyka a překladu webu a spravujte jazyky nainstalované pro překlad offline.
translations-manage-install-description = Instalace jazyků pro offline překlad
translations-manage-language-install-button =
    .label = Nainstalovat
translations-manage-language-install-all-button =
    .label = Nainstalovat vše
    .accesskey = N
translations-manage-language-remove-button =
    .label = Odebrat
translations-manage-language-remove-all-button =
    .label = Odebrat vše
    .accesskey = O
translations-manage-error-install = Při instalaci jazykových souborů došlo k chybě. Prosím zkuste to znovu.
translations-manage-error-remove = Při odstraňování jazykových souborů došlo k chybě. Prosím zkuste to znovu.
translations-manage-error-list = Nepodařilo se získat seznam dostupných jazyků pro překlad. Obnovte stránku a zkuste to znovu.
translations-settings-title =
    .title = Nastavení překladů
    .style = min-width: 36em
translations-settings-close-key =
    .key = w
translations-settings-always-translate-langs-description = Překlad pro následující jazyky proběhne automaticky
translations-settings-never-translate-langs-description = Překlad nebude nabízen pro následující jazyky
translations-settings-never-translate-sites-description = Překlady nebudou nabízeny pro následující stránky
translations-settings-languages-column =
    .label = Jazyky
translations-settings-remove-language-button =
    .label = Odebrat jazyk
    .accesskey = r
translations-settings-remove-all-languages-button =
    .label = Odebrat všechny jazyky
    .accesskey = e
translations-settings-sites-column =
    .label = Webové stránky
translations-settings-remove-site-button =
    .label = Odebrat stránku
    .accesskey = s
translations-settings-remove-all-sites-button =
    .label = Odebrat všechny stránky
    .accesskey = O
translations-settings-close-dialog =
    .buttonlabelaccept = Zavřít
    .buttonaccesskeyaccept = Z
