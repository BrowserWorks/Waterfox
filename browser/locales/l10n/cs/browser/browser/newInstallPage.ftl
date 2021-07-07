# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### For this feature, "installation" is used to mean "this discrete download of
### Firefox" and "version" is used to mean "the specific revision number of a
### given Firefox channel". These terms are not synonymous.

title = Důležité novinky
heading =
    Změny v používání profilů { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }
changed-title = Co se změnilo?
changed-desc-profiles =
    Tato instalace { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    } má nový profil. Profil je místo, kam Firefox ukládá data jako jsou vaše záložky, hesla a vaše nastavení.
changed-desc-dedicated = Aby bylo možné snadno a bezpečně používat více instalací prohlížeče Firefox najednou (finální verzi i verze ESR, Beta, Developer Edition a Nightly), používá nyní tato instalace vlastní profil. Automaticky už tedy nesdílí vaše uložená data s ostatními instalacemi.
lost = <b>O žádná svá data a nastavení nepřijdete.</b> Vše je bezpečně uloženo v profilu a dostupné pro první spuštěnou instalaci Firefoxu.
options-title = Co mohu dělat dál?
options-do-nothing =
    Pokud nebudete dělat nic, { -brand-short-name.gender ->
        [masculine] váš { -brand-short-name }
        [feminine] vaše { -brand-short-name }
        [neuter] vaše { -brand-short-name }
       *[other] vaše aplikace { -brand-short-name }
    } bude používat samostatný profil a nebude sdílet žádná data s ostatními instalacemi prohlížeče Firefox.
options-use-sync = Pokud chcete mít stejná data ve více instalacích Firefoxu, použijte bezpečnou synchronizaci pomocí { -fxaccount-brand-name(case: "gen", capitalization: "lower") }.
resources = Zdroje:
support-link = Správa profilů - článek nápovědy
sync-header = Přihlaste se nebo si založte { -fxaccount-brand-name(case: "acc", capitalization: "lower") }
sync-label = Zadejte svoji e-mailovou adresu
sync-input =
    .placeholder = E-mail
sync-button = Pokračovat
sync-terms = Pokračováním souhlasíte s <a data-l10n-name="terms">podmínkami poskytování služby</a> a <a data-l10n-name="privacy">zásadami ochrany osobních údajů</a>.
sync-first = Používáte { -sync-brand-name(case: "acc") } poprvé? Pro synchronizaci svých dat se přihlaste stejným účtem ve všech instalacích Firefoxu.
new-install-sync-first = Používáte syncronizaci poprvé? Pro synchronizaci svých dat se přihlaste stejným účtem ve všech instalacích Firefoxu.
sync-learn = Zjistit více
