# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Sa rugûñun’ūnj da’ girī’ ‘ngō perfil
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Nuguan' tàj ñaan
       *[other] Guruhuât gunumânt riña { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } nachra sà’ nuguan’ huā dàj nagi’iát riña perfil arâj sunt.

profile-creation-explanation-2 = Ñadu’ua { -brand-short-name } da’a a’ngô da’āj nej duguî’ aché nuun arâj sun nej si, ga’ue gārasunt ga’ì perfil da’ gā da’ go’ngō si perfil nej si. Guendâ dan nī, da’ go’ngō nej si da’ui giri si perfil nej si.

profile-creation-explanation-3 = Si ‘ngō rïnt huin sa arâj sun ñadu’ua { -brand-short-name }, da’ui gā nùhuin si ‘iô’ si ‘ngō rïn perfil. Si ruhuât nī, ga’ue girīt ga’ì perfil da’ gahuînt da’ nachrât sà’t sa huin ruhuât nī dàj gaj ruhuât. Dàj rû’, ga’ue gā ‘ngō perfil ganikājt guendâ gudu’uēt sa gudu’uēt nī a’ngoj da’ gārasunt ngà a’ngô sa huāa.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Da’ gayi’ìt girīt perfil nī, guru’man ra’a Guij Ne’ ñāan.
       *[other] Da’ gayi’ìt girīt perfil nī, guru’man ra’a Ne’ ñāan.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Nuguan' nahuij
       *[other] Hìaj dusìj man { create-profile-window.title }
    }

profile-creation-intro = Sisī ruhuât girīt ga’ì perfil nī, ga’ue nani’înt nej man ngà si yugui da’ go’ngō man. Ga’ue gārasunt si yugui nùn hiuj nan asi girīt a’ngoj.

profile-prompt = Gachrūn si yugui perfil nakàa:
    .accesskey = E

profile-default-name =
    .value = Usuario nū yitïnj ïn

profile-directory-explanation = Nej sa nagi’iát riña usuario, sa nihià’ ruhuât doj nī a’ngô nej nuguan’ nikāj digui’ ngà man nachra sà’ riña:

create-profile-choose-folder =
    .label = Naguī ñanj…
    .accesskey = C

create-profile-use-default =
    .label = Garasun ñanj nū yitïnj ïn
    .accesskey = U
