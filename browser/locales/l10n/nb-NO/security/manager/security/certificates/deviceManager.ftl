# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Enhetsbehandling
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Sikkerhetsmoduler og -enheter

devmgr-header-details =
    .label = Detaljer

devmgr-header-value =
    .label = Verdi

devmgr-button-login =
    .label = Logg inn
    .accesskey = i

devmgr-button-logout =
    .label = Logg ut
    .accesskey = u

devmgr-button-changepw =
    .label = Endre passord
    .accesskey = E

devmgr-button-load =
    .label = Last inn
    .accesskey = L

devmgr-button-unload =
    .label = Fjern
    .accesskey = F

devmgr-button-enable-fips =
    .label = Bruk FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Ikke tillat FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Aktiver PKCS#11 enhets-driver

load-device-info = Skriv inn informasjonen for modulen du vil legge til.

load-device-modname =
    .value = Modulnavn
    .accesskey = M

load-device-modname-default =
    .value = Ny PKCS#11-modul

load-device-filename =
    .value = Modulfilnavn
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
    .label = Ikke oppgitt

devinfo-status-uninitialized =
    .label = Uinitialisert

devinfo-status-not-logged-in =
    .label = Ikke innlogget

devinfo-status-logged-in =
    .label = Innlogget

devinfo-status-ready =
    .label = Klar

devinfo-desc =
    .label = Beskrivelse

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

login-failed = Klarte ikke logge inn

devinfo-label =
    .label = Etikett

devinfo-serialnum =
    .label = Serienummer

fips-nonempty-password-required = FIPS-modus krever at du har et hovedpassord for hver sikkerhetsenhet. Lag et passord før du slår på FIPS-modus.

fips-nonempty-primary-password-required = FIPS-modus krever at du har et hovedpassord for hver sikkerhetsenhet. Lag et passord før du slår på FIPS-modus.
unable-to-toggle-fips = Klarte ikke å endre FIPS-modusen for sikkerhetsenheten. Det anbefales at du avslutter og starter dette programmet på nytt.
load-pk11-module-file-picker-title = Velg en PKCS #11-enhetsdriver å laste

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Modulnavnet kan ikke være tomt.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs‘ er reservert og kan ikke brukes som modulnavn.

add-module-failure = Klarte ikke legge til modul
del-module-warning = Er du sikker på at du vil slette denne sikkerhetsmodulen?
del-module-error = Klarte ikke slette modul
