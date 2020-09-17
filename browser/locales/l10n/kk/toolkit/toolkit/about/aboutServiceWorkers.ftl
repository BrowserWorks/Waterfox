# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Жұмыс үрдістері жөнінде
about-service-workers-main-title = Тіркелген жұмыс үрдістері
about-service-workers-warning-not-enabled = Жұмыс үрдістері іске қосылмаған.
about-service-workers-warning-no-service-workers = Тіркелген жұмыс үрдістері жоқ.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Шыққан жері: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Аймақ</strong> { $name }
script-spec = <strong>Сценарий спецификациясы:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>Ағымдағы Worker сілтемесі:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Белсенді кэш аты:</strong> { $name }
waiting-cache-name = <strong>Күту кэш аты:</strong> { $name }
push-end-point-waiting = <strong>Push түпкі нүктесі:</strong> { waiting }
push-end-point-result = <strong>Push түпкі нүктесі:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Жаңарту

unregister-button = Тіркеуден шығару

unregister-error = Бұл Service Worker тіркеуден шығару сәтсіз аяқталды.

waiting = Күту…
