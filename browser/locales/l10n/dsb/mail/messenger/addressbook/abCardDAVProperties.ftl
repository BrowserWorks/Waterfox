# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

carddav-url-label =
    .value = CardDAV-URL:
    .accesskey = V
carddav-refreshinterval-label =
    .label = Synchronizěrowaś:
    .accesskey = S
# Variables:
#   $minutes (integer) - Number of minutes between address book synchronizations
carddav-refreshinterval-minutes-value =
    .label =
        { $minutes ->
            [one] kuždu { $minutes } minutu
            [two] kuždej { $minutes } minuśe
            [few] kužde { $minutes } minuty
           *[other] kužde { $minutes } minutow
        }
# Variables:
#   $hours (integer) - Number of hours between address book synchronizations
carddav-refreshinterval-hours-value =
    .label =
        { $hours ->
            [one] kuždu { $hours } góźinu
            [two] kuždej { $hours } góźinje
            [few] kužde { $hours } góźiny
           *[other] kužde { $hours } góźin
        }
