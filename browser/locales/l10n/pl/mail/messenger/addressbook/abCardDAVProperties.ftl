# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

carddav-url-label =
    .value = Adres URL do CardDAV:
    .accesskey = U

carddav-refreshinterval-label =
    .label = Synchronizuj:
    .accesskey = S

# Variables:
#   $minutes (integer) - Number of minutes between address book synchronizations
carddav-refreshinterval-minutes-value =
    .label =
        { $minutes ->
            [one] co minutę
            [few] co { $minutes } minuty
           *[many] co { $minutes } minut
        }

# Variables:
#   $hours (integer) - Number of hours between address book synchronizations
carddav-refreshinterval-hours-value =
    .label =
        { $hours ->
            [one] co godzinę
            [few] co { $hours } godziny
           *[many] co { $hours } godzin
        }

carddav-readonly-label =
    .label = Tylko do odczytu
    .accesskey = T
