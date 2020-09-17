# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Yenza igcisa leprofayile
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Intshayelelo
       *[other] Wamkelekile kwi-{ create-profile-window.title }
    }

profile-creation-explanation-1 = I-{ -brand-short-name } igcina inkcazelo engeesethingi zakho neepriferensi kwiprofayile yakho.

profile-creation-explanation-2 = Ukuba wabelana ngale kopi i-{ -brand-short-name } nabanye abasebenzisi, ungasebenzisa iiprofayile ukugcina inkcazelo yomsebenzisi ngamnye ngokwahlukeneyo. Ukwenza oku, umsebenzisi ngamnye kufanele enze iprofayile yakhe.

profile-creation-explanation-3 = Ukuba nguwe kuphela osebenzisa le kopi ye-{ -brand-short-name }, kufuneka ube neprofayile enye. Ukuba uyathanda, ungazenzela iiprofayile ezininzi ukugcina iiseti ezahlukeneyo zeesethingi neepriferensi. Umzekelo, usenokufuna ukuba neeprofayile ezahlukeneyo zoshishino nezinto zakho.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Ukuqalisa ukuyila iprofayile yakho, cofa Qhubeka.
       *[other] Ukuqalisa ukuyila iprofayile yakho, cofa Okulandelayo.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Isiphelo
       *[other] Kugqitywa i-{ create-profile-window.title }
    }

profile-creation-intro = Ukuba wenza iiprofayile ezininzi ungazixelela ngokwahlukeneyo ngamagama eeprofayile. Ungasebenzisa igama elikhoyo apha okanye usebenzise elakho.

profile-prompt = Faka igama elitsha leprofayile:
    .accesskey = F

profile-default-name =
    .value = Umsebenzisi osisiseko

profile-directory-explanation = Iisethingi zomsebenzisi, iipriferensi nezinye iingcombolo zomsebenzisi ziya kugcina:

create-profile-choose-folder =
    .label = Khetha ifolda…
    .accesskey = K

create-profile-use-default =
    .label = Sebenzisa ifolda esisiseko
    .accesskey = S
