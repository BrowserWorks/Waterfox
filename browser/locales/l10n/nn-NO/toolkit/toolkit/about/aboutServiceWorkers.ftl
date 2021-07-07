# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Om Service Workers
about-service-workers-main-title = Registrerte Service Workers
about-service-workers-warning-not-enabled = Service Workers er ikkje påslått.
about-service-workers-warning-no-service-workers = Ingen Service Workers er registrerte.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Kjelde: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Skop:</strong> { $name }
script-spec = <strong>Script-spec:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>Gjeldande Worker-URL:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Aktivt cachenamn:</strong> { $name }
waiting-cache-name = <strong>Ventande cachenamn:</strong> { $name }
push-end-point-waiting = <strong>Push-endepunkt:</strong> { waiting }
push-end-point-result = <strong>Push-endepunkt:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Oppdater

unregister-button = Avregistrer

unregister-error = Klarte ikkje å avregistrere denne serviceworkeren.

waiting = Ventar …
