# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Říci webovým stránkám pomocí signálu Do Not Track, že nechcete být sledováni
do-not-track-description2 =
    .label = Posílat stránkám žádost Do Not Track
    .accesskey = D
do-not-track-learn-more = Zjistit více
do-not-track-option-default-content-blocking-known =
    .label = Jen pokud je zapnuto blokování nalezených sledovacích prvků
do-not-track-option-always =
    .label = Vždy
global-privacy-control-description =
    .label = Říkat stránkám, aby neprodávaly a nesdílely vaše data
    .accesskey = s
settings-page-title = Nastavení
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box2 =
    .style = width: 15.4em
    .placeholder = Najít nastavení
managed-notice = Tento prohlížeč je spravován vaší organizací.
category-list =
    .aria-label = Kategorie
pane-general-title = Obecné
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Domovská stránka
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Vyhledávání
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Soukromí a zabezpečení
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title3 = Synchronizace
category-sync3 =
    .tooltiptext = { pane-sync-title3 }
pane-experimental-title = Experimenty { -brand-short-name(case: "gen") }
category-experimental =
    .tooltiptext = Experimenty { -brand-short-name(case: "gen") }
pane-experimental-subtitle = Tady pozor!
pane-experimental-search-results-header = Experimenty { -brand-short-name(case: "gen") }: Postupujte obezřetně!
pane-experimental-description2 =
    { -brand-short-name.case-status ->
        [with-cases] Změny v pokročilém nastavení mohou negativně ovlivnit výkon a bezpečnost { -brand-short-name(case: "gen") }.
       *[no-cases] Změny v pokročilém nastavení mohou negativně ovlivnit výkon a bezpečnost aplikace { -brand-short-name }.
    }
pane-experimental-reset =
    .label = Obnovit výchozí nastavení
    .accesskey = O
help-button-label =
    { -brand-short-name.case-status ->
        [with-cases] Nápověda { -brand-short-name(case: "gen") }
       *[no-cases] Nápověda
    }
addons-button-label = Rozšíření a vzhledy
focus-search =
    .key = f
close-button =
    .aria-label = Zavřít

## Browser Restart Dialog

feature-enable-requires-restart =
    { -brand-short-name.case-status ->
        [with-cases] Pro povolení této funkce je potřeba { -brand-short-name(case: "acc") } restartovat.
       *[no-cases] Pro povolení této funkce je potřeba aplikaci { -brand-short-name } restartovat.
    }
feature-disable-requires-restart =
    { -brand-short-name.case-status ->
        [with-cases] Pro zakázání této funkce je potřeba { -brand-short-name(case: "acc") } restartovat.
       *[no-cases] Pro zakázání této funkce je potřeba aplikaci { -brand-short-name } restartovat.
    }
should-restart-title =
    { -brand-short-name.case-status ->
        [with-cases] Restartovat { -brand-short-name(case: "acc") }
       *[no-cases] Restartovat aplikaci { -brand-short-name }
    }
should-restart-ok =
    { -brand-short-name.case-status ->
        [with-cases] Restartovat { -brand-short-name(case: "acc") }
       *[no-cases] Restartovat aplikaci { -brand-short-name }
    }
cancel-no-restart-button = Zrušit
restart-later = Restartovat později

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (string) - Name of the extension

# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlling-password-saving = Toto nastavení je spravované rozšířením <img data-l10n-name="icon"/> <strong>{ $name }</strong>.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlling-web-notifications = Toto nastavení je spravované rozšířením <img data-l10n-name="icon"/> <strong>{ $name }</strong>.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlling-privacy-containers = Rozšíření <img data-l10n-name="icon"/> <strong>{ $name }</strong> vyžaduje kontejnerové panely.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlling-websites-content-blocking-all-trackers = Toto nastavení je spravované rozšířením <img data-l10n-name="icon"/> <strong>{ $name }</strong>.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlling-proxy-config =
    { -brand-short-name.case-status ->
        [with-cases] Připojení { -brand-short-name(case: "gen") } k internetu je spravované rozšířením <img data-l10n-name ="icon"/> <strong>{ $name }</strong>.
       *[no-cases] Připojení aplikace { -brand-short-name } k internetu je spravované rozšířením <img data-l10n-name ="icon"/> <strong>{ $name }</strong>.
    }
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Pro povolení rozšíření otevřete <img data-l10n-name="addons-icon"/> Doplňky v nabídce <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Výsledky hledání
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = Je nám líto, pro „<span data-l10n-name="query"></span>“ jsme v nastavení nic nenašli.
search-results-help-link =
    { -brand-short-name.case-status ->
        [with-cases] Potřebujete pomoc? Navštivte <a data-l10n-name="url">Podporu { -brand-short-name(case: "gen") }</a>
       *[no-cases] Potřebujete pomoc? Navštivte <a data-l10n-name="url">Podporu aplikace { -brand-short-name }</a>
    }

## General Section

startup-header = Spuštění
always-check-default =
    .label = Kontrolovat, jestli je { -brand-short-name } výchozím webovým prohlížečem
    .accesskey = w
is-default = { -brand-short-name } je vaším výchozím prohlížečem
is-not-default = { -brand-short-name } aktuálně není výchozím prohlížečem
set-as-my-default-browser =
    .label = Nastavit jako výchozí…
    .accesskey = i
startup-restore-windows-and-tabs =
    .label = Otevřít okna a panely z minula
    .accesskey = p
startup-restore-warn-on-quit =
    .label = Varovat při ukončování prohlížeče
disable-extension =
    .label = Zakázat rozšíření
preferences-data-migration-header = Import dat z prohlížeče
preferences-data-migration-description =
    { -brand-short-name.case-status ->
        [with-cases] Import záložek, hesel, historie a dat automatického vyplňování do { -brand-short-name(case: "gen") }.
       *[no-cases] Import záložek, hesel, historie a dat automatického vyplňování do aplikace { -brand-short-name }.
    }
preferences-data-migration-button =
    .label = Import dat
    .accesskey = m
tabs-group-header = Panely
ctrl-tab-recently-used-order =
    .label = Přepínat panely pomocí Ctrl+Tab v pořadí podle jejich posledního použití
    .accesskey = T
open-new-link-as-tabs =
    .label = Otevírat odkazy v panelech místo v nových oknech
    .accesskey = O
confirm-on-close-multiple-tabs =
    .label = Vždy se zeptat při zavírání více panelů
    .accesskey = V
# This string is used for the confirm before quitting preference.
# Variables:
#   $quitKey (string) - the quit keyboard shortcut, and formatted
#                       in the same manner as it would appear,
#                       for example, in the File menu.
confirm-on-quit-with-key =
    .label = Vždy se zeptat při ukončování aplikace zkratkou { $quitKey }
    .accesskey = V
warn-on-open-many-tabs =
    .label =
        { -brand-short-name.case-status ->
            [with-cases] Varovat, pokud by mohlo otevření více panelů { -brand-short-name(case: "acc") } zpomalit
           *[no-cases] Varovat, pokud by mohlo otevření více panelů aplikaci { -brand-short-name } zpomalit
        }
    .accesskey = d
switch-to-new-tabs =
    .label = Přepnout na nový panel otevřený z odkazu
    .accesskey = n
show-tabs-in-taskbar =
    .label = V hlavním panelu Windows zobrazit náhledy panelů
    .accesskey = h
