# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = { -brand-short-name } evitó que este sitio le solicite instalar software en su equipo.

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = ¿Permitir que { $host } instale un complemento?
xpinstall-prompt-message = Está intentando instalar un complemento desde { $host }. Asegúrese de que confía en el sitio antes de continuar.

##

xpinstall-prompt-header-unknown = ¿Permitir que un sitio desconocido instale complementos?
xpinstall-prompt-message-unknown = Estás intentando instalar un complemento desde un sitio desconocido. Asegúrate de que confías en el sitio antes de continuar.

xpinstall-prompt-dont-allow =
    .label = No permitir
    .accesskey = N
xpinstall-prompt-never-allow =
    .label = No permitir nunca
    .accesskey = N
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = Informar sobre sitio sospechoso
    .accesskey = r
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = Seguir con la instalación
    .accesskey = C

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = Este sitio solicita acceso a sus dispositivos MIDI (Interfaz Digital de Instrumentos Musicales). El acceso al dispositivo se puede activar instalando un complemento.
site-permission-install-first-prompt-midi-message = No se garantiza que este acceso sea seguro. Continúe solo si confía en este sitio.

##

xpinstall-disabled-locked = La instalación de software ha sido desactivada por el administrador de su sistema.
xpinstall-disabled = La instalación de software está actualmente desactivada. Pulse Activar y vuelva a intentarlo.
xpinstall-disabled-button =
    .label = Activar
    .accesskey = c

# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = { $addonName } ({ $addonId }) está bloqueado por el administrador del sistema.
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = El administrador del sistema evitó que este sitio pida instalar software en su ordenador.
addon-install-full-screen-blocked = No se permite la instalación de complementos durante o tras acceder al modo de pantalla completa.

# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = { $addonName } añadido a { -brand-short-name }
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = { $addonName } requiere nuevos permisos

# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons = Finalizar la instalación de extensiones importadas a { -brand-short-name }

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = ¿Eliminar { $name }?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = ¿Eliminar { $name } de { -brand-shorter-name }?
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
    .label = Añadir
    .accesskey = A

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message =
    { $addonCount ->
        [one] Este sitio desea instalar un complemento en { -brand-short-name }:
       *[other] Este sitio desea instalar { $addonCount } complementos en { -brand-short-name }:
    }
addon-confirm-install-unsigned-message =
    { $addonCount ->
        [one] Cuidado: este sitio quiere instalar un complemento no verificado en { -brand-short-name }. Continúe bajo su responsabilidad.
       *[other] Cuidado: este sitio quiere instalar { $addonCount } complementos no verificados en { -brand-short-name }. Continúe bajo su responsabilidad.
    }
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message = Cuidado: este sitio quiere instalar { $addonCount } complementos en { -brand-short-name }, algunos de los cuales no están verificados. Continúe bajo su responsabilidad.

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = El complemento no ha podido ser descargado por un error con la conexión.
addon-install-error-incorrect-hash = Este complemento no ha podido ser instalado porque no concuerda con el complemento { -brand-short-name } esperado.
addon-install-error-corrupt-file = El complemento descargado desde este sitio no ha podido ser instalado porque parece que está dañado.
addon-install-error-file-access = { $addonName } no ha podido ser instalado porque { -brand-short-name } no puede modificar el archivo necesario.
addon-install-error-not-signed = { -brand-short-name } ha evitado que este sitio instala un complemento no verificado.
addon-install-error-invalid-domain = El complemento { $addonName } no se puede instalar desde esta dirección.
addon-local-install-error-network-failure = Este complemento no ha podido ser instalado por un error en el sistema de ficheros.
addon-local-install-error-incorrect-hash = Este complemento no ha podido ser instalado porque no concuerda con el complemento { -brand-short-name } esperado.
addon-local-install-error-corrupt-file = Este complemento no ha podido ser instalado porque parece que está dañado.
addon-local-install-error-file-access = { $addonName } no ha podido ser instalado porque { -brand-short-name } no puede modificar el archivo necesario.
addon-local-install-error-not-signed = Este complemento no ha podido ser instalado porque no ha sido verificado.
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = { $addonName } no ha podido ser instalado porque no es compatible con { -brand-short-name } { $appVersion }.
addon-install-error-blocklisted = { $addonName } no ha podido ser instalado porque tiene un alto riesgo de causar problemas de estabilidad o seguridad.
