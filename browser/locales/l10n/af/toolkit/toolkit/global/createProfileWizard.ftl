# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Skep profielslimmerd
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Inleiding
       *[other] Welkom by die { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } stoor inligting oor u opstelling en voorkeure in u persoonlike profiel.

profile-creation-explanation-2 = Indien u hierdie afskrif van { -brand-short-name } met ander gebruikers wil deel, kan u profiele gebruik om elke gebruiker se inligting apart te hou. Om dit te doen moet elke verbruiker sy of haar eie profiel skep.

profile-creation-explanation-3 = Indien u die enigste persoon is wat hierdie afskrif van { -brand-short-name } gebruik, moet u ten minste een profiel hê. Indien u so verkies, kan u meer as een profiel vir uself skep wat verskillende stelle opstelling en voorkeure stoor. U kan byvoorbeeld 'n aparte profiel vir besigheids- en persoonlike gebruik hê.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Om u profiel te begin skep, kliek Volgende.
       *[other] Om u profiel te begin skep, kliek Volgende.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Slotsom
       *[other] Klaar met die { create-profile-window.title }
    }

profile-creation-intro = Indien u verskeie profiele skep, kan u hulle herken deur hul profielname. U kan die naam gebruik wat hier verskaf word, of een van u eie gebruik.

profile-prompt = Tik nuwe profielnaam in:
    .accesskey = T

profile-default-name =
    .value = Verstekgebruiker

profile-directory-explanation = U gebruikeropstelling, voorkeure en ander gebruikerverwante data sal gestoor word in:

create-profile-choose-folder =
    .label = Kies vouer…
    .accesskey = K

create-profile-use-default =
    .label = Gebruik verstekvouer
    .accesskey = G