browser-containers-enabled =
    .label = Povolit kontejnerové panely
    .accesskey = n
browser-containers-learn-more = Zjistit více
browser-containers-settings =
    .label = Nastavení…
    .accesskey = v
containers-disable-alert-title = Zavřít všechny kontejnerové panely?

## Variables:
##   $tabCount (number) - Number of tabs

containers-disable-alert-desc =
    { $tabCount ->
        [one] Zakážete-li kontejnerové panely, bude zavřen { $tabCount } kontejnerový panel. Opravdu chcete zakázat kontejnerové panely?
        [few] Zakážete-li kontejnerové panely, budou zavřeny { $tabCount } kontejnerové panely. Opravdu chcete zakázat kontejnerové panely?
       *[other] Zakážete-li kontejnerové panely, bude zavřeno { $tabCount } kontejnerových panelů. Opravdu chcete zakázat kontejnerové panely?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Zavřít { $tabCount } kontejnerový panel
        [few] Zavřít { $tabCount } kontejnerové panely
       *[other] Zavřít { $tabCount } kontejnerových panelů
    }

##

containers-disable-alert-cancel-button = Nechat povolené
containers-remove-alert-title = Odstranit tento kontejner?
# Variables:
#   $count (number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Pokud odstraníte tento kontejner, bude zavřen { $count } kontejnerový panel. Opravdu chcete kontejner odstranit?
        [few] Pokud odstraníte tento kontejner, budou zavřeny { $count } kontejnerové panely. Opravdu chcete kontejner odstranit?
       *[other] Pokud odstraníte tento kontejner, bude zavřeno { $count } kontejnerových panelů. Opravdu chcete kontejner odstranit?
    }
containers-remove-ok-button = Odstranit tento kontejner
containers-remove-cancel-button = Neodstraňovat tento kontejner

## General Section - Language & Appearance

language-and-appearance-header = Zobrazení a jazyk stránek
preferences-web-appearance-header = Vzhled webových stránek
preferences-web-appearance-description = Některé stránky dokáží upravit svůj vzhled podle vašeho nastavení. Vyberte vzhled, který chcete na takových stránkách použít.
preferences-web-appearance-choice-auto = Automatický
preferences-web-appearance-choice-light = Světlý
preferences-web-appearance-choice-dark = Tmavý
preferences-web-appearance-choice-tooltip-auto =
    .title =
        { -brand-short-name.case-status ->
            [with-cases] Automaticky změní pozadí stránek a jejich obsahu podle nastavení vzhledu systému a { -brand-short-name(case: "gen") }.
           *[no-cases] Automaticky změní pozadí stránek a jejich obsahu podle nastavení vzhledu systému a aplikace { -brand-short-name }.
        }
preferences-web-appearance-choice-tooltip-light =
    .title = Použije pro pozadí a obsah webových stránek vzhled se světlým barevným tématem.
preferences-web-appearance-choice-tooltip-dark =
    .title = Použije pro pozadí a obsah webových stránek vzhled s tmavým barevným tématem.
preferences-web-appearance-choice-input-auto =
    .aria-description = { preferences-web-appearance-choice-tooltip-auto.title }
preferences-web-appearance-choice-input-light =
    .aria-description = { preferences-web-appearance-choice-tooltip-light.title }
preferences-web-appearance-choice-input-dark =
    .aria-description = { preferences-web-appearance-choice-tooltip-dark.title }
# This can appear when using windows HCM or "Override colors: always" without
# system colors.
preferences-web-appearance-override-warning = Vaše nastavení upravuje vzhled stránky. <a data-l10n-name="colors-link">Nastavit barvy</a>
# This message contains one link. It can be moved within the sentence as needed
# to adapt to your language, but should not be changed.
preferences-web-appearance-footer =
    { -brand-short-name.case-status ->
        [with-cases] Vzhled { -brand-short-name(case: "gen") } nastavíte ve <a data-l10n-name="themes-link">správci doplňků</a>
       *[no-cases] Vzhled aplikace { -brand-short-name } nastavíte ve <a data-l10n-name="themes-link">správci doplňků</a>
    }
preferences-colors-header = Barvy
preferences-colors-description = Nastavení výchozích barev pro text, odkazy a pozadí webových stránek.
preferences-colors-manage-button =
    .label = Nastavení barev…
    .accesskey = b
preferences-fonts-header = Písma
default-font = Výchozí písmo
    .accesskey = p
default-font-size = Velikost
    .accesskey = V
advanced-fonts =
    .label = Rozšířené…
    .accesskey = o
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Velikost stránek
preferences-default-zoom = Výchozí velikost
    .accesskey = z
# Variables:
#   $percentage (number) - Zoom percentage value
preferences-default-zoom-value =
    .label = { $percentage } %
preferences-zoom-text-only =
    .label = Pouze velikost textu
    .accesskey = t
language-header = Jazyk
choose-language-description = Vyberte jazyky pro zobrazování webových stránek
choose-button =
    .label = Vybrat jazyky…
    .accesskey = j
choose-browser-language-description =
    { -brand-short-name.case-status ->
        [with-cases] Vyberte požadovaný jazyk uživatelského rozhraní { -brand-short-name(case: "gen") }.
       *[no-cases] Vyberte požadovaný jazyk uživatelského rozhraní aplikace { -brand-short-name }.
    }
manage-browser-languages-button =
    .label = Vybrat alternativy…
    .accesskey = l
confirm-browser-language-change-description =
    { -brand-short-name.case-status ->
        [with-cases] Aby se změny projevily, restartujte { -brand-short-name(case: "acc") }
       *[no-cases] Aby se změny projevily, restartujte aplikaci { -brand-short-name }
    }
confirm-browser-language-change-button = Potvrdit a restartovat
translate-web-pages =
    .label = Překládat webové stránky
    .accesskey = T
fx-translate-web-pages = { -translations-brand-name }
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Překlady od <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Výjimky…
    .accesskey = V
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Formátovat data, časy, čísla a jednotky podle nastavení jazyka „{ $localeName }“ z operačního systému
check-user-spelling =
    .label = Při psaní kontrolovat pravopis
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = Soubory a aplikace
download-header = Stahování
download-save-where = Ukládat všechny soubory do složky
    .accesskey = v
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Vybrat…
           *[other] Procházet…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] y
           *[other] o
        }
download-always-ask-where =
    .label = U každého souboru se zeptat, kam ho uložit
    .accesskey = a
applications-header = Aplikace
applications-description = Co má { -brand-short-name } dělat se staženými soubory, nebo s aplikacemi, které používáte při prohlížení?
applications-filter =
    .placeholder = Hledat typ souboru nebo aplikaci
applications-type-column =
    .label = Typ obsahu
    .accesskey = T
applications-action-column =
    .label = Akce
    .accesskey = A
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = Soubor { $extension }
applications-action-save =
    .label = Uložit soubor
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Použít { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Použít { $app-name } (výchozí)
applications-use-os-default =
    .label = Použít výchozí systémovou aplikaci
applications-use-other =
    .label = Použít jinou…
applications-select-helper = Zvolit pomocnou aplikaci
applications-manage-app =
    .label = Podrobnosti o aplikaci…
applications-always-ask =
    .label = Vždy se zeptat
# Variables:
#   $type-description (string) - Description of the type (e.g "Portable Document Format")
#   $type (string) - The MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (string) - File extension (e.g .TXT)
#   $type (string) - The MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (string) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label =
        { -brand-short-name.case-status ->
            [with-cases] Použít { $plugin-name } (ve { -brand-short-name(case: "loc") })
           *[no-cases] Použít { $plugin-name } (v aplikaci { -brand-short-name })
        }
applications-open-inapp =
    .label =
        { -brand-short-name.case-status ->
            [with-cases] Otevřít ve { -brand-short-name(case: "loc") }
           *[no-cases] Otevřít v aplikaci { -brand-short-name }
        }

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }
applications-action-save-label =
    .value = { applications-action-save.label }
