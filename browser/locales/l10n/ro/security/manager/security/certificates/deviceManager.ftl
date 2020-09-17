# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Manager de dispozitive
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Module și dispozitive de securitate

devmgr-header-details =
    .label = Detalii

devmgr-header-value =
    .label = Valoare

devmgr-button-login =
    .label = Autentifică-te
    .accesskey = n

devmgr-button-logout =
    .label = Deconectare
    .accesskey = i

devmgr-button-changepw =
    .label = Schimbă parola
    .accesskey = p

devmgr-button-load =
    .label = Încarcă
    .accesskey = c

devmgr-button-unload =
    .label = Descarcă
    .accesskey = D

devmgr-button-enable-fips =
    .label = Activează FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Dezactivează FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Încarcă driver dispozitiv PKCS#11

load-device-info = Introdu informații despre modulul pe care vrei să îl adaugi.

load-device-modname =
    .value = Numele modului
    .accesskey = M

load-device-modname-default =
    .value = Modul PKCS#11 nou

load-device-filename =
    .value = Numele fișierului modulului
    .accesskey = f

load-device-browse =
    .label = Răsfoiește…
    .accesskey = R

## Token Manager

devinfo-status =
    .label = Stare

devinfo-status-disabled =
    .label = Inactivat

devinfo-status-not-present =
    .label = Absent

devinfo-status-uninitialized =
    .label = Neinițializat

devinfo-status-not-logged-in =
    .label = Neautentificat

devinfo-status-logged-in =
    .label = Autentificat

devinfo-status-ready =
    .label = Pregătit

devinfo-desc =
    .label = Descriere

devinfo-man-id =
    .label = Fabricant

devinfo-hwversion =
    .label = Versiune HW
devinfo-fwversion =
    .label = Versiune FW

devinfo-modname =
    .label = Modul

devinfo-modpath =
    .label = Cale

login-failed = Login eșuat

devinfo-label =
    .label = Etichetă

devinfo-serialnum =
    .label = Număr de serie

fips-nonempty-password-required = În modul FIPS trebuie să ai o parolă generală pentru fiecare dispozitiv de securitate. Te rugăm să setezi parola înainte de a încerca activarea modului FIPS.

fips-nonempty-primary-password-required = Modul FIPS impune existența unei parole primare setate pentru fiecare dispozitiv de securitate. Te rugăm să setezi parola înainte de a încerca să activezi modul FIPS.
unable-to-toggle-fips = Imposibil de schimbat modul FIPS pentru dispozitivul de securitate. Este recomandat să ieși și să repornești această aplicație.
load-pk11-module-file-picker-title = Alege un driver al dispozitivului PKCS#11 pentru încărcare

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Este necesar numele modulului.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = „Root Certs” este rezervat și nu poate fi folosit ca nume de modul.

add-module-failure = Nu s-a putut adăuga modulul
del-module-warning = Sigur vrei să elimini acest modul de securitate?
del-module-error = Nu s-a putut elimina modulul
