# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Gestione dispositivi
    .style = width: 70em; height: 33em;

devmgr-devlist =
    .label = Moduli e dispositivi di sicurezza

devmgr-header-details =
    .label = Dettagli

devmgr-header-value =
    .label = Valore

devmgr-button-login =
    .label = Accedi
    .accesskey = A

devmgr-button-logout =
    .label = Esci
    .accesskey = E

devmgr-button-changepw =
    .label = Modifica la password
    .accesskey = p

devmgr-button-load =
    .label = Carica
    .accesskey = C

devmgr-button-unload =
    .label = Scarica
    .accesskey = S

devmgr-button-enable-fips =
    .label = Attiva FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Disattiva FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Carica driver dispositivo PKCS#11

load-device-info = Inserire le informazioni per il modulo che si vuole aggiungere.

load-device-modname =
    .value = Nome modulo
    .accesskey = N

load-device-modname-default =
    .value = Nuovo modulo PKCS#11

load-device-filename =
    .value = Nome file modulo
    .accesskey = f

load-device-browse =
    .label = Sfoglia…
    .accesskey = o

## Token Manager

devinfo-status =
    .label = Stato

devinfo-status-disabled =
    .label = Disattivato

devinfo-status-not-present =
    .label = Non presente

devinfo-status-uninitialized =
    .label = Non inizializzato

devinfo-status-not-logged-in =
    .label = Non connesso

devinfo-status-logged-in =
    .label = Connesso

devinfo-status-ready =
    .label = Pronto

devinfo-desc =
    .label = Descrizione

devinfo-man-id =
    .label = Produttore

devinfo-hwversion =
    .label = Versione HW
devinfo-fwversion =
    .label = Versione FW

devinfo-modname =
    .label = Modulo

devinfo-modpath =
    .label = Percorso

login-failed = Accesso non riuscito

devinfo-label =
    .label = Etichetta

devinfo-serialnum =
    .label = Numero seriale

fips-nonempty-password-required = La modalità FIPS richiede l’impostazione di una password principale per ciascun dispositivo di sicurezza. Impostare le password prima di attivare la modalità FIPS.

fips-nonempty-primary-password-required = La modalità FIPS richiede l’impostazione di una password principale per ciascun dispositivo di sicurezza. Impostare le password prima di attivare la modalità FIPS.
unable-to-toggle-fips = Non è possibile cambiare la modalità FIPS per il dispositivo di sicurezza. Si consiglia di uscire e riavviare l’applicazione.
load-pk11-module-file-picker-title = Scegliere un driver dispositivo PKCS#11 da caricare

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Il nome del modulo non può essere lasciato vuoto.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = “Root Certs” è riservato e non può essere utilizzato come nome del modulo.

add-module-failure = Impossibile aggiungere il modulo
del-module-warning = Eliminare questo modulo di sicurezza?
del-module-error = Impossibile eliminare il modulo