applications-use-app-label =
    .value = { applications-use-app.label }
applications-open-inapp-label =
    .value = { applications-open-inapp.label }
applications-always-ask-label =
    .value = { applications-always-ask.label }
applications-use-app-default-label =
    .value = { applications-use-app-default.label }
applications-use-other-label =
    .value = { applications-use-other.label }
applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

applications-handle-new-file-types-description = Co má { -brand-short-name } dělat s ostatními soubory?
applications-save-for-new-types =
    .label = Ukládat soubory
    .accesskey = s
applications-ask-before-handling =
    .label = Zeptat se, jestli soubor otevřít, nebo uložit
    .accesskey = a
drm-content-header = Obsah chráněný pomocí Digital Rights Management (DRM)
play-drm-content =
    .label = Přehrávat obsah chráněný pomocí DRM
    .accesskey = P
play-drm-content-learn-more = Zjistit více
update-application-title =
    { -brand-short-name.case-status ->
        [with-cases] Aktualizace { -brand-short-name(case: "gen") }
       *[no-cases] Aktualizace aplikace { -brand-short-name }
    }
update-application-description =
    { -brand-short-name.case-status ->
        [with-cases] Pro nejvyšší rychlost, stabilitu a bezpečnost udržujte { -brand-short-name(case: "acc") } stále aktuální.
       *[no-cases] Pro nejvyšší rychlost, stabilitu a bezpečnost udržujte aplikaci { -brand-short-name } stále aktuální.
    }
# Variables:
# $version (string) - Waterfox version
update-application-version = Verze { $version } <a data-l10n-name="learn-more">Co je nového</a>
update-history =
    .label = Zobrazit historii aktualizací…
    .accesskey = h
update-application-allow-description =
    { -brand-short-name.case-status ->
        [with-cases] Povolit { -brand-short-name(case: "dat") }
       *[no-cases] Povolit aplikaci { -brand-short-name }
    }
update-application-auto =
    .label = Instalovat aktualizace automaticky (doporučeno)
    .accesskey = A
update-application-check-choose =
    .label = Vyhledávat aktualizace, ale zeptat se na jejich instalaci
    .accesskey = c
update-application-manual =
    .label = Nikdy nevyhledávat aktualizace (nedoporučeno)
    .accesskey = N
update-application-background-enabled =
    .label =
        { -brand-short-name.gender ->
            [masculine] Když je { -brand-short-name } vypnutý
            [feminine] Když je { -brand-short-name } vypnutá
            [neuter] Když je { -brand-short-name } vypnuté
           *[other] Když je aplikace vypnutá
        }
    .accesskey = v
update-application-warning-cross-user-setting =
    { -brand-short-name.case-status ->
        [with-cases] Toto nastavení ovlivní všechny uživatele systému Windows a jejich profily { -brand-short-name(case: "gen") }, pokud používají stejnou instalaci.
       *[no-cases] Toto nastavení ovlivní všechny uživatele systému Windows a jejich profily aplikace { -brand-short-name }, pokud používají stejnou instalaci.
    }
update-application-use-service =
    .label = K instalaci aktualizací použít službu na pozadí
    .accesskey = b
update-application-suppress-prompts =
    .label = Ukazovat méně oznámení o aktualizacích
    .accesskey = n
update-setting-write-failure-title2 = Chyba při ukládání nastavení aktualizací
# Variables:
#   $path (string) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } zaznamenal
        [feminine] { -brand-short-name } zaznamenala
        [neuter] { -brand-short-name } zaznamenalo
       *[other] Aplikace { -brand-short-name } zaznamenala
    } problém při ukládání změny nastavení. Změna těchto nastavení vyžaduje oprávnění k zápisu do níže uvedeného souboru. Vy nebo správce vašeho systému můžete tento problém vyřešit přidělením úplných oprávnění k tomuto souboru pro skupinu Users.
    
        Není možný zápis do souboru: { $path }
update-in-progress-title = Probíhá aktualizace
update-in-progress-message =
    { -brand-short-name.gender ->
        [masculine] Chcete, aby { -brand-short-name } pokračoval v aktualizaci?
        [feminine] Chcete, aby { -brand-short-name } pokračovala v aktualizaci?
        [neuter] Chcete, aby { -brand-short-name } pokračovalo v aktualizaci?
       *[other] Chcete, aby aplikace { -brand-short-name } pokračovala v aktualizaci?
    }
update-in-progress-ok-button = &Nepokračovat
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Pokračovat

## General Section - Performance

performance-title = Výkon
performance-use-recommended-settings-checkbox =
    .label = Použít doporučené nastavení výkonu
    .accesskey = u
performance-use-recommended-settings-desc = Tato nastavení jsou ušita na míru podle hardwaru a operačního systému vašeho počítače.
performance-settings-learn-more = Zjistit více
performance-allow-hw-accel =
    .label = Použít hardwarovou akceleraci, je-li dostupná
    .accesskey = h
performance-limit-content-process-option = Omezit počet procesů pro obsah na
    .accesskey = b
performance-limit-content-process-enabled-desc = Další procesy pro obsah mohou zlepšit výkon s více otevřenými panely, ale potřebují více paměti.
performance-limit-content-process-blocked-desc =
    { -brand-short-name.case-status ->
        [with-cases] Počet procesů pro obsah lze upravit pouze při použití multiprocesového režimu { -brand-short-name(case: "gen") }. <a data-l10n-name="learn-more">Podívejte se, jak stav multiprocesového režimu zkontrolovat</a>
       *[no-cases] Počet procesů pro obsah lze upravit pouze při použití multiprocesového režimu aplikace { -brand-short-name }. <a data-l10n-name="learn-more">Podívejte se, jak stav multiprocesového režimu zkontrolovat</a>
    }
# Variables:
#   $num (number) - Default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (výchozí)

## General Section - Browsing

browsing-title = Prohlížení
browsing-use-autoscroll =
    .label = Použít automatické posouvání
    .accesskey = a
browsing-use-smooth-scrolling =
    .label = Použít plynulé posouvání
    .accesskey = l
browsing-gtk-use-non-overlay-scrollbars =
    .label = Vždy zobrazovat posuvníky
    .accesskey = o
browsing-use-onscreen-keyboard =
    .label = V případě potřeby zobrazit dotykovou klávesnici
    .accesskey = d
browsing-use-cursor-navigation =
    .label = Používat kurzorové šipky pro pohyb po stránce
    .accesskey = c
browsing-use-full-keyboard-navigation =
    .label = Použít klávesu Tab pro přesun fokusu mezi prvky formuláře a odkazy
    .accesskey = T
browsing-search-on-start-typing =
    .label = Psaním vyhledávat text na stránce
    .accesskey = x
