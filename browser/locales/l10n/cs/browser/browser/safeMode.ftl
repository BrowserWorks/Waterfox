# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

safe-mode-window =
    .title =
        Nouzový režim { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "gen") }
            [feminine] { -brand-short-name(case: "gen") }
            [neuter] { -brand-short-name(case: "gen") }
           *[other] aplikace { -brand-short-name }
        }
    .style = max-width: 400px
start-safe-mode =
    .label = Spustit v nouzovém režimu
refresh-profile =
    .label =
        Obnovit { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "acc") }
            [feminine] { -brand-short-name(case: "acc") }
            [neuter] { -brand-short-name(case: "acc") }
           *[other] aplikaci { -brand-short-name }
        }
safe-mode-description =
    Nouzový režim je speciální režim { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }, který se používá při řešení potíží.
safe-mode-description-details =
    Vaše doplňky a vlastní nastavení budou dočasně zakázány a některé funkce { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    } nemusí fungovat jako nyní.
refresh-profile-instead =
    Také můžete od hledání příčin potíží upustit a { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } obnovit do výchozího nastavení.
# Shown on the safe mode dialog after multiple startup crashes.
auto-safe-mode-description =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } byl při startu neočekávaně ukončen
        [feminine] { -brand-short-name } byla při startu neočekávaně ukončena
        [neuter] { -brand-short-name } bylo při startu neočekávaně ukončeno
       *[other] Aplikace { -brand-short-name } byla při startu neočekávaně ukončena
    }, což mohlo být způsobeno nainstalovanými doplňky nebo jinými problémy. Můžete se pokusit problémy vyřešit v nouzovém režimu.
