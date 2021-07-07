# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Enhedsadministration
    .style = width: 57em; height: 25em;

devmgr-devlist =
    .label = Sikkerhedsmoduler og -enheder

devmgr-header-details =
    .label = Detaljer

devmgr-header-value =
    .label = Værdi

devmgr-button-login =
    .label = Log på
    .accesskey = p

devmgr-button-logout =
    .label = Log ud
    .accesskey = u

devmgr-button-changepw =
    .label = Skift adgangskode
    .accesskey = S

devmgr-button-load =
    .label = Indlæs
    .accesskey = l

devmgr-button-unload =
    .label = Fjern
    .accesskey = j

devmgr-button-enable-fips =
    .label = Aktiver FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Deaktiver FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Indlæs PKCS#11-enhedsdriver

load-device-info = Indtast den information om modulet, du ønsker at tilføje.

load-device-modname =
    .value = Modulnavn
    .accesskey = M

load-device-modname-default =
    .value = Nyt PKCS#11-modul

load-device-filename =
    .value = Modulets filnavn
    .accesskey = n

load-device-browse =
    .label = Gennemse…
    .accesskey = G

## Token Manager

devinfo-status =
    .label = Status

devinfo-status-disabled =
    .label = Deaktiveret

devinfo-status-not-present =
    .label = Ikke tilstede

devinfo-status-uninitialized =
    .label = Ikke initialiseret

devinfo-status-not-logged-in =
    .label = Ikke logget på

devinfo-status-logged-in =
    .label = Logget på

devinfo-status-ready =
    .label = Klar

devinfo-desc =
    .label = Beskrivelse

devinfo-man-id =
    .label = Producent

devinfo-hwversion =
    .label = HW-version
devinfo-fwversion =
    .label = FW-version

devinfo-modname =
    .label = Modul

devinfo-modpath =
    .label = Sti

login-failed = Kunne ikke logge på

devinfo-label =
    .label = Etikette

devinfo-serialnum =
    .label = Serienummer

fips-nonempty-password-required = FIPS-tilstand kræver at der er angivet en hovedadgangskode for hver sikkerhedsenhed. Opret en adgangskode før du skifter til FIPS-tilstand.

fips-nonempty-primary-password-required = FIPS-tilstand kræver, at du har sat en hovedadgangskode for hvert sikkerhedsmodul. Opret en adgangskode, før du forsøger at aktivere FIPS-tilstand.
unable-to-toggle-fips = Kunne ikke skifte FIPS-tilstand med sikkerhedsenheden. Det anbefales at du afslutter og genstarter dette program.
load-pk11-module-file-picker-title = Vælg en PKCS#11-enhedsdriver der skal indlæses

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Modulet har intet navn.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs‘ er reserveret og kan ikke bruges som modul-navn.

add-module-failure = Kunne ikke tilføje modulet
del-module-warning = Er du sikker på, at du vil slette dette sikkerhedsmodul?
del-module-error = Kunne ikke slette modulet
