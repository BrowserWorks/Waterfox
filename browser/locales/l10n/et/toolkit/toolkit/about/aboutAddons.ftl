# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Lisade haldur

addons-page-title = Lisade haldur

search-header =
    .placeholder = Otsi saidilt addons.mozilla.org
    .searchbuttonlabel = Otsi

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Ühtegi seda tüüpi lisa pole paigaldatud

list-empty-available-updates =
    .value = Uuendusi ei leitud

list-empty-recent-updates =
    .value = Hiljuti pole uuendatud ühtki lisa

list-empty-find-updates =
    .label = Kontrolli uuendusi

list-empty-button =
    .label = Rohkem teavet lisade kohta

help-button = Lisade kasutajatugi

sidebar-help-button-title =
    .title = Lisade kasutajatugi

preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name }i sätted
       *[other] { -brand-short-name }i eelistused
    }

sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name }i sätted
           *[other] { -brand-short-name }i eelistused
        }

show-unsigned-extensions-button =
    .label = Mõnda laiendust polnud võimalik verifitseerida

show-all-extensions-button =
    .label = Kuva kõiki laiendusi

cmd-show-details =
    .label = Kuva rohkem teavet
    .accesskey = K

cmd-find-updates =
    .label = Leia uuendusi
    .accesskey = L

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Sätted
           *[other] Eelistused
        }
    .accesskey =
        { PLATFORM() ->
            [windows] t
           *[other] E
        }

cmd-enable-theme =
    .label = Kasuta teemat
    .accesskey = K

cmd-disable-theme =
    .label = Lõpeta teema kasutamine
    .accesskey = p

cmd-install-addon =
    .label = Paigalda
    .accesskey = P

cmd-contribute =
    .label = Aita kaasa
    .accesskey = i
    .tooltiptext = Panusta selle lisa arendusse

detail-version =
    .label = Versioon

detail-last-updated =
    .label = Viimati uuendatud

detail-contributions-description = Selle lisa arendaja palub sult väikse annetuse kujul abi arenduse jätkamiseks.

detail-contributions-button = Aita kaasa
    .title = Aita selle lisa arendamisele kaasa
    .accesskey = A

detail-update-type =
    .value = Automaatne uuendamine

detail-update-default =
    .label = Vaikimisi
    .tooltiptext = Uuendused paigaldatakse ainult siis, kui see on määratud vaikeväärtuses

detail-update-automatic =
    .label = Sees
    .tooltiptext = Paigalda uuendused automaatselt

detail-update-manual =
    .label = Väljas
    .tooltiptext = Ära paigalda uuendusi automaatselt

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Privaatsetes akendes käivitamine

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Privaatsetes akendes keelatud

detail-private-disallowed-description2 = See laiendus on privaatse veebilehitsemise ajal keelatud. <a data-l10n-name="learn-more">Rohkem teavet</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Nõuab ligipääsu privaatsetele akendele

detail-private-required-description2 = Sel laiendusel on privaatse lehitsemise režiimis ligipääs sinu tegevusele. <a data-l10n-name="learn-more">Rohkem teavet</a>

detail-private-browsing-on =
    .label = Lubatud
    .tooltiptext = Luba privaatsetes akendes

detail-private-browsing-off =
    .label = Keelatud
    .tooltiptext = Keela privaatsetes akendes

detail-home =
    .label = Koduleht

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Lisa profiil

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Kontrolli uuenduste olemasolu
    .accesskey = K
    .tooltiptext = Kontrolli, kas lisale on uuendusi

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Sätted
           *[other] Eelistused
        }
    .accesskey =
        { PLATFORM() ->
            [windows] S
           *[other] E
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Muuda selle lisa sätteid
           *[other] Muuda selle lisa eelistusi
        }

detail-rating =
    .value = Hinnang

addon-restart-now =
    .label = Taaskäivita kohe

disabled-unsigned-heading =
    .value = Mõned lisad keelati

disabled-unsigned-description = Järgnevad lisad pole { -brand-short-name }is kasutamiseks verifitseeritud. Sa võid <label data-l10n-name="find-addons">otsida asendusi</label> või paluda arendajatel lasta need ära verifitseerida.

disabled-unsigned-learn-more = Rohkem teavet meie püüdluste kohta muuta sinu võrgusolek ohutumaks.

disabled-unsigned-devinfo = Arendajad, kes on huvitatud oma lisade verifitseerimisest, võivad jätkata juhise lugemist <label data-l10n-name="learn-more">siit</label>.

plugin-deprecation-description = Tunned millestki puudust? { -brand-short-name } ei toeta enam mõnda pluginat. <label data-l10n-name="learn-more">Rohkem teavet.</label>

