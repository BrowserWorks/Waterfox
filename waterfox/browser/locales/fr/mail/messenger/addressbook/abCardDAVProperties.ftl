# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

carddav-url-label =
    .value = URL CardDAV :
    .accesskey = V

carddav-refreshinterval-label =
    .label = Synchroniser :
    .accesskey = S

# Variables:
#   $minutes (integer) - Number of minutes between address book synchronizations
carddav-refreshinterval-minutes-value =
    .label =
        { $minutes ->
            [one] chaque minute
           *[other] toutes les { $minutes } minutes
        }

# Variables:
#   $hours (integer) - Number of hours between address book synchronizations
carddav-refreshinterval-hours-value =
    .label =
        { $hours ->
            [one] chaque heure
           *[other] toutes les { $hours } heures
        }

carddav-readonly-label =
    .label = En lecture seule
    .accesskey = l
