# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Profilio kūrimo vediklis
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Pradžia
       *[other] Sveiki! Čia { create-profile-window.title }
    }

profile-creation-explanation-1 = Informacija apie „{ -brand-short-name }“ nuostatas, tinklaviečių adresynas, laiškai ir t. t. laikoma asmeniniuose profiliuose.

profile-creation-explanation-2 = Jeigu šia „{ -brand-short-name }“ kopija naudojatės ne vienas, kiekvienas galite turėti savo profilį su sava informacija. Tam reikia, kad kiekvienas naudotojas susikurtų savo profilį.

profile-creation-explanation-3 = Jeigu „{ -brand-short-name }“ naudojatės vienas, turite turėti bent vieną profilį. Galite sukurti ir daugiau profilių ir juose laikyti skirtingas nuostatas. Pavyzdžiui, vienas profilis gali būti skirtas darbui, kitas – laisvalaikiui.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Naujas profilis pradedamas kurti spustelėjus mygtuką „Tęsti“.
       *[other] Naujas profilis pradedamas kurti spustelėjus mygtuką „Toliau“.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Pabaiga
       *[other] Baigiama: { create-profile-window.title }
    }

profile-creation-intro = Jeigu turite kelis profilius, juos atskirsite pagal vardus. Galite pasirinkti čia pateiktą vardą arba surinkti kitą.

profile-prompt = Surinkite naujo profilio vardą:
    .accesskey = S

profile-default-name =
    .value = Numatytasis naudotojas

profile-directory-explanation = Jūsų nuostatos ir kita profilio informacija bus laikomi šiame aplanke:

create-profile-choose-folder =
    .label = Parinkti aplanką…
    .accesskey = r

create-profile-use-default =
    .label = Naudoti numatytąjį
    .accesskey = N
