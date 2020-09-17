# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Upravitelj dodatkov
addons-page-title = Upravitelj dodatkov

search-header =
    .placeholder = Iskanje po addons.mozilla.org
    .searchbuttonlabel = Išči

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Nimate nameščenega nobenega dodatka te vrste.

list-empty-available-updates =
    .value = Ni novih posodobitev

list-empty-recent-updates =
    .value = Nedavno niste posodobili nobenih dodatkov

list-empty-find-updates =
    .label = Poišči posodobitve

list-empty-button =
    .label = Več informacij o dodatkih

help-button = Podpora za dodatke
sidebar-help-button-title =
    .title = Podpora za dodatke

preferences =
    { PLATFORM() ->
        [windows] Možnosti { -brand-short-name }a
       *[other] Nastavitve { -brand-short-name }a
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Možnosti { -brand-short-name }a
           *[other] Nastavitve { -brand-short-name }a
        }

show-unsigned-extensions-button =
    .label = Nekaterih razširitev ni bilo mogoče potrditi

show-all-extensions-button =
    .label = Prikaži vse razširitve

cmd-show-details =
    .label = Več informacij
    .accesskey = V

cmd-find-updates =
    .label = Poišči posodobitve
    .accesskey = P

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Možnosti
           *[other] Nastavitve
        }
    .accesskey =
        { PLATFORM() ->
            [windows] M
           *[other] N
        }

cmd-enable-theme =
    .label = Obleci temo
    .accesskey = t

cmd-disable-theme =
    .label = Sleci temo
    .accesskey = t

cmd-install-addon =
    .label = Namesti
    .accesskey = i

cmd-contribute =
    .label = Prispevaj
    .accesskey = P
    .tooltiptext = Sodelujte pri razvoju dodatkov

detail-version =
    .label = Različica

detail-last-updated =
    .label = Nazadnje posodobljeno

detail-contributions-description = Razvijalec tega dodatka vas vabi, da podprete nadaljnji razvoj s skromnim prispevkom.

detail-contributions-button = Prispevajte
    .title = Prispevajte k razvoju tega dodatka
    .accesskey = P

detail-update-type =
    .value = Samodejne posodobitve

detail-update-default =
    .label = Privzeto
    .tooltiptext = Samodejno nameščaj posodobitve le če je to privzeto

detail-update-automatic =
    .label = Vključeno
    .tooltiptext = Samodejno nameščaj posodobitve

detail-update-manual =
    .label = Izključeno
    .tooltiptext = Posodobitev ne nameščaj samodejno

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Delovanje v zasebnih oknih

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Ni dovoljeno v zasebnih oknih
detail-private-disallowed-description2 = Ta razširitev je v zasebnem brskanju izklopljena. <a data-l10n-name="learn-more">Več o tem</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Zahteva dostop do zasebnih oken
detail-private-required-description2 = Ta razširitev ima v zasebnem brskanju dostop do vaše spletne dejavnosti. <a data-l10n-name="learn-more">Več o tem</a>

detail-private-browsing-on =
    .label = Dovoli
    .tooltiptext = Omogoči v zasebnem brskanju

detail-private-browsing-off =
    .label = Ne dovoli
    .tooltiptext = Onemogoči v zasebnem brskanju

detail-home =
    .label = Domača stran

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Profil dodatka

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Poišči posodobitve
    .accesskey = P
    .tooltiptext = Poišči posodobitve za ta dodatek

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Možnosti
           *[other] Nastavitve
        }
    .accesskey =
        { PLATFORM() ->
            [windows] M
           *[other] N
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Spremeni možnosti tega dodatka
           *[other] Spremeni nastavitve tega dodatka
        }

detail-rating =
    .value = Ocena

addon-restart-now =
    .label = Ponovno zaženi

disabled-unsigned-heading =
    .value = Nekateri dodatki so bili onemogočeni

disabled-unsigned-description = Naslednji dodatki niso bili potrjeni za uporabo v { -brand-short-name }u. Lahko <label data-l10n-name="find-addons">jih nadomestite</label> ali zaprosite razvijalca, da jih potrdi.

disabled-unsigned-learn-more = Več o naših prizadevanjih za večjo varnost na spletu.

disabled-unsigned-devinfo = Razvijalcem, ki želijo potrditi svoje dodatke, priporočamo branje našega <label data-l10n-name="learn-more">priročnika</label>.

plugin-deprecation-description = Pogrešate kaj? Nekateri vtičniki niso več podprti v { -brand-short-name }u. <label data-l10n-name="learn-more">Več o tem.</label>

legacy-warning-show-legacy = Prikaži zastarele razširitve

legacy-extensions =
    .value = Zastarele razširitve

