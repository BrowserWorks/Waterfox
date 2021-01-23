# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Quant als processos de treball de servei
about-service-workers-main-title = Processos de treball de servei registrats
about-service-workers-warning-not-enabled = Els processos de treball de servei no estan activats.
about-service-workers-warning-no-service-workers = No hi ha cap procés de treball de servei registrat.

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

scope = <strong>Àmbit:</strong> { $name }
script-spec = <strong>Especificació de l'script:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL del procés de treball actual:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nom de la memòria cau activa:</strong> { $name }
waiting-cache-name = <strong>Nom de la memòria cau en espera:</strong> { $name }
push-end-point-waiting = <strong>Punt final de transferència Push:</strong> { waiting }
push-end-point-result = <strong>Punt final de transferència Push:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Actualitza

unregister-button = Suprimeix el registre

unregister-error = No s'ha pogut suprimir el registre d'aquest procés de treball de servei.

waiting = S'està esperant…
