# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Správce doplňků
addons-page-title = Správce doplňků
search-header =
    .placeholder = Vyhledat na addons.mozilla.org
    .searchbuttonlabel = Hledat
search-header-shortcut =
    .key = f
list-empty-get-extensions-message = Rozšíření a motivy vzhledů získáte na <a data-l10n-name="get-extensions">{ $domain }</a>
list-empty-installed =
    .value = Žádný doplněk tohoto typu není nainstalován
list-empty-available-updates =
    .value = Nenalezeny žádné aktualizace
list-empty-recent-updates =
    .value = Žádný doplněk nebyl aktualizován
list-empty-find-updates =
    .label = Zkontrolovat aktualizace
list-empty-button =
    .label = Zjistit více informací o doplňcích
help-button = Nápověda
sidebar-help-button-title =
    .title = Nápověda
preferences =
    { PLATFORM() ->
        [windows] Možnosti
       *[other] Předvolby
    } { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Možnosti
           *[other] Předvolby
        } { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "gen") }
            [feminine] { -brand-short-name(case: "gen") }
            [neuter] { -brand-short-name(case: "gen") }
           *[other] aplikace
        }
addons-settings-button =
    Nastavení { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace
    }
sidebar-settings-button-title =
    .title =
        Nastavení { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "gen") }
            [feminine] { -brand-short-name(case: "gen") }
            [neuter] { -brand-short-name(case: "gen") }
           *[other] aplikace
        }
show-unsigned-extensions-button =
    .label = Některá rozšíření nemohla být ověřena
show-all-extensions-button =
    .label = Zobrazit všechna rozšíření
cmd-show-details =
    .label = Zobrazit více informací
    .accesskey = v
cmd-find-updates =
    .label = Aktualizovat
    .accesskey = A
cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Možnosti
           *[other] Předvolby
        }
    .accesskey =
        { PLATFORM() ->
            [windows] M
           *[other] P
        }
cmd-enable-theme =
    .label = Použít motiv vzhledu
    .accesskey = m
cmd-disable-theme =
    .label = Nepoužívat motiv vzhledu
    .accesskey = m
cmd-install-addon =
    .label = Instalovat
    .accesskey = I
cmd-contribute =
    .label = Přispět
    .accesskey = s
    .tooltiptext = Zobrazí informace jak přispět na vývoj doplňku
detail-version =
    .label = Verze
detail-last-updated =
    .label = Poslední aktualizace
detail-contributions-description = Vývojář tohoto doplňku vás žádá o malý příspěvek, kterým pomůžete podpořit další vývoj.
detail-contributions-button = Přispět
    .title = Přispějte a pomozte s vývojem tohoto rozšíření
    .accesskey = P
detail-update-type =
    .value = Automatické aktualizace
detail-update-default =
    .label = Výchozí
    .tooltiptext = Aktualizace se instalují automaticky, je-li to výchozí nastavení
detail-update-automatic =
    .label = Povoleny
    .tooltiptext = Aktualizace se instalují automaticky
detail-update-manual =
    .label = Zakázány
    .tooltiptext = Aktualizace se instalují manuálně
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Povolit v anonymních oknech
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Není povoleno v anonymních oknech
detail-private-disallowed-description2 = Toto rozšíření v anonymních oknech nefunguje. <a data-l10n-name="learn-more">Zjistit více</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Vyžaduje přístup k anonymním oknům
detail-private-required-description2 = Toto rozšíření má přístup k vašim aktivitám v anonymních oknech. <a data-l10n-name="learn-more">Zjistit více</a>
detail-private-browsing-on =
    .label = Povolit
    .tooltiptext = Povolí rozšíření v anonymních oknech
detail-private-browsing-off =
    .label = Nepovolit
    .tooltiptext = Zakáže rozšíření v anonymních oknech
