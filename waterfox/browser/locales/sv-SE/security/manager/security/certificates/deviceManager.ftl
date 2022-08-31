# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Enhetshanteraren
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Säkerhetsmoduler och enheter

devmgr-header-details =
    .label = Detaljer

devmgr-header-value =
    .label = Värde

devmgr-button-login =
    .label = Logga in
    .accesskey = L

devmgr-button-logout =
    .label = Logga ut
    .accesskey = u

devmgr-button-changepw =
    .label = Ändra lösenord
    .accesskey = Ä

devmgr-button-load =
    .label = Aktivera
    .accesskey = A

devmgr-button-unload =
    .label = Inaktivera
    .accesskey = v

devmgr-button-enable-fips =
    .label = Aktivera FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Inaktivera FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Aktivera PKCS#11-drivrutin

load-device-info = Skriv in informationen för den modul du vill lägga till.

load-device-modname =
    .value = Modulnamn
    .accesskey = M

load-device-modname-default =
    .value = Ny PKCS#11-modul

load-device-filename =
    .value = Modulens filnamn
    .accesskey = f

load-device-browse =
    .label = Bläddra…
    .accesskey = B

## Token Manager

devinfo-status =
    .label = Status

devinfo-status-disabled =
    .label = Inaktiverad

devinfo-status-not-present =
    .label = Ej tillgänglig

devinfo-status-uninitialized =
    .label = Ej initierad

devinfo-status-not-logged-in =
    .label = Ej inloggad

devinfo-status-logged-in =
    .label = Inloggad

devinfo-status-ready =
    .label = Klar

devinfo-desc =
    .label = Beskrivning

devinfo-man-id =
    .label = Tillverkare

devinfo-hwversion =
    .label = HW-version
devinfo-fwversion =
    .label = FW-version

devinfo-modname =
    .label = Modul

devinfo-modpath =
    .label = Sökväg

login-failed = Inloggning misslyckades

devinfo-label =
    .label = Etikett

devinfo-serialnum =
    .label = Serienummer

fips-nonempty-primary-password-required = FIPS-läget kräver att du har ett huvudlösenord inställt för varje säkerhetsenhet. Vänligen ställ in lösenordet innan du försöker aktivera FIPS-läget.
unable-to-toggle-fips = Kunde inte ändra FIPS-läget för säkerhetsenheten. Du rekommenderas att avsluta och starta om det här programmet.
load-pk11-module-file-picker-title = Välja en PKCS#11-drivrutin att aktivera

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Modulnamnet kan inte vara tomt.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs‘ är reserverat och kan inte användas som modulnamn.

add-module-failure = Kan inte lägga till modulen
del-module-warning = Är du säker på att du vill ta bort säkerhetsmodulen?
del-module-error = Kan inte ta bort modul
