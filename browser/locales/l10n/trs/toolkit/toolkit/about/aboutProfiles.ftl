# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Rayi'î nej perfîl
profiles-subtitle = Pajinâ na ruguñu'unj da' ga'ue girit si perfîlt. Da' go'ngo perfîl huin 'ngo yumiguìi, 'ngo nuguan'an, 'ngo markador, ni a'ngô nga nej sa huaa.
profiles-create = Giri 'ngo perfîl nakàa
profiles-restart-title = Nayi'ì ñû
profiles-restart-in-safe-mode = Nayi'ì ñû ngà nej komplementô ngà ga'nèjt...
profiles-restart-normal = Nayi'ì chre...
profiles-conflict = A'ngô ñadu'ua { -brand-product-name } nadunâ sa hua riña perfîl. Da'uìt dunayi'ìt { -brand-short-name } asìj gàchin nadunat sa màn riñanj.
profiles-flush-fail-title = Nu nañù sà' sa nadunât
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Hua 'ngo sa gire' ni na'ue ga'nïn na'nïnj sà't sa nadunât.
profiles-flush-restart-button = Nayi'ì nakà { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = perfîl: { $name }
profiles-is-default = Perfil nga hua niñaa
profiles-rootdir = Direktoriô sinii

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Direktoriô nichrùn'un
profiles-current-profile = Sa arâj sunt huin perfîl na ni si ga'ue narè'ej
profiles-in-use-profile = Hua a'ngô riña aplikasiûn hua ni'nïnj perfil nan ni si ga'ue narè'ej

profiles-rename = Nachrun nakà si yugui
profiles-remove = Guxūn
profiles-set-as-default = Nachrun man gahuin man perfil ginù yitïnj ïn
profiles-launch-profile = Nachrun perfil riña nabegador nakàa

profiles-cannot-set-as-default-title = Na'ue nagi'ia sa huaa
profiles-cannot-set-as-default-message = Sa ngà 'na' niñaa na'ue nadunaj rayi'î { -brand-short-name }.

profiles-yes = ga'ue
profiles-no = si ga'ue

profiles-rename-profile-title = Naduna si yugui perfîl
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Naduna si yugui perfîl { $name }

profiles-invalid-profile-name-title = Na'ue nada'aj si yugui perfîl
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Si yugui perfil “{ $name }” nu a'nïn ginun.

profiles-delete-profile-title = Nadure' Perfil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm = Si nadurê't 'ngo perfîl riña dukuàn 'na' nej perfîl ni si ga'ue nahuin sà' ñunj ngà'.  Si ruhuât ni ga'ue nadurê't nej archibô 'na' nej si nuguàn' perfîl, si configurasiônj, sertificado ni a'ngô gà' nuguan hua riña yi'ij. Opsiôn na nadure' karpetâ "{ $dir }" ni si ga'ue nahuin sà'aj ngà'. Ruhuât nadurê't nej archibô 'na' nej si nuguàn' perfîl aj.
profiles-delete-files = Nadure' nej archîbo
profiles-dont-delete-files = Si nadurê't nej archîbo

profiles-delete-profile-failed-title = Gahui a'nanj
profiles-delete-profile-failed-message = Hua 'ngo sa gahui a'nan' nga gayi'ìt nadurê't perfîl nan.


profiles-opendir =
    { PLATFORM() ->
        [macos] Digan riña Finder
        [windows] Na'nïn karpeta
       *[other] Direktorio hua ni'nïnj ïn
    }
