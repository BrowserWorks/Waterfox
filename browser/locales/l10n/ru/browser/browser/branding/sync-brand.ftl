# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

-sync-brand-short-name =
    { $case ->
       *[nominative] Синхронизация
        [genitive] Синхронизации
        [accusative] Синхронизацию
    }
# “Sync” can be localized, “Firefox” must be treated as a brand,
# and kept in English.
-sync-brand-name =
    { $case ->
        [nominative] Синхронизация Firefox
        [genitive] Синхронизации Firefox
       *[accusative] Синхронизацию Firefox
    }
# “Account” can be localized, “Firefox” must be treated as a brand,
# and kept in English.
-fxaccount-brand-name =
    { $case ->
       *[nominative] Аккаунт Firefox
        [genitive] Аккаунта Firefox
        [dative] Аккаунту Firefox
        [accusative] Аккаунт Firefox
        [instrumental] Аккаунтом Firefox
        [prepositional] Аккаунте Firefox
    }
