# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Ohjattu profiilin luonti
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Esittely
       *[other] Tervetuloa
    }

profile-creation-explanation-1 = { -brand-short-name } tallentaa asetuksesi ja muut tiedot henkilökohtaiseen profiilisi.

profile-creation-explanation-2 = Jos samaa { -brand-short-name }ia käyttää useampi henkilö, voit pitää jokaisen käyttäjän tiedot erillään luomalla heille nimikkoprofiilit.

profile-creation-explanation-3 = Vaikka olisit tämän { -brand-short-name }in ainoa käyttäjä, ainakin yhden profiilin täytyy silti olla luotuna. Halutessasi voit luoda useita profiileja erilaisia käyttötilanteita varten. Voit esimerkiksi luoda omat profiilit työ- ja vapaa-ajan käyttöön.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Aloita profiilin luominen valitsemalla Seuraava.
       *[other] Aloita profiilin luominen valitsemalla Seuraava.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Viimeistely
       *[other] Viimeistely
    }

profile-creation-intro = Jos luot useita profiileja, voit erotella ne nimen perusteella. Voit käyttää annettua nimeä tai keksiä oman.

profile-prompt = Anna uuden profiilin nimi:
    .accesskey = A

profile-default-name =
    .value = Oletuskäyttäjä

profile-directory-explanation = Asetukset ja muut käyttäjäkohtaiset tiedot tallennetaan kansioon:

create-profile-choose-folder =
    .label = Valitse kansio…
    .accesskey = V

create-profile-use-default =
    .label = Käytä oletuskansiota
    .accesskey = O
