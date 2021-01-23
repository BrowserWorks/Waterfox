# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Profili
profiles-subtitle = Šī lapa palīdz pārvaldīt profilus. Katrs profils ir neatkarīga pasaule ar savu vēsturi, grāmatzīmēm, iestatījumiem un papildinājumiem.
profiles-create = Izveidot jaunu profilu
profiles-restart-title = Pārstartēt
profiles-restart-in-safe-mode = Pārstartēt ar deaktivētiem papildinājumiem…
profiles-restart-normal = Pārstartēt parasti…

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profils: { $name }
profiles-is-default = Noklusētais profils
profiles-rootdir = Saknes mape

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Lokālā mape
profiles-current-profile = Šis profils šobrīd tiek izmantots, tāpēc to nevar izdzēst.
profiles-in-use-profile = Šis profils tiek lietots citā programmā, un to nevar dzēst.

profiles-rename = Pārsaukt
profiles-remove = Aizvākt
profiles-set-as-default = Iestatīt kā noklusēto profilu
profiles-launch-profile = Atvērt profilu jaunā pārlūkā

profiles-yes = jā
profiles-no = nē

profiles-rename-profile-title = Pārdēvēt profilu
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Pārdēvēt profilu { $name }

profiles-invalid-profile-name-title = Nederīgs profila nosaukums
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Profila nosaukums "{ $name }" nav atļauts.

profiles-delete-profile-title = Dzēst profilu
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Profila dzēšana neatgriežami aizvāks to no pieejamo profilu saraksta.
    Jūs varat izvēlēties izdzēst arī profila datu failus, kas satur jūsu iestatījumus, sertifikātus un citus lietotāja datus. Šī iespēja neatgriezeniski izdzēsīs mapi "{ $dir }".
    Vai vēlaties izdzēst profila datu failus?
profiles-delete-files = Dzēst failus
profiles-dont-delete-files = Nedzēst failus

profiles-delete-profile-failed-title = Kļūda
profiles-delete-profile-failed-message = Kļūda mēģinot dzēst profilu.


profiles-opendir =
    { PLATFORM() ->
        [macos] Parādīt Finder
        [windows] Atvērt mapi
       *[other] Atvērt mapi
    }
