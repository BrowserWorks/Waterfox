# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = О Service Worker'ах
about-service-workers-main-title = Зарегистрированные Service Worker'ы
about-service-workers-warning-not-enabled = Нет включённых Service Worker'ов.
about-service-workers-warning-no-service-workers = Ни одного Service Worker'а не зарегистрировано.
# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Источник: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Область:</strong> { $name }
script-spec = <strong>Спецификация сценария:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL текущего Worker:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Имя активного кэша:</strong> { $name }
waiting-cache-name = <strong>Имя кэша ожидания:</strong> { $name }
push-end-point-waiting = <strong>Конечная точка Push:</strong> { waiting }
push-end-point-result = <strong>Конечная точка Push:</strong> { $name }
# This term is used as a button label (verb, not noun).
update-button = Обновить
unregister-button = Разрегистрировать
unregister-error = Не удалось разрегистрировать этот Service Worker.
waiting = Ожидание…
