# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

carddav-url-label =
    .value = CardDAV 網址:
    .accesskey = V

carddav-refreshinterval-label =
    .label = 同步:
    .accesskey = S

# Variables:
#   $minutes (integer) - Number of minutes between address book synchronizations
carddav-refreshinterval-minutes-value =
    .label =
        { $minutes ->
            [one] 每分鐘
           *[other] 每 { $minutes } 分鐘
        }

# Variables:
#   $hours (integer) - Number of hours between address book synchronizations
carddav-refreshinterval-hours-value =
    .label =
        { $hours ->
            [one] 每小時
           *[other] 每 { $hours } 小時
        }

carddav-readonly-label =
    .label = 唯讀
    .accesskey = R
