# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Pri profiloj
profiles-subtitle = Tiu ĉi paĝo helpas vin administri viajn profilojn. Ĉiu profilo estas aparta mondo kiu enhavas apartajn historion, legosignojn, agordojn kaj aldonaĵojn.
profiles-create = Krei novan profilon
profiles-restart-title = Restartigi
profiles-restart-in-safe-mode = Restartigi kun malaktivigitaj aldonaĵoj…
profiles-restart-normal = Restartigi normale…
profiles-conflict = Alia kopio de { -brand-product-name } modifis la profilojn. Vi devas restartigi { -brand-short-name } antaŭ ol fari aliajn ŝanĝojn.
profiles-flush-fail-title = Ŝanĝoj ne konservitaj
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Neatendita eraro evitis la konservon de viaj ŝanĝoj.
profiles-flush-restart-button = Restartigi { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profilo: { $name }
profiles-is-default = Norma profilo
profiles-rootdir = Radika dosierujo

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Loka dosierujo
profiles-current-profile = Tiu ĉi profilo estas uzata kaj ne povas esti forigita.
profiles-in-use-profile = Tiu ĉi profilo estas uzata de alia programo kaj ne povas esti forigita.

profiles-rename = Renomi
profiles-remove = Forigi
profiles-set-as-default = Igi profilon norma
profiles-launch-profile = Lanĉi profilon en nova retumilo

profiles-cannot-set-as-default-title = Ne eblis igi ĝin norma
profiles-cannot-set-as-default-message = Ne eblas ŝanĝi la ĉefan profilon de { -brand-short-name }.

profiles-yes = jes
profiles-no = ne

profiles-rename-profile-title = Renomi profilon
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Renomi profilon { $name }

profiles-invalid-profile-name-title = Nevalida nomo de profilo
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = La nomo de profilo "{ $name }" ne estas permesata.

profiles-delete-profile-title = Forigi profilon
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Forigo de profilo estas nemalfarebla ago, kiu demetos la profilon el la listo de disponeblaj profiloj.
    Vi povas ankaŭ forigi la datumajn dosierojn de la profilo, kiuj inkluzivas agordojn, atestilojn kaj aliajn datumojn de uzanto. Tiu elekteblo forigos la dosierujon "{ $dir }" kaj ĝi ne malfareblas.
    Ĉu vi ŝatus forigi la datumajn dosierojn de la profilo?
profiles-delete-files = Forigi dosierojn
profiles-dont-delete-files = Ne forigi dosierojn

profiles-delete-profile-failed-title = Eraro
profiles-delete-profile-failed-message = Okazi eraro dum la klopodo forigi tiun ĉi profilon.


profiles-opendir =
    { PLATFORM() ->
        [macos] Montri en Finder
        [windows] Malfermi dosierujon
       *[other] Malfermi dosierujon
    }
