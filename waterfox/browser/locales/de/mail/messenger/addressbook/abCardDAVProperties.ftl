# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

carddav-url-label =
    .value = CardDAV-Adresse:
    .accesskey = C

carddav-refreshinterval-label =
    .label = Synchronisation:
    .accesskey = S

# Variables:
#   $minutes (integer) - Number of minutes between address book synchronizations
carddav-refreshinterval-minutes-value =
    .label = { $minutes ->
        [one] jede Minute
       *[other] alle { $minutes } Minuten
    }

# Variables:
#   $hours (integer) - Number of hours between address book synchronizations
carddav-refreshinterval-hours-value =
    .label = { $hours ->
        [one] jede Stunde
       *[other] alle { $hours } Stunden
    }

carddav-readonly-label =
    .label = Schreibgeschützt
    .accesskey = g
