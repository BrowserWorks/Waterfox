# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = UMphathi wezongezelelo

addons-page-title = UMphathi wezongezelelo

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Akunazo izongezelelo zolu didi ezifakelweyo

list-empty-available-updates =
    .value = Akukho zihlaziyi zifumanekayo

list-empty-recent-updates =
    .value = Akuhlaziyanga naziphi na izongezelelo kutshanje

list-empty-find-updates =
    .label = Khangela iZihlaziyi

list-empty-button =
    .label = Funda ngokungaphezulu ngezongezelelo

show-unsigned-extensions-button =
    .label = Ezinye izongezelelo azinaku ukuqinisekiswa

show-all-extensions-button =
    .label = Bonisa zonke izandiso

cmd-show-details =
    .label = Bonisa inkcazelo engaphezulu
    .accesskey = B

cmd-find-updates =
    .label = Fumana iZihlaziyi
    .accesskey = F

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Ekunokukhethwa kuko
           *[other] Izikhethwa
        }
    .accesskey =
        { PLATFORM() ->
            [windows] E
           *[other] I
        }

cmd-enable-theme =
    .label = Umxholo wokuguga
    .accesskey = w

cmd-disable-theme =
    .label = Nqumamisa umxholo wokuguga
    .accesskey = w

cmd-install-addon =
    .label = Fakela
    .accesskey = F

cmd-contribute =
    .label = Yenza igalelo
    .accesskey = Y
    .tooltiptext = Yenza igalelo kuphuhliso lwesi songezelelo

detail-version =
    .label = Uguqulelo

detail-last-updated =
    .label = Uhlaziyo lokuGqibela

detail-contributions-description = Umphuhlisi wesi songezelelo ucela ukuba uxhase uphuhliso lwaso oluqhubayo ngokwenza igalelo elincinane.

detail-update-type =
    .value = IZihlaziyi ezizenzekelayo

detail-update-default =
    .label = Isiseko
    .tooltiptext = Fakela uhlaziyo ngokuzenzekela kuphela ukuba oko kusisiseko

detail-update-automatic =
    .label = Ivulile
    .tooltiptext = Fakela uhlaziyo ngokuzenzekela

detail-update-manual =
    .label = Icimile
    .tooltiptext = Ungalufakeli uhlaziyo ngokuzenzekelayo

detail-home =
    .label = Ikhasi lasekhaya

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Iprofayile yesongezelelo

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Khangela iZihlaziyi
    .accesskey = i
    .tooltiptext = Khangela uhlaziyo lwesi songezelelo

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Ekunokukhethwa kuko
           *[other] Izikhethwa
        }
    .accesskey =
        { PLATFORM() ->
            [windows] E
           *[other] I
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Tshintsha okunokukhethwa kuko kwesongezelelo
           *[other] Tshintsha iipriferensi zesongezelelo
        }

detail-rating =
    .value = Ukulinganisa umyinge

addon-restart-now =
    .label = Qalisa kwakhona ngoku

disabled-unsigned-heading =
    .value = Ezinye izongezelelo zenziwe azasebenza

disabled-unsigned-description = Izongezelelo ezilandelayo ziqinisekisiwe ukusetyenziswa kwe-{ -brand-short-name }. Unganako<label data-l10n-name="find-addons">fumana izinto zokutshintsha </label>  okanye cela umenzi ukufumana ukuba baqinisekiswe.

disabled-unsigned-learn-more = Funda okuninzi malunga neenzane zethu ukukunceda uhlale ukhuselekile kuqhagamshelwano lwe-intanethi.

disabled-unsigned-devinfo = Abenzi abanomdla ekufumaneni izongezelelo zabo ukuba ziqinisekiswe kungaqhubeka ngokufunda zethu<label data-l10n-name="learn-more">Ukwenza ngaphandle komatshini</label>.

plugin-deprecation-description = Ngaba kukho into engekhoyo? Ezinye iiplagini azisaxhaswa yi-{ -brand-short-name } <label data-l10n-name="learn-more">Funda Okungakumbi</label>

legacy-warning-show-legacy = Bonisa izongezelelo ezizizikhokelo

legacy-extensions =
    .value = IZongezelelo zeziKhokelo

legacy-extensions-description = Ezi zongezelelo azidibani nemilinganiselo ye{ -brand-short-name } ekhoyo ngoko iye yayekiswa. <label data-l10n-name="legacy-learn-more">Funda ngotshintsho kwizongezelelo</label>

addon-category-extension = Izandiso
addon-category-extension-title =
    .title = Izandiso
addon-category-plugin = Izifakelo
addon-category-plugin-title =
    .title = Izifakelo
addon-category-dictionary = Izichazi-magama
addon-category-dictionary-title =
    .title = Izichazi-magama
addon-category-locale = Iilwimi
addon-category-locale-title =
    .title = Iilwimi
addon-category-available-updates = Uhlaziyo olufumanekayo
addon-category-available-updates-title =
    .title = Uhlaziyo olufumanekayo
addon-category-recent-updates = Uhlaziyo lwakutshanje
addon-category-recent-updates-title =
    .title = Uhlaziyo lwakutshanje

## These are global warnings

extensions-warning-safe-mode = Zonke izongezelelo ziqhwalelisiwe ngemo ekhuselekileyo.
extensions-warning-check-compatibility = Isongezelelo sokukhangela uhambelwanosiqhwalelisiwe. Usenokuba nezongezelelo ezingahambelaniyo.
extensions-warning-check-compatibility-button = Vumela
    .title = Vumela isongezelelo sokukhangela uhambelwano
extensions-warning-update-security = Uhlaziyo lwesongezelelo sokukhangela ukhuseleko luqhwalelisiwe. Ungahlangatyezwa luhlaziyo.
extensions-warning-update-security-button = Vumela
    .title = Vumela uhlaziyo lwesongezelelo sokukhangela ukhuseleko


## Strings connected to add-on updates

addon-updates-check-for-updates = Khangela iZihlaziyi
    .accesskey = K
addon-updates-view-updates = Jonga uhlaziyo lwakutshanje
    .accesskey = J

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Uhlaziyo nezongezelelo ngokuzenzekelayo
    .accesskey = n

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Seta kwakhona zonke izongezelelo zihlaziye ngokuzenzekelayo
    .accesskey = S
addon-updates-reset-updates-to-manual = Seta kwakhona zonke izongezelelo zihlaziywe ngesandla
    .accesskey = S

## Status messages displayed when updating add-ons

addon-updates-updating = Ihlaziya izongezelelo
addon-updates-installed = Izongezelelo zakho zihlaziyiwe.
addon-updates-none-found = Akukho zihlaziyi zifumanekayo
addon-updates-manual-updates-found = Jonga uhlaziyo olufumanekayo

## Add-on install/debug strings for page options menu

addon-install-from-file = Fakela izongezelelo ezisuka kule fayile…
    .accesskey = F
addon-install-from-file-dialog-title = Khetha isongezelelo ukufakela
addon-install-from-file-filter-name = Izongezelelo
addon-open-about-debugging = Khuphaibhagi Kwizongezelelo
    .accesskey = i

## Extension shortcut management


## Recommended add-ons page


## Add-on actions


## Pending uninstall message bar


## Page headings

addon-page-options-button =
    .title = Izixhobo zazo zonke izongezelelo
