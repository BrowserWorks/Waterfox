# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

-sync-brand-short-name =
    { $case ->
       *[nom] Sync
        [gen] Syncu
        [dat] Syncu
        [acc] Sync
        [voc] Syncu
        [loc] Syncu
        [ins] Syncem
    }

# “Sync” can be localized, “Firefox” must be treated as a brand,
# and kept in English.
-sync-brand-name =
    { $case ->
       *[nom] Waterfox Sync
        [gen] Waterfox Syncu
        [dat] Waterfox Syncu
        [acc] Waterfox Sync
        [voc] Waterfox Syncu
        [loc] Waterfox Syncu
        [ins] Waterfox Syncem
    }

# “Account” can be localized, “Firefox” must be treated as a brand,
# and kept in English.
-fxaccount-brand-name =
    { $case ->
       *[nom]
            { $capitalization ->
               *[upper] Účet Waterfoxu
                [lower] účet Waterfoxu
            }
        [gen]
            { $capitalization ->
               *[upper] Účtu Waterfoxu
                [lower] účtu Waterfoxu
            }
        [dat]
            { $capitalization ->
               *[upper] Účtu Waterfoxu
                [lower] účtu Waterfoxu
            }
        [acc]
            { $capitalization ->
               *[upper] Účet Waterfoxu
                [lower] účet Waterfoxu
            }
        [voc]
            { $capitalization ->
               *[upper] Účte Waterfoxu
                [lower] účte Waterfoxu
            }
        [loc]
            { $capitalization ->
               *[upper] Účtu Waterfoxu
                [lower] účtu Waterfoxu
            }
        [ins]
            { $capitalization ->
               *[upper] Účtem Waterfoxu
                [lower] účtem Waterfoxu
            }
    }
