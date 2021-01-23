# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Informaçioin in sci Service worker
about-service-workers-main-title = Service worker registræ
about-service-workers-warning-not-enabled = Service worker no ativæ.
about-service-workers-warning-no-service-workers = Nisciun Service worker registròu.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Òrigine: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Anbito:</strong> { $name }
script-spec = <strong>Spec. script:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL worker corente:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nomme cache ativa:</strong> { $name }
waiting-cache-name = <strong>In ateiza do nomme cache:</strong> { $name }
push-end-point-waiting = <strong>Endpoint push:</strong> { waiting }
push-end-point-result = <strong>Endpoint push:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Agiorna

unregister-button = Deregistra

unregister-error = Deregistraçion do Service worker no ariescia.

waiting = In ateiza…