detail-home =
    .label = Domovská stránka
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Profil doplňku
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Zkontrolovat aktualizace
    .accesskey = Z
    .tooltiptext = Zkontroluje dostupnost aktualizace doplňku
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Možnosti
           *[other] Předvolby
        }
    .accesskey =
        { PLATFORM() ->
            [windows] M
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Umožní změnit možnosti doplňku
           *[other] Umožní změnit předvolby doplňku
        }
detail-rating =
    .value = Hodnocení
addon-restart-now =
    .label = Restartovat
disabled-unsigned-heading =
    .value = Některé doplňky byly zablokovány
disabled-unsigned-description =
    Následující doplňky nebyly ověřeny pro použití { -brand-short-name.gender ->
        [masculine] ve { -brand-short-name(case: "loc") }
        [feminine] v { -brand-short-name(case: "loc") }
        [neuter] v { -brand-short-name(case: "loc") }
       *[other] v aplikaci { -brand-short-name }
    }. Můžete <label data-l10n-name="find-addons">za ně najít náhrady</label> nebo požádat vývojáře, aby je nechal ověřit.
disabled-unsigned-learn-more = Zjistěte více o naší snaze o vaši bezpečnost.
disabled-unsigned-devinfo = Vývojáři, kteří mají zájem o ověření svých rozšíření, mohou pokračovat přečtením <label data-l10n-name="learn-more">našeho manuálu</label>.
plugin-deprecation-description = Něco chybí? Některé zásuvné moduly už { -brand-short-name } nepodporuje. <label data-l10n-name="learn-more">Zjistit více.</label>
legacy-warning-show-legacy = Zobrazit zastaralá rozšíření
legacy-extensions =
    .value = Zastaralá rozšíření
legacy-extensions-description =
    Tato rozšíření byla zakázána, protože neodpovídají současným standardům { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }. <label data-l10n-name="legacy-learn-more">Zjistit více o změnách pro doplňky</label>
private-browsing-description2 =
    Fungování rozšíření pro aplikaci { -brand-short-name } se v anonymních oknech mění. Žádné nově nainstalované rozšíření, nebude ve výchozím nastavení v anonymních oknech fungovat, pokud mu to nepovolíte. Rozšíření tak nebudou mít bez vašeho vědomí přístup k tomu, co v anonymních oknech děláte.
    <label data-l10n-name="private-browsing-learn-more">Jak na nastavení rozšíření</label>
addon-category-discover = Doporučení
addon-category-discover-title =
    .title = Doporučení
addon-category-extension = Rozšíření
addon-category-extension-title =
    .title = Rozšíření
addon-category-theme = Motivy vzhledu
addon-category-theme-title =
    .title = Motivy vzhledu
addon-category-plugin = Zásuvné moduly
addon-category-plugin-title =
    .title = Zásuvné moduly
addon-category-dictionary = Slovníky
addon-category-dictionary-title =
    .title = Slovníky
addon-category-locale = Jazyky
addon-category-locale-title =
    .title = Jazyky
addon-category-available-updates = Dostupné aktualizace
addon-category-available-updates-title =
    .title = Dostupné aktualizace
addon-category-recent-updates = Aktualizováno
addon-category-recent-updates-title =
    .title = Aktualizováno

## These are global warnings

extensions-warning-safe-mode = V nouzovém režimu jsou všechny doplňky zakázány.
extensions-warning-check-compatibility = Kontrola kompatibility doplňků je zakázána. Aplikace může obsahovat nekompatibilní doplňky.
extensions-warning-check-compatibility-button = Povolit
    .title = Povolí kontrolu kompatibility doplňků
extensions-warning-update-security = Kontrola bezpečné aktualizace doplňků je zakázána. Aplikace může být pomocí aktualizací napadena.
extensions-warning-update-security-button = Povolit
    .title = Povolí kontrolu bezpečné aktualizace doplňků

## Strings connected to add-on updates

addon-updates-check-for-updates = Zkontrolovat aktualizace
    .accesskey = k
addon-updates-view-updates = Zobrazit nedávno aktualizované doplňky
    .accesskey = Z

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Automaticky aktualizovat doplňky
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Nastavit všem doplňkům automatickou aktualizaci
    .accesskey = N