browsing-picture-in-picture-toggle-enabled =
    .label = Zobrazovat přepínač do režimu obrazu v obraze
    .accesskey = E
browsing-picture-in-picture-learn-more = Zjistit více
browsing-media-control =
    .label = Ovládat média pomocí klávesnice, sluchátek nebo virtuálního rozhraní
    .accesskey = v
browsing-media-control-learn-more = Zjistit více
browsing-cfr-recommendations =
    .label = Doporučovat vhodná rozšíření pro navštívené stránky
    .accesskey = r
browsing-cfr-features =
    .label = Doporučovat funkce během prohlížení
    .accesskey = f
browsing-cfr-recommendations-learn-more = Zjistit více

## General Section - Proxy

network-settings-title = Nastavení sítě
network-proxy-connection-description =
    { -brand-short-name.case-status ->
        [with-cases] Konfigurovat připojení { -brand-short-name(case: "gen") } k internetu.
       *[no-cases] Konfigurovat připojení aplikace { -brand-short-name } k internetu.
    }
network-proxy-connection-learn-more = Zjistit více
network-proxy-connection-settings =
    .label = Nastavení…
    .accesskey = e

## Home Section

home-new-windows-tabs-header = Nová okna a panely
home-new-windows-tabs-description2 = Vyberte si domovskou stránku a stránku zobrazovanou při otevření nového okna nebo panelu.

## Home Section - Home Page Customization

home-homepage-mode-label = Na domovské stránce a v novém okně
home-newtabs-mode-label = V novém panelu
home-restore-defaults =
    .label = Obnovit výchozí
    .accesskey = O
home-mode-choice-default-fx =
    .label = { -firefox-home-brand-name } (výchozí)
home-mode-choice-custom =
    .label = Vlastní adresy…
home-mode-choice-blank =
    .label = Prázdnou stránku
home-homepage-custom-url =
    .placeholder = Zadejte URL adresu…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Použít aktuální stránku
           *[other] Použít aktuální stránky
        }
    .accesskey = k
choose-bookmark =
    .label = Použít záložku…
    .accesskey = z

## Home Section - Waterfox Home Content Customization

home-prefs-content-header2 = Obsah { -firefox-home-brand-name(case: "gen", capitalization: "lower") }
home-prefs-content-description2 = Vyberte obsah, který chcete mít na { -firefox-home-brand-name(case: "loc", capitalization: "lower") }.
home-prefs-search-header =
    .label = Vyhledávání na webu
home-prefs-shortcuts-header =
    .label = Zkratky
home-prefs-shortcuts-description = Uložené nebo navštěvované stránky
home-prefs-shortcuts-by-option-sponsored =
    .label = Sponzorované zkratky

## Variables:
##  $provider (string) - Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Doporučení ze služby { $provider }
home-prefs-recommended-by-description-new = Výjimečný obsah vybraný společností { $provider }, která je součástí rodiny { -brand-product-name(case: "gen") }

##

home-prefs-recommended-by-learn-more = Jak to funguje
home-prefs-recommended-by-option-sponsored-stories =
    .label = Sponzorované články
home-prefs-recommended-by-option-recent-saves =
    .label = Zobrazit nedávno uložené
home-prefs-highlights-option-visited-pages =
    .label = Navštívené stránky
home-prefs-highlights-options-bookmarks =
    .label = Záložky
home-prefs-highlights-option-most-recent-download =
    .label = Nedávná stahování
home-prefs-highlights-option-saved-to-pocket =
    .label = Stránky uložené do { -pocket-brand-name(case: "gen") }
home-prefs-recent-activity-header =
    .label = Nedávná aktivita
home-prefs-recent-activity-description = Výběr z nedávných stránek a obsahu
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Útržky
home-prefs-snippets-description-new =
    { -vendor-short-name.case-status ->
        [with-cases] Tipy a novinky od { -vendor-short-name(case: "gen") } a aplikace { -brand-product-name }
       *[no-cases] Tipy a novinky od organizace { -vendor-short-name } a aplikace { -brand-product-name }
    }
# Variables:
#   $num (number) - Number of rows displayed
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } řádek
            [few] { $num } řádky
           *[other] { $num } řádků
        }

## Search Section

search-bar-header = Vyhledávací pole
search-bar-hidden =
    .label = Použít adresní řádek pro navigaci i vyhledávání
search-bar-shown =
    .label = Přidat na lištu vyhledávací pole
search-engine-default-header = Výchozí vyhledávač
search-engine-default-desc-2 = Vyberte si výchozí vyhledávač pro adresní řádek i vyhledávací pole.
search-engine-default-private-desc-2 = Vyberte odlišný výchozí vyhledávač pro použití v režimu anonymního prohlížení.
search-separate-default-engine =
    .label = Použít tento vyhledávač jako výchozí také v režimu anonymního prohlížení
    .accesskey = u
search-suggestions-header = Našeptávání dotazů pro vyhledávač
search-suggestions-desc = Zvolte si, zda a jak má prohlížeč zobrazovat návrhy od vyhledávače.
search-suggestions-option =
    .label = Našeptávat dotazy pro vyhledávač
    .accesskey = n
search-show-suggestions-url-bar-option =
    .label = Našeptávat dotazy pro vyhledávač také v adresním řádku
    .accesskey = e
# With this option enabled, on the search results page
# the URL will be replaced by the search terms in the address bar
# when using the current default search engine.
search-show-search-term-option =
    .label = Pro výsledky výchozího vyhledávače zobrazovat vyhledané výrazy místo jeho URL adresy
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Našeptávat dotazy pro vyhledávač v adresním řádku nad stránkami z historie prohlížení
search-show-suggestions-private-windows =
    .label = Našeptávat dotazy pro vyhledávač také v anonymních oknech
suggestions-addressbar-settings-generic2 = Změnit nastavení našeptávání v adresním řádku
search-suggestions-cant-show =
    { -brand-short-name.case-status ->
        [with-cases] Návrhy vyhledávání se nebudou adresním řádku zobrazovat, protože jste { -brand-short-name(case: "acc") } nastavili, aby si nikdy nepamatoval historii.
       *[no-cases] Návrhy vyhledávání se nebudou adresním řádku zobrazovat, protože jste aplikaci { -brand-short-name } nastavili, aby si nikdy nepamatovala historii.
    }
search-one-click-header2 = Vyhledávače
search-one-click-desc = Vyberte další vyhledávače, které se zobrazí v nabídce adresního řádku a vyhledávacího pole.
search-choose-engine-column =
    .label = Vyhledávač
search-choose-keyword-column =
    .label = Klíčové slovo
search-restore-default =
    .label = Obnovit výchozí vyhledávače
    .accesskey = d
search-remove-engine =
    .label = Odebrat
    .accesskey = r
search-add-engine =
    .label = Přidat
    .accesskey = P
search-find-more-link = Přidat další vyhledávače
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Použité klíčové slovo
# Variables:
#   $name (string) - Name of a search engine.
search-keyword-warning-engine = Zvolili jste klíčové slovo, které už je použito pro „{ $name }“. Zvolte prosím jiné.
search-keyword-warning-bookmark = Zvolili jste klíčové slovo, které už je použito pro záložku. Zvolte prosím jiné.

## Containers Section

containers-back-button2 =
    .aria-label = Zpět do nastavení
containers-header = Kontejnerové panely
containers-add-button =
    .label = Přidat kontejner
    .accesskey = a
