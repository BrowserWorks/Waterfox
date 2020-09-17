# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Sprievodca vytvorením profilu
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Úvod
       *[other] Víta vás { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } ukladá informácie o vašich nastaveniach a predvoľbách v osobnom profile.

profile-creation-explanation-2 = Ak zdieľate túto kópiu aplikácie { -brand-short-name } s inými používateľmi, môžete používať profily, aby informácie pre každého používateľa boli oddelené. Ak tak chcete urobiť, treba každému používateľovi vytvoriť vlastný profil.

profile-creation-explanation-3 = Ak ste jediná osoba používajúca túto kópiu programu { -brand-short-name }, musíte mať aspoň jeden profil. Ak chcete, môžete pre seba vytvoriť viac profilov na uloženie rôznych nastavení a možností. Môžete mať napríklad osobitné profily pre pracovné a osobné použitie.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Svoj profil vytvoríte kliknutím na tlačidlo Pokračovať.
       *[other] Svoj profil vytvoríte kliknutím na tlačidlo Ďalej.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Záver
       *[other] Dokončuje sa { create-profile-window.title }
    }

profile-creation-intro = Ak vytvoríte viac profilov, môžete ich označovať podľa názvu profilu. Môžete použiť uvedený názov alebo použiť vlastný.

profile-prompt = Zadajte názov nového profilu:
    .accesskey = n

profile-default-name =
    .value = Predvolený používateľ

profile-directory-explanation = Nastavenie, možnosti a ďalšie používateľské údaje budú uložené v:

create-profile-choose-folder =
    .label = Vybrať priečinok…
    .accesskey = V

create-profile-use-default =
    .label = Použiť predvolený priečinok
    .accesskey = P
