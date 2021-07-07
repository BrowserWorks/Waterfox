# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

open-preferences-sidebar-button =
    Předvolby { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace
    }
open-addons-sidebar-button = Doplňky a vzhledy
account-action-add-newsgroup-account =
    .label = Přidat účet pro diskusní skupiny…
    .accesskey = d
