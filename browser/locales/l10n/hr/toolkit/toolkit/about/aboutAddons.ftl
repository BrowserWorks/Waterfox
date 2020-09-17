# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Upravljač dodataka
addons-page-title = Upravljač dodataka
search-header =
    .placeholder = Pretraži addons.mozilla.org
    .searchbuttonlabel = Traži
search-header-shortcut =
    .key = f
list-empty-installed =
    .value = Nemate instaliran nijedan dodatak ove vrste
list-empty-available-updates =
    .value = Nema nadogradnji
list-empty-recent-updates =
    .value = U posljednje vrijeme nisi aktualizirao/la nijedan dodatak
list-empty-find-updates =
    .label = Provjeri dostupnost dopuna
list-empty-button =
    .label = Saznaj više o dodacima
help-button = Podrška za dodatke
sidebar-help-button-title =
    .title = Podrška za dodatke
preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } Mogućnosti
       *[other] { -brand-short-name } Postavke
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } Mogućnosti
           *[other] { -brand-short-name } Postavke
        }
show-unsigned-extensions-button =
    .label = Neka proširenja nisu mogla biti verificirana
show-all-extensions-button =
    .label = Prikaži sva proširenja
cmd-show-details =
    .label = Prikaži više informacija
    .accesskey = f
cmd-find-updates =
    .label = Pronađi dopune
    .accesskey = P
cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Mogućnosti
           *[other] Osobitosti
        }
    .accesskey =
        { PLATFORM() ->
            [windows] M
           *[other] O
        }
cmd-enable-theme =
    .label = Aktiviraj motiv
    .accesskey = k
cmd-disable-theme =
    .label = Deaktiviraj motiv
    .accesskey = k
cmd-install-addon =
    .label = Instaliraj
    .accesskey = I
cmd-contribute =
    .label = Doprinesite
    .accesskey = D
    .tooltiptext = Doprinesite razvoju ovog dodatka
detail-version =
    .label = Verzija
detail-last-updated =
    .label = Posljednja dopuna
detail-contributions-description = Programer ovog proširenja te moli, da pomoću male donacije podržiš daljnji razvoj proširenja.
detail-contributions-button = Doprinesite
    .title = Doprinesite razvoju ovog dodatka
    .accesskey = D
detail-update-type =
    .value = Automatske dopune
detail-update-default =
    .label = Standardno
    .tooltiptext = Instaliraj dopune automatski samo ako je to standardno postavljeno
detail-update-automatic =
    .label = Uključeno
    .tooltiptext = Automatski instaliraj dopune
detail-update-manual =
    .label = Isključeno
    .tooltiptext = Nemoj automatski instalirati dopune
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Pokreni u privatnim prozorima
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Nije dopušteno u privatnim prozorima
detail-private-disallowed-description2 = Ovaj dodatak se ne pokreće tijekom privatnog pregledavanja. <a data-l10n-name="learn-more">Saznaj više</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Zahtjeva pristup u privatnim prozorima
detail-private-required-description2 = Ovo proširenje ima pristup tvojim internetskim aktivnostima tijekom privatnog pregledavanja. <a data-l10n-name="learn-more">Saznaj više</a>
detail-private-browsing-on =
    .label = Dozvoli
    .tooltiptext = Omogući u privatnom pretraživanju
detail-private-browsing-off =
    .label = Nemoj dozvoliti
    .tooltiptext = Onemogući u privatnom pretraživanju
detail-home =
    .label = Početna stranica
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Profil dodataka
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Provjeri dostupnost dopuna
    .accesskey = r
    .tooltiptext = Provjeri dostupnost dopuna za ovaj dodatak
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Mogućnosti
           *[other] Osobitosti
        }
    .accesskey =
        { PLATFORM() ->
            [windows] o
           *[other] t
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Promijeni mogućnosti ovog dodatka
           *[other] Promijeni osobitosti ovog dodatka
        }
detail-rating =
    .value = Ocjena
addon-restart-now =
    .label = Ponovo pokreni sada
disabled-unsigned-heading =
    .value = Neki dodaci su isključeni
disabled-unsigned-description = Navedeni dodaci nisu mogli biti verificirani za korištenje u { -brand-short-name }u. Možete <label data-l10n-name="find-addons">pronaći zamjenske dodatke</label> ili kontaktirati autora dodataka da zatraži njihovu verifikaciju.
disabled-unsigned-learn-more = Saznaj više o našim naporima da te zaštitimo na Internetu.
disabled-unsigned-devinfo = Programeri koji su zainteresirani za verifikaciju svojih dodataka, mogu nastaviti čitati naš <label data-l10n-name="learn-more">priručnik</label>.
plugin-deprecation-description = Ne možeš pronaći priključak koji tražiš? Neke priključke { -brand-short-name } više ne podržava. <label data-l10n-name="learn-more">Saznaj više.</label>
legacy-warning-show-legacy = Prikaži zastarjele dodatke
legacy-extensions =
    .value = Zastarjeli dodaci
