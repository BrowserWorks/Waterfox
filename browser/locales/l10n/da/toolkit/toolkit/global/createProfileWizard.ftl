# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Guiden Opret profil
    .style = width: 47em; height: 35em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introduktion
       *[other] Velkommen til { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } opbevarer information om dine indstillinger i din brugerprofil.

profile-creation-explanation-2 = Hvis du deler denne installation af { -brand-short-name } med andre brugere, kan I bruge profiler til at holde hinandens brugerinformation adskilt. For at gøre dette, skal I oprette hver jeres profil.

profile-creation-explanation-3 = Hvis du er den eneste person der benytter denne installation af { -brand-short-name }, skal du stadig have mindst en profil. Hvis du ønsker det kan du oprette flere profiler til dig selv, hvori du kan gemme forskellige indstillinger. Du kan fx oprette en profil til henholdsvis personligt og forretningsmæssigt brug.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] For at gå i gang med at oprette din profil, klik på 'Fortsæt'.
       *[other] For at gå i gang med at oprette din profil, klik på 'Næste'.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Konklusion
       *[other] Færdiggør { create-profile-window.title }
    }

profile-creation-intro = Hvis du opretter flere profiler kan du adskille dem på profilnavnet. Du kan anvende det foreslåede navn, eller angive et selv.

profile-prompt = Indtast nyt profilnavn:
    .accesskey = I

profile-default-name =
    .value = Standard

profile-directory-explanation = Dine indstillinger og øvrige brugerdata vil blive opbevaret i mappen:

create-profile-choose-folder =
    .label = Vælg mappe…
    .accesskey = V

create-profile-use-default =
    .label = Anvend standardmappe
    .accesskey = A
