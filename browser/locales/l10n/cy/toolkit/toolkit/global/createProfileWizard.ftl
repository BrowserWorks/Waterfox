# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Creu Proffil Dewin
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Cyflwyniad
       *[other] Croeso i { create-profile-window.title }
    }

profile-creation-explanation-1 = Mae { -brand-short-name } yn storio gwybodaeth am eich gosodiadau a'ch dewisiadau yn eich proffil personol.

profile-creation-explanation-2 = Os ydych yn rhannu'r copi o { -brand-short-name } gyda defnyddwyr eraill, mae modd defnyddio proffiliau i gadw gwybodaeth eich gilydd ar wahân. I wneud hyn, dylai pob defnyddiwr greu ei broffil ei hun.

profile-creation-explanation-3 = Os mai chi yw'r unig berson sy'n defnyddio'r copi o { -brand-short-name }, rhaid i chi gael o leiaf un proffil. Os hoffech chi mae modd creu proffiliau niferus er mwyn cadw gosodiadau a dewisiadau i chi eich hun. Er enghraifft, efallai yr hoffech chi gael proffil gwahanol ar gyfer defnydd busnes neu bersonol.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] I gychwyn creu eich proffil, cliciwch Ymlaen.
       *[other] I gychwyn creu eich proffil, cliciwch Nesaf.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Diweddglo
       *[other] Cwblhau { create-profile-window.title }
    }

profile-creation-intro = Os ydych yn creu nifer o broffiliau mae modd eu gwahaniaethu wrth enw'r proffil. Mae modd defnyddio'r enw sy'n cael ei ddarparu yma neu enw eich hun.

profile-prompt = Rhowch enw proffil newydd:
    .accesskey = e

profile-default-name =
    .value = Defnyddiwr Rhagosodedig

profile-directory-explanation = Bydd eich gosodiadau defnyddiwr, dewisiadau a data arall sy'n perthyn i ddefnyddiwr yn cael ei gadw yn:

create-profile-choose-folder =
    .label = Dewis Ffolder…
    .accesskey = D

create-profile-use-default =
    .label = Defnyddio'r Ffolder Rhagosodedig
    .accesskey = R
