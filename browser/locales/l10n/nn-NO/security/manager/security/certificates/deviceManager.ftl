# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Einingshandtering
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Tryggingsmodular og -einingar

devmgr-header-details =
    .label = Detaljar

devmgr-header-value =
    .label = Verdi

devmgr-button-login =
    .label = Logg inn
    .accesskey = L

devmgr-button-logout =
    .label = Logg ut
    .accesskey = o

devmgr-button-changepw =
    .label = Endra passord
    .accesskey = n

devmgr-button-load =
    .label = Last inn
    .accesskey = L

devmgr-button-unload =
    .label = Fjern
    .accesskey = r

devmgr-button-enable-fips =
    .label = Bruk FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Slå av FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Aktiver PKCS#11-einingsdrivaren

load-device-info = Skriv inn informasjonen for modulen du vil leggja til.

load-device-modname =
    .value = Modulnamn
    .accesskey = M

load-device-modname-default =
    .value = Ny PKCS#11-modul

load-device-filename =
    .value = Modulfilnamn
    .accesskey = f

load-device-browse =
    .label = Bla gjennom …
    .accesskey = B

## Token Manager

devinfo-status =
    .label = Status

devinfo-status-disabled =
    .label = Avslått

devinfo-status-not-present =
    .label = Ikkje spesifisert

devinfo-status-uninitialized =
    .label = Uinitialisert

devinfo-status-not-logged-in =
    .label = Ikkje innlogga

devinfo-status-logged-in =
    .label = Innlogga

devinfo-status-ready =
    .label = Klar

devinfo-desc =
    .label = Skildring

devinfo-man-id =
    .label = Produsent

devinfo-hwversion =
    .label = HW-versjon
devinfo-fwversion =
    .label = FW-versjon

devinfo-modname =
    .label = Modul

devinfo-modpath =
    .label = Sti

login-failed = Klarte ikkje å logga inn

devinfo-label =
    .label = Etikett

devinfo-serialnum =
    .label = Serienummer

fips-nonempty-password-required = FIPS-modus krev at du har eit hovudpassord for kvar tryggingseining. Vel eit hovudpassord før du slår på FIPS-moduset.

fips-nonempty-primary-password-required = FIPS-moduset krev at du har eit hovudpassord for kvar tryggingseining. Lag eit passord før du slår på FIPS-modus.
unable-to-toggle-fips = Klarte ikkje å endra FIPS-modusen for tryggingseininga. Det er tilrådd at du avsluttar og startar denne applikasjonen på nytt.
load-pk11-module-file-picker-title = Vel ei PKCS#11-drivarrutine å aktivere

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Modulnamnet kan ikkje vere tomt.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs‘ er reservert og kan ikkje brukast som modulnamn.

add-module-failure = Klarte ikkje å leggja til modul
del-module-warning = Er du viss på at du vil sletta denne tryggingsmodulen?
del-module-error = Klarte ikkje å sletta modul
