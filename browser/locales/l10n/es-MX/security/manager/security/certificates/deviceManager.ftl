# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Administrador de dispositivos
    .style = width: 67em; height: 32em;
devmgr-devlist =
    .label = Módulos de seguridad y dispositivos
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
    .accesskey = C
devmgr-button-load =
    .label = Cargar
    .accesskey = C
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
    .title = Cargar el driver de dispositivo PKCS#11
load-device-info = Introduce la información para el módulo que quieres añadir.
load-device-modname =
    .value = Nombre del módulo
    .accesskey = M
load-device-modname-default =
    .value = Nuevo módulo PKCS#11
load-device-filename =
    .value = Nombre del archivo del módulo
    .accesskey = f
load-device-browse =
    .label = Examinar…
    .accesskey = x

## Token Manager

devinfo-status =
    .label = Estado
devinfo-status-disabled =
    .label = Deshabilitado
devinfo-status-not-present =
    .label = No presente
devinfo-status-uninitialized =
    .label = Sin inicializar
devinfo-status-not-logged-in =
    .label = No ha iniciado la sesión
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
login-failed = Falló el inicio de sesión
devinfo-label =
    .label = Etiqueta
devinfo-serialnum =
    .label = Número de serie
fips-nonempty-password-required = El modo FIPS requiere tener una contraseña maestra establecida para cada dispositivo de seguridad. Establece la contraseña antes de activar este modo.
fips-nonempty-primary-password-required = El modo FIPS requiere que tengas una contraseña principal establecida para cada dispositivo de seguridad. Establece la contraseña antes de tratar de activar el modo FIPS.
unable-to-toggle-fips = No se puede cambiar el modo FIPS para el dispositivo de seguridad.Te recomiend salir y reiniciar la aplicación.
load-pk11-module-file-picker-title = Escoger un dispositivo driver PKCS#11 para cargar
# Load Module Dialog
load-module-help-empty-module-name =
    .value = El nombre del módulo no se puede quedar vacío.
# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = "Root Certs" está reservado y no puede ser usado como nombre del módulo.
add-module-failure = No es posible añadir el módulo
del-module-warning = ¿Realmente quieres eliminar este módulo de seguridad?
del-module-error = No es posible eliminar el módulo
