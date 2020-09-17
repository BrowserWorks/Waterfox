# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Profila sortzeko morroia
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Sarrera
       *[other] Ongi etorri { create-profile-window.title }-(e)ra
    }

profile-creation-explanation-1 = { -brand-short-name }(e)k zure ezarpen eta hobespenak gordetzen ditu profil pertsonalean.

profile-creation-explanation-2 = { -brand-short-name }(r)en kopia hau beste erabiltzaile batzuekin partekatzen ari bazara, profilak erabil ditzakezu erabiltzaile bakoitzaren datuak bereizita gordetzeko. Hau egiteko erabiltzaile bakoitzak bere profila sortu behar du.

profile-creation-explanation-3 = { -brand-short-name } kopia hau erabiltzen duen pertsona bakarra bazara, behintzat profil bat eduki behar duzu. Nahi izanez gero profil bat baino gehiago erabil ditzakezu ezarpen eta hobespen desberdinak erabiltzeko. Adibidez, profil bat erabilera pertsonalerako eta beste bat lanerako.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Zure profila sortzen hasteko, egin klik 'Jarraitu' botoian.
       *[other] Zure profila sortzen hasteko, egin klik 'Hurrengoa' botoian.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Bukaera
       *[other] { create-profile-window.title } bukatzen
    }

profile-creation-intro = Profil ugari sortuz gero, profil-izen desberdinez dei ditzakezu. Hemen eskaintzen zaizun izena edo aukerako beste edozein erabil dezakezu.

profile-prompt = Idatzi profil berriaren izena
    .accesskey = e

profile-default-name =
    .value = Erabiltzaile lehenetsia

profile-directory-explanation = Zure ezarpenak, hobespenak eta beste zenbait datu hemen gordeko dira:

create-profile-choose-folder =
    .label = Aukeratu karpeta…
    .accesskey = A

create-profile-use-default =
    .label = Erabili karpeta lehenetsia
    .accesskey = l
