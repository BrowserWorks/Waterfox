# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Om Service Workers
about-service-workers-main-title = Registrerade Service Workers
about-service-workers-warning-not-enabled = Service Workers är inte aktiverade.
about-service-workers-warning-no-service-workers = Inga Service Workers registrerade.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Ursprung: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Omfattning:</strong> { $name }
script-spec = <strong>Specifikation skript:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>Aktuell Worker URL:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Aktivt cache namn:</strong> { $name }
waiting-cache-name = <strong>Väntande cache namn:</strong> { $name }
push-end-point-waiting = <strong>Skicka Endpoint:</strong> { waiting }
push-end-point-result = <strong>Skicka Endpoint:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Uppdatera

unregister-button = Avregistrera

unregister-error = Det gick inte att avregistrera denna Service Worker.

waiting = Väntar…
