# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Despre scripturile Service Worker
about-service-workers-main-title = Scripturi Service Worker înregistrate
about-service-workers-warning-not-enabled = Scripturile Service Worker nu sunt activate.
about-service-workers-warning-no-service-workers = Niciun Service Worker înregistrat.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Origine: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Domeniu:</strong> { $name }
script-spec = <strong>Specificația scriptului:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL-ul actual al workerului:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nume de cache activ:</strong> { $name }
waiting-cache-name = <strong>Nume de cache în așteptare:</strong> { $name }
push-end-point-waiting = <strong>Punct terminal de transferuri push:</strong> { waiting }
push-end-point-result = <strong>Punct terminal de transferuri push:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Actualizează

unregister-button = Dezînregistrează

unregister-error = Nu s-a reușit dezînregistrarea acestui Service Worker.

waiting = Așteptare…