containers-new-tab-check =
    .label = Zobrazit výběr kontejneru při klepnutí na tlačítko otevření nového panelu
    .accesskey = t
containers-settings-button =
    .label = Nastavení
containers-remove-button =
    .label = Odstranit

## Waterfox account - Signed out. Note that "Sync" and "Waterfox account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Vezměte si web s sebou
sync-signedout-description2 = Synchronizujte své záložky, historii, panely, hesla, doplňky a nastavení ve všech svých zařízeních.
sync-signedout-account-signin3 =
    .label = Přihlásit se k synchronizaci…
    .accesskey = i
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Stáhněte si Waterfox pro <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> nebo <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> a synchronizujte svá data se svým mobilním zařízením.

## Waterfox account - Signed in

sync-profile-picture =
    .tooltiptext = Změnit profilový obrázek
sync-sign-out =
    .label = Odhlásit se…
    .accesskey = O
sync-manage-account = Spravovat účet
    .accesskey = S

## Variables
## $email (string) - Email used for Waterfox account

sync-signedin-unverified = Účet { $email } není ověřen.
sync-signedin-login-failure = Pro opětovné připojení účtem { $email } se přihlaste

##

sync-resend-verification =
    .label = Znovu odeslat ověření
    .accesskey = d
sync-remove-account =
    .label = Odebrat účet
    .accesskey = d
sync-sign-in =
    .label = Přihlásit se
    .accesskey = i

## Sync section - enabling or disabling sync.

prefs-syncing-on = Synchronizace zapnuta
prefs-syncing-off = Synchronizace vypnuta
prefs-sync-turn-on-syncing =
    .label = Zapnout synchronizaci…
    .accesskey = s
prefs-sync-offer-setup-label2 = Synchronizujte své záložky, historii, panely, hesla, doplňky a nastavení ve všech svých zařízeních.
prefs-sync-now =
    .labelnotsyncing = Synchronizovat
    .accesskeynotsyncing = S
    .labelsyncing = Probíhá synchronizace…
prefs-sync-now-button =
    .label = Synchronizovat
    .accesskey = S
prefs-syncing-button =
    .label = Probíhá synchronizace…

## The list of things currently syncing.

sync-syncing-across-devices-heading = Synchronizujete tyto položky ve všech připojených zařízeních:
sync-currently-syncing-bookmarks = Záložky
sync-currently-syncing-history = Historie
sync-currently-syncing-tabs = Otevřené panely
sync-currently-syncing-logins-passwords = Přihlašovací údaje
sync-currently-syncing-addresses = Adresy
sync-currently-syncing-creditcards = Platební karty
sync-currently-syncing-addons = Doplňky
sync-currently-syncing-settings = Nastavení
sync-change-options =
    .label = Změnit…
    .accesskey = Z

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog3 =
    .title = Nastavení synchronizace
    .style = min-width: 36em;
    .buttonlabelaccept = Uložit
    .buttonaccesskeyaccept = U
    .buttonlabelextra2 = Zrušit synchronizaci…
    .buttonaccesskeyextra2 = Z
sync-choose-dialog-subtitle = Změny v seznamu položek k synchronizaci se projeví ve všech připojených zařízeních.
sync-engine-bookmarks =
    .label = Záložky
    .accesskey = Z
sync-engine-history =
    .label = Historii
    .accesskey = r
sync-engine-tabs =
    .label = Otevřené panely
    .tooltiptext = Seznam panelů otevřených v ostatních zařízeních
    .accesskey = t
sync-engine-logins-passwords =
    .label = Přihlašovací údaje
    .tooltiptext = Uložená uživatelská jména a hesla
    .accesskey = P
sync-engine-addresses =
    .label = Adresy
    .tooltiptext = Uložené poštovní adresy (pouze na počítači)
    .accesskey = e
sync-engine-creditcards =
    .label = Platební karty
    .tooltiptext = Jména, čísla a data expirace (pouze na počítači)
    .accesskey = K
sync-engine-addons =
    .label = Doplňky
    .tooltiptext = Rozšíření a motivy vzhledu ve Waterfoxu pro počítač
    .accesskey = D
sync-engine-settings =
    .label = Nastavení
    .tooltiptext = Nastavení v sekcích Obecné a Soukromí a zabezpečení
    .accesskey = s

## The device name controls.

sync-device-name-header = Název zařízení
sync-device-name-change =
    .label = Přejmenovat toto zařízení…
    .accesskey = j
sync-device-name-cancel =
    .label = Zrušit
    .accesskey = u
sync-device-name-save =
    .label = Uložit
    .accesskey = l
sync-connect-another-device = Připojit další zařízení

## These strings are shown in a desktop notification after the
## user requests we resend a verification email.

sync-verification-sent-title = Ověření odesláno
# Variables:
#   $email (String): Email address of user's Waterfox account.
sync-verification-sent-body = Odkaz pro ověření byl odeslán na { $email }.
sync-verification-not-sent-title = Ověření nelze odeslat
sync-verification-not-sent-body = V tuto chvíli nemůžeme ověřovací email odeslat, zkuste to prosím znovu později.

## Privacy Section

privacy-header = Nastavení soukromí

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Přihlašovací údaje
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Ptát se na ukládání přihlašovacích údajů
    .accesskey = P
forms-exceptions =
    .label = Výjimky…
    .accesskey = k
forms-generate-passwords =
    .label = Generovat a navrhovat silná hesla
    .accesskey = G
forms-breach-alerts =
    .label = Upozorňovat na hesla uložená pro servery, kde došlo k úniku dat
    .accesskey = ú
forms-breach-alerts-learn-more-link = Zjistit více
preferences-relay-integration-checkbox =
    .label = Navrhovat e-mailové masky služby { -relay-brand-name } na ochranu vaší e-mailové adresy
relay-integration-learn-more-link = Zjistit více
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Automaticky vyplňovat přihlašovací údaje
    .accesskey = y
forms-saved-logins =
    .label = Uložené přihlašovací údaje…
    .accesskey = l
forms-primary-pw-use =
    .label = Použít hlavní heslo
    .accesskey = P
forms-primary-pw-learn-more-link = Zjistit více
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Změnit hlavní heslo…
    .accesskey = m
forms-primary-pw-change =
    .label = Změnit hlavní heslo…
    .accesskey = m
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = Momentálně jste v režimu FIPS, který vyžaduje neprázdné hlavní heslo.
forms-master-pw-fips-desc = Neúspěšná změna hesla
forms-windows-sso =
    .label = Povolit jednotné přihlašování Windows pro pracovní a školní účty a účty Microsoft
forms-windows-sso-learn-more-link = Zjistit více
forms-windows-sso-desc = Účty můžete spravovat v nastavení svého zařízení

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Pro nastavení hlavního hesla prosím zadejte své přihlašovací údaje k systému Windows. Toto opatření pomáhá v zabezpečení vašich účtů.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Waterfox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = vytvořit hlavní heslo
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Historie prohlížení
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Waterfox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Waterfox history settings:".
history-remember-label = Historii prohlížených stránek
    .accesskey = i
history-remember-option-all =
    .label = ukládat
history-remember-option-never =
    .label = nikdy neukládat
history-remember-option-custom =
    .label = ukládat podle vlastního nastavení
