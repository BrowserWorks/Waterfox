# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Gestor de dispositius
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Mòduls i dispositius de seguretat

devmgr-header-details =
    .label = Detalls

devmgr-header-value =
    .label = Valor

devmgr-button-login =
    .label = Inicia la sessió
    .accesskey = n

devmgr-button-logout =
    .label = Finalitza la sessió
    .accesskey = z

devmgr-button-changepw =
    .label = Canvia la contrasenya
    .accesskey = y

devmgr-button-load =
    .label = Carrega
    .accesskey = g

devmgr-button-unload =
    .label = Descarrega
    .accesskey = D

devmgr-button-enable-fips =
    .label = Habilita els FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Inhabilita els FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Carrega el controlador de dispositiu PKCS#11

load-device-info = Introduïu la informació del mòdul que voleu afegir.

load-device-modname =
    .value = Nom del mòdul
    .accesskey = m

load-device-modname-default =
    .value = Nou mòdul PKCS#11

load-device-filename =
    .value = Nom de fitxer del mòdul
    .accesskey = f

load-device-browse =
    .label = Navega…
    .accesskey = N

## Token Manager

devinfo-status =
    .label = Estat

devinfo-status-disabled =
    .label = Inhabilitat

devinfo-status-not-present =
    .label = No present

devinfo-status-uninitialized =
    .label = No inicialitzat

devinfo-status-not-logged-in =
    .label = No s'ha iniciat la sessió

devinfo-status-logged-in =
    .label = S'ha iniciat la sessió

devinfo-status-ready =
    .label = Preparat

devinfo-desc =
    .label = Descripció

devinfo-man-id =
    .label = Fabricant

devinfo-hwversion =
    .label = Versió HW
devinfo-fwversion =
    .label = Versió FW

devinfo-modname =
    .label = Mòdul

devinfo-modpath =
    .label = Camí

login-failed = No s'ha pogut iniciar la sessió

devinfo-label =
    .label = Etiqueta

devinfo-serialnum =
    .label = Número de sèrie

fips-nonempty-password-required = El mode FIPS requereix que tingueu una contrasenya mestra definida per a cada dispositiu de seguretat. Definiu la contrasenya abans d'habilitar el mode FIPS.

fips-nonempty-primary-password-required = El mode FIPS requereix que tingueu una contrasenya principal definida per a cada dispositiu de seguretat. Definiu la contrasenya abans d'habilitar el mode FIPS.
unable-to-toggle-fips = No s'ha pogut canviar el mode FIPS del dispositiu de seguretat. Es recomana que sortiu i reinicieu l'aplicació.
load-pk11-module-file-picker-title = Trieu un controlador de dispositiu PKCS#11 per carregar

# Load Module Dialog
load-module-help-empty-module-name =
    .value = El nom del mòdul no pot estar buit.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = «Root Certs» és reservat i no es pot usar com a nom de mòdul.

add-module-failure = No s'ha pogut afegir el mòdul
del-module-warning = Esteu segur que voleu suprimir aquest mòdul de seguretat?
del-module-error = No s'ha pogut suprimir el mòdul
