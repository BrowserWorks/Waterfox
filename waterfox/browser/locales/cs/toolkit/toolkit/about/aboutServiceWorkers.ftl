# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = O Service Worker
about-service-workers-main-title = Registrovaní Service Workers
about-service-workers-warning-not-enabled = Service Workers nejsou povoleny.
about-service-workers-warning-no-service-workers = Není zaregistrován žádný Service Worker.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Původ: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Rozsah:</strong> { $name }
script-spec = <strong>Specifikace skriptu:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL aktuálního Worker:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Název aktivní vyrovnávací paměti:</strong> { $name }
waiting-cache-name = <strong>Čekající název vyrovnávací paměti:</strong> { $name }
push-end-point-waiting = <strong>Push Endpoint:</strong> { waiting }
push-end-point-result = <strong>Push Endpoint:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Aktualizovat

unregister-button = Zrušit registraci

unregister-error = Chyba při rušení registrace tohoto Service Worker.

waiting = Čekání…
