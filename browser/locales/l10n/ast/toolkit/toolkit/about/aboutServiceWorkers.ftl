# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Tocante a los trabayadores del serviciu
about-service-workers-main-title = Trabayadores del serviciu rexistraos
about-service-workers-warning-not-enabled = Nun s'activaron los trabayadores del serviciu.
about-service-workers-warning-no-service-workers = Nun se rexistró dengún trabayador del serviciu.

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

scope = <strong>Algame:</strong> { $name }
script-spec = <strong>Especificación del script:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL del trabayador actual:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nome de la caché activa:</strong> { $name }
waiting-cache-name = <strong>Nome de la caché n'espera:</strong> { $name }
push-end-point-waiting = <strong>Puntu final de tresferencia Push:</strong> { waiting }
push-end-point-result = <strong>Puntu final de tresferencia Push:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Anovar

unregister-button = Anular rexistru

unregister-error = Fallu al anular rexistru d'esti trabayador del serviciu.

waiting = Esperando…
