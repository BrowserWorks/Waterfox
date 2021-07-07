# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

carddav-url-label =
    .value = „CardDAV“ URL:
    .accesskey = V
carddav-refreshinterval-label =
    .label = Sinchronizuoti:
    .accesskey = S
# Variables:
#   $minutes (integer) - Number of minutes between address book synchronizations
carddav-refreshinterval-minutes-value =
    .label =
        { $minutes ->
            [one] kas { $minutes } minutę
            [few] kas { $minutes } minutes
           *[other] kas { $minutes } minučių
        }
# Variables:
#   $hours (integer) - Number of hours between address book synchronizations
carddav-refreshinterval-hours-value =
    .label =
        { $hours ->
            [one] kas { $hours } valandą
            [few] kas { $hours } valandas
           *[other] kas { $hours } valandų
        }
carddav-readonly-label =
    .label = Tik skaitymui
    .accesskey = s
