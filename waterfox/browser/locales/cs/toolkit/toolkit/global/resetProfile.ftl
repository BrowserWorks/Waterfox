# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

refresh-profile-dialog-title =
    { -brand-short-name.case-status ->
        [with-cases] Chcete obnovit výchozí nastavení nastavení { -brand-short-name(case: "gen") }?
       *[no-cases] Chcete obnovit výchozí nastavení nastavení aplikace { -brand-short-name }?
    }
refresh-profile-dialog-button =
    .label =
        { -brand-short-name.case-status ->
            [with-cases] Obnovit { -brand-short-name(case: "acc") }
           *[no-cases] Obnovit aplikaci { -brand-short-name }
        }
refresh-profile-dialog-description = Začněte nanovo a vyřešte problémy s výkonem. Tím odstraníte nainstalovaná rozšíření a svá nastavení. Nepřijdete ale o žádná svá data jako jsou záložky a hesla.
refresh-profile =
    { -brand-short-name.case-status ->
        [with-cases] Vyladění { -brand-short-name(case: "gen") }
       *[no-cases] Vyladění aplikace { -brand-short-name }
    }
refresh-profile-button =
    { -brand-short-name.case-status ->
        [with-cases] Obnovit { -brand-short-name(case: "acc") }
       *[no-cases] Obnovit aplikaci { -brand-short-name }
    }
refresh-profile-learn-more = Zjistit více

refresh-profile-progress =
    .title =
        { -brand-short-name.case-status ->
            [with-cases] Obnovení { -brand-short-name(case: "gen") }
           *[no-cases] Obnovení aplikace { -brand-short-name }
        }
refresh-profile-progress-description = Téměř hotovo…
