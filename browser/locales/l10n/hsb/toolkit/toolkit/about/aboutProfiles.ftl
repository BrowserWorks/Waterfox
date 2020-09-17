# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Wo profilowach
profiles-subtitle = Tuta strona wam pomha, waše profile rjadować. Kóždy profil je wosebity swět, kotryž wosebitu historiju, wosebite zapołožki, nastajenja a přidatki wobsahuje.
profiles-create = Nowy profil załožić
profiles-restart-title = Znowa startować
profiles-restart-in-safe-mode = Ze znjemóžnjenymi přidatkami startować…
profiles-restart-normal = Normalnje znowa startować…
profiles-conflict = Druha kopija { -brand-product-name } je změny na wašich profilach přewjedła. Dyrbiće { -brand-short-name } znowa startować, prjedy hač dalše změny přewjedźeće.
profiles-flush-fail-title = Změny njejsu so składowali
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Njewočakowany zmylk je składowanju wašich změnow zadźěwał.
profiles-flush-restart-button = { -brand-short-name } znowa startować

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profil: { $name }
profiles-is-default = Standardny profil
profiles-rootdir = Korjenjowy zapis

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Lokalny zapis
profiles-current-profile = Tutón profil so runje wužiwa a njeda so zhašeć.
profiles-in-use-profile = Tutón profil so přez druhe nałoženje wužiwa a njeda so zhašeć.

profiles-rename = Přemjenować
profiles-remove = Wotstronić
profiles-set-as-default = Jako standardny profil nastajić
profiles-launch-profile = Profil w nowym wobhladowaku startować

profiles-cannot-set-as-default-title = Standard njeda so nastajić
profiles-cannot-set-as-default-message = Standardny profil njeda so za { -brand-short-name } změnić.

profiles-yes = haj
profiles-no = ně

profiles-rename-profile-title = Profil přemjenować
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Profil { $name } přemjenować

profiles-invalid-profile-name-title = Njepłaćiwe profilowe mjeno
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Profilowe mjeno "{ $name }" njeje dowolene.

profiles-delete-profile-title = Profil zhašeć
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Hašenje profila wotstroni profil z lisćiny k dispoziciji stejacych profilow a njeda so anulować.
    Móžeće tež dataje z profilowymi datami zhašeć, inkluziwnje waše nastajenja, certifikaty a druhe daty, kotrež so na wužiwarja poćahuja. Tute nastajenje rjadowak "{ $dir }" zhaša a njeda so anulować.
    Chceće dataje z profilowymi datami zhašeć?
profiles-delete-files = Dataje zhašeć
profiles-dont-delete-files = Dataje njezhašeć

profiles-delete-profile-failed-title = Zmylk
profiles-delete-profile-failed-message = Při pospyće tutón profil zhašeć je zmylk wustupił.


profiles-opendir =
    { PLATFORM() ->
        [macos] W Finder pokazać
        [windows] Rjadowak wočinić
       *[other] Zapis wočinić
    }
