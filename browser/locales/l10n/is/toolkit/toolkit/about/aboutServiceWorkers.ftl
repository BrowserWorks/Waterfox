# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Um Service Workers
about-service-workers-main-title = Skráðir Service Workers
about-service-workers-warning-not-enabled = Service Workers ekki virkir.
about-service-workers-warning-no-service-workers = Engir Service Workers skráðir.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Uppruni: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Umfang:</strong> { $name }
script-spec = <strong>Skriftu staðall:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>Núverandi Worker URL:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nafn á virku biðminni:</strong> { $name }
waiting-cache-name = <strong>Nafn á biðminni:</strong> { $name }
push-end-point-waiting = <strong>Senda endapunkt:</strong> { waiting }
push-end-point-result = <strong>Senda endapunkt:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Uppfæra

unregister-button = Afskrá

unregister-error = Gat ekki afskráð þennan Service Worker.

waiting = Bið…
