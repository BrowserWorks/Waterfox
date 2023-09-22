# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# “Account” can be localized, “Waterfox” must be treated as a brand,
# and kept in English.
-fxaccount-brand-name =
    { $case ->
        [gen]
            { $capitalization ->
                [lower] účtu Waterfoxu
                [sentence] účtu Waterfoxu
                [title] Účtu Waterfoxu
               *[upper] Účtu Waterfoxu
            }
        [dat]
            { $capitalization ->
                [lower] účtu Waterfoxu
                [sentence] účtu Waterfoxu
                [title] Účtu Waterfoxu
               *[upper] Účtu Waterfoxu
            }
        [acc]
            { $capitalization ->
                [lower] účet Waterfoxu
                [sentence] účet Waterfoxu
                [title] Účet Waterfoxu
               *[upper] Účet Waterfoxu
            }
        [voc]
            { $capitalization ->
                [lower] účte Waterfoxu
                [sentence] účte Waterfoxu
                [title] Účte Waterfoxu
               *[upper] Účte Waterfoxu
            }
        [loc]
            { $capitalization ->
                [lower] účtu Waterfoxu
                [sentence] účtu Waterfoxu
                [title] Účtu Waterfoxu
               *[upper] Účtu Waterfoxu
            }
        [ins]
            { $capitalization ->
                [lower] účtem Waterfoxu
                [sentence] účtem Waterfoxu
                [title] Účtem Waterfoxu
               *[upper] Účtem Waterfoxu
            }
       *[nom]
            { $capitalization ->
                [lower] účet Waterfoxu
                [sentence] účet Waterfoxu
                [title] Účet Waterfoxu
               *[upper] Účet Waterfoxu
            }
    }
