# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Profil létrehozása
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Első lépés
       *[other] { create-profile-window.title } első lépése
    }

profile-creation-explanation-1 = A { -brand-short-name } a személyes profilban tárolja a beállításait.

profile-creation-explanation-2 = Ha a { -brand-short-name } programot más felhasználókkal megosztva használja, érdemes profilokat használni, hogy a személyes adatok ne keveredjenek. Emiatt minden felhasználónak létre kell hoznia a saját profilját.

profile-creation-explanation-3 = Ha Ön az egyetlen felhasználója ennek a { -brand-short-name }-példánynak, akkor is legalább egy profillal rendelkeznie kell. Igény szerint több profilt is létrehozhat eltérő beállításkészletek tárolására. Elképzelhető például, hogy külön profilt szeretne üzleti és személyes használatra.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] A profil elkészítésének megkezdéséhez kattintson a Continue gombra.
       *[other] A profil elkészítésének megkezdéséhez kattintson a Tovább gombra.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Befejezés
       *[other] { create-profile-window.title } befejezése
    }

profile-creation-intro = Ha több profilt hoz létre, akkor a nevük alapján különböztetheti meg azokat. Használhatja az itt megadott nevet, vagy beírhat egy másikat.

profile-prompt = Adja meg az új profil nevét:
    .accesskey = d

profile-default-name =
    .value = Alapértelmezett felhasználó

profile-directory-explanation = Az Ön beállításai és egyéb személyes adatai az alábbi helyen lesznek tárolva:

create-profile-choose-folder =
    .label = Mappa választása…
    .accesskey = M

create-profile-use-default =
    .label = Alapértelmezett mappa
    .accesskey = A
