# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = veiviser for ny profil
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introduksjon
       *[other] Velkommen til { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } lagrer innstillinger og annen brukerdata i din personlige profil.

profile-creation-explanation-2 = Dersom du deler denne kopien av { -brand-short-name } med andre brukere, kan du bruke profilene for å skille brukernes egen informasjon. For å gjøre dette må hver bruker opprette sin egen profil.

profile-creation-explanation-3 = Dersom du er den eneste personen som bruker denne kopien av { -brand-short-name } må du ha minst en profil. Om du vil kan du opprette flere profiler for å skille mellom ulike sett av innstillinger og brukerdata. Du kan for eksempel ha forskjellige profiler for jobb og personlig bruk.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Trykk «Fortsett» for å begynne opprette profilen.
       *[other] Trykk «Neste» for å opprette en ny profil.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Konklusjon
       *[other] Fullfører { create-profile-window.title }
    }

profile-creation-intro = Dersom du oppretter flere profiler, kan du skille dem fra hverandre med profilnavnet. Du kan bruke navnet foreslått her, eller du kan bruke et annet.

profile-prompt = Skriv inn nytt profilnavn:
    .accesskey = p

profile-default-name =
    .value = Standardbruker

profile-directory-explanation = Innstillinger og andre brukerdata lagres i:

create-profile-choose-folder =
    .label = Velg mappe …
    .accesskey = m

create-profile-use-default =
    .label = Bruk standard mappe
    .accesskey = B
