# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Amarag n tmerna n umaɣnu
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Tazwart
       *[other] Ansuf yis-k ɣeṛ { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } ad igber talɣut n iɣewwaṛen n yismenyifen-ik deg umaɣnu-ik udmawan.

profile-creation-explanation-2 = Ma yella tebḍiḍ anɣel-agi n { -brand-short-name } akked iseqdacen-nniḍen, tzemreḍ ad tesqedceḍ imeɣna akken ad tǧeḍ talɣut n yal aseqdac iman-is. I waya, Issefk yal aseqdac ad yernu ameɣnu-ines.

profile-creation-explanation-3 = Ma telliḍ s yiman-ik kan i tessaqdaceḍ anɣel-agi n { -brand-short-name }, issefk ihi ɣersum ad yili ɣur-k yiwen umaɣnu. Ma tebɣiḍ, tzemreḍ ad ternuḍ imeɣna-nniḍen i keč. Amedya, izmer ad tesɛuḍ imaɣna imgaraden i weseqdec udmawan neɣ asedri.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Akken ad tebduḍ timerna n umaɣnu-inek, sit ɣef Ɣer-zdat.
       *[other] Akken ad tebduḍ timerna n umaɣnu-inek, sit ɣef Ɣer-zdat.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Tagrayt
       *[other] { create-profile-window.title } - Immed
    }

profile-creation-intro = Ma terniḍ imeɣna, tzemreḍ ad ten-tsemgiredeḍ s yisem. Tzemreḍ ad tesqedceḍ isem i d-ittusumren neɣ fren isem s yiman-ik.

profile-prompt = Sekcem isem amaynut n umaɣnu
    .accesskey = k

profile-default-name =
    .value = Aseqdac  amezwer

profile-directory-explanation = Iɣewwaṛen-ik n useqdac, isemnyifen akked isefka-inek usligen ad ttwakelsen maṛṛa di:

create-profile-choose-folder =
    .label = Fren akaram…
    .accesskey = F

create-profile-use-default =
    .label = Seqdec akaram amezwer
    .accesskey = S
