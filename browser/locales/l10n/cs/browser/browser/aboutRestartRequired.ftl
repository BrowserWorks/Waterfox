# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

restart-required-title = Vyžadován restart
restart-required-header = Pro pokračování v prohlížení je potřeba jedna malá drobnost.
restart-required-intro-brand =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } byl na pozadí aktualizován. Pro dokončení aktualizace klepněte na „Restartovat aplikaci { -brand-short-name }”.
        [feminine] { -brand-short-name } byla na pozadí aktualizována. Pro dokončení aktualizace klepněte na „Restartovat aplikaci { -brand-short-name }”.
        [neuter] { -brand-short-name } bylo na pozadí aktualizováno. Pro dokončení aktualizace klepněte na „Restartovat aplikaci { -brand-short-name }”.
       *[other] Aplikace { -brand-short-name } byla na pozadí aktualizována. Pro dokončení aktualizace klepněte na „Restartovat aplikaci { -brand-short-name }”.
    }
restart-required-description = Všechny vaše stránky, okna a panely budou po restartu obnoveny a budete moci pokračovat v prohlížení.

restart-button-label =
    Restartovat { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    }
