# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Acerca de los Service Workers
about-service-workers-main-title = Service Workers registrados
about-service-workers-warning-not-enabled = Service Workers no activados.
about-service-workers-warning-no-service-workers = No hay Service Workers registrados.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Origen: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Alcance:</strong> { $name }
script-spec = <strong>Especificaciones del Script:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL del Worker actual:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nombre de la Caché activa:</strong> { $name }
waiting-cache-name = <strong>Esperando el nombre de la Caché:</strong> { $name }
push-end-point-waiting = <strong>Punto final del empuje:</strong> { waiting }
push-end-point-result = <strong>Punto final del empuje:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Actualizar

unregister-button = Desregistrar

unregister-error = Falló el desregistrar este Service Worker.

waiting = Esperando…
