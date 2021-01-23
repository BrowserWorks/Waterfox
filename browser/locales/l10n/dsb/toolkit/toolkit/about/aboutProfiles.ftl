# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Wó profilowach
profiles-subtitle = Toś ten bok wam pomaga, waše profile zastojaś. Kuždy profil jo wósebny swět, kótaryž wopśimujo wósebnu historiju, wósebne cytańske znamjenja, nastajenja a dodanki.
profiles-create = Nowy profil załožyś
profiles-restart-title = Znowego startowaś
profiles-restart-in-safe-mode = Ze znjemóžnjonymi dodankami znowego startowaś…
profiles-restart-normal = Normalnje znowego startowaś…
profiles-conflict = Druga kopija { -brand-product-name } jo pśewjedła změny na wašych profilach. Musyśo { -brand-short-name } znowego startowaś, nježli až dalšne změny pśewjedujośo.
profiles-flush-fail-title = Změny njejsu se składli
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Njewótcakana zmólka jo składowanjeju wašych změnow zajźował.
profiles-flush-restart-button = { -brand-short-name } znowego startowaś

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profil: { $name }
profiles-is-default = Standardny profil
profiles-rootdir = Kórjenjowy zapis

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Lokalny zapis
profiles-current-profile = Toś ten profil se rowno wužywa a njedajo se wulašowaś.
profiles-in-use-profile = Toś ten profil se pśez druge nałoženje wužywa a njedajo se wulašowaś.

profiles-rename = Pśemjeniś
profiles-remove = Wótpóraś
profiles-set-as-default = Ako standardny profil nastajiś
profiles-launch-profile = Profil w nowem wobglědowaku startowaś

profiles-cannot-set-as-default-title = Standard njedajo se nastajiś
profiles-cannot-set-as-default-message = Standardny profil njedajo se za { -brand-short-name } změniś.

profiles-yes = jo
profiles-no = ně

profiles-rename-profile-title = Profil pśemjeniś
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Profil { $name } pśemjeniś

profiles-invalid-profile-name-title = Njepłaśiwe profilowe mě
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Profilowe mě „{ $name }“ njejo dowólone.

profiles-delete-profile-title = Profil wulašowaś
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Lašowanje profila wótpórajo profil z lisćiny k dispoziciji stojecych profilow a njedajo se anulěrowaś.
    Móžośo teke dataje z profilowymi datami lašowaś, inkluziwnje waše nastajenja, certifikaty a druge daty, kótarež pósěguju se na wužywarja. Toś ta opcija buźo zarědnik „{ $dir }“ lašowaś a njedajo se anulěrowaś.
    Cośo dataje z profilowymi datami lašowaś?
profiles-delete-files = Dataje lašowaś
profiles-dont-delete-files = Dataje njelašowaś

profiles-delete-profile-failed-title = Zmólka
profiles-delete-profile-failed-message = Pśi wopyśe toś ten profil wulašowaś jo zmólka nastała.


profiles-opendir =
    { PLATFORM() ->
        [macos] W Finder pokazaś
        [windows] Zarědnik wócyniś
       *[other] Zarědnik wócyniś
    }
