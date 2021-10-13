# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

carddav-url-label =
    .value = CardDAV-adresse:
    .accesskey = V

carddav-refreshinterval-label =
    .label = Synkroniser:
    .accesskey = S

# Variables:
#   $minutes (integer) - Number of minutes between address book synchronizations
carddav-refreshinterval-minutes-value =
    .label =
        { $minutes ->
            [one] kvart minutt
           *[other] kvart { $minutes }. minutt
        }

# Variables:
#   $hours (integer) - Number of hours between address book synchronizations
carddav-refreshinterval-hours-value =
    .label =
        { $hours ->
            [one] kvar time
           *[other] kvarr { $hours }. time
        }

carddav-readonly-label =
    .label = Skriveverna
    .accesskey = S
