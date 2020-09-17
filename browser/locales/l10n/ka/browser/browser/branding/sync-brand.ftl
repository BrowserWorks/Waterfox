# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

-sync-brand-short-name =
    { $case ->
       *[nom] სინქრონიზაცია
        [dat] სინქრონიზაციას
        [gen] სინქრონიზაციის
    }

# “Sync” can be localized, “Firefox” must be treated as a brand,
# and kept in English.
-sync-brand-name = Firefox Sync

# “Account” can be localized, “Firefox” must be treated as a brand,
# and kept in English.
-fxaccount-brand-name =
    { $case ->
       *[nom] Firefox-ანგარიში
        [dat] Firefox-ანგარიშს
        [gen] Firefox-ანგარიშის
        [ins] Firefox-ანგარიშით
        [add] Firefox-ანგარიშთან
    }
