# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Saugumo priemonių tvarkytuvė
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Saugumo moduliai ir priemonės

devmgr-header-details =
    .label = Išsamiau

devmgr-header-value =
    .label = Reikšmė

devmgr-button-login =
    .label = Pradėti seansą
    .accesskey = P

devmgr-button-logout =
    .label = Baigti seansą
    .accesskey = B

devmgr-button-changepw =
    .label = Pakeisti slaptažodį
    .accesskey = s

devmgr-button-load =
    .label = Įkelti
    .accesskey = k

devmgr-button-unload =
    .label = Iškelti
    .accesskey = š

devmgr-button-enable-fips =
    .label = FIPS veiksena
    .accesskey = F

devmgr-button-disable-fips =
    .label = Išjungti FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Įkelti PKCS#11 įrenginio tvarkyklę

load-device-info = Surinkite informaciją apie pridedamą modulį.

load-device-modname =
    .value = Modulio pavadinimas
    .accesskey = M

load-device-modname-default =
    .value = Naujas PKCS Nr. 11 modulis

load-device-filename =
    .value = Modulio failo pavadinimas
    .accesskey = f

load-device-browse =
    .label = Parinkti failą…
    .accesskey = r

## Token Manager

devinfo-status =
    .label = Būsena

devinfo-status-disabled =
    .label = Išjungtas

devinfo-status-not-present =
    .label = Nėra

devinfo-status-uninitialized =
    .label = Atšauktos pradinės reikšmės

devinfo-status-not-logged-in =
    .label = Nepradėtas seansas

devinfo-status-logged-in =
    .label = Pradėtas seansas

devinfo-status-ready =
    .label = Parengtas

devinfo-desc =
    .label = Aprašas

devinfo-man-id =
    .label = Gamintojas

devinfo-hwversion =
    .label = HW versija
devinfo-fwversion =
    .label = FW versija

devinfo-modname =
    .label = Modulis

devinfo-modpath =
    .label = Kelias

login-failed = Nepavyko prisijungti

devinfo-label =
    .label = Žymė

devinfo-serialnum =
    .label = Numeris

fips-nonempty-primary-password-required = Norint dirbti FIPS veiksenoje, reikia turėti tiek pagrindinių slaptažodžių, kiek turite saugumo priemonių. Prašom sukurti pagrindinius slaptažodžius prieš įjungiant FIPS veikseną.
unable-to-toggle-fips = Nepavyko pakeisti su saugumo priemone naudojamos FIPS veiksenos. Patariame užbaigti šios programos darbą, o tada paleisti ją iš naujo.
load-pk11-module-file-picker-title = Pasirinkite norimą įkelti PKCS#11 įrenginio tvarkyklę

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Modulio pavadinimas negali būti tuščias.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = „Root Certs“ yra rezervuotas ir negali būti naudojamas modulio pavadinimui.

add-module-failure = Nepavyko įdiegti modulio
del-module-warning = Ar tikrai norite pašalinti šį saugumo modulį?
del-module-error = Modulio pašalinti nepavyko