addon-updates-reset-updates-to-manual = Nastavit všem doplňkům manuální aktualizaci
    .accesskey = N

## Status messages displayed when updating add-ons

addon-updates-updating = Probíhá aktualizace doplňků
addon-updates-installed = Doplňky byly aktualizovány.
addon-updates-none-found = Nenalezeny žádné aktualizace
addon-updates-manual-updates-found = Zobrazit dostupné aktualizace

## Add-on install/debug strings for page options menu

addon-install-from-file = Instalovat doplněk ze souboru…
    .accesskey = I
addon-install-from-file-dialog-title = Zvolte doplněk k instalaci
addon-install-from-file-filter-name = Doplňky
addon-open-about-debugging = Ladění doplňků
    .accesskey = L

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Správa klávesových zkratek pro rozšíření
    .accesskey = S
shortcuts-no-addons = Nemáte povoleno žádné rozšíření.
shortcuts-no-commands = Následující rozšíření nemají žádné klávesové zkratky:
shortcuts-input =
    .placeholder = Zadejte klávesovou zkratku
shortcuts-browserAction2 = Přidat tlačítko na lištu
shortcuts-pageAction = Povolit akci stránky
shortcuts-sidebarAction = Přepnout zobrazení postranního panelu
shortcuts-modifier-mac = Zahrnout Ctrl, Alt nebo ⌘
shortcuts-modifier-other = Zahrnout Ctrl nebo Alt
shortcuts-invalid = Neplatná kombinace kláves
shortcuts-letter = Napište písmeno
shortcuts-system =
    Nelze přepsat zkratku { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Duplicitní zkratka
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = Zkratka { $shortcut } se používá na více místech. To může způsobit její neočekávané chování.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Tuto zkratku už používá { $addon }
shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Zobrazit další
        [few] Zobrazit { $numberToShow } další
       *[other] Zobrazit { $numberToShow } dalších
    }
shortcuts-card-collapse-button = Zobrazit méně
header-back-button =
    .title = Zpátky

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Rozšíření a vzhledy jsou jako aplikace pro váš prohlížeč. S nimi můžete chránit
    svá hesla, stahovat videa, hledat výhodné nabídky, blokovat otravné reklamy,
    měnit vzhled prohlížeče a mnoho dalšího. Tyto malé prográmky většinou vytváří
    někdy jiný než my. Zde je výběr rozšíření <a data-l10n-name="learn-more-trigger">doporučených</a>
    pro { -brand-product-name.gender ->
        [masculine] { -brand-product-name(case: "acc") }
        [feminine] { -brand-product-name(case: "acc") }
        [neuter] { -brand-product-name(case: "acc") }
       *[other] aplikaci { -brand-product-name }
    } díky jejich jedinečné bezpečnosti a funkcím.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Některá z těchto doporučení se zobrazují na základě informací o ostatních
    vámi nainstalovaných rozšíření, nastavení profilu a statistik o používání.
discopane-notice-learn-more = Zjistit více
privacy-policy = Zásady ochrany osobních údajů
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = od autora <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Počet uživatelů: { $dailyUsers }
install-extension-button =
    Přidat do { -brand-product-name.gender ->
        [masculine] { -brand-product-name(case: "gen") }
        [feminine] { -brand-product-name(case: "gen") }
        [neuter] { -brand-product-name(case: "gen") }
       *[other] aplikace { -brand-product-name }
    }
install-theme-button = Nainstalovat vzhled
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Správa
find-more-addons = Najít další doplňky
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Více možností

## Add-on actions

report-addon-button = Nahlásit
remove-addon-button = Odebrat
# The link will always be shown after the other text.
remove-addon-disabled-button = Nelze odebrat. <a data-l10n-name="link">Proč?</a>
disable-addon-button = Zakázat
enable-addon-button = Povolit
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Povolit
preferences-addon-button =
    { PLATFORM() ->
        [windows] Možnosti
       *[other] Předvolby
    }
