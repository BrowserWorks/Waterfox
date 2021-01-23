# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Administrador de dispositivos
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Módulos y dispositivos de seguridad

devmgr-header-details =
    .label = Detalles

devmgr-header-value =
    .label = Valor

devmgr-button-login =
    .label = Iniciar sesión
    .accesskey = n

devmgr-button-logout =
    .label = Terminar sesión
    .accesskey = T

devmgr-button-changepw =
    .label = Cambiar contraseña
    .accesskey = b

devmgr-button-load =
    .label = Cargar
    .accesskey = g

devmgr-button-unload =
    .label = Descargar
    .accesskey = D

devmgr-button-enable-fips =
    .label = Habilitar FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Deshabilitar FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Cargar controlador de dispositivo PKCS#11

load-device-info = Ingrese la información para el módulo que quiere agregar

load-device-modname =
    .value = Nombre del módulo
    .accesskey = M

load-device-modname-default =
    .value = Nuevo módulo PKCS#11

load-device-filename =
    .value = Nombre del archivo del módulo
    .accesskey = v

load-device-browse =
    .label = Examinar...
    .accesskey = x

## Token Manager

devinfo-status =
    .label = Estado

devinfo-status-disabled =
    .label = Deshabilitado

devinfo-status-not-present =
    .label = No está presente

devinfo-status-uninitialized =
    .label = Sin inicializar

devinfo-status-not-logged-in =
    .label = No se ha iniciado sesión

devinfo-status-logged-in =
    .label = Sesión iniciada

devinfo-status-ready =
    .label = Listo

devinfo-desc =
    .label = Descripción

devinfo-man-id =
    .label = Fabricante

devinfo-hwversion =
    .label = Versión HW
devinfo-fwversion =
    .label = Versión FW

devinfo-modname =
    .label = Módulo

devinfo-modpath =
    .label = Ruta

login-failed = No se pudo iniciar la sesión

devinfo-label =
    .label = Etiqueta

devinfo-serialnum =
    .label = Número De Serie

fips-nonempty-password-required = El modo FIPS requiere que se ingrese una Contraseña Maestra para cada dispositivo de seguridad. Ingrese una contraseña antes de intentar habilitar el modo FIPS.

fips-nonempty-primary-password-required = El modo FIPS requiere que tenga una contraseña maestra establecida para cada dispositivo de seguridad. Establezca la contraseña antes de tratar de activar el modo FIPS.
unable-to-toggle-fips = No se puede cambiar el modo FIPS para el dispositivo de seguridad. Se recomienda que salga y reinicie esta aplicación.
load-pk11-module-file-picker-title = Seleccionar un controlador de dispositivo PKCS#11 para cargar

# Load Module Dialog
load-module-help-empty-module-name =
    .value = El nombre de módulo no puede estar vacío.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs‘ está reservado y no puede usarse como nombre de módulo.

add-module-failure = No se puede agregar el módulo
del-module-warning = ¿Está seguro de querer borrar este módulo de seguridad?
del-module-error = No se puede borrar el módulo
