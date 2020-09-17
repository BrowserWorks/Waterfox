# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Alhaaley ga
profiles-subtitle = Moɲoo woo ga war gaa ka war alhaaley juwal. Alhaali foo kul ti ganda fayante kaŋ goo nda taariki fayante ga bara, doo-šilbay, kayandiyan nda tontoni fayanteyaŋ.
profiles-create = Alhaali taaga tee
profiles-restart-title = Tunandi taaga
profiles-restart-in-safe-mode = Tunandi taaga kaŋ tontoney kayandi…
profiles-restart-normal = Tunandi taaga sanda waatikul

# Variables:
#   $name (String) - Name of the profile
profiles-name = Alhaali: { $name }
profiles-is-default = Tilasu alhali
profiles-rootdir = Linji fooloɲaa

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Gorodoo fooloɲaa
profiles-current-profile = Alhaali ti woo kaŋ goo goy ra, a ši hin ka tuusandi.

profiles-rename = Maa barmay
profiles-remove = Kaa
profiles-set-as-default = Kayandi sanda tilasu alhali
profiles-launch-profile = Alhaaloo tunandi ceecikaw taaga ra

profiles-yes = ayyo
profiles-no = kalaa

profiles-rename-profile-title = Alhaali maa barmay
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = { $name } alhaali maa barmay

profiles-invalid-profile-name-title = Alhaali maa laybante
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = "{ $name }" alhaali maaɲoo ši duu fondo.

profiles-delete-profile-title = Alhaaloo tuusu
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Alhaali foo tuusuyanoo ga alhaaloo kaa maašeedaa ra, kaŋ banda ga a ši hin ka taafeeri.
    War ga hin ka suuba k'alhaali bayhaya tukey tuusu, kaŋyaŋ ti war kayandiyaney, tabatiyan-tiirawey nda goy-mise bayhaya tana. Suubaroo woo ga "{ $dir }" foolaa tuusu nd'a ši hin ka taafeeri.
    War ga baa war ma alhaali bayhaya tukey tuusu wala?
profiles-delete-files = Tukey tuusu
profiles-dont-delete-files = Ma ši tukey tuusu


profiles-opendir =
    { PLATFORM() ->
        [macos] Cebe ceecikoy ra
        [windows] Foolo feeri
       *[other] Fooloɲaa feeri
    }
