# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

profiles-title = Sobre los Perfils
profiles-subtitle = Is pachina t'aduya a chestionar los tuyos perfils. Cada perfil ye un mundo deseparau que contién historials, marcapachinas, achustes y complementos diferents.
profiles-create = Creyar un Nuevo Perfil
profiles-restart-title = Reiniciar
profiles-restart-in-safe-mode = Reiniciar con os complementos desactivaus…
profiles-restart-normal = Reiniciar de traza normal…
profiles-conflict = Belatra copia de { -brand-product-name } ha feito cambios a lo perfil. Has de reiniciar { -brand-short-name } antes de fer mas cambios.
profiles-flush-fail-title = No s'han alzau los cambios
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Una error inesperada ha privau que los cambios fuesen alzaus.
profiles-flush-restart-button = Reiniciar { -brand-short-name }
# Variables:
#   $name (String) - Name of the profile
profiles-name = Perfil: { $name }
profiles-is-default = Perfil por defecto
profiles-rootdir = Directorio radiz
# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Directorio local
profiles-current-profile = Iste ye lo perfil en uso y no se puet borrar.
profiles-in-use-profile = Este perfil lo ye usando belatra aplicación y no se puede borrar.
profiles-rename = Renombrar
profiles-remove = Borrar
profiles-set-as-default = Fixar como perfil por defecto
profiles-launch-profile = Lanzar lo perfil en un nuevo navegador
profiles-cannot-set-as-default-title = No se puet establir per defecto
profiles-cannot-set-as-default-message = Lo perfil por defecto no se puet cambiar pa { -brand-short-name }.
profiles-yes = sí
profiles-no = no
profiles-rename-profile-title = Renombrar lo Perfil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Renombrar lo perfil { $name }
profiles-invalid-profile-name-title = Nombre de perfil invalido
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Lo nombre de perfil "{ $name }" no ye permitiu.
profiles-delete-profile-title = Borrar o perfil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Si borra un perfil se borra lo perfil d'a lista de perfils disponibles, y ixo no se puede desfer.
    Tamién puet borrar los fichers de datos d'o perfil, incluyindo los achustes, certificaus y atros datos d'usuario. Ista opción borrará la carpeta "{ $dir }" y no se puede desfer.
    Querría borrar los fichers dadatos d'o perfil?
profiles-delete-files = Borrar los fichers
profiles-dont-delete-files = No borrar los fichers
profiles-delete-profile-failed-title = Error
profiles-delete-profile-failed-message = I ha habiu una error mientres se miraba de borrar este perfil.
profiles-opendir =
    { PLATFORM() ->
        [macos] Amostrar en Finder
        [windows] Ubrir la carpeta
       *[other] Ubrir lo directorio
    }
