# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Profila veidošanas vednis
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Ievads
       *[other] Laipni lūdzam { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } saglabā jūsu iestatījumus un izvēles jūsu personīgajā profilā.

profile-creation-explanation-2 = Ja { -brand-short-name } izmanto vairāki lietotāji, iespējams izmantot profilus, kas ļauj glabāt katra lietotāja informāciju atsevišķi. Lai to izdarītu, katram lietotājam ir jāizveido savs profils.

profile-creation-explanation-3 = Ja jūs esat vienīgā persona, kas lieto šo { -brand-short-name } kopiju, jums ir jābūt vismaz vienam profilam. Ja vēlaties, varat radīt sev vairākus profilus, lai saglabātu dažādas iestatījumu un izvēļu kopas. Piemēram, jūs varētu vēlēties vienu profilu darbam un citu personīgai lietošanai.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Lai sāktu profila izveidi, spiediet pogu Uz priekšu.
       *[other] Lai sāktu profila izveidi, spiediet pogu Uz priekšu.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Noslēgums
       *[other] Pabeidz { create-profile-window.title }
    }

profile-creation-intro = Izveidojot vairākus profilus, tos var atšķirt pēc nosaukumiem. Profila nosaukumu varat izvēlēties vai izmantot piedāvāto.

profile-prompt = Ievadiet jaunu profila nosaukumu:
    .accesskey = e

profile-default-name =
    .value = Noklusētais lietotājs

profile-directory-explanation = Jūsu iestatījumi, izvēles un citi lietotāja dati tiks saglabāti:

create-profile-choose-folder =
    .label = Izvēlēties mapi...
    .accesskey = I

create-profile-use-default =
    .label = Lietot noklusēto mapi
    .accesskey = u
