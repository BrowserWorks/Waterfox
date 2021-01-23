# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Yub Ladiro ma Gwoko ngec
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Nyute
       *[other] Wajoli i { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } gwoko ngec makwako terni ki gin ma imaro i yi kagwoko gin makwaki.

profile-creation-explanation-2 = Ka itye ka leyo gin acoya man { -brand-short-name } ki jo mukene, in itwero tic ki gin makwako in pi gwoko tic pa ngat acelacel patpat. Me timo man, ngat acelacel omyero oyub katice kene.

profile-creation-explanation-3 = Ka in keken aye itye ka tic ki gin acoya man { -brand-short-name }, omyero ibed ki gin acel mo. Ka imaro, in itwero cweyo katici mapol piri me kano tera ki gin ma imaro. Labole, itwero mito bedo ki gin atimani piri keni.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Me cako yubo katici, dii Mede anyim.
       *[other] Me cako yubo katici, dii mukene.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Dolo tere
       *[other] Tyeko { create-profile-window.title }
    }

profile-creation-intro = Ka iyubo katic mapol itwero poko kingi mapat pat malube ki nyingi. Bene itwereo tic ki nying ma kimiyo kanyi onyo ma imiyo.

profile-prompt = Ket nying katic manyen:
    .accesskey = K

profile-default-name =
    .value = Latic kit ma onongo tye kwede

profile-directory-explanation = Ter me ticii, gin ma i maro ki coc mukene ma cal-cal bino gwoke iyie:

create-profile-choose-folder =
    .label = Yer Boc…
    .accesskey = Y

create-profile-use-default =
    .label = Tii ki Boc Matye
    .accesskey = T
