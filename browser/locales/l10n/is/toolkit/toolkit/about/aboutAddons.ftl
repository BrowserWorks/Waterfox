# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Viðbótastjóri

addons-page-title = Viðbótastjóri

search-header =
    .placeholder = Leita á addons.mozilla.org
    .searchbuttonlabel = Leita

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Engar viðbætur af þessari tegund hafa verið settar inn

list-empty-available-updates =
    .value = Engar uppfærslur fundust

list-empty-recent-updates =
    .value = Þú hefur ekki uppfært neinar viðbætur nýlega

list-empty-find-updates =
    .label = Athuga með uppfærslur

list-empty-button =
    .label = Fræðast meira um viðbætur

help-button = Viðbótastuðningur

sidebar-help-button-title =
    .title = Viðbótastuðningur

preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } Valmynd
       *[other] { -brand-short-name } Valkostir
    }

sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } Valmynd
           *[other] { -brand-short-name } Valkostir
        }

show-unsigned-extensions-button =
    .label = Ekki tókst að staðfesta sumar viðbætur

show-all-extensions-button =
    .label = Sýna allar viðbætur

cmd-show-details =
    .label = Sýna meiri upplýsingar
    .accesskey = S

cmd-find-updates =
    .label = Leita að uppfærslum
    .accesskey = f

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Valkostir
           *[other] Valkostir
        }
    .accesskey =
        { PLATFORM() ->
            [windows] o
           *[other] o
        }

cmd-enable-theme =
    .label = Nota þema
    .accesskey = þ

cmd-disable-theme =
    .label = Hætta að nota þema
    .accesskey = þ

cmd-install-addon =
    .label = Setja upp
    .accesskey = t

cmd-contribute =
    .label = Gefa
    .accesskey = G
    .tooltiptext = Hjálpa til með þróunina á þessari viðbót

detail-version =
    .label = Útgáfa

detail-last-updated =
    .label = Síðast uppfært

detail-contributions-description = Höfundur þessarar viðbótar biður þig um að styðja við áframhaldandi þróun með því að styrkja viðkomandi með smá upphæð.

detail-update-type =
    .value = Sjálfvirkar uppfærslur

detail-update-default =
    .label = Sjálfgefið
    .tooltiptext = Setja sjálfvirkt inn uppfærslur aðeins ef það er ekki sjálfgefið

detail-update-automatic =
    .label = Virkt
    .tooltiptext = Setja sjálfvirkt inn uppfærslur

detail-update-manual =
    .label = Óvirkt
    .tooltiptext = Ekki setja sjálfvirkt inn uppfærslur

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Keyra í huliðsgluggum

detail-private-browsing-on =
    .label = Heimila
    .tooltiptext = Heimila í huliðsvöfrun

detail-private-browsing-off =
    .label = Ekki heimila
    .tooltiptext = Ekki heimila í huliðsvöfrun

detail-home =
    .label = Heimasíða

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Lýsing viðbótar

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Leita að uppfærslum
    .accesskey = f
    .tooltiptext = Athuga uppfærslur fyrir þessa viðbót

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Valkostir
           *[other] Valkostir
        }
    .accesskey =
        { PLATFORM() ->
            [windows] o
           *[other] o
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Breyta stillingum fyrir þessa viðbót
           *[other] Breyta stillingum viðbótar
        }

detail-rating =
    .value = Einkunn

addon-restart-now =
    .label = Endurræsa núna

disabled-unsigned-heading =
    .value = Búið er að gera sumar viðbætur óvirkar

disabled-unsigned-description = Ekki tókst að sannreyna eftirfarandi viðbætur fyrir notkun í { -brand-short-name }. Þú getur <label data-l10n-name="find-addons">reynt að finna aðrar viðbætur</label> eða beðið forritara um að staðfesta viðbót.

disabled-unsigned-learn-more = Fræðast meira um hvað við gerum til að þú sért öruggur á netinu.

disabled-unsigned-devinfo = Þeir forritarar sem eru áhugasamir um að staðfesta viðbæturnar sínar geta prófað að lesa <label data-l10n-name="learn-more">handbókina</label> okkar.

plugin-deprecation-description = Vantar eitthvað? Sum tengiforrit eru ekki lengur stutt af { -brand-short-name }. <label data-l10n-name="learn-more">Lesa meira.</label>

