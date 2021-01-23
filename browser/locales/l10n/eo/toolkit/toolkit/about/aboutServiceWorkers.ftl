# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Pri Service Workers
about-service-workers-main-title = Registritaj Service Workers
about-service-workers-warning-not-enabled = Service Workers ne estas aktivaj.
about-service-workers-warning-no-service-workers = Neniu registrita Service Workers.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Origino: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Amplekso:</strong> { $name }
script-spec = <strong>Skripta specifo:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL de nuna Worker:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nomo de aktiva staplo:</strong> { $name }
waiting-cache-name = <strong>Nomo de atendanta staplo:</strong> { $name }
push-end-point-waiting = <strong>Flanko de «Push»:</strong> { waiting }
push-end-point-result = <strong>Flanko de «Push»:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Ĝisdatigi

unregister-button = Malregistri

unregister-error = Malsukcesa malregistro de tiu ĉi Service Worker.

waiting = Atendo…
