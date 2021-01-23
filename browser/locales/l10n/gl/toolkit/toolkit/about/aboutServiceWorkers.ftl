# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Sobre os Service Workers
about-service-workers-main-title = Service Workers rexistrados
about-service-workers-warning-not-enabled = Os Service Workers non están activados.
about-service-workers-warning-no-service-workers = Non hai Service Workers rexistrados.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Orixe: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Ámbito:</strong> { $name }
script-spec = <strong>Especificación do script:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL do Worker actual:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nome da caché activa:</strong> { $name }
waiting-cache-name = <strong>Nome da caché de espera:</strong> { $name }
push-end-point-waiting = <strong>Push Endpoint:</strong> { waiting }
push-end-point-result = <strong>Push Endpoint:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Actualizar

unregister-button = Cancelar rexistro

unregister-error = Fallou a cancelación do rexistro deste Service Worker.

waiting = Agardando…
