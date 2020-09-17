# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Davart Service Workers
about-service-workers-main-title = Service Workers registrads
about-service-workers-warning-not-enabled = Service Workers n'èn betg activads.
about-service-workers-warning-no-service-workers = Nagins Service Workers registrads.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Origin: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Champ d'applicaziun:</strong> { $name }
script-spec = <strong>Specificaziun dal sript:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL dal worker actual:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Num dal cache activ:</strong> { $name }
waiting-cache-name = <strong>Num dal cache che spetga:</strong> { $name }
push-end-point-waiting = <strong>Endpoint da Push:</strong> { waiting }
push-end-point-result = <strong>Endpoint da Push:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Actualisar

unregister-button = De-registrar

unregister-error = Betg reussì da de-registrar quest Service Worker.

waiting = Spetgar…
