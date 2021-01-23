# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Ustvarjanje profila
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Uvod
       *[other] { create-profile-window.title }: Pozdravljeni
    }

profile-creation-explanation-1 = { -brand-short-name } shrani informacije o nastavitvah, zaznamkih, e-poštnih sporočilih in drugih uporabniških elementih v vašem uporabniškem profilu.

profile-creation-explanation-2 = Če si to kopijo { -brand-short-name }a delite z ostalimi uporabniki, lahko s pomočjo profilov ločite posamezne uporabnike. Za to mora imeti vsak uporabnik svoj profil.

profile-creation-explanation-3 = Če edini uporabljate to kopijo { -brand-short-name }a, morate imeti vsaj en profil. Če hočete, lahko ustvarite več profilov, da lahko shranite različne nastavitve in osebne nastavitve. Lahko imate, na primer, ločene profile za zasebno in službeno rabo.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Kliknite gumb Nadaljuj, da boste začeli ustvarjati profil.
       *[other] Kliknite gumb Naprej, da boste začeli ustvarjati profil.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Zaključek
       *[other] { create-profile-window.title }: Končano
    }

profile-creation-intro = Če ustvarite več profilov, jih lahko prepoznate po njihovih imenih. Uporabite lahko predlagano ime, ali pa uporabite svoje.

profile-prompt = Vnesite novo ime profila:
    .accesskey = E

profile-default-name =
    .value = Privzeti uporabnik

profile-directory-explanation = Vaše nastavitve in drugi podatki, vezani na uporabnika, bodo shranjeni v:

create-profile-choose-folder =
    .label = Izberi mapo …
    .accesskey = I

create-profile-use-default =
    .label = Uporabi privzeto mapo
    .accesskey = U