history-remember-description = { -brand-short-name } si bude pamatovat historii vašeho prohlížení, stahování, formulářů a vyhledávání.
history-dontremember-description = { -brand-short-name } použije stejné nastavení jako v režimu anonymního prohlížení a nebude si pamatovat žádnou historii prohlížení.
history-private-browsing-permanent =
    .label = Vždy použít režim anonymního prohlížení
    .accesskey = p
history-remember-browser-option =
    .label = Pamatovat si historii stránek a stahování
    .accesskey = s
history-remember-search-option =
    .label = Pamatovat si historii hledání a formulářů
    .accesskey = f
history-clear-on-close-option =
    .label =
        { -brand-short-name.case-status ->
            [with-cases] Vymazat historii při ukončení { -brand-short-name(case: "gen") }
           *[no-cases] Vymazat historii při ukončení aplikace { -brand-short-name }
        }
    .accesskey = r
history-clear-on-close-settings =
    .label = Nastavení…
    .accesskey = t
history-clear-button =
    .label = Vymazat historii…
    .accesskey = V

## Privacy Section - Site Data

sitedata-header = Cookies a data stránek
sitedata-total-size-calculating = Výpočet velikosti mezipaměti a dat stránek…
# Variables:
#   $value (number) - Value of the unit (for example: 4.6, 500)
#   $unit (string) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Velikost cookies, dat uložených stránkami a mezipaměti je { $value } { $unit }.
sitedata-learn-more = Zjistit více
sitedata-delete-on-close =
    .label =
        { -brand-short-name.case-status ->
            [with-cases] Vymazat cookies a data stránek při zavření { -brand-short-name(case: "gen") }
           *[no-cases] Vymazat cookies a data stránek při zavření aplikace { -brand-short-name }
        }
    .accesskey = c
sitedata-delete-on-close-private-browsing = V trvalém režimu anonymního prohlížení { -brand-short-name } smaže cookies a data stránek vždy při svém ukončení.
sitedata-allow-cookies-option =
    .label = Ukládat všechny cookies a data stránek
    .accesskey = a
sitedata-disallow-cookies-option =
    .label = Blokovat cookies a data stránek
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Blokovat
    .accesskey = t
sitedata-option-block-cross-site-trackers =
    .label = Sledovací prvky
sitedata-option-block-cross-site-tracking-cookies =
    .label = Sledovací cross-site cookies
sitedata-option-block-cross-site-cookies =
    .label = Sledovací cross-site cookies, ostatní izolovat
sitedata-option-block-unvisited =
    .label = Cookies z dosud nenavštívených stránek
sitedata-option-block-all-cross-site-cookies =
    .label = Všechny cross-site cookies (může omezit fungování některých stránek)
sitedata-option-block-all =
    .label = Všechny cookies (omezí fungování některých stránek)
sitedata-clear =
    .label = Vymazat data…
    .accesskey = V
sitedata-settings =
    .label = Správa dat…
    .accesskey = S
sitedata-cookies-exceptions =
    .label = Výjimky…
    .accesskey = k

## Privacy Section - Cookie Banner Handling

cookie-banner-handling-header = Omezení cookie lišt
cookie-banner-handling-description = { -brand-short-name } se automaticky snaží odmítat lišty s žádostmi o povolení cookies na podporovaných serverech.
cookie-banner-learn-more = Zjistit více
forms-handle-cookie-banners =
    .label = Omezit cookie lišty

## Privacy Section - Address Bar

addressbar-header = Adresní řádek
addressbar-suggest = V adresním řádku našeptávat
addressbar-locbar-history-option =
    .label = Historii prohlížení
    .accesskey = H
addressbar-locbar-bookmarks-option =
    .label = Záložky
    .accesskey = Z
addressbar-locbar-clipboard-option =
    .label = Schránka
    .accesskey = S
addressbar-locbar-openpage-option =
    .label = Otevřené panely
    .accesskey = O
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = Zkratky
    .accesskey = Z
addressbar-locbar-topsites-option =
    .label = Top stránky
    .accesskey = T
addressbar-locbar-engines-option =
    .label = Vyhledávače
    .accesskey = a
addressbar-locbar-quickactions-option =
    .label = Rychlé akce
    .accesskey = R
addressbar-suggestions-settings = Nastavit našeptávání dotazů pro vyhledávač
addressbar-quickactions-learn-more = Zjistit více

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Rozšířená ochrana proti sledování
content-blocking-section-top-level-description = Sledovací prvky sbírají informace, co a kde na internetu děláte, jaké máte návyky a co vás zajímá. { -brand-short-name } blokuje mnoho takových prvků i dalších škodlivých skriptů.
content-blocking-learn-more = Zjistit více
content-blocking-fpi-incompatibility-warning = Používáte izolaci prvních stran (FPI), která potlačí některá nastavení cookies ve { -brand-short-name(case: "loc") }.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Standardní
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = Přísná
    .accesskey = P
enhanced-tracking-protection-setting-custom =
    .label = Vlastní
    .accesskey = V

##

content-blocking-etp-standard-desc = Vyvážená ochrana a výkon. Neovlivní správné načítání webových stránek.
content-blocking-etp-strict-desc = Silnější ochrana. Může omezit fungování některých stránek.
content-blocking-etp-custom-desc = Vyberte sledovací prvky a skripty, které chcete zablokovat.
content-blocking-etp-blocking-desc = { -brand-short-name } blokuje:
content-blocking-private-windows = Sledující obsah v anonymních oknech
content-blocking-cross-site-cookies-in-all-windows2 = Cookies třetích stran ve všech oknech
content-blocking-cross-site-tracking-cookies = Sledovací cookies
content-blocking-all-cross-site-cookies-private-windows = Cookies třetích stran v anonymních oknech
content-blocking-cross-site-tracking-cookies-plus-isolate = Sledovací cookies třetích stran, ostatní izolovat
content-blocking-social-media-trackers = Sledující prvky sociálních sítí
content-blocking-all-cookies = Všechny cookies
content-blocking-unvisited-cookies = Cookies z dosud nenavštívených stránek
content-blocking-all-windows-tracking-content = Sledující obsah blokován ve všech oknech
content-blocking-all-cross-site-cookies = Všechny cross-site cookies
content-blocking-cryptominers = Těžba kryptoměn
content-blocking-fingerprinters = Vytváření otisku prohlížeče
# The known fingerprinters are those that are known for collecting browser fingerprints from user devices. And
# the suspected fingerprinters are those that we are uncertain about browser fingerprinting activities. But they could
# possibly acquire browser fingerprints because of the behavior on accessing APIs that expose browser fingerprints.
content-blocking-known-and-suspected-fingerprinters = Známé a podezřelé vytváření otisku prohlížeče

# The tcp-rollout strings are no longer used for the rollout but for tcp-by-default in the standard section

# "Contains" here means "isolates", "limits".
content-blocking-etp-standard-tcp-rollout-description = Úplná ochrana před cookies omezuje cookies na web, na němž se nacházíte, aby vás sledující subjekty nemohly sledovat napříč stránkami.
content-blocking-etp-standard-tcp-rollout-learn-more = Zjistit více
content-blocking-etp-standard-tcp-title = Zahrnuje úplnou ochranu před cookies, naši nejsilnější funkci zaměřenou na soukromí
content-blocking-warning-title = Pozor!
content-blocking-and-isolating-etp-warning-description-2 = Toto nastavení může způsobit, že některé stránky nebudou fungovat správně. Pro řešení případných problémů můžete ochranu proti sledování na takových stránkách vypnout.
content-blocking-warning-learn-how = Jak na to
content-blocking-reload-description = Aby se změny projevily, načtěte znovu své panely.
content-blocking-reload-tabs-button =
    .label = Znovu načíst všechny panely
    .accesskey = n
