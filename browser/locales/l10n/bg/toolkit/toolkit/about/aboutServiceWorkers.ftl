# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Относно Service Workers
about-service-workers-main-title = Регистрирани Service Workers
about-service-workers-warning-not-enabled = Service Workers не са включени.
about-service-workers-warning-no-service-workers = Няма регистрирани Service Workers.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Произход: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Обхват:</strong> { $name }
script-spec = <strong>Спецификация на скрипт:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>Интернет адрес на текущ Worker:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Име на активен буфер:</strong> { $name }
waiting-cache-name = <strong>Име на изчакващ буфер:</strong> { $name }
push-end-point-waiting = <strong>Входна точка на избутване:</strong> { waiting }
push-end-point-result = <strong>Входна точка на избутване:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Обновяване

unregister-button = Отмяна на регистрацията

unregister-error = Грешка при отмяна на регистрацията на скритата обслужваща страница.

waiting = Изчакване…
