# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Asistanto de kreado de profilo
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Enkonduko
       *[other] Bonvenon al { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } konservas informon pri viaj agordoj kaj preferoj en via persona dosiero.

profile-creation-explanation-2 = Se vi dividas tiun ĉi kopion de { -brand-short-name } kun aliaj uzantoj vi povas uzi profilojn por teni aparte la informon de ĉiu uzanto. Se vi faras tion ĉiu uzanto devus krei sian propran profilon.

profile-creation-explanation-3 = Se vi estas la ununura persono kiu uzas tiun ĉi kopion de { -brand-short-name } vi devas almenaŭ havi unu profilon. Se vi volas, vi povas krei malsamajn profilojn por vi mem, por konservi malsamajn arojn de agordoj kaj preferoj. Ekzempe, vi eble volas havi du apartajn profilojn por negoca kaj persona uzado.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Por komenci la kreadon de via profilo alklaku Daŭrigi.
       *[other] Por eki la kreadon de via profilo alklaku Sekvanta.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Konkludo
       *[other] Kompletigado de { create-profile-window.title }
    }

profile-creation-intro = Se vi kreas multajn profilojn vi povas identigi ilin pere de la nomoj de la profiloj.  Vi povas uzi la donitan nomon aŭ elekti propran.

profile-prompt = Tajpu novan nomon por profilo:
    .accesskey = T

profile-default-name =
    .value = Ĉefa uzanto

profile-directory-explanation = Viaj agordoj, preferoj kaj aliaj datumoj rilataj estos konservitaj en:

create-profile-choose-folder =
    .label = Elekti dosierujon…
    .accesskey = E

create-profile-use-default =
    .label = Uzi normalan dosierujon
    .accesskey = U
