# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Čarobnjak za stvaranje profila
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Uvod
       *[other] Dobrodošli u { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } sprema informacije o tvojim postavkama i osobitostima u tvoj osobni profil.

profile-creation-explanation-2 = Ako ovu kopiju { -brand-short-name }a dijelite s ostalima, možete koristiti profile kako biste informacije svakog korisnika držali odvojenima. Da biste to uradili, svaki korisnik bi trebao stvoriti svoj vlastiti profil.

profile-creation-explanation-3 = Ako si jedini korisnik ove verzije { -brand-short-name }a, moraš imati barem jedan profil. Ako želiš, možeš stvoriti više profila za spremanje različitih postavki i osobitosti. Na primjer, možeš imati odvojene profile za poslovnu i osobnu upotrebu.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Za početak stvaranja tvog profila, klikni na Nastavi.
       *[other] Za početak stvaranja tvog profila, klikni na Dalje.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Zaključak
       *[other] Dovršavanje { create-profile-window.title }
    }

profile-creation-intro = Ako stvoriš nekoliko profila, možeš ih razlikovati po njihovim imenima. Možeš koristiti imena koja su ovdje zadana ili stvoriti svoja vlastita.

profile-prompt = Upiši ime novog profila:
    .accesskey = e

profile-default-name =
    .value = Standardni korisnik

profile-directory-explanation = Tvoje korisničke postavke, osobitosti i ostali korisnički podaci bit će spremljeni u:

create-profile-choose-folder =
    .label = Odaberi mapu...
    .accesskey = m

create-profile-use-default =
    .label = Koristi standardnu mapu
    .accesskey = u
