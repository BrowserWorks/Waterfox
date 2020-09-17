# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Asistente de creación de perfís
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introdución
       *[other] Benvido(a) a { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } almacena información sobre a súa configuración e preferencias no seu perfil persoal.

profile-creation-explanation-2 = Se está a compartir esta copia de { -brand-short-name } con outros usuarios pode usar os perfís para manter separada a información de cada usuario. Para facer isto, cada usuario debería crear o seu propio perfil.

profile-creation-explanation-3 = Se só vai usar esta copia de { -brand-short-name } unha persoa, debe ter como mínimo un perfil, aínda que tamén pode crear varios perfís para almacenar diferentes tipos de configuracións e preferencias. Por exemplo, pode ter perfís diferentes para traballo e para uso persoal.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Para comezar a crear o seu perfil, prema Continuar.
       *[other] Para comezar a crear o seu perfil, prema Seguinte.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Conclusión
       *[other] Completar { create-profile-window.title }
    }

profile-creation-intro = Se crea diferentes perfís pode distinguilos polo seu nome. Pode usar o nome aquí definido ou outro.

profile-prompt = Introduza o nome do novo perfil:
    .accesskey = I

profile-default-name =
    .value = Usuario predeterminado

profile-directory-explanation = A configuración, preferencias e máis datos relacionados co usuario almacenarase en:

create-profile-choose-folder =
    .label = Escoller cartafol…
    .accesskey = E

create-profile-use-default =
    .label = Usar o cartafol predeterminado
    .accesskey = U