legacy-extensions-description = Ovi dodaci ne zadovoljavaju trenutačne { -brand-short-name } standarde te se isključeni. <label data-l10n-name="legacy-learn-more">Saznaj o promjenama u dodacima</label>
private-browsing-description2 = { -brand-short-name } mijenja način na koji dodaci rade u privatnom pretraživanju. Svaki novi dodatak koji dodaš u { -brand-short-name } neće automatski raditi u privatnom pretraživanju. Ukoliko ne dozvoliš u postavkama, dodatak neće raditi dok koristiš privatno pretraživanje i neće imati pristup tvojim aktivnostima. Napravili smo ovu izmjenu kako bismo zadržali tvoje pretraživanje privatnim. <label data-l10n-name="private-browsing-learn-more">Saznaj kako upravljati postavkama dodataka</label>
addon-category-discover = Preporuke
addon-category-discover-title =
    .title = Preporuke
addon-category-extension = Dodaci
addon-category-extension-title =
    .title = Dodaci
addon-category-theme = Motivi
addon-category-theme-title =
    .title = Motivi
addon-category-plugin = Priključci
addon-category-plugin-title =
    .title = Priključci
addon-category-dictionary = Rječnici
addon-category-dictionary-title =
    .title = Rječnici
addon-category-locale = Jezici
addon-category-locale-title =
    .title = Jezici
addon-category-available-updates = Dostupne dopune
addon-category-available-updates-title =
    .title = Dostupne dopune
addon-category-recent-updates = Nedavne dopune
addon-category-recent-updates-title =
    .title = Nedavne dopune

## These are global warnings

extensions-warning-safe-mode = Siguran način rada isključio je sve dodatke.
extensions-warning-check-compatibility = Provjera kompatibilnosti dodataka je isključena. Možda imaš nekompatibilne dodatke.
extensions-warning-check-compatibility-button = Omogući
    .title = Omogući provjeru kompatibilnosti dodataka
extensions-warning-update-security = Provjera dostupnosti sigurnosnih nadogradnji za dodatke je isključena. Nadogradnje mogu naškoditi tvojoj sigurnosti.
extensions-warning-update-security-button = Omogući
    .title = Omogući provjeru dostupnosti sigurnosnih dopuna za dodatke

## Strings connected to add-on updates

addon-updates-check-for-updates = Provjeri dostupnost dopuna
    .accesskey = d
addon-updates-view-updates = Prikaži nedavne dopune
    .accesskey = v

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Automatski aktualiziraj dodatke
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Postavi automatsko aktualiziranje za sve dodatke
    .accesskey = r
addon-updates-reset-updates-to-manual = Postavi ručno aktualiziranje za sve dodatke
    .accesskey = r

## Status messages displayed when updating add-ons

addon-updates-updating = Aktualiziranje dodataka
addon-updates-installed = Tvoji su dodaci aktualizirani.
addon-updates-none-found = Nema dopuna
addon-updates-manual-updates-found = Prikaži dostupne dopune

## Add-on install/debug strings for page options menu

addon-install-from-file = Instaliraj dodatak iz datoteke…
    .accesskey = I
addon-install-from-file-dialog-title = Odaberi dodatak koji želiš instalirati
addon-install-from-file-filter-name = Dodaci
addon-open-about-debugging = Otklanjanje grešaka u dodacima
    .accesskey = g

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Upravljaj tipkovničkim prečacima dodatka
    .accesskey = U
shortcuts-no-addons = Nemaš aktiviranih proširenja.
shortcuts-no-commands = Sljedeći dodaci nemaju prečace:
shortcuts-input =
    .placeholder = Upišite prečac
shortcuts-pageAction = Aktiviraj radnju stranice
shortcuts-sidebarAction = Prikaži/sakrij bočnu traku
shortcuts-modifier-mac = Uključi Ctrl, Alt ili ⌘
shortcuts-modifier-other = Uključi Ctrl ili Alt
shortcuts-invalid = Nepodržana kombinacija
shortcuts-letter = Upiši slovo
shortcuts-system = Nije moguće izmijeniti { -brand-short-name } prečac
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Duplikat prečice
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } se koristi kao prečac u više od jednog slučaja. Dupli prečaci mogu prouzročiti neočekivano ponašanje.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Već se koristi za { $addon }
shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Prikaži još { $numberToShow }
        [few] Prikaži još { $numberToShow }
       *[other] Prikaži još { $numberToShow }
    }
