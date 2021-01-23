# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Sobre "Service Workers"
about-service-workers-main-title = Service Workers rechistraus
about-service-workers-warning-not-enabled = Os Service Workers no s'han habilitau
about-service-workers-warning-no-service-workers = No s'ha habilitau Service Workers

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Orichen: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Ambito</strong> { $name }
script-spec = <strong>Script Spec:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL de Worker actual:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nombre de caché activa:</strong> { $name }
waiting-cache-name = <strong>Aguardando a nombre de caché:</strong> { $name }
push-end-point-waiting = <strong>Empentar Punto final:</strong> { waiting }
push-end-point-result = <strong>Empentar Punto final:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Actualización:

unregister-button = Desrechistrar

unregister-error = No s'ha puesto desrechistrar iste Service Worker.

waiting = Se ye aguardando…
