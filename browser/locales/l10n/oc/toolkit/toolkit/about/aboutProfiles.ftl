# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = A perpaus dels perfils
profiles-subtitle = Aquesta pagina vos ajuda a gerir vòstres perfils. Cada perfil es separat e conten un istoric, de marcapaginas e de moduls pròpris.
profiles-create = Crear un perfil novèl
profiles-restart-title = Reaviar
profiles-restart-in-safe-mode = Reaviar amb los moduls desactivats…
profiles-restart-normal = Reaviar normalament…
profiles-conflict = Una autra còpia de { -brand-product-name } a modificat los perfils. Vos cal reaviar { -brand-short-name } abans de far mai de modificacions.
profiles-flush-fail-title = Modificacions pas enregistradas
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Una error inesperada a empachat l’enregistrament de vòstras modificacions.
profiles-flush-restart-button = Reaviar { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Perfil : { $name }
profiles-is-default = Perfil per defaut
profiles-rootdir = Dossièr raiç

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Dossièr local
profiles-current-profile = Aqueste es lo perfil que siatz a utilizar e se pòt pas suprimir.
profiles-in-use-profile = Una autra aplicacion utiliza aqueste perfil e fa que sa supression es impossibla.

profiles-rename = Renommar
profiles-remove = Suprimir
profiles-set-as-default = Definir coma perfil per defaut
profiles-launch-profile = Lançar lo perfil dins un navegador novèl

profiles-cannot-set-as-default-title = Impossible de definir la valor per defaut
profiles-cannot-set-as-default-message = Lo perfil per defaut se pòt pas cambiar per { -brand-short-name }.

profiles-yes = òc
profiles-no = non

profiles-rename-profile-title = Renommar lo perfil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Renommar lo perfil { $name }

profiles-invalid-profile-name-title = Nom de perfil invalid
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Lo nom de perfil « { $name } » es pas valid.

profiles-delete-profile-title = Suprimir lo perfil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Suprimir un perfil lo levarà de la lista dels perfils disponibles e pòt pas èsser anullat.
    Tanben es possible de causir de suprimir los fichièrs de donadas del perfil, que comprenon vòstres paramètres, certificats e totas vòstras donadas personalas. Aquesta opcion suprimirà lo dossièr « { $dir } » e poirà pas èsser anullada.
    Desiratz suprimir los fichièrs de donadas del perfil ?
profiles-delete-files = Suprimir los fichièrs
profiles-dont-delete-files = Suprimir pas los fichièrs

profiles-delete-profile-failed-title = Error
profiles-delete-profile-failed-message = Una error s’es produita en ensajar de suprimir aqueste perfil.


profiles-opendir =
    { PLATFORM() ->
        [macos] Afichar dins lo Finder
        [windows] Dobrir lo dossièr
       *[other] Dobrir lo dossièr
    }
