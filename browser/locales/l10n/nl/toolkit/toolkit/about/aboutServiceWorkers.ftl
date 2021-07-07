# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Over Service Workers
about-service-workers-main-title = Geregistreerde Service Workers
about-service-workers-warning-not-enabled = Service Workers zijn niet ingeschakeld.
about-service-workers-warning-no-service-workers = Geen Service Workers geregistreerd.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Oorsprong: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Bereik:</strong> { $name }
script-spec = <strong>Scriptspecificatie:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL van huidige Worker:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Naam van actieve buffer:</strong> { $name }
waiting-cache-name = <strong>Naam van wachtbuffer:</strong> { $name }
push-end-point-waiting = <strong>Push-eindpunt:</strong> { waiting }
push-end-point-result = <strong>Push-eindpunt:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Bijwerken

unregister-button = Registratie opheffen

unregister-error = Opheffen van registratie van deze Service Worker mislukt.

waiting = Wachten…
