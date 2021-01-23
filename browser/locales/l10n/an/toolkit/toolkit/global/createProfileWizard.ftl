# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Asistent de creyación de perfils
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introducción
       *[other] Bienplegau en { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } almagazena información sobre a suya configuración y preferencias en o suyo perfil personal.

profile-creation-explanation-2 = Si ye compartiendo ista copia de { -brand-short-name } con atros usuarios, puede fer servir os perfils ta mantener deseparada a información de cadagún d'os usuarios. Ta ixo, cada usuario habría de creyar o suyo propio perfil.

profile-creation-explanation-3 = Si ye a sola persona que emplega ista copia de { -brand-short-name }, ha de tener a o menos un perfil. Si lo deseya, puede creyar multiples perfils ta almagazenar-ie diferents conchuntos de configuracions y preferencias. Por eixemplo, puestar l'aganaría tener un perfil ta la faina y unatro ta uso personal.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Ta prencipiar a creyar o suyo perfil, faiga clic en Continar.
       *[other] Ta prencipiar a creyar o suyo perfil, faiga clic en 'Enta debant'.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Conclusión
       *[other] Se ye remando o { create-profile-window.title }
    }

profile-creation-intro = Si creya distintos perfils puede distinguir-los por os suyos nombres de perfil. Puede emplegar o nombre que se proporciona aquí u trigar-ne unatro vusté mesmo.

profile-prompt = Escriba un nombre t'o nuevo perfil:
    .accesskey = e

profile-default-name =
    .value = Usuario por defecto

profile-directory-explanation = Os suyos parametros de configuración, preferencias y atros datos tocants a l'usuario s'alzarán en:

create-profile-choose-folder =
    .label = Trigar una carpeta…
    .accesskey = c

create-profile-use-default =
    .label = Usar a carpeta por defecto
    .accesskey = U
