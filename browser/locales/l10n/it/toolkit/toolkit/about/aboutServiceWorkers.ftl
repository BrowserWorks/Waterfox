# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Informazioni sui service worker
about-service-workers-main-title = Service worker registrati
about-service-workers-warning-not-enabled = Service worker non attivati.
about-service-workers-warning-no-service-workers = Nessun service worker registrato.

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
script-spec = <strong>Spec. script:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL worker corrente:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nome cache attiva:</strong> { $name }
waiting-cache-name = <strong>In attesa del nome cache:</strong> { $name }
push-end-point-waiting = <strong>Endpoint push:</strong> { waiting }
push-end-point-result = <strong>Endpoint push:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Aggiorna

unregister-button = Deregistra

unregister-error = Deregistrazione del service worker non riuscita.

waiting = In attesa…
