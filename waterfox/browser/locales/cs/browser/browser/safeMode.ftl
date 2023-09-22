# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

troubleshoot-mode-window =
    .title =
        { -brand-short-name.case-status ->
            [with-cases] Chcete { -brand-short-name(case: "acc") } otevřít v režimu řešení potíží?
           *[no-cases] Chcete aplikaci { -brand-short-name } otevřít v režimu řešení potíží?
        }
    .style = max-width: 400px
start-troubleshoot-mode =
    .label = Otevřít
refresh-profile =
    .label =
        { -brand-short-name.case-status ->
            [with-cases] Obnovit { -brand-short-name(case: "acc") }
           *[no-cases] Obnovit aplikaci { -brand-short-name }
        }
troubleshoot-mode-description =
    { -brand-short-name.case-status ->
        [with-cases] Tento režim { -brand-short-name(case: "gen") } vám pomůže s diagnostikou problémů. Vaše rozšíření a uživatelská nastavení budou dočasně zakázána.
       *[no-cases] Tento režim aplikace { -brand-short-name } vám pomůže s diagnostikou problémů. Vaše rozšíření a uživatelská nastavení budou dočasně zakázána.
    }
skip-troubleshoot-refresh-profile =
    { -brand-short-name.case-status ->
        [with-cases] Také můžete od hledání příčin problémů upustit a provést obnovu { -brand-short-name(case: "gen") }  do výchozího nastavení.
       *[no-cases] Také můžete od hledání příčin problémů upustit a provést obnovu aplikace { -brand-short-name }  do výchozího nastavení.
    }
# Shown on the safe mode dialog after multiple startup crashes.
auto-safe-mode-description =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } byl při startu neočekávaně ukončen
        [feminine] { -brand-short-name } byla při startu neočekávaně ukončena
        [neuter] { -brand-short-name } bylo při startu neočekávaně ukončeno
       *[other] Aplikace { -brand-short-name } byla při startu neočekávaně ukončena
    }, což mohlo být způsobeno nainstalovanými doplňky nebo jinými problémy. Můžete se pokusit problémy vyřešit v nouzovém režimu.
