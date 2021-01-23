# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

-sync-brand-short-name =
    { $case ->
        *[nom] { $capitalization ->
           *[upper] Синхронізація
            [lower] синхронізація
        }
        [gen] { $capitalization ->
           *[upper] Синхронізації
            [lower] синхронізації
        }
        [dat] { $capitalization ->
           *[upper] Синхронізації
            [lower] синхронізації
        }
        [acc] { $capitalization ->
           *[upper] Синхронізацію
            [lower] синхронізацію
        }
        [abl] { $capitalization ->
           *[upper] Синхронізацією
            [lower] синхронізацією
        }
    }

# “Sync” can be localized, “Firefox” must be treated as a brand,
# and kept in English.
-sync-brand-name =
    { $case ->
        *[nom] { $capitalization ->
           *[upper] Синхронізація Waterfox
            [lower] синхронізація Waterfox
        }
        [gen] { $capitalization ->
           *[upper] Синхронізації Waterfox
            [lower] синхронізації Waterfox
        }
        [dat] { $capitalization ->
           *[upper] Синхронізації Waterfox
            [lower] синхронізації Waterfox
        }
        [acc] { $capitalization ->
           *[upper] Синхронізацію Waterfox
            [lower] синхронізацію Waterfox
        }
        [abl] { $capitalization ->
           *[upper] Синхронізацією Waterfox
            [lower] синхронізацією Waterfox
        }
    }

# “Account” can be localized, “Firefox” must be treated as a brand,
# and kept in English.
-fxaccount-brand-name =
    { $case ->
        *[nom] { $capitalization ->
           *[upper] Обліковий запис Waterfox
            [lower] обліковий запис Waterfox
        }
        [gen] { $capitalization ->
           *[upper] Облікового запису Waterfox
            [lower] облікового запису Waterfox
        }
        [dat] { $capitalization ->
           *[upper] Обліковому записі Waterfox
            [lower] обліковому записі Waterfox
        }
        [acc] { $capitalization ->
           *[upper] Обліковий запис Waterfox
            [lower] обліковий запис Waterfox
        }
        [abl] { $capitalization ->
           *[upper] Обліковим записом Waterfox
            [lower] обліковим записом Waterfox
        }
    }
