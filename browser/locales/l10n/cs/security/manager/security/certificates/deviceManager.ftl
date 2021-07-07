# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Správce bezpečnostních zařízení
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Bezpečnostní moduly a zařízení

devmgr-header-details =
    .label = Podrobnosti

devmgr-header-value =
    .label = Hodnota

devmgr-button-login =
    .label = Přihlásit
    .accesskey = P

devmgr-button-logout =
    .label = Odhlásit
    .accesskey = O

devmgr-button-changepw =
    .label = Změnit heslo
    .accesskey = h

devmgr-button-load =
    .label = Načíst
    .accesskey = N

devmgr-button-unload =
    .label = Uvolnit
    .accesskey = U

devmgr-button-enable-fips =
    .label = Povolit FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Zakázat FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Načíst ovladač PKCS#11 zařízení

load-device-info = Zadejte informace o modulu, který chcete přidat.

load-device-modname =
    .value = Název modulu
    .accesskey = m

load-device-modname-default =
    .value = Nový modul PKCS#11

load-device-filename =
    .value = Název souboru modulu
    .accesskey = N

load-device-browse =
    .label = Procházet…
    .accesskey = P

## Token Manager

devinfo-status =
    .label = Stav

devinfo-status-disabled =
    .label = Zakázáno

devinfo-status-not-present =
    .label = Není přítomno

devinfo-status-uninitialized =
    .label = Neinicializováno

devinfo-status-not-logged-in =
    .label = Nepřihlášeno

devinfo-status-logged-in =
    .label = Přihlášeno

devinfo-status-ready =
    .label = Připraveno

devinfo-desc =
    .label = Popis

devinfo-man-id =
    .label = Výrobce

devinfo-hwversion =
    .label = Verze HW
devinfo-fwversion =
    .label = Verze FW

devinfo-modname =
    .label = Modul

devinfo-modpath =
    .label = Umístění

login-failed = Přihlášení selhalo.

devinfo-label =
    .label = Označení

devinfo-serialnum =
    .label = Sériové číslo

fips-nonempty-password-required = Režim FIPS vyžaduje, abyste měli nastavené hlavní heslo pro každé bezpečnostní zařízení. Prosím nastavte jej před povolením režimu FIPS.

fips-nonempty-primary-password-required = Režim FIPS vyžaduje, abyste měli nastavené hlavní heslo pro každé bezpečnostní zařízení. Prosím nastavte jej před povolením režimu FIPS.
unable-to-toggle-fips = Změna režimu FIPS pro bezpečnostní zařízení se nezdařila. Doporučujeme restartovat aplikaci.
load-pk11-module-file-picker-title = Vyberte ovladač PKCS#11 zařízení k načtení

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Název modulu nemůže být prázdný.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = „Root Certs“ je rezervovaný název a nemůže být použit jako název modulu.

add-module-failure = Nepodařilo se přidat modul
del-module-warning = Opravdu chcete smazat tento bezpečnostní modul?
del-module-error = Nepodařilo se smazat modul