shortcuts-card-collapse-button = Prikaži manje
header-back-button =
    .title = Idi natrag

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Dodaci i motivi su kao programi za preglednik i omogućavaju zaštitu za
    lozinke, preuzimanje videozapisa, pronalaženje ponuda, blokiranje
    dosadnih oglasa, izmjenu izgleda preglednika i još puno više. Ove male
    programe često razvijaju treće strane. Ovdje je izbor dodataka koje
    { -brand-product-name } <a data-l10n-name="learn-more-trigger">preporučuje</a> za dodatnu
    sigurnost, perfomanse i funkcionalnost.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Neki prijedlozi su specifični za tebe, jer se temelje na drugim već instaliranim
    proširenjima, na postavkama profila ili na statistici korištenja.
discopane-notice-learn-more = Saznaj više
privacy-policy = Politika privatnosti
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = od <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Korisnici: { $dailyUsers }
install-extension-button = Dodaj u { -brand-product-name }
install-theme-button = Instaliraj motiv
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Upravljaj
find-more-addons = Pronađi daljnje dodatke
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Više mogućnosti

## Add-on actions

report-addon-button = Prijavi
remove-addon-button = Ukloni
# The link will always be shown after the other text.
remove-addon-disabled-button = Ne može se ukloniti. <a data-l10n-name="link">Zašto?</a>
disable-addon-button = Onemogući
enable-addon-button = Omogući
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Omogući
preferences-addon-button =
    { PLATFORM() ->
        [windows] Mogućnosti
       *[other] Mogućnosti
    }
details-addon-button = Detalji
release-notes-addon-button = Napomene o izdanju
permissions-addon-button = Dozvole
extension-enabled-heading = Aktivirano
extension-disabled-heading = Onemogućeno
theme-enabled-heading = Aktivirano
theme-disabled-heading = Onemogućeno
plugin-enabled-heading = Aktivirano
plugin-disabled-heading = Onemogućeno
dictionary-enabled-heading = Aktivirano
dictionary-disabled-heading = Onemogućeno
locale-enabled-heading = Aktivirano
locale-disabled-heading = Onemogućeno
ask-to-activate-button = Pitaj prilikom aktivacije
always-activate-button = Uvijek aktiviraj
never-activate-button = Nikada nemoj aktivirati
addon-detail-author-label = Autor
addon-detail-version-label = Verzija
addon-detail-last-updated-label = Zadnje aktualiziranje
addon-detail-homepage-label = Početna stranica
addon-detail-rating-label = Ocjena
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Ocjenjeno je { NUMBER($rating, maximumFractionDigits: 1) } od 5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (onemogućeno)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } recenzija
        [few] { $numberOfReviews } recenzije
       *[other] { $numberOfReviews } recenzija
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> je uklonjen.
pending-uninstall-undo-button = Vrati
addon-detail-updates-label = Dozvoli automatska aktualiziranja
addon-detail-updates-radio-default = Standardno
addon-detail-updates-radio-on = Uključeno
addon-detail-updates-radio-off = Isključeno
addon-detail-update-check-label = Provjeri dostupnost dopuna
install-update-button = Aktualiziraj
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Dopušteno u privatnim prozorima
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Kad je dopušteno, dodatak će imati pristup tvojim aktivnostima dok si u privatnom pretraživanju. <a data-l10n-name="learn-more">Saznaj više</a>
addon-detail-private-browsing-allow = Dozvoli
addon-detail-private-browsing-disallow = Nemoj dozvoliti
# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } preporuča samo proširenja, koja udovoljavaju našim standardima za sigurnost i performanse
    .aria-label = { addon-badge-recommended2.title }
available-updates-heading = Dostupne dopune
recent-updates-heading = Nedavne dopune
release-notes-loading = Učitavanje…
release-notes-error = Došlo je do greške pri učitavanju napomena o izdanju.
addon-permissions-empty = Ovaj dodatak ne zahtjeva nikakve dozvole.
recommended-extensions-heading = Preporučeni dodatci
recommended-themes-heading = Preporučeni motivi
# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Osjećate li se kreativno? <a data-l10n-name="link">Izradite vlastiti motiv s Firefox Color.</a>

## Page headings

extension-heading = Upravljaj dodacima
theme-heading = Upravljaj motivima
plugin-heading = Upravljaj priključcima
dictionary-heading = Upravljaj rječnicima
locale-heading = Upravljaj jezicima
updates-heading = Upravljaj nadogradnjama
discover-heading = Prilagodi svoj { -brand-short-name }
shortcuts-heading = Upravljaj prečacima dodataka
default-heading-search-label = Pronađi daljnje dodatke
addons-heading-search-input =
    .placeholder = Pretraži addons.mozilla.org
addon-page-options-button =
    .title = Alati za sve dodatke
