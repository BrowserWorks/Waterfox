# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

-sync-brand-short-name =
    { $case ->
        [adessive] Sync-palvelulla
        [elative] Sync-palvelusta
        [genetive] Sync-palvelun
        [illative] Sync-palveluun
        [inessive] Sync-palvelussa
        [partitive] Sync-palvelua
       *[nominative] Sync
    }
# “Sync” can be localized, “Firefox” must be treated as a brand,
# and kept in English.
-sync-brand-name = Firefox Sync
# “Account” can be localized, “Firefox” must be treated as a brand,
# and kept in English.
-fxaccount-brand-name =
    { $case ->
        [ablative] Firefox-tililtä
        [adessive] Firefox-tilillä
        [allative] Firefox-tilille
        [genitive] Firefox-tilin
        [illative] Firefox-tiliin
        [partitive] Firefox-tiliä
       *[nominative] Firefox-tili
    }