details-addon-button = Podrobnosti
release-notes-addon-button = Poznámky k vydání
permissions-addon-button = Oprávnění
extension-enabled-heading = Povolená rozšíření
extension-disabled-heading = Zakázaná rozšíření
theme-enabled-heading = Aktivní vzhled
theme-disabled-heading = Zakázané vzhledy
plugin-enabled-heading = Povolené moduly
plugin-disabled-heading = Zakázané moduly
dictionary-enabled-heading = Povolené slovníky
dictionary-disabled-heading = Zakázané slovníky
locale-enabled-heading = Povolené jazyky
locale-disabled-heading = Zakázané jazyky
ask-to-activate-button = Spustit na vyžádání
always-activate-button = Vždy spustit
never-activate-button = Nespouštět
addon-detail-author-label = Autor
addon-detail-version-label = Verze
addon-detail-last-updated-label = Poslední aktualizace
addon-detail-homepage-label = Domovská stránka
addon-detail-rating-label = Hodnocení
# Message for add-ons with a staged pending update.
install-postponed-message =
    Toto rozšíření bude aktualizováno během restartu { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }.
install-postponed-button = Aktualizovat hned
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Hodnoceno { NUMBER($rating, maximumFractionDigits: 1) } z 5 hvězdiček
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (zakázáno)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } recenze
        [few] { $numberOfReviews } recenze
       *[other] { $numberOfReviews } recenzí
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = Doplněk <span data-l10n-name="addon-name">{ $addon }</span> byl odebrán.
pending-uninstall-undo-button = Vrátit zpět
addon-detail-updates-label = Automatické aktualizace
addon-detail-updates-radio-default = Výchozí nastavení
addon-detail-updates-radio-on = Zapnuty
addon-detail-updates-radio-off = Vypnuty
addon-detail-update-check-label = Zkontrolovat aktualizace
install-update-button = Aktualizovat
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Povoleno v anonymních oknech
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Povolená rozšíření mají přístup k vašim online aktivitám i v anonymních oknech. <a data-l10n-name="learn-more">Zjistit více</a>
addon-detail-private-browsing-allow = Povolit
addon-detail-private-browsing-disallow = Nepovolit

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = { -brand-product-name } doporučuje jen rozšíření, která splňují naše standardy pro bezpečnost a výkon
    .aria-label = { addon-badge-recommended2.title }
# We hard code "Mozilla" in the string below because the extensions are built
# by Mozilla and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = Oficiální rozšíření od Mozilly. Splňuje standardy na zabezpečení i výkon
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = U tohoto rozšíření bylo zkontrolováno, že splňuje naše standardy ohledně zabezpečení a výkonu
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = Dostupné aktualizace
recent-updates-heading = Aktualizováno
release-notes-loading = Načítání…
release-notes-error = Omlouváme se, ale při načítání poznámek k vydání nastala chyba.
addon-permissions-empty = Toto rozšíření nevyžaduje žádná oprávnění.
addon-permissions-required = Vyžadovaná oprávnění pro základní funkce:
addon-permissions-optional = Volitelná oprávnění pro dodatečné funkce:
addon-permissions-learnmore = Zjistit více o oprávněních
recommended-extensions-heading = Doporučená rozšíření
recommended-themes-heading = Doporučené vzhledy
# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Jste tvořiví? <a data-l10n-name="link">Vyrobte si vlastní vzhled pomocí Firefox Color.</a>

## Page headings

extension-heading = Správa rozšíření
theme-heading = Správa vzhledů
plugin-heading = Správa zásuvných modulů
dictionary-heading = Správa slovníků
locale-heading = Správa jazyků
updates-heading = Správa aktualizací
discover-heading =
    Přizpůsobte si { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    }
shortcuts-heading = Správa klávesových zkratek pro rozšíření
default-heading-search-label = Najít další doplňky
addons-heading-search-input =
    .placeholder = Vyhledat na addons.mozilla.org
addon-page-options-button =
    .title = Nástroje doplňků
