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
           *[upper] Синхронізація Firefox
            [lower] синхронізація Firefox
        }
        [gen] { $capitalization ->
           *[upper] Синхронізації Firefox
            [lower] синхронізації Firefox
        }
        [dat] { $capitalization ->
           *[upper] Синхронізації Firefox
            [lower] синхронізації Firefox
        }
        [acc] { $capitalization ->
           *[upper] Синхронізацію Firefox
            [lower] синхронізацію Firefox
        }
        [abl] { $capitalization ->
           *[upper] Синхронізацією Firefox
            [lower] синхронізацією Firefox
        }
    }

# “Account” can be localized, “Firefox” must be treated as a brand,
# and kept in English.
-fxaccount-brand-name =
    { $case ->
        *[nom] { $capitalization ->
           *[upper] Обліковий запис Firefox
            [lower] обліковий запис Firefox
        }
        [gen] { $capitalization ->
           *[upper] Облікового запису Firefox
            [lower] облікового запису Firefox
        }
        [dat] { $capitalization ->
           *[upper] Обліковому записі Firefox
            [lower] обліковому записі Firefox
        }
        [acc] { $capitalization ->
           *[upper] Обліковий запис Firefox
            [lower] обліковий запис Firefox
        }
        [abl] { $capitalization ->
           *[upper] Обліковим записом Firefox
            [lower] обліковим записом Firefox
        }
    }
