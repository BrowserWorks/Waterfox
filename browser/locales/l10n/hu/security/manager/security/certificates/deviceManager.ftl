# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Eszközkezelő
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Biztonsági modulok és szolgáltatások

devmgr-header-details =
    .label = Részletek

devmgr-header-value =
    .label = Érték

devmgr-button-login =
    .label = Bejelentkezés
    .accesskey = B

devmgr-button-logout =
    .label = Kijelentkezés
    .accesskey = K

devmgr-button-changepw =
    .label = Jelszócsere
    .accesskey = J

devmgr-button-load =
    .label = Betöltés
    .accesskey = e

devmgr-button-unload =
    .label = Eltávolítás
    .accesskey = v

devmgr-button-enable-fips =
    .label = FIPS engedélyezése
    .accesskey = F

devmgr-button-disable-fips =
    .label = FIPS tiltása
    .accesskey = F

## Strings used for load device

load-device =
    .title = PKCS#11 eszközillesztő betöltése

load-device-info = Adja meg a kívánt modulinformációkat

load-device-modname =
    .value = Modulnév
    .accesskey = M

load-device-modname-default =
    .value = Új PKCS#11 modul

load-device-filename =
    .value = Modul fájlneve
    .accesskey = f

load-device-browse =
    .label = Tallózás…
    .accesskey = T

## Token Manager

devinfo-status =
    .label = Állapot

devinfo-status-disabled =
    .label = Tiltva

devinfo-status-not-present =
    .label = Nincs jelen

devinfo-status-uninitialized =
    .label = Nincs inicializálva

devinfo-status-not-logged-in =
    .label = Nincs bejelentkezve

devinfo-status-logged-in =
    .label = Be van jelentkezve

devinfo-status-ready =
    .label = Kész

devinfo-desc =
    .label = Leírás

devinfo-man-id =
    .label = Gyártó

devinfo-hwversion =
    .label = HW-verzió
devinfo-fwversion =
    .label = FW-verzió

devinfo-modname =
    .label = Modul

devinfo-modpath =
    .label = Útvonal

login-failed = Sikertelen bejelentkezés

devinfo-label =
    .label = Címke

devinfo-serialnum =
    .label = Sorozatszám

fips-nonempty-password-required = A FIPS-módhoz szükséges, hogy minden adatvédelmi eszközhöz legyen mesterjelszó beállítva. Állítsa be a jelszót a FIPS-mód engedélyezése előtt.

fips-nonempty-primary-password-required = A FIPS-módhoz szükséges, hogy minden adatvédelmi eszközhöz legyen elsődleges jelszó beállítva. Állítsa be a jelszót a FIPS-mód engedélyezése előtt.
unable-to-toggle-fips = Nem sikerült módosítani a biztonsági eszköz FIPS-módját. Javasoljuk, hogy lépjen ki az alkalmazásból, és indítsa újra.
load-pk11-module-file-picker-title = Válassza ki a betöltendő PKCS#11 eszközillesztőt

# Load Module Dialog
load-module-help-empty-module-name =
    .value = A modulnév nem lehet üres.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = A „Root Certs” fenntartott név, nem használható modulnévként.

add-module-failure = A modul hozzáadása sikertelen.
del-module-warning = Biztosan törölni kívánja ezt a biztonsági modult?
del-module-error = A modul törlése sikertelen.
