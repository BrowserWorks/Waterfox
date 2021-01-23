# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Про Service Workers
about-service-workers-main-title = Зареєстровані Service Workers
about-service-workers-warning-not-enabled = Service Workers не увімкнені.
about-service-workers-warning-no-service-workers = Немає зареєстрованих Service Workers.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Джерело: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Область:</strong> { $name }
script-spec = <strong>Специфікація сценарія:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL поточного Worker:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Ім'я активного кеша:</strong> { $name }
waiting-cache-name = <strong>Ім'я очікуваного кеша:</strong> { $name }
push-end-point-waiting = <strong>Кінцева точка Push:</strong> { waiting }
push-end-point-result = <strong>Кінцева точка Push:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Оновити

unregister-button = Розреєструвати

unregister-error = Не вдалося розреєструвати цей Service Worker.

waiting = Очікування…