legacy-warning-show-legacy = Kuva aegunud laiendusi

legacy-extensions =
    .value = Aegunud laiendused

legacy-extensions-description = Need laiendused ei vasta tänapäevastele { -brand-short-name }i standarditele ja need keelati. <label data-l10n-name="legacy-learn-more">Vaata rohkem teavet lisadega toimunud muudatuste kohta</label>

private-browsing-description2 = { -brand-short-name } on muutmas seda, kuidas laiendused töötavad privaatse veebilehitsemise režiimis. Uued { -brand-short-name }ile paigaldatud laiendused privaatsetes akendes vaikimisi enam ei tööta. Kui sa sätetes ei luba laienduse töötamist privaatsetes akendes, siis ei ole sel ligipääsu sinu tegevusele neis akendes. Me tegime selle muudatuse, et hoida sinu privaatne veebilehitsemine täielikult privaatsena. <label data-l10n-name="private-browsing-learn-more">Rohkem teavet laienduste sätete haldamise kohta</label>

addon-category-discover = Soovitused
addon-category-discover-title =
    .title = Soovitused
addon-category-extension = Laiendused
addon-category-extension-title =
    .title = Laiendused
addon-category-theme = Teemad
addon-category-theme-title =
    .title = Teemad
addon-category-plugin = Pluginad
addon-category-plugin-title =
    .title = Pluginad
addon-category-dictionary = Sõnaraamatud
addon-category-dictionary-title =
    .title = Sõnaraamatud
addon-category-locale = Keeled
addon-category-locale-title =
    .title = Keeled
addon-category-available-updates = Saadaolevad uuendused
addon-category-available-updates-title =
    .title = Saadaolevad uuendused
addon-category-recent-updates = Hiljutised uuendused
addon-category-recent-updates-title =
    .title = Hiljutised uuendused

## These are global warnings

extensions-warning-safe-mode = Kõik lisad on ohutu režiimi poolt keelatud.
extensions-warning-check-compatibility = Lisade ühilduvuse kontrollimine on keelatud. Kasutusel võib olla mitteühilduvaid lisasid.
extensions-warning-check-compatibility-button = Luba
    .title = Luba lisade ühilduvuse kontrollimine
extensions-warning-update-security = Lisade uuendamise turvalisuse kontrollimine on keelatud. Sinu turvalisus võib uuenduste tõttu ohus olla.
extensions-warning-update-security-button = Luba
    .title = Luba lisade uuendamise turvalisuse kontrollimine


## Strings connected to add-on updates

addon-updates-check-for-updates = Kontrolli uuendusi
    .accesskey = o
addon-updates-view-updates = Vaata hiljutisi uuendusi
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Lisasid uuendatakse automaatselt
    .accesskey = L

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Määra kõik lisad uuendama automaatselt
    .accesskey = M
addon-updates-reset-updates-to-manual = Määra kõik lisad käsitsi uuendamisele
    .accesskey = M

## Status messages displayed when updating add-ons

addon-updates-updating = Lisade uuendamine
addon-updates-installed = Lisad on uuendatud.
addon-updates-none-found = Uuendusi ei leitud
addon-updates-manual-updates-found = Vaata saadaolevaid uuendusi

## Add-on install/debug strings for page options menu

addon-install-from-file = Paigalda lisa failist…
    .accesskey = P
addon-install-from-file-dialog-title = Paigaldatava lisa valimine
addon-install-from-file-filter-name = Lisad
addon-open-about-debugging = Debugi lisasid
    .accesskey = D

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Halda laienduste kiirklahve
    .accesskey = H

shortcuts-no-addons = Ühtki laiendust pole lubatud.
shortcuts-no-commands = Järgmistel laiendustel puuduvad kiirklahvid:
shortcuts-input =
    .placeholder = Sisesta kiirklahvide kombinatsioon

shortcuts-pageAction = Aktiveeri lehe toiming
shortcuts-sidebarAction = Kuva/peida külgriba

shortcuts-modifier-mac = Kaasa Ctrl, Alt või ⌘
shortcuts-modifier-other = Kaasa Ctrl või Alt
shortcuts-invalid = Sobimatu kombinatsioon
shortcuts-letter = Sisesta täht
shortcuts-system = Pole võimalik üle kirjutada { -brand-short-name }i kiirklahvide kombinatsiooni

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Selline kiirklahvide kombinatsioon on juba olemas

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = Kombinatsiooni { $shortcut } kasutatakse rohkem kui ühes kohas. Mitmes kohas määratud sama kiirklahvide kombinatsioon võib põhjustada ootamatut käitumist.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Lisa { $addon } juba kasutab seda

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Näita veel ühte
       *[other] Näita veel { $numberToShow }
    }

