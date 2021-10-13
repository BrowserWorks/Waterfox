# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Acerca de los Perfiles
profiles-subtitle = Esta página ayuda a administrar tus perfiles. Cada perfil es un mundo único que contiene historial, marcadores, configuraciones y complementos.
profiles-create = Crear un nuevo perfil
profiles-restart-title = Reiniciar
profiles-restart-in-safe-mode = Reiniciar con Complementos Deshabilitados…
profiles-restart-normal = Reiniciar normalmente…
profiles-conflict = Otra copia de { -brand-product-name } ha hecho cambios a los perfiles. Debes reiniciar { -brand-short-name } antes de hacer más cambios.
profiles-flush-fail-title = Cambios no guardados
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Un error inesperado ha evitado que se guarden sus cambios.
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
profiles-current-profile = Este es el perfil en uso y no se puede eliminar.
profiles-in-use-profile = Este perfil está en uso en otra aplicación y no puede ser eliminado.

profiles-rename = Renombrar
profiles-remove = Eliminar
profiles-set-as-default = Establecer como perfil predeterminado
profiles-launch-profile = Lanzar perfil en nuevo navegador

profiles-cannot-set-as-default-title = No se puede establecer predeterminado
profiles-cannot-set-as-default-message = No se puede cambiar el perfil predeterminado para { -brand-short-name }.

profiles-yes = sí
profiles-no = no

profiles-rename-profile-title = Renombrar perfil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Renombrar perfil { $name }

profiles-invalid-profile-name-title = Nombre de perfil no válido
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = El nombre del perfil "{ $name }" no está permitido.

profiles-delete-profile-title = Eliminar perfil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Al eliminar un perfil se quitará de la lista de perfiles y no podrás recuperarlo.
    También puedes elegir eliminar los archivos de datos del perfil, incluyendo tu configuración, certificados y otros datos. Esta opción eliminará la carpeta "{ $dir }" sin posiblidad de recuperarla.
    ¿Realmente quieres eliminar los archivos de este perfil?
profiles-delete-files = Eliminar archivos
profiles-dont-delete-files = No eliminar archivos

profiles-delete-profile-failed-title = Error
profiles-delete-profile-failed-message = Hubo un error mientras se intentaba eliminar este perfil.


profiles-opendir =
    { PLATFORM() ->
        [macos] Mostrar en Finder
        [windows] Abrir carpeta
       *[other] Abrir directorio
    }
