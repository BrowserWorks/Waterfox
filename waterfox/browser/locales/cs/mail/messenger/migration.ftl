# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

migration-progress-header =
    { -brand-short-name.gender ->
        [masculine] Příprava { -brand-short-name(case: "gen") }…
        [feminine] Příprava { -brand-short-name(case: "gen") }…
        [neuter] Příprava { -brand-short-name(case: "gen") }…
       *[other] Příprava aplikace { -brand-short-name }…
    }

## Migration tasks


# These strings are displayed to the user if a migration is taking a long time.
# They should be short (no more than a handful of words) and in the present tense.

migration-task-test-fast = Testování rychlé změny
migration-task-test-slow = Testování pomalé změny
migration-task-test-progress = Testování ukazatele průběhu
