# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Upravnik add-onima

addons-page-title = Upravnik add-onima

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Vi nemate instaliranih add-ona ovog tipa

list-empty-available-updates =
    .value = Nijedna nadogradnja nije pronađena

list-empty-recent-updates =
    .value = Odavno niste nadograđivali add-one

list-empty-find-updates =
    .label = Provjeri za nadogradnje

list-empty-button =
    .label = Naučite više o add-onima

show-unsigned-extensions-button =
    .label = Neke ekstenzije nisu mogle biti verifikovane

show-all-extensions-button =
    .label = Prikaži sve ekstenzije

cmd-show-details =
    .label = Prikaži više informacija
    .accesskey = P

cmd-find-updates =
    .label = Pronađi nadogradnje
    .accesskey = P

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opcije
           *[other] Postavke
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }

cmd-enable-theme =
    .label = Obuci temu
    .accesskey = O

cmd-disable-theme =
    .label = Prestani nositi temu
    .accesskey = P

cmd-install-addon =
    .label = Instaliraj
    .accesskey = I

cmd-contribute =
    .label = Doprinesite
    .accesskey = D
    .tooltiptext = Doprinesite razvoju ovog add-ona

detail-version =
    .label = Verzija

detail-last-updated =
    .label = Zadnja nadogradnja

detail-contributions-description = Developer ovog add-ona vas je zamolio da podržite njegov dalji razvoj davanjem malog doprinosa.

detail-update-type =
    .value = Automatske nadogradnje

detail-update-default =
    .label = Izvorno
    .tooltiptext = Automatski nadograđuj samo ako je to izabrana postavka

detail-update-automatic =
    .label = Uključeno
    .tooltiptext = Automatski nadograđuj

detail-update-manual =
    .label = Isključeno
    .tooltiptext = Nemoj automatski nadograđivati

detail-home =
    .label = Web stranica

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Add-on profil

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Provjeri za nadogradnje
    .accesskey = P
    .tooltiptext = Provjeri za nadogradnje za ovaj add-on

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opcije
           *[other] Postavke
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Promijeni opcije ovog add-ona
           *[other] Promijeni postavke ovog add-ona
        }

detail-rating =
    .value = Ocjena

addon-restart-now =
    .label = Restartuj sada

disabled-unsigned-heading =
    .value = Neki add-oni su onemogućeni

disabled-unsigned-description = Sljedeći add-oni nisu verifikovani za upotrebu u { -brand-short-name }. Možete <label data-l10n-name="find-addons">pronaći zamjene</label> ili tražiti od developera da ih verifikuje.

disabled-unsigned-learn-more = Saznajte više o našim naporima da vas zaštitimo na internetu.

disabled-unsigned-devinfo = Developeri koji su zainteresovani za verifikaciju njihovih add-ona mogu nastaviti s čitanjem našeg <label data-l10n-name="learn-more">vodiča</label>.

plugin-deprecation-description = Fali vam nešto? Neki plugini više nisu podržani od strane { -brand-short-name }a. <label data-l10n-name="learn-more">Saznajte više.</label>

legacy-warning-show-legacy = Prikaže zastarjele ekstenzije

legacy-extensions =
    .value = Zastarjele ekstenzije

legacy-extensions-description = Ove ekstenzije ne zadovoljavaju trenutne { -brand-short-name } standarde i stoga su deaktivirane. <label data-l10n-name="legacy-learn-more">Saznajte više o promjenama na add-onima</label>

addon-category-extension = Ekstenzije
addon-category-extension-title =
    .title = Ekstenzije
addon-category-theme = Teme
addon-category-theme-title =
    .title = Teme
addon-category-plugin = Plugini
addon-category-plugin-title =
    .title = Plugini
addon-category-dictionary = Rječnici
addon-category-dictionary-title =
    .title = Rječnici
addon-category-locale = Jezici
addon-category-locale-title =
    .title = Jezici
addon-category-available-updates = Dostupne nadogradnje
addon-category-available-updates-title =
    .title = Dostupne nadogradnje
addon-category-recent-updates = Nedavne nadogradnje
addon-category-recent-updates-title =
    .title = Nedavne nadogradnje

## These are global warnings

extensions-warning-safe-mode = Svi add-oni su onemogućeni od strane sigurnog režima.
extensions-warning-check-compatibility = Provjera kompatibilnosti add-ona je onemogućena. Možda imate nekompatibilnih add-ona.
extensions-warning-check-compatibility-button = Omogući
    .title = Omogući provjeravanje kompatibilnosti add-ona
extensions-warning-update-security = Sigurnosna provjera nadogradnje za add-one je onemogućena. Možete biti kompromitovani putem nadogradnje.
extensions-warning-update-security-button = Omogući
    .title = Omogući provjeravanje sigurnosti nadogradnje add-ona


## Strings connected to add-on updates

addon-updates-check-for-updates = Provjeri za nadogradnje
    .accesskey = P
addon-updates-view-updates = Prikaži nedavne nadogradnje
    .accesskey = v

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Automatski nadograđuj add-one
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Postavi sve add-one da se automatski nadograđuju
    .accesskey = r
addon-updates-reset-updates-to-manual = Postavi sve add-one da se ručno nadograđuju
    .accesskey = r

## Status messages displayed when updating add-ons

addon-updates-updating = Nadograđujem add-one
addon-updates-installed = Vaši add-oni su nadograđeni.
addon-updates-none-found = Nijedna nadogradnja nije pronađena
addon-updates-manual-updates-found = Prikaži dostupne nadogradnje

## Add-on install/debug strings for page options menu

addon-install-from-file = Instaliraj Add-on iz fajla…
    .accesskey = I
addon-install-from-file-dialog-title = Izaberite add-on za instalaciju
addon-install-from-file-filter-name = Add-oni
addon-open-about-debugging = Debagiranje add-ona
    .accesskey = b

## Extension shortcut management


## Recommended add-ons page


## Add-on actions


## Pending uninstall message bar


## Page headings

addon-page-options-button =
    .title = Alati za sve add-one
