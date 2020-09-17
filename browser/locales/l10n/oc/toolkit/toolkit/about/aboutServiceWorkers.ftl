# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = A prepaus dels servicis Workers
about-service-workers-main-title = Servici Workers enregistrats
about-service-workers-warning-not-enabled = Los Servicis Workers son pas activats.
about-service-workers-warning-no-service-workers = Cap de servici Workers pas enregistrat.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Origina : { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Portada :</strong> { $name }
script-spec = <strong>Caracteristicas de l'escript :</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL del Worker corrent :</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nom de cache actiu :</strong> { $name }
waiting-cache-name = <strong>Nom de cache en espèra :</strong> { $name }
push-end-point-waiting = <strong>Punt de terminason pel mandadís :</strong> { waiting }
push-end-point-result = <strong>Punt de terminason pel mandadís :</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Metre a jorn

unregister-button = Desinscriure

unregister-error = Fracàs de la desinscripcion d'aqueste Service Worker.

waiting = En espèra…
