# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Lisäosien hallinta
addons-page-title = Lisäosien hallinta
search-header =
    .placeholder = Etsi addons.mozilla.orgista
    .searchbuttonlabel = Etsi
search-header-shortcut =
    .key = f
list-empty-installed =
    .value = Tämäntyyppisiä lisäosia ei ole asennettuna
list-empty-available-updates =
    .value = Päivityksiä ei löytynyt
list-empty-recent-updates =
    .value = Lisäosia ei ole päivitetty viime aikoina.
list-empty-find-updates =
    .label = Hae päivityksiä
list-empty-button =
    .label = Lue lisää lisäosista
help-button = Lisäosien tuki
sidebar-help-button-title =
    .title = Lisäosien tuki
preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name }-asetukset
       *[other] { -brand-short-name }-asetukset
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name }-asetukset
           *[other] { -brand-short-name }-asetukset
        }
show-unsigned-extensions-button =
    .label = Joitain laajennuksia ei voitu varmentaa
show-all-extensions-button =
    .label = Näytä kaikki laajennukset
cmd-show-details =
    .label = Näytä lisätietoja
    .accesskey = N
cmd-find-updates =
    .label = Hae päivityksiä
    .accesskey = H
cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Asetukset
           *[other] Asetukset
        }
    .accesskey =
        { PLATFORM() ->
            [windows] A
           *[other] A
        }
cmd-enable-theme =
    .label = Käytä teemaa
    .accesskey = t
cmd-disable-theme =
    .label = Lopeta teeman käyttö
    .accesskey = l
cmd-install-addon =
    .label = Asenna
    .accesskey = A
cmd-contribute =
    .label = Auta
    .accesskey = A
    .tooltiptext = Auta lisäosan kehitystyössä
detail-version =
    .label = Versio
detail-last-updated =
    .label = Päivitetty viimeksi
detail-contributions-description = Tämän lisäosan kehittäjä toivoo, että tukisit lisäosan kehitystyötä pienellä summalla.
detail-contributions-button = Auta
    .title = Auta lisäosan kehitystyössä
    .accesskey = A
detail-update-type =
    .value = Automaattinen päivitys
detail-update-default =
    .label = Oletus
    .tooltiptext = Asenna päivitykset automaattisesti vain, jos se on oletusasetus
detail-update-automatic =
    .label = Käytössä
    .tooltiptext = Asenna päivitykset automaattisesti
detail-update-manual =
    .label = Pois käytöstä
    .tooltiptext = Älä asenna päivityksiä automaattisesti
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Suoritus yksityisissä ikkunoissa
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Ei sallittu yksityisissä ikkunoissa
detail-private-disallowed-description2 = Tätä laajennusta ei suoriteta yksityisen selauksen aikana. <a data-l10n-name="learn-more">Lue lisää</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Vaatii pääsyn yksityisiin ikkunoihin
detail-private-required-description2 = Tällä laajennuksella on pääsy verkossa tekemiisi toimiin yksityisen selauksen aikana. <a data-l10n-name="learn-more">Lue lisää</a>
detail-private-browsing-on =
    .label = Salli
    .tooltiptext = Ota käyttöön yksityisessä selauksessa
detail-private-browsing-off =
    .label = Älä salli
    .tooltiptext = Poista käytöstä yksityisessä selauksessa
detail-home =
    .label = Kotisivu
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Lisäosan profiili
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Hae päivityksiä
    .accesskey = H
    .tooltiptext = Hae päivityksiä lisäosaan
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Asetukset
           *[other] Asetukset
        }
    .accesskey =
        { PLATFORM() ->
            [windows] A
           *[other] A
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Muokkaa tämän lisäosan asetuksia
           *[other] Muokkaa tämän lisäosan asetuksia
        }
detail-rating =
    .value = Arvostelu:
addon-restart-now =
    .label = Käynnistä uudelleen
disabled-unsigned-heading =
    .value = Jotkin lisäosat on poistettu käytöstä
disabled-unsigned-description = Seuraavia lisäosia ei ole varmennettu käytettäväksi { -brand-short-name }issa. Voit <label data-l10n-name="find-addons">etsiä korvaavia lisäosia</label> tai pyytää kehittäjää varmentamaan ne.
disabled-unsigned-learn-more = Lue lisää tavoista, joilla yritämme auttaa sinua pysymään turvassa verkossa.
disabled-unsigned-devinfo = Kehittäjät, joita kiinnostaa lisäosansa varmentaminen, voivat lukea siitä <label data-l10n-name="learn-more">käsikirjastamme</label>.
plugin-deprecation-description = Puuttuuko jotain? { -brand-short-name } ei enää tue joitain liitännäisiä. <label data-l10n-name="learn-more">Lue lisää.</label>
legacy-warning-show-legacy = Näytä perinteiset laajennukset
legacy-extensions =
    .value = Perinteiset laajennukset
