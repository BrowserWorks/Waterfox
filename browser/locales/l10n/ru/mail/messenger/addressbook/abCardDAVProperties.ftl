# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

carddav-url-label =
    .value = URL CardDAV:
    .accesskey = V
carddav-refreshinterval-label =
    .label = Синхронизовать:
    .accesskey = х
# Variables:
#   $minutes (integer) - Number of minutes between address book synchronizations
carddav-refreshinterval-minutes-value =
    .label =
        { $minutes ->
            [one] каждую { $minutes } минуту
            [few] каждые { $minutes } минуты
           *[many] каждые { $minutes } минут
        }
# Variables:
#   $hours (integer) - Number of hours between address book synchronizations
carddav-refreshinterval-hours-value =
    .label =
        { $hours ->
            [one] каждый { $hours } час
            [few] каждые { $hours } часа
           *[many] каждые { $hours } часов
        }
carddav-readonly-label =
    .label = Только для чтения
    .accesskey = е
