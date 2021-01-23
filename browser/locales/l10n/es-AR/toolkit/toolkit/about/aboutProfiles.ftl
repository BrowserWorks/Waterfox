# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Acerca de perfiles
profiles-subtitle = Esta página permite administrar los perfiles. Cada perfil es un mundo separado que contiene historial, marcadores, configuración y complementos separados.
profiles-create = Crear un nuevo perfil
profiles-restart-title = Reiniciar
profiles-restart-in-safe-mode = Reiniciar con los complementos deshabilitados…
profiles-restart-normal = Reiniciar normalmente…
profiles-conflict = Otra copia de { -brand-product-name } ha hecho cambios a los perfiles. Debe reiniciar { -brand-short-name } antes de hacer más cambios.
profiles-flush-fail-title = Cambios no guardados
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Un error inesperado ha evitado que los cambios se guarden.
profiles-flush-restart-button = Reiniciar { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Perfil: { $name }
profiles-is-default = Perfil predeterminado
profiles-rootdir = Directorio raíz

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Directorio local
profiles-current-profile = Este es el perfil en uso y no puede ser borrado.
profiles-in-use-profile = Este perfil está en uso en otra aplicación y no se puede borrar.

profiles-rename = Renombrar
profiles-remove = Eliminar
profiles-set-as-default = Establecer como predeterminado
profiles-launch-profile = Iniciar perfil en nuevo navegador

profiles-cannot-set-as-default-title = No se puede establecer predeterminado
profiles-cannot-set-as-default-message = El perfil predeterminado no se puede cambiar para { -brand-short-name }.

profiles-yes = si
profiles-no = no

profiles-rename-profile-title = Renombrar perfil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Renombrar perfil { $name }

profiles-invalid-profile-name-title = Nombre de perfil inválido
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = El nombre de perfil "{ $name }" no está permitido.

profiles-delete-profile-title = Borrar perfil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Borrar un perfil eliminará el perfil de la lista de perfiles disponibles y no puede deshacerse.
    También puede decidir borrar los archivos del perfil, incluyendo sus opciones, certificados y otros datos de usuario. Esta opción borrará la carpeta "{ $dir }" y no puede deshacerse.
    ¿Desea borrar los archivos del perfil?
profiles-delete-files = Borrar archivos
profiles-dont-delete-files = No borrar archivos

profiles-delete-profile-failed-title = Error
profiles-delete-profile-failed-message = Hubo un error al intentar borrar este perfil.


profiles-opendir =
    { PLATFORM() ->
        [macos] Mostrar en Finder
        [windows] Abrir carpeta
       *[other] Abrir directorio
    }
