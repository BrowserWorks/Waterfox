# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = { -brand-short-name } evitó que este sitio web te pidiera instalar software en tu equipo.

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = ¿Permitir que { $host } instale un complemento?
xpinstall-prompt-message = Estás intentando instalar un complemento desde { $host }. Asegúrate de que confías en el sitio antes de continuar.

##

xpinstall-prompt-header-unknown = ¿Permites que un sitio desconocido instale un complemento?
xpinstall-prompt-message-unknown = Estás intentando instalar un complemento desde un sitio desconocido. Asegúrate de que confías en el sitio antes de continuar.

xpinstall-prompt-dont-allow =
    .label = No permitir
    .accesskey = D
xpinstall-prompt-never-allow =
    .label = Nunca permitir
    .accesskey = N
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = Reportar sitio sospechoso
    .accesskey = R
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = Continuar con la instalación
    .accesskey = C

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = Este sitio solicita acceso a tus dispositivos MIDI (Interfaz Digital de Instrumentos Musicales). El acceso al dispositivo se puede activar instalando un complemento.
site-permission-install-first-prompt-midi-message = No se garantiza que este acceso sea seguro. Continúa solo si confías en este sitio.

##

xpinstall-disabled-locked = El administrador del sistema desactivó la instalación de software.
xpinstall-disabled = La instalación de software está desactivada. Haz clic en Activar y vuelve a intentarlo.
xpinstall-disabled-button =
    .label = Activar
    .accesskey = A

# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = { $addonName } ({ $addonId }) está bloqueado por tu administrador de sistema.
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = Tu administrador de sistema evitó que este sitio te pidiera que instalaras software en tu computadora.
addon-install-full-screen-blocked = No se permite la instalación de complementos durante o tras acceder al modo pantalla completa.

# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = { $addonName } se agregó a { -brand-short-name }
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = { $addonName } requiere nuevos permisos

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = ¿Eliminar { $name }?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = ¿Eliminar { $name } desde { -brand-shorter-name }?
addon-removal-button = Eliminar
addon-removal-abuse-report-checkbox = Informar de esta extensión a { -vendor-short-name }

# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying =
    { $addonCount ->
        [one] Descargando y verificando complemento…
       *[other] Descargando y verificando { $addonCount } complementos…
    }
addon-download-verifying = Verificando

addon-install-cancel-button =
    .label = Cancelar
    .accesskey = C
addon-install-accept-button =
    .label = Agregar
    .accesskey = A

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message =
    { $addonCount ->
        [one] A este sitio le gustaría instalar un complemento en { -brand-short-name }:
       *[other] A este sitio le gustaría instalar { $addonCount } complementos en { -brand-short-name }:
    }
addon-confirm-install-unsigned-message =
    { $addonCount ->
        [one] Precaución: A este sitio le gustaría instalar un complemento no verificado en { -brand-short-name }. Continuar bajo tu propio riesgo.
       *[other] Precaución: A este sitio le gustaría instalar { $addonCount } complementos no verificados en { -brand-short-name }. Proceder bajo tu propio riesgo.
    }
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message = Precaución: A este sitio le gustaría instalar { $addonCount } complementos en { -brand-short-name }, algunos de ellos no están verificados. Proceder bajo tu propio riesgo.

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = El complemento no se pudo descargar porque la conexión tuvo un fallo.
addon-install-error-incorrect-hash = El complemento no pudo ser instalado porque no se encuentra el complemento { -brand-short-name } solicitado.
addon-install-error-corrupt-file = El complemento descargado desde este sitio no pudo ser instalado porque parece estar corrupto.
addon-install-error-file-access = { $addonName } no pudo ser instalado porque { -brand-short-name } no puede modificar el archivo necesario.
addon-install-error-not-signed = { -brand-short-name } evitó que este sitio instalara un complemento sin verificar.
addon-install-error-invalid-domain = El complemento { $addonName } no puede ser instalado desde esta ubicación.
addon-local-install-error-network-failure = Este complemento no se pudo instalar debido a un error de sistema de archivos.
addon-local-install-error-incorrect-hash = Este complemento no se pudo instalar porque no coincide el complemento { -brand-short-name } esperado.
addon-local-install-error-corrupt-file = Este complemento no se pudo instalar debido a que parece estar dañado.
addon-local-install-error-file-access = { $addonName } no pudo ser instalado porque { -brand-short-name } no puede modificar el archivo necesario.
addon-local-install-error-not-signed = Este complemento no se pudo instalar debido a que no ha sido verificado.
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = { $addonName } no pudo ser instalado porque no es compatible con { -brand-short-name } { $appVersion }.
addon-install-error-blocklisted = { $addonName } no pudo ser instalado porque tiene un alto riesgo de causar problemas de seguridad.
