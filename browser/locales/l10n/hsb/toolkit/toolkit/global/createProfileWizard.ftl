# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Asistent za založenje profilow
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Zawod
       *[other] Witajće do { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } składuje informacije wo wašich nastajenjach a preferencach we wašim wosobinskim profilu.

profile-creation-explanation-2 = Jeli tutu kopiju { -brand-short-name } zhromadnje z druhimi wužiwarjemi wužiwaće, móžeće rozdźelne profile wužiwać, zo byšće informacije kóždeho wužiwarja rozdźělene zdźeržał. Za to dyrbjał kóždy wužiwar swój profil załožić.

profile-creation-explanation-3 = Jeli sće jenička wosoba, kotraž tutu kopiju { -brand-short-name } wužiwa, dyrbiće znajmjeńša jedyn profil měć. Jeli chceće, móžeće wjacore profile za sebje załožić, zo byšće rozdźělne grupy nastajenjow a preferency składował. Na přikład chceće snano separatne profile za powołanske a priwatne wužiwanje měć.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Zo byšće swój profil załožił, klikńće na Pokročować.
       *[other] Zo byšće swój profil załožił, klikńće na Dale.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Zakónčenje
       *[other] { create-profile-window.title } dokónčić
    }

profile-creation-intro = Jeli wjacore profile založujeće, móžeće je z profilowymi mjenami rozeznawać. Móžeće tu podate abo swoje mjeno wužiwać.

profile-prompt = Zapodajće nowe profilowe mjeno:
    .accesskey = Z

profile-default-name =
    .value = Standardny wužiwar

profile-directory-explanation = Waše wužiwarske nastajenja, preferency a druhe daty, kotrež so na wužiwarja poćahuja, budu so składować w:

create-profile-choose-folder =
    .label = Rjadowak wubrać…
    .accesskey = R

create-profile-use-default =
    .label = Standardny rjadowak wužiwać
    .accesskey = S
