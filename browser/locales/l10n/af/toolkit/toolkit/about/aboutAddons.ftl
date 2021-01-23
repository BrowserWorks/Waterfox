# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Byvoegingbestuurder

addons-page-title = Byvoegingbestuurder

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Daar is geen byvoegings van hierdie tipe geïnstalleer nie

list-empty-available-updates =
    .value = Geen bywerkings gevind nie

list-empty-recent-updates =
    .value = Geen byvoegings is onlangs bygewerk nie

list-empty-find-updates =
    .label = Kontroleer vir bywerkings

list-empty-button =
    .label = Kom meer te wete oor byvoegings

show-unsigned-extensions-button =
    .label = Sommige uitbreidings kon nie geverifieer word nie

show-all-extensions-button =
    .label = Wys alle uitbreidings

cmd-show-details =
    .label = Wys meer inligting
    .accesskey = W

cmd-find-updates =
    .label = Vind bywerkings
    .accesskey = V

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opsies
           *[other] Voorkeure
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] V
        }

cmd-enable-theme =
    .label = Trek tema aan
    .accesskey = T

cmd-disable-theme =
    .label = Trek tema uit
    .accesskey = e

cmd-install-addon =
    .label = Installeer
    .accesskey = I

cmd-contribute =
    .label = Dra by
    .accesskey = D
    .tooltiptext = Dra by tot die ontwikkeling van hierdie byvoeging

detail-version =
    .label = Weergawe

detail-last-updated =
    .label = Laas bygewerk

detail-contributions-description = Die ontwikkelaar van hierdie byvoeging vra dat jy die volgehoue ontwikkeling daarvan steun deur 'n klein bydrae te lewer.

detail-update-type =
    .value = Outobywerkings

detail-update-default =
    .label = Verstek
    .tooltiptext = Installeer bywerkings outomaties net as dit die verstek is

detail-update-automatic =
    .label = Aan
    .tooltiptext = Installeer bywerkings outomaties

detail-update-manual =
    .label = Af
    .tooltiptext = Moenie bywerkings outomaties installeer nie

detail-home =
    .label = Tuisblad

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Byvoeging-profiel

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Kontroleer vir bywerkings
    .accesskey = v
    .tooltiptext = Kontroleer vir bywerking vir hierdie byvoeging

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opsies
           *[other] Voorkeure
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] V
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Verander hierdie byvoeging se opsies
           *[other] Verander hierdie byvoeging se voorkeure
        }

detail-rating =
    .value = Gradering

addon-restart-now =
    .label = Herbegin nou

disabled-unsigned-heading =
    .value = Sommige byvoegings is gedeaktiveer

disabled-unsigned-description = Die volgende byvoegings is nie geverifieer vir gebruik in { -brand-short-name } nie. U kan <label data-l10n-name="find-addons">plaasvervangers soek</label> of die ontwikkelaar vra om hulle te laat verifieer.

disabled-unsigned-learn-more = Meer inligting oor ons pogings om elkeen veilig te hou aanlyn.

disabled-unsigned-devinfo = Ontwikkelaars wat hulle byvoegings wil laat verifieer kan gerus ons <label data-l10n-name="learn-more">handleiding</label> lees.

plugin-deprecation-description = Kort iets? Sommige inproppe word nie meer ondersteun deur { -brand-short-name } nie. <label data-l10n-name="learn-more">Meer inligting.</label>

legacy-warning-show-legacy = Wys verouderde uitbreidings

legacy-extensions =
    .value = Verouderde uitbreidings

legacy-extensions-description = Dié uitbreidings voldoen nie aan { -brand-short-name } se huidige standaarde nie, en is dus gedeaktiveer. <label data-l10n-name="legacy-learn-more">Lees meer oor veranderinge aan byvoegings</label>

addon-category-extension = Uitbreidings
addon-category-extension-title =
    .title = Uitbreidings
addon-category-plugin = Inproppe
addon-category-plugin-title =
    .title = Inproppe
addon-category-dictionary = Woordeboeke
addon-category-dictionary-title =
    .title = Woordeboeke
addon-category-locale = Tale
addon-category-locale-title =
    .title = Tale
addon-category-available-updates = Beskikbare bywerkings
addon-category-available-updates-title =
    .title = Beskikbare bywerkings
addon-category-recent-updates = Onlangse bywerkings
addon-category-recent-updates-title =
    .title = Onlangse bywerkings

## These are global warnings

extensions-warning-safe-mode = Alle byvoegings is deur veilige modus gedeaktiveer.
extensions-warning-check-compatibility = Kontrolering of byvoegings versoenbaar is, is gedeaktiveer. U het moontlik onversoenbare byvoegings.
extensions-warning-check-compatibility-button = Aktiveer
    .title = Aktiveer byvoeging-versoenbaarheidkontrole
extensions-warning-update-security = Kontrolering vir bywerkings vir byvoegings is gedeaktiveer. U kan dalk deur bywerkings gekompromitteer word.
extensions-warning-update-security-button = Aktiveer
    .title = Aktiveer byvoegingsbywerking-beveiliging-kontrole


## Strings connected to add-on updates

addon-updates-check-for-updates = Kontroleer vir bywerkings
    .accesskey = K
addon-updates-view-updates = Bekyk onlangse bywerkings
    .accesskey = B

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Werk byvoegings outomaties by
    .accesskey = W

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Stel alle byvoegings om outomaties by te werk
    .accesskey = S
addon-updates-reset-updates-to-manual = Stel alle byvoegings om handmatig by te werk
    .accesskey = S

## Status messages displayed when updating add-ons

addon-updates-updating = Byvoegings word bygewerk
addon-updates-installed = Die byvoegings is bygewerk.
addon-updates-none-found = Geen bywerkings gevind nie
addon-updates-manual-updates-found = Bekyk beskikbare bywerkings

## Add-on install/debug strings for page options menu

addon-install-from-file = Installeer byvoeging uit lêer…
    .accesskey = I
addon-install-from-file-dialog-title = Kies byvoeging om te installeer
addon-install-from-file-filter-name = Byvoegings
addon-open-about-debugging = Ontfout byvoegings
    .accesskey = b

## Extension shortcut management


## Recommended add-ons page


## Add-on actions


## Pending uninstall message bar


## Page headings

addon-page-options-button =
    .title = Nutsgoed vir alle byvoegings
