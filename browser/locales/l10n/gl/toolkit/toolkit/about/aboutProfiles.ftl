# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

profiles-title = Sobre os perfís
profiles-subtitle = Esta páxina axúdao a xestionar os seus perfís. Cada un é un mundo diferente que contén un historial, marcadores, configuración e complementos propios.
profiles-create = Crear un novo perfil
profiles-restart-title = Reiniciar
profiles-restart-in-safe-mode = Reiniciar cos complementos desactivados…
profiles-restart-normal = Reiniciar normalmente…
profiles-conflict = Outra copia de { -brand-product-name } modificou os perfís. Debe reiniciar { -brand-short-name } antes de facer máis cambios.
profiles-flush-fail-title = Non se gardaron os cambios
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Un erro inesperado impediu gardar os seus cambios.
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
profiles-current-profile = Este perfil está en uso e non é posíbel eliminalo.
profiles-in-use-profile = Este perfil está en uso noutro aplicativo e non é posíbel eliminalo.
profiles-rename = Renomear
profiles-remove = Retirar
profiles-set-as-default = Estabelecer como perfil predeterminado
profiles-launch-profile = Iniciar o perfil nun novo navegador
profiles-cannot-set-as-default-title = Non foi posíbel establecer o predeterminado
profiles-cannot-set-as-default-message = Non é posíbel cambiar o perfil por omisión do { -brand-short-name }.
profiles-yes = si
profiles-no = non
profiles-rename-profile-title = Renomear perfil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Renomear perfil { $name }
profiles-invalid-profile-name-title = Nome de perfil non válido
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Non está permitido o nome de perfil «{ $name }».
profiles-delete-profile-title = Eliminar perfil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Se elimina un perfil non estará dispoñíbel na lista e non será posíbel desfacer esta acción.
    Tamén pode eliminar os ficheiros de datos do perfil, inclusive a súa configuración, certificados e máis datos relacionados co usuario. Isto eliminará o cartafol «{ $dir }» e non é posíbel desfacer a acción.
    Desexa eliminar os ficheiros de datos do perfil?
profiles-delete-files = Eliminar ficheiros
profiles-dont-delete-files = Non eliminar ficheiros
profiles-delete-profile-failed-title = Erro
profiles-delete-profile-failed-message = Produciuse un erro mentres se tentaba eliminar este perfil.
profiles-opendir =
    { PLATFORM() ->
        [macos] Amosar no Finder
        [windows] Abrir cartafol
       *[other] Abrir directorio
    }
