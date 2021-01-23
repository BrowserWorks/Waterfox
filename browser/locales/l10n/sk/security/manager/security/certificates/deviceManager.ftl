# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Správca bezpečnostných zariadení
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Bezpečnostné moduly a zariadenia

devmgr-header-details =
    .label = Podrobnosti

devmgr-header-value =
    .label = Hodnota

devmgr-button-login =
    .label = Prihlásiť
    .accesskey = P

devmgr-button-logout =
    .label = Odhlásiť
    .accesskey = O

devmgr-button-changepw =
    .label = Zmeniť heslo
    .accesskey = h

devmgr-button-load =
    .label = Načítať
    .accesskey = N

devmgr-button-unload =
    .label = Uvoľniť
    .accesskey = U

devmgr-button-enable-fips =
    .label = Povoliť FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Zakázať FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Načítať ovládač zariadenia PKCS#11

load-device-info = Zadajte informácie pre modul, ktorý chcete pridať.

load-device-modname =
    .value = Názov modulu
    .accesskey = m

load-device-modname-default =
    .value = Nový modul PKCS#11

load-device-filename =
    .value = Názov súboru modulu
    .accesskey = s

load-device-browse =
    .label = Prehľadávať…
    .accesskey = h

## Token Manager

devinfo-status =
    .label = Stav

devinfo-status-disabled =
    .label = Zakázané

devinfo-status-not-present =
    .label = Neprítomné

devinfo-status-uninitialized =
    .label = Neinicializované

devinfo-status-not-logged-in =
    .label = Neprihlásený

devinfo-status-logged-in =
    .label = Prihlásený

devinfo-status-ready =
    .label = Pripravené

devinfo-desc =
    .label = Opis

devinfo-man-id =
    .label = Výrobca

devinfo-hwversion =
    .label = Verzia hardvéru
devinfo-fwversion =
    .label = Verzia firmvéru

devinfo-modname =
    .label = Modul

devinfo-modpath =
    .label = Cesta

login-failed = Nepodarilo sa prihlásiť

devinfo-label =
    .label = Popis

devinfo-serialnum =
    .label = Sériové číslo

fips-nonempty-password-required = Režim FIPS vyžaduje, aby ste mali nastavené hlavné heslo pre každé bezpečnostné zariadenie. Zadajte toto heslo a potom skúste povoliť režim FIPS.

fips-nonempty-primary-password-required = Režim FIPS vyžaduje, aby ste mali nastavené hlavné heslo pre každé bezpečnostné zariadenie. Zadajte toto heslo a potom skúste povoliť režim FIPS.
unable-to-toggle-fips = Pre bezpečnostné zariadenie nebolo možné zmeniť režim FIPS. Odporúčame ukončenie a reštartovanie aplikácie.
load-pk11-module-file-picker-title = Vyberte ovládač zariadenia PKCS#11 na načítanie

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Názov modulu nemôže byť prázdny.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = „Root Certs“ je rezervovaný názov a nemôže byť použitý ako názov modulu.

add-module-failure = Nepodarilo sa pridať modul
del-module-warning = Naozaj chcete odstrániť tento bezpečnostný modul?
del-module-error = Nepodarilo sa odstrániť modul
