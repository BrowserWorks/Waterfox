# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Vegvisar for ny profil
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introduksjon
       *[other] Velkomen til { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } lagrar innstillingar og adre brukardata i den personlege profilen din.

profile-creation-explanation-2 = Dersom du deler dette eksemplaret av { -brand-short-name } med andre brukarar kan du bruke profilane for å halde informasjonen til kvar brukar for seg sjølv. For å gjere dette må kvar brukar lage sin eigen profil.

profile-creation-explanation-3 = Dersom du er den einaste personen som brukar dette eksemplaret av { -brand-short-name } må du ha minst ein profil. Dersom du vil kan du lage fleire profilar for deg sjølv for å skilja mellom ulike sett av innstillingar og val. Du kan til dømes ha separate profilar for arbeid og personleg bruk.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Trykk «Fortset» for å byrje å lage profilen din.
       *[other] Trykk «Neste» for å lage ein ny profil.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Konklusjon
       *[other] Fullfører { create-profile-window.title }
    }

profile-creation-intro = Dersom du lagar fleire profilar kan du skilje dei frå kvarandre med profilnamn. Du kan bruke namnet spesifisert her, eller du kan bruke eit anna.

profile-prompt = Skriv inn nytt profilnamn:
    .accesskey = S

profile-default-name =
    .value = Standardbrukar

profile-directory-explanation = Innstillingane dine og andre brukardata vart lagra i:

create-profile-choose-folder =
    .label = Vel mappe…
    .accesskey = V

create-profile-use-default =
    .label = Bruk standardmappe
    .accesskey = B