legacy-extensions-description = Te razširitve ne ustrezajo trenutnim standardom { -brand-short-name }a, zato so bile onemogočene. <label data-l10n-name="legacy-learn-more">Več o spremembah dodatkov</label>

private-browsing-description2 =
    { -brand-short-name } spreminja delovanje razširitev v zasebnem brskanju. Nove razširitve, dodane v { -brand-short-name } privzeto ne bodo delovale v zasebnih oknih. Razširitve ne bodo delovale v zasebnem brskanju in ne bodo imele dostopa do vaše spletne dejavnosti, razen če to dovolite v nastavitvah.
    <label data-l10n-name="private-browsing-learn-more">Več o upravljanju nastavitev razširitev</label>

addon-category-discover = Priporočila
addon-category-discover-title =
    .title = Priporočila
addon-category-extension = Razširitve
addon-category-extension-title =
    .title = Razširitve
addon-category-theme = Teme
addon-category-theme-title =
    .title = Teme
addon-category-plugin = Vtičniki
addon-category-plugin-title =
    .title = Vtičniki
addon-category-dictionary = Slovarji
addon-category-dictionary-title =
    .title = Slovarji
addon-category-locale = Jeziki
addon-category-locale-title =
    .title = Jeziki
addon-category-available-updates = Nove posodobitve
addon-category-available-updates-title =
    .title = Nove posodobitve
addon-category-recent-updates = Nedavne posodobitve
addon-category-recent-updates-title =
    .title = Nedavne posodobitve

## These are global warnings

extensions-warning-safe-mode = Zaradi dela v varnem načinu so vsi dodatki onemogočeni.
extensions-warning-check-compatibility = Preverjanje združljivosti dodatkov je onemogočeno. Mogoče imate nameščene dodatke, ki niso združljivi.
extensions-warning-check-compatibility-button = Omogoči
    .title = Omogoči preverjanje združljivosti dodatkov
extensions-warning-update-security = Preverjanje, ali je posodobitev dodatkov varna, je onemogočeno. Posodobitve lahko ogrozijo vaš sistem.
extensions-warning-update-security-button = Omogoči
    .title = Omogoči preverjanje, ali je posodobitev dodatka varna


## Strings connected to add-on updates

addon-updates-check-for-updates = Poišči posodobitve
    .accesskey = P
addon-updates-view-updates = Pokaži nedavne posodobitve
    .accesskey = n

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Samodejno posodobi dodatke
    .accesskey = d

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Ponastavi vse dodatke na samodejno posodabljanje
    .accesskey = S
addon-updates-reset-updates-to-manual = Ponastavi vse dodatke na ročno posodabljanje
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = Posodabljanje dodatkov
addon-updates-installed = Vaši dodatki so posodobljeni.
addon-updates-none-found = Ni novih posodobitev
addon-updates-manual-updates-found = Preglej vse posodobitve

## Add-on install/debug strings for page options menu

addon-install-from-file = Namesti dodatek iz datoteke …
    .accesskey = I
addon-install-from-file-dialog-title = Izberite dodatek za namestitev
addon-install-from-file-filter-name = Dodatki
addon-open-about-debugging = Dodatki za razhroščevanje
    .accesskey = D

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Upravljanje bližnjic razširitev
    .accesskey = b

shortcuts-no-addons = Nimate omogočenih razširitev.
shortcuts-no-commands = Naslednje razširitve nimajo dodeljenih bližnjic:
shortcuts-input =
    .placeholder = Vnesite bližnjico

shortcuts-browserAction2 = Aktiviraj gumb orodne vrstice
shortcuts-pageAction = Aktiviraj dejanje strani
shortcuts-sidebarAction = Preklopi stransko vrstico

shortcuts-modifier-mac = Vključi Ctrl, Alt ali ⌘
shortcuts-modifier-other = Vključi Ctrl ali Alt
shortcuts-invalid = Neveljavna kombinacija
shortcuts-letter = Vnesite črko
shortcuts-system = Bližnjice { -brand-short-name }a ni mogoče preglasiti

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Podvojena bližnjica

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } se uporablja kot bližnjica v več primerih. Podvojene bližnjice lahko povzročijo nepričakovano vedenje.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Že uporablja { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Prikaži še { $numberToShow }
        [two] Prikaži še { $numberToShow }
        [few] Prikaži še { $numberToShow }
       *[other] Prikaži še { $numberToShow }
    }

shortcuts-card-collapse-button = Prikaži manj

