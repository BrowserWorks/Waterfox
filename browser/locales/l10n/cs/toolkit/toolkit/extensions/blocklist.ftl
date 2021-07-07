# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0

blocklist-window =
    .title = Doplňky způsobující problémy
    .style = width: 45em; height: 30em
blocklist-accept =
    .label =
        Restartovat { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "acc") }
            [feminine] { -brand-short-name(case: "acc") }
            [neuter] { -brand-short-name(case: "acc") }
           *[other] aplikaci { -brand-short-name }
        }
    .accesskey = R

blocklist-label-summary =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } zjistil
        [feminine] { -brand-short-name } zjistila
        [neuter] { -brand-short-name } zjistilo
       *[other] Aplikace { -brand-short-name } zjistila
    }, že následující doplňky způsobují bezpečnostní nebo výkonnostní problémy:
blocklist-soft-and-hard = Z důvodů vaší ochrany byly více nebezpečné doplňky označeny jako zakázané. Zbylé doplňky jsou sice méně nebezpečné, přesto je doporučováno je zakázat a aplikaci restartovat.
blocklist-hard-blocked = Z důvodů vaší ochrany byly tyto nebezpečné doplňky označeny jako zakázané. Pro jejich kompletní zákaz je vyžadován restart aplikace.
blocklist-soft-blocked = Z důvodů vaší ochrany je doporučováno tyto doplňky zakázat a aplikaci restartovat.
blocklist-more-information =
    .value = Více informací

blocklist-blocked =
    .label = Blokováno
blocklist-checkbox =
    .label = Zakázat