shortcuts-card-collapse-button = Näita vähem

header-back-button =
    .title = Mine tagasi

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro = Laiendused ja teemad on nagu äpid sinu brauseri jaoks. Need aitavad sul kaitsta paroole, laadida alla videoid, otsida häid tehinguid, blokkida tüütuid reklaame, muuta brauseri välimust ja veel palju muud. Need väikesed programmid on tihti arendatud kolmandate osapoolte poolt. Siin on valik { -brand-product-name }i poolt <a data-l10n-name="learn-more-trigger">soovitatud</a> lisasid, mis paistavad silma oma erakordse turvalisuse, võimekuse või funktsionaalsuse poolest.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Mõned neist soovitustest on isikupärastatud. Need baseeruvad sinu teistel paigaldatud lisadel,
    profiili sätetel ja kasutamise statistikal.
discopane-notice-learn-more = Rohkem teavet

privacy-policy = Privaatsusreeglid

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = arendajalt <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Kasutajaid: { $dailyUsers }
install-extension-button = Paigalda { -brand-product-name }ile
install-theme-button = Paigalda teema
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Halda
find-more-addons = Avasta veel lisasid

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Rohkem sätteid

## Add-on actions

report-addon-button = Raporteeri
remove-addon-button = Eemalda
disable-addon-button = Keela
enable-addon-button = Luba
preferences-addon-button =
    { PLATFORM() ->
        [windows] Sätted
       *[other] Eelistused
    }
details-addon-button = Üksikasjad
release-notes-addon-button = Väljalaskemärkmed
permissions-addon-button = Õigused

extension-enabled-heading = Lubatud
extension-disabled-heading = Keelatud

theme-enabled-heading = Lubatud
theme-disabled-heading = Keelatud

plugin-enabled-heading = Lubatud
plugin-disabled-heading = Keelatud

dictionary-enabled-heading = Lubatud
dictionary-disabled-heading = Keelatud

locale-enabled-heading = Lubatud
locale-disabled-heading = Keelatud

ask-to-activate-button = Aktiveerimiseks küsitakse luba
always-activate-button = Alati aktiivne
never-activate-button = Mitte kunagi aktiivne

addon-detail-author-label = Autor
addon-detail-version-label = Versioon
addon-detail-last-updated-label = Viimati uuendatud
addon-detail-homepage-label = Koduleht
addon-detail-rating-label = Hinnang

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Hinnatud hindele { NUMBER($rating, maximumFractionDigits: 1) } 5-st

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (keelatud)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] 1 kommentaar
       *[other] { $numberOfReviews } kommentaari
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = Lisa <span data-l10n-name="addon-name">{ $addon }</span> eemaldati.
pending-uninstall-undo-button = Võta tagasi

addon-detail-updates-label = Automaatsed uuendused
addon-detail-updates-radio-default = vaikimisi
addon-detail-updates-radio-on = sees
addon-detail-updates-radio-off = väljas
addon-detail-update-check-label = Kontrolli uuendusi
install-update-button = Uuenda

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Töötamine privaatsetes akendes on lubatud
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Lubamise korral saab laiendus ligipääsu sinu tegevusele privaatsetes akendes. <a data-l10n-name="learn-more">Rohkem teavet</a>
addon-detail-private-browsing-allow = lubatud
addon-detail-private-browsing-disallow = keelatud

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } soovitab ainult meie turvalisuse ja jõudluse standarditele vastavaid laiendusi
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Saadaolevad uuendused
recent-updates-heading = Hiljutised uuendused

release-notes-loading = Laadimine…
release-notes-error = Vabandust, väljalasketeate laadimisel esines viga.

addon-permissions-empty = See laiendus ei nõua eriõigusi

recommended-extensions-heading = Soovitatavad laiendused
recommended-themes-heading = Soovitatavad teemad

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Tunned end loomingulisena? <a data-l10n-name="link">Loo endale oma teema Firefox Coloriga.</a>

## Page headings

extension-heading = Laienduste haldamine
theme-heading = Teemade haldamine
plugin-heading = Pluginate haldamine
dictionary-heading = Sõnastike haldamine
locale-heading = Keelte haldamine
discover-heading = Isikupärasta oma { -brand-short-name }
shortcuts-heading = Halda laienduste kiirklahve

addons-heading-search-input =
    .placeholder = Otsi saidilt addons.mozilla.org

addon-page-options-button =
    .title = Tööriistad kõigile lisadele