legacy-warning-show-legacy = Sýna allar gamlar viðbætur

legacy-extensions =
    .value = Gamlar viðbætur

legacy-extensions-description = Þessar viðbætur standast ekki núverandi staðla í { -brand-short-name } þannig að þær hafa verið gerðar óvirkar. <label data-l10n-name="legacy-learn-more">Fræðast um breytingar á viðbótum</label>

addon-category-extension = Viðbætur
addon-category-extension-title =
    .title = Viðbætur
addon-category-theme = Þema
addon-category-theme-title =
    .title = Þema
addon-category-plugin = Tengiforrit
addon-category-plugin-title =
    .title = Tengiforrit
addon-category-dictionary = Orðabækur
addon-category-dictionary-title =
    .title = Orðabækur
addon-category-locale = Tungumál
addon-category-locale-title =
    .title = Tungumál
addon-category-available-updates = Fáanlegar uppfærslur
addon-category-available-updates-title =
    .title = Fáanlegar uppfærslur
addon-category-recent-updates = Nýlegar uppfærslur
addon-category-recent-updates-title =
    .title = Nýlegar uppfærslur

## These are global warnings

extensions-warning-safe-mode = Allar viðbætur hafa verið gerðar óvirkar vegna öryggishams.
extensions-warning-check-compatibility = Samhæfnisathugun viðbóta er óvirk. Hugsanlegt er að þú sért með ósamhæfðar viðbætur.
extensions-warning-check-compatibility-button = Virkja
    .title = Virkja samhæfnisathugun viðbóta
extensions-warning-update-security = Öryggisuppfærslur fyrir viðbætur eru óvirkar. Þú gætir verið í hættu vegna uppfærslu.
extensions-warning-update-security-button = Virkja
    .title = Virkja öryggisuppfærslur fyrir viðbætur


## Strings connected to add-on updates

addon-updates-check-for-updates = Leita að uppfærslum
    .accesskey = L
addon-updates-view-updates = Skoða nýlegar uppfærslur
    .accesskey = S

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Uppfæra viðbætur sjálfvirkt
    .accesskey = a

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Endurstilla allar viðbætur á sjálfvirka uppfærslu
    .accesskey = r
addon-updates-reset-updates-to-manual = Endurstilla allar viðbætur á handvirka uppfærslu
    .accesskey = r

## Status messages displayed when updating add-ons

addon-updates-updating = Uppfæri viðbætur
addon-updates-installed = Búið er að uppfæra viðbætur.
addon-updates-none-found = Engar uppfærslur fundust
addon-updates-manual-updates-found = Skoða fáanlegar uppfærslur

## Add-on install/debug strings for page options menu

addon-install-from-file = Setja inn viðbót frá skrá…
    .accesskey = i
addon-install-from-file-dialog-title = Veldu viðbót til að setja inn
addon-install-from-file-filter-name = Viðbætur
addon-open-about-debugging = Kemba viðbætur
    .accesskey = b

## Extension shortcut management

shortcuts-input =
    .placeholder = Slá inn flýtilykil

shortcuts-pageAction = Virkja síðuaðgerð
shortcuts-sidebarAction = Víxla hliðarslá

shortcuts-modifier-mac = Hafa með Ctrl, Alt eða ⌘
shortcuts-modifier-other = Hafa með Ctrl eða Alt
shortcuts-invalid = Ógild samsetning
shortcuts-letter = Slá inn bókstaf
shortcuts-system = Ekki hægt að breyta { -brand-short-name }-flýtilykli

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Sýna { $numberToShow } í viðbót
       *[other] Sýna { $numberToShow } í viðbót
    }

shortcuts-card-collapse-button = Sýna minna

header-back-button =
    .title = Til baka

## Recommended add-ons page


## Add-on actions

remove-addon-button = Fjarlægja
disable-addon-button = Óvirkja
enable-addon-button = Virkja

## Pending uninstall message bar


## Page headings

extension-heading = Stjórnborð viðbóta
theme-heading = Stjórnborð þema
plugin-heading = Stjórnborð tengiforrita
dictionary-heading = Stjórnborð orðabóka
locale-heading = Stjórnborð tungumála

addons-heading-search-input =
    .placeholder = Leita á addons.mozilla.org

addon-page-options-button =
    .title = Verkfæri fyrir allar viðbætur