content-blocking-tracking-content-label =
    .label = Sledující obsah
    .accesskey = o
content-blocking-tracking-protection-option-all-windows =
    .label = ve všech oknech
    .accesskey = v
content-blocking-option-private =
    .label = jen v anonymních oknech
    .accesskey = a
content-blocking-tracking-protection-change-block-list = Změnit úroveň blokování
content-blocking-cookies-label =
    .label = Cookies
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = Více informací
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Těžbu kryptoměn
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Vytváření otisku prohlížeče
    .accesskey = s
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
#
# The known fingerprinters are those that are known for collecting browser fingerprints from user devices.
content-blocking-known-fingerprinters-label =
    .label = Známé vytváření otisků prohlížeče
    .accesskey = Z
# The suspected fingerprinters are those that we are uncertain about browser fingerprinting activities. But they could
# possibly acquire browser fingerprints because of the behavior on accessing APIs that expose browser fingerprints.
content-blocking-suspected-fingerprinters-label =
    .label = Podezřelé vytváření otisku prohlížeče
    .accesskey = P

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Výjimky…
    .accesskey = k

## Privacy Section - Permissions

permissions-header = Oprávnění
permissions-location = Poloha
permissions-location-settings =
    .label = Nastavení…
    .accesskey = a
permissions-xr = Virtuální realita
permissions-xr-settings =
    .label = Nastavení…
    .accesskey = t
permissions-camera = Kamera
permissions-camera-settings =
    .label = Nastavení…
    .accesskey = a
permissions-microphone = Mikrofon
permissions-microphone-settings =
    .label = Nastavení…
    .accesskey = n
# Short form for "the act of choosing sound output devices and redirecting audio to the chosen devices".
permissions-speaker = Volba reproduktoru
permissions-speaker-settings =
    .label = Nastavení…
    .accesskey = t
permissions-notification = Oznámení
permissions-notification-settings =
    .label = Nastavení…
    .accesskey = n
permissions-notification-link = Zjistit více
permissions-notification-pause =
    .label =
        { -brand-short-name.case-status ->
            [with-cases] Zakázat oznámení do restartu { -brand-short-name(case: "gen") }
           *[no-cases] Zakázat oznámení do restartu aplikace { -brand-short-name }
        }
    .accesskey = n
permissions-autoplay = Automatické přehrávání
permissions-autoplay-settings =
    .label = Nastavení…
    .accesskey = t
permissions-block-popups =
    .label = Blokovat vyskakovací okna
    .accesskey = B
# "popup" is a misspelling that is more popular than the correct spelling of
# "pop-up" so it's included as a search keyword, not displayed in the UI.
permissions-block-popups-exceptions-button =
    .label = Výjimky…
    .accesskey = k
    .searchkeywords = popup
permissions-addon-install-warning =
    .label = Vždy upozornit při pokusu o instalaci doplňku
    .accesskey = u
permissions-addon-exceptions =
    .label = Výjimky…
    .accesskey = k

## Privacy Section - Data Collection

collection-header =
    { -brand-short-name.case-status ->
        [with-cases] Sběr a používání dat o { -brand-short-name(case: "loc") }
       *[no-cases] Sběr a používání dat o aplikaci { -brand-short-name }
    }
collection-header2 =
    { -brand-short-name.case-status ->
        [with-cases] Sběr a používání dat o { -brand-short-name(case: "loc") }
       *[no-cases] Sběr a používání dat o aplikaci { -brand-short-name }
    }
    .searchkeywords = telemetrie
collection-description =
    { -brand-short-name.case-status ->
        [with-cases] S daty vám dáváme vždy na výběr a sbíráme jen data potřebná pro vylepšování { -brand-short-name(case: "gen") }. Před odesíláním osobních dat vždy žádáme o váš souhlas.
       *[no-cases] S daty vám dáváme vždy na výběr a sbíráme jen data potřebná pro vylepšování aplikace { -brand-short-name }. Před odesíláním osobních dat vždy žádáme o váš souhlas.
    }
collection-privacy-notice = Zásady ochrany osobních údajů
collection-health-report-telemetry-disabled =
    { -vendor-short-name.case-status ->
        [with-cases] Odesílat { -vendor-short-name(case: "dat") } technická data a data o interakcích není nadále povoleno. Všechna historická data budou smazána během 30 dnů.
       *[no-cases] Odesílat organizaci { -vendor-short-name } technická data a data o interakcích není nadále povoleno. Všechna historická data budou smazána během 30 dnů.
    }
collection-health-report-telemetry-disabled-link = Zjistit více
collection-health-report =
    .label =
        { -vendor-short-name.case-status ->
            [with-cases] Odesílat { -vendor-short-name(case: "dat") } technická data a data o interakcích
           *[no-cases] Odesílat technická data a data o interakcích
        }
    .accesskey = r
collection-health-report-link = Zjistit více
collection-studies =
    .label =
        { -brand-short-name.case-status ->
            [with-cases] Povolit { -brand-short-name(case: "dat") } instalovat studie
           *[no-cases] Povolit instalaci studií
        }
collection-studies-link =
    { -brand-short-name.case-status ->
        [with-cases] Zobrazit studie { -brand-short-name(case: "gen") }
       *[no-cases] Zobrazit studie aplikace { -brand-short-name }
    }
addon-recommendations =
    .label =
        { -brand-short-name.case-status ->
            [with-cases] Povolit { -brand-short-name(case: "dat") } doporučovat rozšíření vybraná přímo pro mě
           *[no-cases] Povolit aplikaci { -brand-short-name } doporučovat rozšíření vybraná přímo pro mě
        }
addon-recommendations-link = Zjistit více
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Odesílání dat je zakázáno konfigurací tohoto sestavení
collection-backlogged-crash-reports-with-link =
    { -brand-short-name.case-status ->
        [with-cases] Odesílat nevyřízená hlášení o pádech { -brand-short-name(case: "gen") } za vás <a data-l10n-name="crash-reports-link">Zjistit více</a>
       *[no-cases] Odesílat nevyřízená hlášení o pádech aplikace za vás <a data-l10n-name="crash-reports-link">Zjistit více</a>
    }
    .accesskey = c
privacy-segmentation-section-header = Nové funkce, které zlepšují vaše prohlížení
privacy-segmentation-section-description = Když nabízíme funkce, které využívají vaše data, abychom vám poskytli osobnější prožitek:
privacy-segmentation-radio-off =
    .label =
        { -brand-product-name.case-status ->
            [with-cases] Použít doporučení { -brand-product-name(case: "gen") }
           *[no-cases] Použít doporučení aplikace { -brand-product-name }
        }
privacy-segmentation-radio-on =
    .label = Zobrazit podrobnosti

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Zabezpečení
security-browsing-protection = Ochrana před klamavým obsahem a nebezpečným softwarem
security-enable-safe-browsing =
    .label = Blokovat nebezpečný a klamavý obsah
    .accesskey = B
security-enable-safe-browsing-link = Zjistit více
security-block-downloads =
    .label = Blokovat nebezpečná stahování
    .accesskey = s
