# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Správca doplnkov

addons-page-title = Správca doplnkov

search-header =
    .placeholder = Hľadať na addons.mozilla.org
    .searchbuttonlabel = Hľadať

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Nemáte nainštalované žiadne doplnky tohto typu

list-empty-available-updates =
    .value = Neboli nájdené žiadne aktualizácie

list-empty-recent-updates =
    .value = V poslednom čase ste neaktualizovali žiadne doplnky

list-empty-find-updates =
    .label = Vyhľadať aktualizácie

list-empty-button =
    .label = Ďalšie informácie o doplnkoch

help-button = Podpora doplnkov

sidebar-help-button-title =
    .title = Podpora doplnkov

preferences =
    { PLATFORM() ->
        [windows] Možnosti aplikácie
       *[other] Možnosti aplikácie
    }

sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Možnosti aplikácie
           *[other] Možnosti aplikácie
        }

show-unsigned-extensions-button =
    .label = Niektoré rozšírenia nemohli byť overené

show-all-extensions-button =
    .label = Zobraziť všetky rozšírenia

cmd-show-details =
    .label = Zobraziť ďalšie informácie
    .accesskey = Z

cmd-find-updates =
    .label = Vyhľadať aktualizácie
    .accesskey = h

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Možnosti
           *[other] Možnosti
        }
    .accesskey =
        { PLATFORM() ->
            [windows] M
           *[other] M
        }

cmd-enable-theme =
    .label = Použiť tému
    .accesskey = m

cmd-disable-theme =
    .label = Zrušiť tému
    .accesskey = m

cmd-install-addon =
    .label = Nainštalovať
    .accesskey = N

cmd-contribute =
    .label = Prispieť
    .accesskey = r
    .tooltiptext = Prispieť na vývoj tohto doplnku

detail-version =
    .label = Verzia

detail-last-updated =
    .label = Naposledy aktualizované

detail-contributions-description = Vývojár tohto doplnku by bol rád, keby ste mu na jeho vývoj prispeli malou čiastkou.

detail-contributions-button = Prispieť
    .title = Prispejte na vývoj tohto doplnku
    .accesskey = r

detail-update-type =
    .value = Automatické aktualizácie

detail-update-default =
    .label = Predvolené
    .tooltiptext = Automaticky inštalovať aktualizácie len v prípade, že je to predvolené nastavenie

detail-update-automatic =
    .label = Zapnuté
    .tooltiptext = Automaticky inštalovať aktualizácie

detail-update-manual =
    .label = Vypnuté
    .tooltiptext = Neinštalovať aktualizácie automaticky

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Povoliť v súkromných oknách

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Toto rozšírenie sa nespúšťa v súkromných oknách

detail-private-disallowed-description2 = Tvorca rozšírenia zakázal jeho spúšťanie v súkromných oknách. <a data-l10n-name="learn-more">Ďalšie informácie</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Vyžaduje prístup k súkromným oknám

detail-private-required-description2 = Toto rozšírenie má prístup k vašim aktivitám v súkromných oknách. <a data-l10n-name="learn-more">Ďalšie informácie</a>

detail-private-browsing-on =
    .label = Povoliť
    .tooltiptext = Povoliť v súkromných oknách

detail-private-browsing-off =
    .label = Nepovoliť
    .tooltiptext = Nepovoliť v súkromných oknách

detail-home =
    .label = Domovská stránka

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Profil doplnku

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Hľadať aktualizácie
    .accesskey = H
    .tooltiptext = Vyhľadať aktualizácie tohto doplnku

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Možnosti
           *[other] Možnosti
        }
    .accesskey =
        { PLATFORM() ->
            [windows] M
           *[other] M
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Upraviť možnosti a nastavenia tohto doplnku
           *[other] Upraviť možnosti a nastavenia tohto doplnku
        }

detail-rating =
    .value = Hodnotenie

addon-restart-now =
    .label = Reštartovať teraz

disabled-unsigned-heading =
    .value = Niektoré doplnky boli zakázané

disabled-unsigned-description = Nasledujúce doplnky neboli overené pre používanie v aplikácii { -brand-short-name }. Môžete si skúsiť <label data-l10n-name="find-addons">vyhľadať náhradu</label> alebo požiadať vývojára o overenie doplnku.

disabled-unsigned-learn-more = Ďalšie informácie o našej snahe udržať vás v bezpečí online.

disabled-unsigned-devinfo = Vývojári, ktorí si chcú nechať overiť svoje doplnky, si môžu prečítať náš <label data-l10n-name="learn-more">manuál</label>.

plugin-deprecation-description = Chýba vám tu niečo? Niektoré zásuvné moduly už { -brand-short-name } nepodporuje. <label data-l10n-name="learn-more">Ďalšie informácie.</label>

legacy-warning-show-legacy = Zobraziť zastarané rozšírenia

legacy-extensions =
    .value = Zastarané rozšírenia

