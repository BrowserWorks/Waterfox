# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

carddav-url-label =
    .value = CardDAV-URL:
    .accesskey = V
carddav-refreshinterval-label =
    .label = Synchronizować:
    .accesskey = S
# Variables:
#   $minutes (integer) - Number of minutes between address book synchronizations
carddav-refreshinterval-minutes-value =
    .label =
        { $minutes ->
            [one] kóždu { $minutes } mjeńšinu
            [two] kóždej { $minutes } mjeńšinje
            [few] kóžde { $minutes } mjeńšiny
           *[other] kóžde { $minutes } mjeńšin
        }
# Variables:
#   $hours (integer) - Number of hours between address book synchronizations
carddav-refreshinterval-hours-value =
    .label =
        { $hours ->
            [one] kóždu { $hours } hodźinu
            [two] kóždej { $hours } hodźinje
            [few] kóžde { $hours } hodźiny
           *[other] kóžde { $hours } hodźin
        }
