# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

carddav-url-label =
    .value = CardDAV URL：
    .accesskey = V
carddav-refreshinterval-label =
    .label = 同步：
    .accesskey = S
# Variables:
#   $minutes (integer) - Number of minutes between address book synchronizations
carddav-refreshinterval-minutes-value =
    .label =
        { $minutes ->
            [one] 每分钟
           *[other] 每 { $minutes } 分钟
        }
# Variables:
#   $hours (integer) - Number of hours between address book synchronizations
carddav-refreshinterval-hours-value =
    .label =
        { $hours ->
            [one] 每小时
           *[other] 每 { $hours } 小时
        }
carddav-readonly-label =
    .label = 只读
    .accesskey = R
