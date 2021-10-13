# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Om service workers
about-service-workers-main-title = Registrerede service workers
about-service-workers-warning-not-enabled = Service workers er ikke aktiveret.
about-service-workers-warning-no-service-workers = Ingen service workers registreret.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Oprindelse: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Scope:</strong> { $name }
script-spec = <strong>Script-spec.:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>Aktuel Worker-URL:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Aktuel cache-navn:</strong> { $name }
waiting-cache-name = <strong>Ventende cache-navn:</strong> { $name }
push-end-point-waiting = <strong>Push netværksplacering:</strong> { waiting }
push-end-point-result = <strong>Push netværksplacering:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Opdater

unregister-button = Afregistrering

unregister-error = Kunne ikke afregistrere denne Service Worker.

waiting = Venter…
