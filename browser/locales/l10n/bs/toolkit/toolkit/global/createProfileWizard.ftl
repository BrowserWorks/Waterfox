# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Čarobnjak za pravljenje profila
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Uvod
       *[other] Dobrodošli u { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } pohranjuje informacije o vašim postavkama u vašem ličnom profilu.

profile-creation-explanation-2 = Ako dijelite ovu kopiju { -brand-short-name }a sa drugim korisnicima možete koristiti profile da razdvojite informacije svakog od korisnika. Da biste ovo postigli, svaki korisnik treba napraviti svoj profil.

profile-creation-explanation-3 = Ako ste jedina osoba koja koristi ovu kopiju { -brand-short-name }a morate imati barem jedan profil. Ako želite, možete napraviti više profila za sebe da biste pohranili drugačije setove postavki. Naprimjer, možda želite imati različite profile za poslovnu i privatnu upotrebu.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Da započnete pravljenje vašeg profila, kliknite Nastavi.
       *[other] Da započnete kreiranje vašeg profila, kliknite Sljedeće.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Zaključak
       *[other] Završavam { create-profile-window.title }
    }

profile-creation-intro = Ako napravite nekoliko profila možete ih razlikovati po imenima. Možete koristiti ime koje je dato ovdje ili neko po vašoj želji.

profile-prompt = Unesite novo ime profila:
    .accesskey = e

profile-default-name =
    .value = Početni korisnik

profile-directory-explanation = Vaše korisničke postavke i drugi korisnički podaci bit će pohranjeni u:

create-profile-choose-folder =
    .label = Izaberite direktorij…
    .accesskey = I

create-profile-use-default =
    .label = Koristi prvobitni direktorij
    .accesskey = K
