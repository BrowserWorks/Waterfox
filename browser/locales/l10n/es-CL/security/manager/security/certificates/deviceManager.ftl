# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Administrador de Dispositivo
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Este certificado personal no puede ser instalado porque no posees la clave privada correspondiente que fue creada cuando el certificado fue solicitado.

devmgr-header-details =
    .label = Detalles

devmgr-header-value =
    .label = Valor

devmgr-button-login =
    .label = Ingresar
    .accesskey = n

devmgr-button-logout =
    .label = Salir
    .accesskey = S

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
    .label = Activar FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Desactivar FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Cargar el controlador de dispositivo PKCS#11

load-device-info = Ingresa la información para el módulo que deseas añadir.

load-device-modname =
    .value = Nombre de módulo
    .accesskey = M

load-device-modname-default =
    .value = Nuevo módulo PKCS#11

load-device-filename =
    .value = Nombre de archivo de módulo
    .accesskey = f

load-device-browse =
    .label = Examinar…
    .accesskey = E

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
    .label = Ubicación

login-failed = Falló el inicio de sesión

devinfo-label =
    .label = Etiqueta

devinfo-serialnum =
    .label = Número de serie

fips-nonempty-password-required = El modo FIPS requiere que tenga una contraseña maestra establecida para cada dispositivo de seguridad. Por favor, establece la contraseña antes de tratar de activar el modo FIPS.

fips-nonempty-primary-password-required = El modo FIPS requiere que tenga una contraseña primaria establecida para cada dispositivo de seguridad. Por favor, establece la contraseña antes de tratar de activar el modo FIPS.
unable-to-toggle-fips = No se puede cambiar el modo FIPS para el dispositivo de seguridad. Se recomienda que salga y reinicie esta aplicación.
load-pk11-module-file-picker-title = Elija un controlador de dispositivo PKCS#11 para cargar

# Load Module Dialog
load-module-help-empty-module-name =
    .value = El nombre del módulo no puede estar vacío.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = "Root Certs" está reservado y no puede ser usado como el nombre del módulo.

add-module-failure = No se pudo añadir el módulo
del-module-warning = ¿Está seguro que desea eliminar este módulo de seguridad?
del-module-error = Incapaz de eliminar módulo