header-back-button =
    .title = Nazaj

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Razširitve in teme so kot aplikacije za vaš brskalnik in vam omogočajo
    varovanje gesel, prenašanje videoposnetkov, iskanje ponudb, zavračanje
    nadležnih oglasov, spreminjanje izgleda brskalnika in še veliko več. Te majhne
    programčke pogosto razvijajo tretje osebe. Tukaj je izbira, ki jo { -brand-product-name }
    <a data-l10n-name="learn-more-trigger">priporoča</a> zaradi izjemne varnosti,
    zmogljivosti in funkcionalnosti.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Nekatera od teh priporočil so prilagojena za vas. Temeljijo na vaših
    ostalih razširitvah, nastavitvah profila in statistiki uporabe.
discopane-notice-learn-more = Več o tem

privacy-policy = Politika zasebnosti

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = (<a data-l10n-name="author">{ $author }</a>)
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Uporabnikov: { $dailyUsers }
install-extension-button = Dodaj v { -brand-product-name }
install-theme-button = Namesti temo
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Upravljaj
find-more-addons = Poišči več dodatkov

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Več možnosti

## Add-on actions

report-addon-button = Prijavi
remove-addon-button = Odstrani
# The link will always be shown after the other text.
remove-addon-disabled-button = Ni mogoče odstraniti <a data-l10n-name="link">Zakaj?</a>
disable-addon-button = Onemogoči
enable-addon-button = Omogoči
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Omogoči
preferences-addon-button =
    { PLATFORM() ->
        [windows] Možnosti
       *[other] Nastavitve
    }
details-addon-button = Podrobnosti
release-notes-addon-button = Opombe ob izdaji
permissions-addon-button = Dovoljenja

extension-enabled-heading = Omogočeno
extension-disabled-heading = Onemogočeno

theme-enabled-heading = Omogočeno
theme-disabled-heading = Onemogočeno

plugin-enabled-heading = Omogočeno
plugin-disabled-heading = Onemogočeno

dictionary-enabled-heading = Omogočeno
dictionary-disabled-heading = Onemogočeno

locale-enabled-heading = Omogočeno
locale-disabled-heading = Onemogočeno

ask-to-activate-button = Vprašaj pred uporabo
always-activate-button = Vedno omogoči
never-activate-button = Nikoli ne omogoči

addon-detail-author-label = Avtor
addon-detail-version-label = Različica
addon-detail-last-updated-label = Zadnja posodobitev
addon-detail-homepage-label = Domača stran
addon-detail-rating-label = Ocena

# Message for add-ons with a staged pending update.
install-postponed-message = Razširitev se bo posodobila ob ponovnem zagonu { -brand-short-name }a.
install-postponed-button = Posodobi zdaj

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Ocena { NUMBER($rating, maximumFractionDigits: 1) } od 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (onemogočeno)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } ocena
        [two] { $numberOfReviews } oceni
        [few] { $numberOfReviews } ocene
       *[other] { $numberOfReviews } ocen
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = Dodatek <span data-l10n-name="addon-name">{ $addon }</span> je bil odstranjen.
pending-uninstall-undo-button = Razveljavi

addon-detail-updates-label = Dovoli samodejne posodobitve
addon-detail-updates-radio-default = Privzeto
addon-detail-updates-radio-on = Vključeno
addon-detail-updates-radio-off = Izključeno
addon-detail-update-check-label = Poišči posodobitve
install-update-button = Posodobi

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Dovoljeno v zasebnih oknih
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Če je dovoljeno, bo imela razširitev dostop do vaše spletne dejavnosti v zasebnem brskanju. <a data-l10n-name="learn-more">Več o tem</a>
addon-detail-private-browsing-allow = Dovoli
addon-detail-private-browsing-disallow = Ne dovoli

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } priporoča samo razširitve, ki ustrezajo našim standardom glede varnosti in učinkovitosti delovanja.
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Razpoložljive posodobitve
recent-updates-heading = Nedavne posodobitve

release-notes-loading = Nalaganje …
release-notes-error = Pri nalaganju opomb k izdaji je prišlo do napake.

addon-permissions-empty = Ta razširitev ne zahteva nobenih dovoljenj

recommended-extensions-heading = Priporočene razširitve
recommended-themes-heading = Priporočene teme

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Ste ustvarjalno razpoloženi? <a data-l10n-name="link">Ustvarite lastno temo s Firefox Colorjem.</a>

## Page headings

extension-heading = Upravljanje razširitev
theme-heading = Upravljanje tem
plugin-heading = Upravljanje vtičnikov
dictionary-heading = Upravljanje slovarjev
locale-heading = Upravljanje jezikov
updates-heading = Upravljanje posodobitev
discover-heading = Prilagodite svoj { -brand-short-name }
shortcuts-heading = Upravljanje bližnjic razširitev

default-heading-search-label = Poišči več dodatkov
addons-heading-search-input =
    .placeholder = Iskanje po addons.mozilla.org

addon-page-options-button =
    .title = Orodja za vse dodatke
