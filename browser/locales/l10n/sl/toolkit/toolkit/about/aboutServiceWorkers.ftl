# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = O Service Workerjih
about-service-workers-main-title = Registrirani Service Workerji
about-service-workers-warning-not-enabled = Service Workerji niso omogočeni.
about-service-workers-warning-no-service-workers = Ni registriranih Service Workerjev.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Izvor: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Obseg:</strong> { $name }
script-spec = <strong>Specifikacija skripta:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL trenutnega Workerja:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Ime aktivnega predpomnilnika:</strong> { $name }
waiting-cache-name = <strong>Ime predpomnilnika na čakanju:</strong> { $name }
push-end-point-waiting = <strong>Končna točka Push:</strong> { waiting }
push-end-point-result = <strong>Končna točka Push:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Posodobi

unregister-button = Odstrani

unregister-error = Odjava Service Workerja ni uspela.

waiting = Čakanje …