legacy-extensions-description = Tieto rozšírenia nespĺňajú súčasné kritériá prehliadača { -brand-short-name } a boli preto deaktivované. <label data-l10n-name="legacy-learn-more">Ďalšie informácie o zmenách ohľadom doplnkov</label>

private-browsing-description2 =
    Fungovanie rozšírení v aplikácii { -brand-short-name } v súkromnom prehliadaní sa mení. Všetky novo nainštalované 
    rozšírenia do aplikácie { -brand-short-name } nebudú fungovať v súkromných oknách, pokiaľ im to nepovolíte.
    Rozšírenia tak nebudú mať bez vášho vedomia prístup k tomu, čo robíte v súkromnom prehliadaní. 
    Týmto krokom sa snažíme zvýšiť vaše súkromie.
    <label data-l10n-name="private-browsing-learn-more">Ďalšie informácie o správe rozšírení.</label>

addon-category-discover = Odporúčania
addon-category-discover-title =
    .title = Odporúčania
addon-category-extension = Rozšírenia
addon-category-extension-title =
    .title = Rozšírenia
addon-category-theme = Témy vzhľadu
addon-category-theme-title =
    .title = Témy vzhľadu
addon-category-plugin = Zásuvné moduly
addon-category-plugin-title =
    .title = Zásuvné moduly
addon-category-dictionary = Slovníky
addon-category-dictionary-title =
    .title = Slovníky
addon-category-locale = Jazyky
addon-category-locale-title =
    .title = Jazyky
addon-category-available-updates = Dostupné aktualizácie
addon-category-available-updates-title =
    .title = Dostupné aktualizácie
addon-category-recent-updates = Nedávno aktualizované
addon-category-recent-updates-title =
    .title = Nedávno aktualizované

## These are global warnings

extensions-warning-safe-mode = Všetky doplnky boli zakázané núdzovým režimom.
extensions-warning-check-compatibility = Kontrola kompatibility doplnkov je vypnutá. Môžete mať nekompatibilné doplnky.
extensions-warning-check-compatibility-button = Zapnúť
    .title = Povoliť kontrolu kompatibility doplnkov
extensions-warning-update-security = Kontrola bezpečnosti aktualizácií doplnkov je vypnutá. Aktualizácie vás môžu ohroziť.
extensions-warning-update-security-button = Zapnúť
    .title = Povoliť kontrolu bezpečnosti aktualizácií doplnkov


## Strings connected to add-on updates

addon-updates-check-for-updates = Vyhľadať aktualizácie
    .accesskey = V
addon-updates-view-updates = Zobraziť nedávno aktualizované
    .accesskey = Z

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Automaticky aktualizovať doplnky
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Nastaviť všetky doplnky na automatické aktualizovanie
    .accesskey = s
addon-updates-reset-updates-to-manual = Nastaviť všetky doplnky na manuálne aktualizovanie
    .accesskey = s

## Status messages displayed when updating add-ons

addon-updates-updating = Aktualizujú sa doplnky
addon-updates-installed = Vaše doplnky boli aktualizované.
addon-updates-none-found = Neboli nájdené žiadne aktualizácie
addon-updates-manual-updates-found = Zobraziť dostupné aktualizácie

## Add-on install/debug strings for page options menu

addon-install-from-file = Nainštalovať doplnok zo súboru…
    .accesskey = N
addon-install-from-file-dialog-title = Zvoľte doplnok, ktorý chcete nainštalovať
addon-install-from-file-filter-name = Doplnky
addon-open-about-debugging = Ladiť doplnky
    .accesskey = L

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Spravovať klávesové skratky pre rozšírenia
    .accesskey = n

shortcuts-no-addons = Nemáte povolené žiadne rozšírenie.
shortcuts-no-commands = Nasledujúce rozšírenia nemajú skratky:
shortcuts-input =
    .placeholder = Zadajte klávesovú skratku

shortcuts-browserAction2 = Pridať tlačidlo na panel nástrojov
shortcuts-pageAction = Aktivovať akciu stránky
shortcuts-sidebarAction = Prepnúť zobrazenie bočného panela

shortcuts-modifier-mac = Nezabudnite vložiť aj Ctrl, Alt alebo ⌘
shortcuts-modifier-other = Nezabudnite vložiť aj Ctrl alebo Alt
shortcuts-invalid = Neplatná kombinácia klávesov
shortcuts-letter = Napíšte písmeno
shortcuts-system = Prepísať skratku aplikácie { -brand-short-name } nie je možné

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Duplicitná skratka

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = Skratka { $shortcut } sa používa na viacerých miestach. To môže spôsobiť jej neočakávané správanie.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Túto skratku už používa { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Zobraziť { $numberToShow } ďalšiu
        [few] Zobraziť { $numberToShow } ďalšie
       *[other] Zobraziť { $numberToShow } ďalších
    }

shortcuts-card-collapse-button = Zobraziť menej

