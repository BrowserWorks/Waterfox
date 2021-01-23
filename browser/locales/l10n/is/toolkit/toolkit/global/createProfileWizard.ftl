# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Hjálp við að búa til notanda
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Inngangur
       *[other] Vertu velkomin í { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } geymir þínar stillingar í persónulegum notanda stillingum.

profile-creation-explanation-2 = Ef þú ert að deila { -brand-short-name } með öðrum notendum, geturðu notað notendur til að halda stillingum hjá hverjum notenda sér. Til að þetta sé mögulegt verður hver notandi að búa til sína eigin notanda.

profile-creation-explanation-3 = Ef þú ert aðeins sá eini sem notar { -brand-short-name }, þarftu að minnsta kosti einn notanda. Ef þú vilt geturðu búið til marga notendur fyrir þig til að geta geymt mismunandi sett af stillingum. Til dæmis, gætirðu viljað hafa mismunandi stillingar fyrir vinnuna og heima.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Til að búa til notanda, smelltu á Áfram.
       *[other] Til að búa til notanda, smelltu á Áfram.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Niðurstaða
       *[other] Ljúka við { create-profile-window.title }
    }

profile-creation-intro = Ef þú býrð til marga notendur geturðu þekkt þá í sundur á nafninu. Þú getur notað nafnið sem er hér fyrir eða sett inn þitt eigið.

profile-prompt = Sláðu inn nafn á nýjum notanda:
    .accesskey = S

profile-default-name =
    .value = Sjálfgefinn notandi

profile-directory-explanation = Stillingar og önnur gögn tengdum þínum notanda verða geymdar í:

create-profile-choose-folder =
    .label = Veldu möppu…
    .accesskey = V

create-profile-use-default =
    .label = Nota sjálfgefna möppu
    .accesskey = N
