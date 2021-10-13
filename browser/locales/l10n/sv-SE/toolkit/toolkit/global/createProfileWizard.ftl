# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Guiden skapa profil
    .style = width: 45em; height: 34em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introduktion
       *[other] Välkommen till { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } lagrar information om inställningar i din personliga profil.

profile-creation-explanation-2 = Om du delar denna kopia av { -brand-short-name } med andra användare kan ni använda profiler för att hålla isär varje användares information. För att göra detta, bör varje användare skapa sin egen profil.

profile-creation-explanation-3 = Om du är den enda användaren av denna kopia av { -brand-short-name }, måste du ändå ha minst en profil. Om du vill kan du skapa flera profiler åt dig själv för att spara olika uppsättningar inställningar och alternativ, t.ex. kan du ha olika profiler för arbete och för personlig användning.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] För att påbörja skapandet av din profil, klicka på Fortsätt.
       *[other] För att påbörja skapandet av din profil, klicka på Nästa.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Avslutning
       *[other] Slutför { create-profile-window.title }
    }

profile-creation-intro = Om du skapar flera olika profiler kan du skilja dem åt med hjälp av profilnamnen. Du kan använda namnet som givits här, eller ange ett eget.

profile-prompt = Skriv in profilnamnet:
    .accesskey = S

profile-default-name =
    .value = Standardanvändare

profile-directory-explanation = Dina inställningar och annan användarrelaterad data kommer att lagras i:

create-profile-choose-folder =
    .label = Välj mapp…
    .accesskey = V

create-profile-use-default =
    .label = Använd standardmapp
    .accesskey = A
