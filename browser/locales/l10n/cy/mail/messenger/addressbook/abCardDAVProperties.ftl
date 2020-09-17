# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

carddav-url-label =
    .value = URL CardDAV:
    .accesskey = V
carddav-refreshinterval-label =
    .label = Cydweddu:
    .accesskey = C
# Variables:
#   $minutes (integer) - Number of minutes between address book synchronizations
carddav-refreshinterval-minutes-value =
    .label =
        { $minutes ->
            [zero] pob munud
            [one] pob munud
            [two] pob { $minutes } funud
            [few] pob { $minutes } munud
            [many] pob { $minutes } munud
           *[other] pob { $minutes } munud
        }
# Variables:
#   $hours (integer) - Number of hours between address book synchronizations
carddav-refreshinterval-hours-value =
    .label =
        { $hours ->
            [zero] pob awr
            [one] pob awr
            [two] pob { $hours } awr
            [few] pob { $hours } awr
            [many] pob { $hours } awr
           *[other] pob { $hours } awr
        }
