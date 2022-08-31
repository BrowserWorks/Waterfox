# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# “Account” can be localized, “Waterfox” must be treated as a brand,
# and kept in English.
-fxaccount-brand-name =
    { $case ->
       *[nom]
            { $capitalization ->
               *[upper] Λογαριασμός Waterfox
                [lower] λογαριασμός Waterfox
            }
        [gen]
            { $capitalization ->
               *[upper] Λογαριασμού Waterfox
                [lower] λογαριασμού Waterfox
            }
        [acc]
            { $capitalization ->
               *[upper] Λογαριασμό Waterfox
                [lower] λογαριασμό Waterfox
            }
    }
