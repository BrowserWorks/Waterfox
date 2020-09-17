# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Bainisteoir na mBreiseán

addons-page-title = Bainisteoir na mBreiseán

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Níl aon bhreiseán den chineál seo suiteáilte agat

list-empty-available-updates =
    .value = Ní bhfuarthas nuashonruithe

list-empty-recent-updates =
    .value = Ní raibh aon bhreiseáin nuashonraithe agat le déanaí

list-empty-find-updates =
    .label = Lorg Nuashonruithe

list-empty-button =
    .label = Tuilleadh eolais faoi bhreiseáin

show-unsigned-extensions-button =
    .label = Níorbh fhéidir roinnt eisínteachtaí a fhíorú

show-all-extensions-button =
    .label = Taispeáin na heisínteachtaí go léir

cmd-show-details =
    .label = Taispeáin Tuilleadh Eolais
    .accesskey = T

cmd-find-updates =
    .label = Aimsigh Nuashonruithe
    .accesskey = A

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Roghanna
           *[other] Sainroghanna
        }
    .accesskey =
        { PLATFORM() ->
            [windows] R
           *[other] S
        }

cmd-enable-theme =
    .label = Úsáid an téama
    .accesskey = t

cmd-disable-theme =
    .label = Ná húsáid an téama a thuilleadh
    .accesskey = N

cmd-install-addon =
    .label = Suiteáil
    .accesskey = S

cmd-contribute =
    .label = Glac Páirt
    .accesskey = c
    .tooltiptext = Glac páirt i bhforbairt an bhreiseáin seo

detail-version =
    .label = Leagan

detail-last-updated =
    .label = Nuashonraithe

detail-contributions-description = Tacaigh le forbairt leanúnach an bhreiseáin seo trí dheontas beag a thabhairt don fhorbróir.

detail-update-type =
    .value = Nuashonruithe Uathoibríocha

detail-update-default =
    .label = Réamhshocrú
    .tooltiptext = Suiteáil nuashonruithe go huathoibríoch más é sin an réamhshocrú

detail-update-automatic =
    .label = Ann
    .tooltiptext = Suiteáil nuashonruithe go huathoibríoch

detail-update-manual =
    .label = As
    .tooltiptext = Ná suiteáil nuashonruithe go huathoibríoch

detail-home =
    .label = Leathanach Baile

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Próifíl an Bhreiseáin

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Lorg Nuashonruithe
    .accesskey = L
    .tooltiptext = Lorg nuashonruithe le haghaidh an bhreiseáin seo

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Roghanna
           *[other] Sainroghanna
        }
    .accesskey =
        { PLATFORM() ->
            [windows] R
           *[other] S
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Athraigh roghanna an bhreiseáin seo
           *[other] Athraigh sainroghanna an bhreiseáin seo
        }

detail-rating =
    .value = Rátáil

addon-restart-now =
    .label = Atosaigh anois

disabled-unsigned-heading =
    .value = Díchumasaíodh roinnt breiseán

disabled-unsigned-description = Níl na breiseáin seo a leanas fíoraithe le húsáid in { -brand-short-name }. Is féidir leat <label data-l10n-name="find-addons">ionadaithe a aimsiú</label> nó iarr ar an bhforbróir iad a chur tríd an bpróiseas fíoraithe.

disabled-unsigned-learn-more = Tuilleadh eolais faoi na rudaí a dhéanaimid chun tú a choinneáil slán sábháilte ar líne.

disabled-unsigned-devinfo = Más forbróir thú, foghlaim conas is féidir breiseán a fhíorú inár <label data-l10n-name="learn-more">lámhleabhar</label>.

plugin-deprecation-description = Rud éigin ar iarraidh? Ní thacaíonn { -brand-short-name } le roinnt forlíontán a thuilleadh. <label data-l10n-name="learn-more">Tuilleadh Eolais.</label>

legacy-warning-show-legacy = Taispeáin seaneisínteachtaí

legacy-extensions =
    .value = Seaneisínteachtaí

legacy-extensions-description = Ní chloíonn na heisínteachtaí seo le caighdeáin { -brand-short-name } a thuilleadh agus dhíchumasaíomar iad. <label data-l10n-name="legacy-learn-more">Foghlaim faoi na hathruithe ar bhreiseáin</label>

addon-category-extension = Eisínteachtaí
addon-category-extension-title =
    .title = Eisínteachtaí
addon-category-plugin = Forlíontáin
addon-category-plugin-title =
    .title = Forlíontáin
addon-category-dictionary = Foclóirí
addon-category-dictionary-title =
    .title = Foclóirí
addon-category-locale = Teangacha
addon-category-locale-title =
    .title = Teangacha
addon-category-available-updates = Nuashonruithe Ar Fáil
addon-category-available-updates-title =
    .title = Nuashonruithe Ar Fáil
addon-category-recent-updates = Nuashonruithe Le Déanaí
addon-category-recent-updates-title =
    .title = Nuashonruithe Le Déanaí

## These are global warnings

extensions-warning-safe-mode = Tá gach Breiseán díchumasaithe sa Mhód Sábháilteachta.
extensions-warning-check-compatibility = Tá seiceáil chomhoiriúnacht na mBreiseán díchumasaithe. D'fhéadfadh Breiseáin neamh-chomhoiriúnacha a bheith agat.
extensions-warning-check-compatibility-button = Cumasaigh
    .title = Cumasaigh seiceáil chomhoiriúnacht na mbreiseán
extensions-warning-update-security = Tá seiceáil shlándáil na mbreiseán díchumasaithe. D'fhéadfadh nuashonruithe dochar a dhéanamh.
extensions-warning-update-security-button = Cumasaigh
    .title = Cumasaigh seiceáil slándála nuashonrú na mbreiseán


## Strings connected to add-on updates

addon-updates-check-for-updates = Lorg Nuashonruithe
    .accesskey = L
addon-updates-view-updates = Féach ar Nuashonruithe Le Déanaí
    .accesskey = F

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Nuashonraigh Breiseáin go hUathoibríoch
    .accesskey = B

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Athshocraigh nuashonrú uathoibríoch na mbreiseán
    .accesskey = r
addon-updates-reset-updates-to-manual = Athshocraigh nuashonrú láimhe na mbreiseán
    .accesskey = r

## Status messages displayed when updating add-ons

addon-updates-updating = Breiseáin á nuashonrú
addon-updates-installed = Nuashonraíodh do chuid breiseán.
addon-updates-none-found = Ní bhfuarthas nuashonruithe
addon-updates-manual-updates-found = Féach ar Nuashonruithe Ar Fáil

## Add-on install/debug strings for page options menu

addon-install-from-file = Suiteáil Breiseán Ó Chomhad…
    .accesskey = S
addon-install-from-file-dialog-title = Roghnaigh breiseán le suiteáil
addon-install-from-file-filter-name = Breiseáin
addon-open-about-debugging = Dífhabhtaigh Breiseáin
    .accesskey = b

## Extension shortcut management


## Recommended add-ons page


## Add-on actions


## Pending uninstall message bar


## Page headings

addon-page-options-button =
    .title = Uirlisí le haghaidh gach breiseán