legacy-extensions-description = Nämä laajennukset eivät täytä { -brand-short-name }in nykyisiä vaatimuksia, joten ne on poistettu käytöstä. <label data-l10n-name="legacy-learn-more">Lue lisää muutoksista lisäosiin</label>
private-browsing-description2 =
    { -brand-short-name }-laajennusten toiminta yksityisissä ikkunoissa muuttuu. Uutena { -brand-short-name }iin lisättyjä laajennuksia ei enää suoriteta oletuksena yksityisissä ikkunoissa. Jos et salli suorittamista asetuksista, laajennus ei toimi yksityisen selaamisen aikana eikä siten sinä aikana pääse käsiksi tekemisiisi verkossa. Olemme tehneet tämän muutoksen, jotta yksityinen selaus pysyy yksityisenä.
    <label data-l10n-name="private-browsing-learn-more">Lue lisää kuinka hallita laajennusten asetuksia</label>
addon-category-discover = Suositukset
addon-category-discover-title =
    .title = Suositukset
addon-category-extension = Laajennukset
addon-category-extension-title =
    .title = Laajennukset
addon-category-theme = Teemat
addon-category-theme-title =
    .title = Teemat
addon-category-plugin = Liitännäiset
addon-category-plugin-title =
    .title = Liitännäiset
addon-category-dictionary = Oikoluvut
addon-category-dictionary-title =
    .title = Oikoluvut
addon-category-locale = Kielet
addon-category-locale-title =
    .title = Kielet
addon-category-available-updates = Päivitykset
addon-category-available-updates-title =
    .title = Päivitykset
addon-category-recent-updates = Tuoreet päivitykset
addon-category-recent-updates-title =
    .title = Tuoreet päivitykset

## These are global warnings

extensions-warning-safe-mode = Kaikki lisäosat on poistettu käytöstä vikasietotilassa.
extensions-warning-check-compatibility = Lisäosien yhteensopivuuden tarkistus ei ole käytössä. Osa lisäosista voi olla epäyhteensopivia.
extensions-warning-check-compatibility-button = Ota käyttöön
    .title = Ota lisäosien yhteensopivuuden tarkistus käyttöön
extensions-warning-update-security = Lisäosien päivitysten turvallisuustarkistus ei ole käytössä. Päivitykset voivat saastuttaa koneesi.
extensions-warning-update-security-button = Ota käyttöön
    .title = Ota lisäosien päivitysten turvallisuustarkistus käyttöön

## Strings connected to add-on updates

addon-updates-check-for-updates = Hae päivityksiä
    .accesskey = H
addon-updates-view-updates = Näytä tuoreet päivitykset
    .accesskey = N

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Päivitä lisäosat automaattisesti
    .accesskey = u

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Aseta kaikki lisäosat päivittymään automaattisesti
    .accesskey = P
addon-updates-reset-updates-to-manual = Aseta kaikki lisäosat päivittymään vain käsin
    .accesskey = k

## Status messages displayed when updating add-ons

addon-updates-updating = Päivitetään lisäosia
addon-updates-installed = Lisäosat on päivitetty.
addon-updates-none-found = Päivityksiä ei löytynyt
addon-updates-manual-updates-found = Näytä saatavilla olevat päivitykset

## Add-on install/debug strings for page options menu

addon-install-from-file = Asenna lisäosa tiedostosta…
    .accesskey = A
addon-install-from-file-dialog-title = Valitse asennettava lisäosa
addon-install-from-file-filter-name = Lisäosat
addon-open-about-debugging = Jäljitä lisäosien virheitä
    .accesskey = J

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Hallitse laajennusten pikanäppäimiä
    .accesskey = t
shortcuts-no-addons = Yhtäkään lisäosaa ei ole otettu käyttöön.
shortcuts-no-commands = Seuraavilla laajennuksilla ei ole pikanäppäimiä:
shortcuts-input =
    .placeholder = Kirjoita näppäinyhdistelmä
shortcuts-browserAction2 = Aktivoi työkalupalkin painike
shortcuts-pageAction = Aktivoi sivutoiminto
shortcuts-sidebarAction = Näytä/piilota sivupaneeli
shortcuts-modifier-mac = Paina Ctrl-, Alt- tai ⌘-näppäintä
shortcuts-modifier-other = Paina Ctrl- tai Alt-näppäintä
shortcuts-invalid = Virheellinen yhdistelmä
shortcuts-letter = Kirjoita kirjain
shortcuts-system = { -brand-short-name }-pikanäppäintä ei voi korvata
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Päällekkäinen pikanäppäin
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } on käytössä pikanäppäimenä enemmän kuin yhdessä tapauksessa. Päällekkäiset pikanäppäimet saattavat aiheuttaa odottamatonta käytöstä.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = { $addon } käyttää tätä jo
shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Näytä { $numberToShow } lisää
       *[other] Näytä { $numberToShow } lisää
    }