header-back-button =
    .title = Späť

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Rozšírenia a témy vzhľadu sú ako aplikácie pre váš prehliadač. S nimi môžete
    chrániť svoje heslá, preberať videá, hľadať výhodné ponuky, blokovať reklamy,
    meniť vzhľad prehliadača a omnoho viac. Tieto malé programy väčšinou vyrába
    niekto iný ako my. Tu je výber <a data-l10n-name="learn-more-trigger">odporúčaných</a>
    rozšírení pre { -brand-product-name }, ktoré majú jedinečnú bezpečnosť a funkcie.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Niektoré z týchto odporúčaní sú vám prispôsobené. Sú založené na rozšíreniach, ktoré už
    máte nainštalované, nastaveniach profilu a štatistikách používania.
discopane-notice-learn-more = Ďalšie informácie

privacy-policy = Zásady ochrany súkromia

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = Autor: <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Počet používateľov: { $dailyUsers }
install-extension-button = Pridať do { -brand-product-name(case: "gen") }
install-theme-button = Nainštalovať tému vzhľadu
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Spravovať
find-more-addons = Zobraziť ďalšie doplnky

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Ďalšie možnosti

## Add-on actions

report-addon-button = Nahlásiť
remove-addon-button = Odstrániť
# The link will always be shown after the other text.
remove-addon-disabled-button = Nie je možné odstrániť. <a data-l10n-name="link">Prečo?</a>
disable-addon-button = Zakázať
enable-addon-button = Povoliť
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Povoliť
preferences-addon-button =
    { PLATFORM() ->
        [windows] Možnosti
       *[other] Možnosti
    }
details-addon-button = Podrobnosti
release-notes-addon-button = Poznámky k vydaniu
permissions-addon-button = Povolenia

extension-enabled-heading = Povolené rozšírenia
extension-disabled-heading = Zakázané rozšírenia

theme-enabled-heading = Aktívna téma vzhľadu
theme-disabled-heading = Zakázané témy vzhľadu

plugin-enabled-heading = Povolené zásuvné moduly
plugin-disabled-heading = Zakázané zásuvné moduly

dictionary-enabled-heading = Povolené slovníky
dictionary-disabled-heading = Zakázané slovníky

locale-enabled-heading = Povolené jazyky
locale-disabled-heading = Zakázané jazyky

ask-to-activate-button = Vyžiadať aktivovanie
always-activate-button = Vždy aktivovať
never-activate-button = Nikdy neaktivovať

addon-detail-author-label = Autor
addon-detail-version-label = Verzia
addon-detail-last-updated-label = Posledná aktualizácia
addon-detail-homepage-label = Domovská stránka
addon-detail-rating-label = Hodnotenie

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Ohodnotené na { NUMBER($rating, maximumFractionDigits: 1) } z 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (zakázané)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } recenzia
        [few] { $numberOfReviews } recenzie
       *[other] { $numberOfReviews } recenzií
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = Doplnok <span data-l10n-name="addon-name">{ $addon }</span> bol odstránený.
pending-uninstall-undo-button = Späť

addon-detail-updates-label = Automatické aktualizácie
addon-detail-updates-radio-default = Predvolené nastavenie
addon-detail-updates-radio-on = Zapnuté
addon-detail-updates-radio-off = Vypnuté
addon-detail-update-check-label = Vyhľadať aktualizácie
install-update-button = Aktualizovať

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Povolené v súkromných oknách
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Povolené rozšírenia majú prístup k vašim aktivitám na internete v súkromných oknách. <a data-l10n-name="learn-more">Ďalšie informácie</a>
addon-detail-private-browsing-allow = Povoliť
addon-detail-private-browsing-disallow = Nepovoliť

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } odporúča len rozšírenia, ktoré spĺňajú naše štandardy pre bezpečnosť a výkon.
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = K dispozícii je aktualizácia
recent-updates-heading = Naposledy aktualizované

release-notes-loading = Načítava sa…
release-notes-error = Pri načítaní poznámok k vydaniu sa vyskytla chyba.

addon-permissions-empty = Toto rozšírenie nevyžaduje žiadne povolenia

recommended-extensions-heading = Odporúčané rozšírenia
recommended-themes-heading = Odporúčané témy vzhľadu

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Ste tvoriví? <a data-l10n-name="link">Vytvorte si svoju vlastnú tému vzhľadu pomocou Firefox Color.</a>

## Page headings

extension-heading = Spravujte svoje rozšírenia
theme-heading = Spravujte svoje témy vzhľadu
plugin-heading = Spravujte svoje zásuvné moduly
dictionary-heading = Spravujte svoje slovníky
locale-heading = Spravujte svoje jazyky
updates-heading = Spravujte svoje aktualizácie
discover-heading = Prispôsobte si { -brand-short-name }
shortcuts-heading = Správa klávesových skratiek pre rozšírenia

default-heading-search-label = Zobraziť ďalšie doplnky
addons-heading-search-input =
    .placeholder = Hľadať na addons.mozilla.org

addon-page-options-button =
    .title = Nástroje pre všetky doplnky
