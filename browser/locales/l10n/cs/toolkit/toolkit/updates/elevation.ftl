# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# This is temporary until bug 1521632 is fixed

elevation-update-wizard =
    .title = Aktualizace aplikace
elevation-details-link-label =
    .value = Podrobnosti
elevation-error-manual =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] Aplikaci { -brand-short-name }
    } doporučujeme aktualizovat ručně stažením nejnovější verze z této stránky:
elevation-finished-page = Aktualizace je připravena k instalaci
elevation-finished-background-page =
    Bezpečnostní a výkonnostní aktualizace { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    } byla stažena a je připravena k instalaci.
elevation-finished-background = Aktualizace:
elevation-more-elevated =
    Tato aktualizace vyžaduje oprávnění správce. Aktualizace bude nainstalována při příštím spuštění { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }. { -brand-short-name.gender ->
        [masculine] Nyní ho můžete restartovat, pokračovat v práci a restartovat ho později, nebo aktualizaci zcela zrušit.
        [feminine] Nyní ji můžete restartovat, pokračovat v práci a restartovat ji později, nebo aktualizaci zcela zrušit.
        [neuter] Nyní ho můžete restartovat, pokračovat v práci a restartovat ho později, nebo aktualizaci zcela zrušit.
       *[other] Nyní můžete aplikaci restartovat, pokračovat v práci a restartovat ji později, nebo aktualizaci zcela zrušit.
    }
