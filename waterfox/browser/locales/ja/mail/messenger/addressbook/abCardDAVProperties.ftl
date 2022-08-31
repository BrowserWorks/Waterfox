# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

carddav-url-label =
    .value = CardDAV URL:
    .accesskey = V

carddav-refreshinterval-label =
    .label = 同期間隔:
    .accesskey = S

# Variables:
#   $minutes (integer) - Number of minutes between address book synchronizations
carddav-refreshinterval-minutes-value =
    .label = { $minutes ->
        [one] 毎分
       *[other] { $minutes } 分ごと
    }

# Variables:
#   $hours (integer) - Number of hours between address book synchronizations
carddav-refreshinterval-hours-value =
    .label = { $hours ->
        [one] 毎時間
       *[other] { $hours } 時間ごと
    }

carddav-readonly-label =
    .label = 読み取り専用
    .accesskey = R
