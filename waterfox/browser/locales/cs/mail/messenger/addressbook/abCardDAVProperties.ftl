# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

carddav-url-label =
    .value = URL adresa CardDAV:
    .accesskey = V

carddav-refreshinterval-label =
    .label = Synchronizovat:
    .accesskey = S

# Variables:
#   $minutes (integer) - Number of minutes between address book synchronizations
carddav-refreshinterval-minutes-value =
    .label =
        { $minutes ->
            [one] každou minutu
            [few] každé { $minutes } minuty
           *[other] každých { $minutes } minut
        }

# Variables:
#   $hours (integer) - Number of hours between address book synchronizations
carddav-refreshinterval-hours-value =
    .label =
        { $hours ->
            [one] každou hodinu
            [few] každé { $hours } hodiny
           *[other] každých { $hours } hodin
        }

carddav-readonly-label =
    .label = Pouze pro čtení
    .accesskey = r
