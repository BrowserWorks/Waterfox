# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Service Workers haqida
about-service-workers-main-title = Ro‘yxatdan o‘tgan Service Workers
about-service-workers-warning-not-enabled = Service Workers yoqilmagan.
about-service-workers-warning-no-service-workers = Hech qanday Service Workers ro‘yxatdan o‘tmagan.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Manbasi: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Doira:</strong> { $name }
script-spec = <strong>Spekulyatsiya skripti:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>Joriy Worker URL manzili:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Faol kesh nomi:</strong> { $name }
waiting-cache-name = <strong>Kesh nomi kutilmoqda:</strong> { $name }
push-end-point-waiting = <strong>Turtki tugash nuqtasi:</strong> { waiting }
push-end-point-result = <strong>Turtki tugash nuqtasi:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Yangilash

unregister-button = Ro‘yxatdan chiqarish

unregister-error = Ushbu Service Worker ro‘yxatdan chiqmadi.

waiting = Kutilmoqda…