shortcuts-card-collapse-button = Näytä vähemmän
header-back-button =
    .title = Takaisin

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Laajennukset ja teemat ovat kuin sovelluksia selaimessa. Ne voivat suojata salasanojasi,
    ladata videoita, löytää hyviä tarjouksia, estää ärsyttäviä mainoksia, muuttaa
    selaimen ulkoasua ja paljon muuta. Nämä pienet ohjelmat ovat usein kolmansien
    osapuolten kehittämiä. Tässä on valikoima { -brand-product-name }in
    <a data-l10n-name="learn-more-trigger">suosittelemia</a> laajennuksia
    tietoturvan, suorituskyvyn ja toiminnallisuuden parantamiseksi.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Jotkin näistä suosituksista ovat henkilökohtaisia. Suositukset pohjautuvat
    muihin asentamiisi laajennuksiin, profiiliasetuksiin ja käyttötilastoihin.
discopane-notice-learn-more = Lue lisää
privacy-policy = Tietosuojaseloste
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = Tekijä: <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Käyttäjiä: { $dailyUsers }
install-extension-button = Lisää { -brand-product-name }iin
install-theme-button = Asenna teema
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Hallitse
find-more-addons = Etsi lisää lisäosia
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Lisää valintoja

## Add-on actions

report-addon-button = Raportoi
remove-addon-button = Poista
# The link will always be shown after the other text.
remove-addon-disabled-button = Tätä ei voi poistaa <a data-l10n-name="link">Miksi?</a>
disable-addon-button = Poista käytöstä
enable-addon-button = Käytä
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Ota käyttöön
preferences-addon-button = Asetukset
details-addon-button = Tiedot
release-notes-addon-button = Julkaisutiedot
permissions-addon-button = Oikeudet
extension-enabled-heading = Käytössä
extension-disabled-heading = Ei käytössä
theme-enabled-heading = Käytössä
theme-disabled-heading = Ei käytössä
plugin-enabled-heading = Käytössä
plugin-disabled-heading = Ei käytössä
dictionary-enabled-heading = Käytössä
dictionary-disabled-heading = Ei käytössä
locale-enabled-heading = Käytössä
locale-disabled-heading = Ei käytössä
ask-to-activate-button = Kysy aktivointia
always-activate-button = Aktivoi aina
never-activate-button = Älä koskaan aktivoi
addon-detail-author-label = Tekijä
addon-detail-version-label = Versio
addon-detail-last-updated-label = Päivitetty viimeksi
addon-detail-homepage-label = Kotisivu
addon-detail-rating-label = Arvostelu
# Message for add-ons with a staged pending update.
install-postponed-message = Tämä laajennus päivitetään, kun { -brand-short-name } käynnistyy uudelleen.
install-postponed-button = Päivitä nyt
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Arvostelu { NUMBER($rating, maximumFractionDigits: 1) }/5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (ei käytössä)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } arvio
       *[other] { $numberOfReviews } arviota
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> on poistettu.
pending-uninstall-undo-button = Kumoa
addon-detail-updates-label = Automaattiset päivitykset
addon-detail-updates-radio-default = Oletus
addon-detail-updates-radio-on = Käytössä
addon-detail-updates-radio-off = Ei käytössä
addon-detail-update-check-label = Tarkista päivitykset
install-update-button = Päivitä
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Sallittu yksityisissä ikkunnoissa
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Kun sallittu, laajennus voi seurata, mitä teet verkossa yksityisen selauksen tilassa. <a data-l10n-name="learn-more">Lue lisää</a>
addon-detail-private-browsing-allow = Salli
addon-detail-private-browsing-disallow = Älä salli
# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } suosittelee vain laajennuksia, jotka täyttävät standardimme turvallisuuden ja suorituskyvyn suhteen
    .aria-label = { addon-badge-recommended2.title }
available-updates-heading = Saatavilla olevat päivitykset
recent-updates-heading = Tuoreet päivitykset
release-notes-loading = Ladataan…
release-notes-error = Julkaisutietojen lataaminen epäonnistui.
addon-permissions-empty = Tämä laajennus ei vaadi mitään oikeuksia
recommended-extensions-heading = Suositellut laajennukset
recommended-themes-heading = Suositellut teemat
# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Haluatko kokeilla itse? <a data-l10n-name="link">Voit luoda oman teeman Firefox Color -ohjelmalla.</a>

## Page headings

extension-heading = Laajennusten hallinta
theme-heading = Teemojen hallinta
plugin-heading = Liitännäisten hallinta
dictionary-heading = Sanastojen hallinta
locale-heading = Kielten hallinta
updates-heading = Päivitysten hallinta
discover-heading = Tee { -brand-short-name }ista mieleisesi
shortcuts-heading = Laajennusten pikanäppäinten hallinta
default-heading-search-label = Etsi lisää lisäosia
addons-heading-search-input =
    .placeholder = Etsi addons.mozilla.orgista
addon-page-options-button =
    .title = Työkaluja kaikille lisäosille
