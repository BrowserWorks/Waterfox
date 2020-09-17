# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Proçedua goidâ pe creâ o profî
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introduçion
       *[other] Benvegnuo into { create-profile-window.title }
    }

profile-creation-explanation-1 = O { -brand-short-name } o sarva informançioin de teu preferense e inpostançioin into teu profî.

profile-creation-explanation-2 = Se ti ti uzi sta còpia de { -brand-short-name } con atre personn-e ti peu uzâ i profî pe tegnî e informaçioin separæ. Pe fâ coscì ògnidun deve creâ o seu profî.

profile-creation-explanation-3 = Se ti t'ê a sola personn-a che adeuvia sta còpia de { -brand-short-name }, ti devi avei armeno un profî. Se t'eu, ti peu creâ ciù profî pe sarvâ diverse preferense. Pe ezenpio ti peu avei un profî pe-i afari e un pe uzo personale.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Pe iniçiâ a creâ o teu profî, sciacca Continoa.
       *[other] Pe iniçiâ a creâ o teu profî, sciacca Pròscimo.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Fin
       *[other] Finiscio o { create-profile-window.title }
    }

profile-creation-intro = Se ti ti crei tanti profî ti peu dagghe un nomme pe deuviali. Ti peu uzâ sto nomme o ti peu crealo ti.

profile-prompt = Inserisci o nomme do neuvo profî:
    .accesskey = e

profile-default-name =
    .value = Utilizatô predefinio

profile-directory-explanation = E teu inpostaçioin e preferense saian sarvæ chi:

create-profile-choose-folder =
    .label = Çerni cartella…
    .accesskey = c

create-profile-use-default =
    .label = Adeuvia cartella predefinia
    .accesskey = z