security-block-uncommon-software =
    .label = Upozorňovat na nežádoucí nebo neobvyklý software
    .accesskey = w

## Privacy Section - Certificates

certs-header = Certifikáty
certs-enable-ocsp =
    .label = Aktuální platnost certifikátů ověřovat na serverech OCSP
    .accesskey = o
certs-view =
    .label = Zobrazit certifikáty…
    .accesskey = C
certs-devices =
    .label = Bezpečnostní zařízení…
    .accesskey = B
space-alert-over-5gb-settings-button =
    .label = Otevřít nastavení
    .accesskey = O
space-alert-over-5gb-message2 =
    { -brand-short-name.case-status ->
        [with-cases] <strong>{ -brand-short-name(case: "dat") } dochází místo na disku.</strong> Obsah webové stránky se nemusí zobrazit správně. Uložená data stránky můžete vymazat v Nastavení  > Soukromí a zabezpečení > Cookies a data stránek.
       *[no-cases] <strong>Aplikaci { -brand-short-name } dochází místo na disku.</strong> Obsah webové stránky se nemusí zobrazit správně. Uložená data stránky můžete vymazat v Nastavení  > Soukromí a zabezpečení > Cookies a data stránek.
    }
space-alert-under-5gb-message2 =
    { -brand-short-name.case-status ->
        [with-cases] <strong>{ -brand-short-name(case: "dat") } dochází místo na disku.</strong> Obsah webové stránky se nemusí zobrazit správně. Klepněte na „Dozvědět se více“ o optimalizaci využití disku k lepšímu prohlížení webu.
       *[no-cases] <strong>Aplikaci { -brand-short-name } dochází místo na disku.</strong> Obsah webové stránky se nemusí zobrazit správně. Klepněte na „Dozvědět se více“ o optimalizaci využití disku k lepšímu prohlížení webu.
    }

## Privacy Section - HTTPS-Only

httpsonly-header = Režim „pouze HTTPS“
httpsonly-description =
    { -brand-short-name.case-status ->
        [with-cases] Protokol HTTPS poskytuje zabezpečené, šifrované spojení mezi { -brand-short-name(case: "ins") } a navštěvovanými webovými stránkami. Většina webů protokol HTTPS podporuje, a pokud je zapnut režim „pouze HTTPS“, bude { -brand-short-name } navazovat spojení jen skrze protokol HTTPS.
       *[no-cases] Protokol HTTPS poskytuje zabezpečené, šifrované spojení mezi aplikací { -brand-short-name } a navštěvovanými webovými stránkami. Většina webů protokol HTTPS podporuje, a pokud je zapnut režim „pouze HTTPS“, bude { -brand-short-name } navazovat spojení jen skrze protokol HTTPS.
    }
httpsonly-learn-more = Zjistit více
httpsonly-radio-enabled =
    .label = Zapnout režim „pouze HTTPS“ ve všech oknech
httpsonly-radio-enabled-pbm =
    .label = Zapnout režim „pouze HTTPS“ v anonymních oknech
httpsonly-radio-disabled =
    .label = Nezapínat režim „pouze HTTPS“

## DoH Section

preferences-doh-header = DNS over HTTPS
preferences-doh-description = Systém doménových jmen (DNS) přes HTTPS odešle váš požadavek na doménu skrze šifrované spojení, čímž DNS zabezpečuje a znesnadňuje ostatním, aby viděli, které servery navštěvujete.
# Variables:
#   $status (string) - The status of the DoH connection
preferences-doh-status = Stav: { $status }
# Variables:
#   $name (string) - The name of the DNS over HTTPS resolver. If a custom resolver is used, the name will be the domain of the URL.
preferences-doh-resolver = Poskytovatel: { $name }
# This is displayed instead of $name in preferences-doh-resolver
# when the DoH URL is not a valid URL
preferences-doh-bad-url = Neplatná adresa URL
preferences-doh-steering-status = Pomocí místního poskytovatele
preferences-doh-status-active = Aktivní
preferences-doh-status-disabled = Vypnuto
# Variables:
#   $reason (string) - A string representation of the reason DoH is not active. For example NS_ERROR_UNKNOWN_HOST or TRR_RCODE_FAIL.
preferences-doh-status-not-active = Neaktivní ({ $reason })
preferences-doh-group-message = Povolit zabezpečené DNS:
preferences-doh-expand-section =
    .tooltiptext = Více informací
preferences-doh-setting-default =
    .label = Výchozí ochrana
    .accesskey = V
preferences-doh-default-desc = { -brand-short-name } se rozhodne, kdy používat bezpečné DNS pro ochranu vašeho soukromí.
preferences-doh-default-detailed-desc-1 = Zabezpečené DNS se použije v oblastech, kde je dostupné
preferences-doh-default-detailed-desc-2 = Pokud se zabezpečeným DNS nastane problém, použije se výchozí překladač DNS
preferences-doh-default-detailed-desc-3 = Pokud je to možné, použijte místního poskytovatele
preferences-doh-default-detailed-desc-4 = Vypne se, když je aktivní VPN, rodičovská kontrola nebo podnikové zásady
preferences-doh-default-detailed-desc-5 =
    { -brand-short-name.case-status ->
        [with-cases] Vypne se, když síť oznámí { -brand-short-name(case: "dat") }, že nemá používat zabezpečené DNS
       *[no-cases] Vypne se, když síť oznámí aplikaci { -brand-short-name }, že nemá používat zabezpečené DNS
    }
preferences-doh-setting-enabled =
    .label = Zvýšená ochrana
    .accesskey = Z
preferences-doh-enabled-desc = Sami si nastavíte, kdy se zabezpečené DNS použije, a od jakého poskytovatele.
preferences-doh-enabled-detailed-desc-1 = Použije se poskytovatel, kterého jste si vybrali
preferences-doh-enabled-detailed-desc-2 = Výchozí překladač DNS se použijte jen v případě problému se zabezpečeným DNS
preferences-doh-setting-strict =
    .label = Maximální ochrana
    .accesskey = M
preferences-doh-strict-desc = { -brand-short-name } vždy použije zabezpečené DNS. Před použitím systémového překladače DNS vždy uvidíte bezpečnostní varování.
preferences-doh-strict-detailed-desc-1 = Použije pouze poskytovatele, kterého si vyberete
preferences-doh-strict-detailed-desc-2 = Vždy upozorní, pokud není zabezpečené DNS dostupné
preferences-doh-strict-detailed-desc-3 = Pokud není zabezpečené DNS dostupné, webové stránky se nenačtou nebo nemusí správně fungovat
preferences-doh-setting-off =
    .label = Vypnuto
    .accesskey = V
preferences-doh-off-desc = Použije výchozí překladač DNS
preferences-doh-checkbox-warn =
    .label = Upozornit, pokud třetí strana aktivně brání zabezpečenému DNS
    .accesskey = U
preferences-doh-select-resolver = Vyberte poskytovatele:
preferences-doh-exceptions-description = { -brand-short-name } nebude používat zabezpečené DNS na těchto stránkách
preferences-doh-manage-exceptions =
    .label = Výjimky…
    .accesskey = k

## The following strings are used in the Download section of settings

desktop-folder-name = Plocha
downloads-folder-name = Stažené soubory
choose-download-folder-title = Vyberte složku pro stahování souborů
