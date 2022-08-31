# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Průvodce vytvořením profilu
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Úvod
       *[other] { create-profile-window.title } - Vítejte
    }

profile-creation-explanation-1 = { -brand-short-name } ukládá informace o vašem nastavení a předvolbách do vašeho osobního profilu.

profile-creation-explanation-2 = Pokud { -brand-short-name(case: "acc") } používá více uživatelů, můžete pomocí profilů uchovávat informace o uživatelích odděleně. Každý uživatel by si měl vytvořit svůj profil.

profile-creation-explanation-3 = Pokud { -brand-short-name(case: "acc") } používáte sami, musíte mít vytvořen aspoň jeden profil. Pokud chcete, můžete si vytvořit více profilů pro různé účely. Například můžete mít jeden profil pracovní a druhý soukromý.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Pro zahájení vytváření profilu klepněte na tlačítko Pokračovat.
       *[other] Pro zahájení vytváření profilu klepněte na tlačítko Další.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Závěr
       *[other] { create-profile-window.title } - Dokončování
    }

profile-creation-intro = Pokud vytváříte profily, musíte si je nějak nazvat. Můžete použít buď předvolený název nebo si zvolit vlastní.

profile-prompt = Zadejte nový název profilu:
    .accesskey = n

profile-default-name =
    .value = Nepojmenovaný

profile-directory-explanation = Vaše uživatelské nastavení, předvolby a další uživatelská data budou uložena v:

create-profile-choose-folder =
    .label = Vybrat složku…
    .accesskey = V

create-profile-use-default =
    .label = Použít výchozí složku
    .accesskey = u
