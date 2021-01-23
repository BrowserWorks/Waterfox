# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Аб Service Workers
about-service-workers-main-title = Зарэгістраваныя Service Workers
about-service-workers-warning-not-enabled = Service Workers не ўключаны.
about-service-workers-warning-no-service-workers = Ніводнага Service Worker не зарэгістравана.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Крыніца: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Вобласць:</strong> { $name }
script-spec = <strong>Спецыфікацыя сцэнару:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL бягучага Worker:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Імя актыўнага кэша:</strong> { $name }
waiting-cache-name = <strong>Імя кэша чакання:</strong> { $name }
push-end-point-waiting = <strong>Канчатковая кропка Push:</strong> { waiting }
push-end-point-result = <strong>Канчатковая кропка Push:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Абнавіць

unregister-button = Разрэгістраваць

unregister-error = Не атрымалася разрэгістраваць гэты Service Worker.

waiting = Чаканне…
