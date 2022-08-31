# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# “Account” can be localized, “Waterfox” must be treated as a brand,
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
