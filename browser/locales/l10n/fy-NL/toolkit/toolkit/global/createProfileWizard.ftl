# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Wizard profyl oanmeitsje
    .style = width: 50em; height: 37em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Yntroduksje
       *[other] Wolkom by de { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } bewarret ynformaasje oer jo ynstellingen en foarkarren yn jo persoanlike profyl.

profile-creation-explanation-2 = As jo dizze kopy fan { -brand-short-name } diele mei oare brûkers, kinne jo profilen brûke om de ynformaasje fan alle brûkers skieden te hâlden. Om dit te beriken moat elke brûker syn of har eigen profyl oanmeitsje.

profile-creation-explanation-3 = As jo de iennichste binne dy't dizze kopy fan { -brand-short-name } brûke, moatte jo op syn minst ien profyl hawwe. Jo kinne, as jo wolle, mear as ien profyl oanmeitsje foar josels om ferskate sets fan ynstellingen en foarkarren te bewarjen. Bygelyks, jo wolle miskien aparte profilen ha foar saaklik en persoanlik gebrûk.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Klik op Trochgean om te begjinnen mei it oanmeitsjen fan jo profyl.
       *[other] Om te begjinnen mei it oanmeitsjen fan jo profyl, klik op Folgjende.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Konklusje
       *[other] Foltôgje fan { create-profile-window.title }
    }

profile-creation-intro = As jo mear as ien profyl oanmeitsje, kin jo se út inoar hâlde troch de profylnammen. Jo kinne de namme hjirûnder brûke of in eigen namme kieze.

profile-prompt = Fier in nije profylnamme yn:
    .accesskey = F

profile-default-name =
    .value = Standertbrûker

profile-directory-explanation = Jo ynstellingen, foarkarren en oare brûkersgegevens sille bewarre wurde yn:

create-profile-choose-folder =
    .label = Map kieze...
    .accesskey = K

create-profile-use-default =
    .label = Standertmap brûke
    .accesskey = b
