# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Tocante a Perfiles
profiles-subtitle = Esta páxina ayúdate a xestionar los perfiles. Cada perfil ye un mundu únicu que contién l'historial, marcadores, axustes y complementos.
profiles-create = Crear un perfil nuevu
profiles-restart-title = Reaniciar
profiles-restart-in-safe-mode = Reaniciar colos complementos desactivaos…
profiles-restart-normal = Reaniciar de mou normal…

# Variables:
#   $name (String) - Name of the profile
profiles-name = Perfil: { $name }
profiles-is-default = Perfil predetermináu
profiles-rootdir = Direutoriu raigañu

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Direutoriu llocal
profiles-current-profile = Esti ye'l perfil n'usu y nun pue desaniciase.

profiles-rename = Renomar
profiles-remove = Desaniciar
profiles-set-as-default = Predeterminar perfil
profiles-launch-profile = Llanzar perfil nun restolador nuevu

profiles-yes = sí
profiles-no = non

profiles-rename-profile-title = Renomar perfil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Renomar perfil { $name }

profiles-invalid-profile-name-title = Nome non válidu de perfil
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Nun se permite'l nome de perfil «{ $name }».

profiles-delete-profile-title = Desaniciar perfil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Desaniciar un perfil va quitalu del llistáu de perfiles disponibles y nun va poder desfacese.
    Tamién podríes escoyer el desaniciu de los ficheros de datos del perfil, incluyendo los axustes, certificaos y otros datos venceyaos al usuariu. Esta opción va desaniciar la carpeta «{ $dir }» y nun va poder desfacese.
    ¿Prestaríate desaniciar los ficheros de datos del perfil?
profiles-delete-files = Desaniciar ficheros
profiles-dont-delete-files = Nun desaniciar ficheros


profiles-opendir =
    { PLATFORM() ->
        [macos] Amosar en Finder
        [windows] Abrir carpeta
       *[other] Abrir direutoriu
    }
