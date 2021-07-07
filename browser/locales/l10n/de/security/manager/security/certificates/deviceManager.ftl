# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Kryptographie-Modul-Verwaltung
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Sicherheitsmodule und -einrichtungen

devmgr-header-details =
    .label = Details

devmgr-header-value =
    .label = Wert

devmgr-button-login =
    .label = Anmelden (Log In)
    .accesskey = A

devmgr-button-logout =
    .label = Abmelden (Log Out)
    .accesskey = b

devmgr-button-changepw =
    .label = Passwort ändern
    .accesskey = P

devmgr-button-load =
    .label = Laden
    .accesskey = L

devmgr-button-unload =
    .label = Entladen
    .accesskey = E

devmgr-button-enable-fips =
    .label = FIPS aktivieren
    .accesskey = F

devmgr-button-disable-fips =
    .label = FIPS deaktivieren
    .accesskey = F

## Strings used for load device

load-device =
    .title = PKCS#11-Gerätetreiber laden

load-device-info = Geben Sie die Informationen für das Modul an, das hinzugefügt werden soll.

load-device-modname =
    .value = Modulname:
    .accesskey = M

load-device-modname-default =
    .value = Neues PKCS#11 Modul

load-device-filename =
    .value = Modul-Dateiname:
    .accesskey = o

load-device-browse =
    .label = Durchsuchen…
    .accesskey = D

## Token Manager

devinfo-status =
    .label = Status

devinfo-status-disabled =
    .label = Deaktiviert

devinfo-status-not-present =
    .label = Nicht vorhanden

devinfo-status-uninitialized =
    .label = Uninitialisiert

devinfo-status-not-logged-in =
    .label = Nicht eingeloggt

devinfo-status-logged-in =
    .label = Eingeloggt

devinfo-status-ready =
    .label = Bereit

devinfo-desc =
    .label = Beschreibung

devinfo-man-id =
    .label = Hersteller

devinfo-hwversion =
    .label = HW-Version
devinfo-fwversion =
    .label = FW-Version

devinfo-modname =
    .label = Modul

devinfo-modpath =
    .label = Pfad

login-failed = Einloggen fehlgeschlagen

devinfo-label =
    .label = Etikett

devinfo-serialnum =
    .label = Seriennummer

fips-nonempty-password-required = FIPS-Modus benötigt ein Master-Passwort für jedes Kryptographie-Modul. Bitte legen Sie das Passwort fest, bevor Sie versuchen, den FIPS-Modus zu aktivieren.

fips-nonempty-primary-password-required = FIPS-Modus benötigt ein Hauptpasswort für jedes Kryptographie-Modul. Bitte legen Sie das Passwort fest, bevor Sie versuchen, den FIPS-Modus zu aktivieren.
unable-to-toggle-fips = Der FIPS-Modus für das Kryptographie-Modul konnte nicht geändert werden. Es wird empfohlen, dass Sie diese Anwendung benden und neu starten.
load-pk11-module-file-picker-title = Wählen Sie einen PKCS#11-Gerätetreiber zum Laden aus

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Der Modulname darf nicht leer sein.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = "Root Certs" ist ein reservierter Name und darf daher nicht als Modulname verwendet werden.

add-module-failure = Konnte Modul nicht laden
del-module-warning = Soll dieses Sicherheitsmodul wirklich gelöscht werden?
del-module-error = Konnte Modul nicht löschen
