# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = A proposito del profilos
profiles-subtitle = Iste pagina te adjuta gerer tu profilos. Cata profilo es un mundo separate que contine chronologia, marcapaginas, parametros e additivos separate.
profiles-create = Crear un nove profilo
profiles-restart-title = Reinitiar
profiles-restart-in-safe-mode = Reinitiar con le additivos inactive…
profiles-restart-normal = Reinitiar normalmente…
profiles-conflict = Un altere copia de { -brand-product-name } ha facite cambios al profilos. Tu debe reinitiar { -brand-short-name } ante que facer altere cambios.
profiles-flush-fail-title = Cambios non salvate
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Un error impreviste ha impedite le salvamento de tu cambios.
profiles-flush-restart-button = Reinitiar { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profilo: { $name }
profiles-is-default = Profilo predefinite
profiles-rootdir = Directorio radice

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Directorio local
profiles-current-profile = Iste profilo es in uso e non pote esser delite.
profiles-in-use-profile = Iste profilo es in uso in un altere application e non pote esser delite.

profiles-rename = Renominar
profiles-remove = Remover
profiles-set-as-default = Marcar como profilo predefinite
profiles-launch-profile = Lancear le profilo in un nove navigator

profiles-cannot-set-as-default-title = Impossibile configurar le parametros
profiles-cannot-set-as-default-message = Le profilo predefinite non pote ser cambiate pro { -brand-short-name }.

profiles-yes = si
profiles-no = no

profiles-rename-profile-title = Renominar le profilo
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Renominar le profilo { $name }

profiles-invalid-profile-name-title = Nomine de profilo invalide
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Le nomine de profilo “{ $name }” non es permittite.

profiles-delete-profile-title = Deler le profilo
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Deler un profilo lo removera del lista de profilos e es irreversibile.
    Tu pote etiam optar pro deler le files del profilo, incluse tu parametros, certificatos e altere datos personal. Iste option destruera le dossier “{ $dir }” e es irreversibile.
    Vole tu deler le files de datos del profilo?
profiles-delete-files = Deler files
profiles-dont-delete-files = Non deler le files

profiles-delete-profile-failed-title = Error
profiles-delete-profile-failed-message = Il ha essite un error durante le tentativa a deler ista profilo.


profiles-opendir =
    { PLATFORM() ->
        [macos] Monstrar in Finder
        [windows] Aperir le dossier
       *[other] Aperir le directorio
    }
