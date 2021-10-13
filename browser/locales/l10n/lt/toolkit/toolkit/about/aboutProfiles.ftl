# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Apie profilius
profiles-subtitle = Šis tinklalapis padeda tvarkyti jūsų profilius. Kiekvienas profilis yra atskiras pasaulis su savo nuosavu naršymo žurnalu, adresynu, nuostatomis bei priedais.
profiles-create = Kurti naują profilį
profiles-restart-title = Perleisti
profiles-restart-in-safe-mode = Perleisti išjungus priedus…
profiles-restart-normal = Perleisti įprastai…
profiles-conflict = Kita „{ -brand-product-name }“ kopija atliko pakeitimus profiliams. Turite paleisti „{ -brand-short-name }“ iš naujo, kad atliktumėte daugiau pakeitimų.
profiles-flush-fail-title = Pakeitimai neįrašyti
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Netikėta klaida neleido įrašyti jūsų pakeitimų.
profiles-flush-restart-button = Perleisti „{ -brand-short-name }“

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profilis: { $name }
profiles-is-default = Numatytasis profilis
profiles-rootdir = Šakninis aplankas

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Vietinis aplankas
profiles-current-profile = Tai dabar naudojamas profilis ir jo ištrinti negalima.
profiles-in-use-profile = Šį profilį naudoja kita programa, todėl jis negali būti pašalintas.

profiles-rename = Pervadinti
profiles-remove = Pašalinti
profiles-set-as-default = Nustatyti numatytuoju profiliu
profiles-launch-profile = Paleisti profilį naujoje naršyklėje

profiles-cannot-set-as-default-title = Nepavyko padaryti numatytuoju
profiles-cannot-set-as-default-message = Numatytasis „{ -brand-short-name }“ profilis negali būti pakeistas.

profiles-yes = taip
profiles-no = ne

profiles-rename-profile-title = Pervadinti profilį
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Pervadinti profilį { $name }

profiles-invalid-profile-name-title = Netinkamas profilio vardas
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = „{ $name }“ negali būti profilio vardu.

profiles-delete-profile-title = Ištrinti profilį
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Ištrynus profilį jis bus pašalintas iš galimų profilių sąrašo ir to nebus galima atstatyti.
    Jūs taip pat galite pašalinti profilio duomenų failus, įskaitant jūsų nuostatas, liudijimus ir kitus susijusius duomenis. Pasirinkus šį būdą bus negrįžtamai pašalintas aplankas „{ $dir }“.
    Ar norite pašalinti profilio duomenų failus?
profiles-delete-files = Trinti failus
profiles-dont-delete-files = Netrinti failų

profiles-delete-profile-failed-title = Klaida
profiles-delete-profile-failed-message = Bandant pašalinti šį profilį įvyko klaida.


profiles-opendir =
    { PLATFORM() ->
        [macos] Rodyti per „Finder“
        [windows] Atverti aplanką
       *[other] Atverti aplanką
    }
