# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = A proposito del Service Workers
about-service-workers-main-title = Service Workers registrate
about-service-workers-warning-not-enabled = Le Service Workers non es active.
about-service-workers-warning-no-service-workers = Nulle Service Workers registrate.

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

scope = <strong>Ambito:</strong> { $name }
script-spec = <strong>Specification del script:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL del Worker actual:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nomine del cache active:</strong> { $name }
waiting-cache-name = <strong>Attendente pro le nomine del cache:</strong> { $name }
push-end-point-waiting = <strong>Destination final:</strong> { waiting }
push-end-point-result = <strong>Destination final:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Actualisar

unregister-button = De-registrar

unregister-error = Falta a registrar iste Service Worker.

waiting = Attendente…
