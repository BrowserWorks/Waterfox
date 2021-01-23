# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Encontu pa crear perfiles
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introducción
       *[other] Afáyate en { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } atroxa información tocante a los tos axustes y preferencies nel perfil personal.

profile-creation-explanation-2 = Si tas compartiendo esta copia de { -brand-short-name } con otros usuarios, pues usar los perfiles pa tener separtada la información de cada usuariu. Pa facelo, cada usuariu debería crear el so perfil propiu.

profile-creation-explanation-3 = Si yes la única persona qu'usa esta copia de { -brand-short-name }, has tener polo menos un perfil. Si quies, pues crear perfile múltiples col envís d'atroxar conxuntos diferentes d'axustes y preferencies. Por exemplu, podríes querer tener perfiles separtaos pa usu personal y usu profesional.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Pa entamar a crear el perfil, primi en Siguiente.
       *[other] Pa entamar a crear el perfil, primi en Siguiente.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Conclusión
       *[other] Completando'l { create-profile-window.title }
    }

profile-creation-intro = Si crees dellos perfiles, pues estremalos polos sos nomes. Podríes usar el nome apurríu equí o usar unu de to.

profile-prompt = Introduz el nome del perfil nuevu:
    .accesskey = I

profile-default-name =
    .value = Usuariu por defeutu

profile-directory-explanation = La tos axustes d'usuariu, preferencies y otros datos venceyaos al usuariu van atroxase en:

create-profile-choose-folder =
    .label = Escoyer carpeta…
    .accesskey = E

create-profile-use-default =
    .label = Usar carpeta por defeutu
    .accesskey = U
