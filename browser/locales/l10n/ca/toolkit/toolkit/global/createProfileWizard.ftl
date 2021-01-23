# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Auxiliar per a la creació de perfils
    .style = width: 47em; height: 35em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introducció
       *[other] Benvinguts al { create-profile-window.title }
    }

profile-creation-explanation-1 = El { -brand-short-name } emmagatzema informació sobre els vostres paràmetres i preferències en el vostre perfil personal.

profile-creation-explanation-2 = Si esteu compartint aquesta còpia del { -brand-short-name } amb altres usuaris, podeu utilitzar els perfils per mantenir separada la informació de cadascun dels usuaris. Per fer-ho, cada usuari o usuària hauria de crear el seu propi perfil.

profile-creation-explanation-3 = Si sou l'única persona que utilitza aquesta còpia del { -brand-short-name } heu de tenir com a mínim un perfil. Si voleu, podeu crear diversos perfils per emmagatzemar-hi diferents preferències i paràmetres de configuració. Per exemple, potser us agradaria tenir un perfil per a la feina i un altre per a ús personal.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Per començar a crear el vostre perfil, feu clic a Continua.
       *[other] Per començar a crear el vostre perfil, feu clic a Endavant.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Conclusió
       *[other] S'està acabant el { create-profile-window.title }
    }

profile-creation-intro = Si creeu diferents perfils, podeu distingir-los pel seu nom de perfil. Podeu utilitzar el nom que es proporciona aquí o un de personalitzat.

profile-prompt = Introduïu un nom per al nou perfil:
    .accesskey = e

profile-default-name =
    .value = Usuari per defecte

profile-directory-explanation = Els vostres paràmetres, preferències i altres dades d'usuari s'emmagatzemaran a:

create-profile-choose-folder =
    .label = Trieu una carpeta…
    .accesskey = c

create-profile-use-default =
    .label = Utilitza la carpeta per defecte
    .accesskey = U
