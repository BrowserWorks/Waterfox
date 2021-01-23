# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = To'onel richin kinuk'ik taq ruwäch b'i'aj
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Nab'ey taq tzij
       *[other] Ütz apetik pa { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } nuyäk etamab'äl pa ruwi' ri anuk'ulem chuqa' awajowab'äl pa ri ruwäch ab'i'.

profile-creation-explanation-2 = We nakomonij re ruwachib'äl { -brand-short-name } kik'in ch'aqa' chik taq winäq, yatikïr ye'awokisaj taq ruwäch b'i'aj richin chi ejachon ri ketamab'al jujun taq winäq. Ruma ri', chi kijujunal ri winaqi' nikinük' ruwäch kib'i'.

profile-creation-explanation-3 = We rat ayonil nawokisaj re ruwachib'al { -brand-short-name }, k'o chi k'o jun ruwäch ab'i'. We nawajo', yatikïr ye'anük' jalajöj chi kiwäch taq b'i'aj richin ye'ayák kan jalajöj taq nuk'ulem chuqa' taq ajowab'äl. Achi'el, jun ruwäch b'i'aj xa xe awichin chuqa' jun chik richin pan asamaj.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Tapitz'a' pa Tichap chik el richin natikirisaj nanük' ruwäch ab'i'.
       *[other] Tapitz'a' pa Jun chik richin natikirisaj nanük' ruwäch ab'i'.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Ruk'isib'äl taq tzij
       *[other] Tajin nitz'aqatisäx ri { create-profile-window.title }
    }

profile-creation-intro = We ye'anük' k'ïy taq ruwäch b'i'aj, yatikïr naya' ketal ruma ri kib'i'. Yatikïr natz'ib'aj rub'i' achi'el re' chuqa' natz'ib'aj jun chik.

profile-prompt = Tatz'ib'aj rub'i' ri k'ak'a' ruwäch b'i'aj:
    .accesskey = T

profile-default-name =
    .value = Winäq ri ruk'amon wi pe

profile-directory-explanation = Ri anuk'ulem winäq, taq ajowab'äl chuqa' ch'aqa' chik taq tzij pa ruwi' ri winäq xkeyak pa:

create-profile-choose-folder =
    .label = Ticha' yakwuj…
    .accesskey = T

create-profile-use-default =
    .label = Tokisäx ri yakwuj ri ruk'amon wi pe
    .accesskey = o
