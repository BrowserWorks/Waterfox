# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Mbi Service Workers
about-service-workers-main-title = Service Workers të Regjistruar
about-service-workers-warning-not-enabled = Service Workers nuk janë të aktivizuar.
about-service-workers-warning-no-service-workers = Pa Service Workers të regjistruar.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Origjinë: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Objekt:</strong> { $name }
script-spec = <strong>Specifikime Skriptimic:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL Worker-i të Tanishëm:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Emër Fshehtine Aktive:</strong> { $name }
waiting-cache-name = <strong>Emër Fshehtine në Pritje:</strong> { $name }
push-end-point-waiting = <strong>Push Endpoint:</strong> { waiting }
push-end-point-result = <strong>Push Endpoint:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Përditësoje

unregister-button = Çregjistroje

unregister-error = S’u arrit të çregjistrohet ky Service Worker.

waiting = Po pritet…
