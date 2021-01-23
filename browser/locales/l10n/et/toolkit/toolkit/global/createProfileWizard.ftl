# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Profiili loomise nõustaja
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Sissejuhatus
       *[other] { create-profile-window.title } tervitab
    }

profile-creation-explanation-1 = { -brand-short-name } säilitab teavet sinu kasutajasätete ja eelistuste kohta isikliku profiili kujul.

profile-creation-explanation-2 = Kui jagad seda { -brand-short-name }i koopiat teiste kasutajatega, võid luua rohkem profiile, et iga kasutaja andmed oleksid eraldi. Selleks peab iga kasutaja looma endale isikliku profiili.

profile-creation-explanation-3 = Kui sa oled selle { -brand-short-name }i koopia ainukasutaja, pead looma vähemalt ühe kasutajaprofiili. Soovi korral võid neid endale ka rohkem teha, kui soovid talletada suuremat kogust erinevaid sätteid ja eelistusi. Võid näiteks teha eraldi profiilid kasutamiseks tööl ja kodus.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Profiili loomise alustamiseks klõpsa nupul Jätka.
       *[other] Profiili loomise alustamiseks klõpsa nupul Edasi.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Kokkuvõte
       *[other] { create-profile-window.title } lõpetas
    }

profile-creation-intro = Profiile on võimalik eristada nime järgi. Võid kasutada siin pakutavat nime või kirjutada uue nime.

profile-prompt = Sisesta uue profiili nimi:
    .accesskey = S

profile-default-name =
    .value = Vaikimisi kasutaja

profile-directory-explanation = Sinu kasutajasätteid, eelistusi, järjehoidjaid ja e-posti hoitakse kaustas:

create-profile-choose-folder =
    .label = Vali kaust...
    .accesskey = V

create-profile-use-default =
    .label = Kasuta vaikimisi kausta
    .accesskey = K
