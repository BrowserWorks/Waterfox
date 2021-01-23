# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Ikom Service Workers
about-service-workers-main-title = Service Workers ma kicoyo
about-service-workers-warning-not-enabled = Pe kicako Service Workers.
about-service-workers-warning-no-service-workers = Pe tye Service Workers ma kicoyo.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Kama oa iye: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Kama orumo:</strong> { $name }
script-spec = <strong>Lok ikom coc:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL pa Worker ma kombedi:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nying kakan ma tye katic:</strong> { $name }
waiting-cache-name = <strong>Nying kakan ma tye kakuro:</strong> { $name }
push-end-point-waiting = <strong>Agiki me coro:</strong> { waiting }
push-end-point-result = <strong>Agiki me coro:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Ngec manyen

unregister-button = Kwanyo

unregister-error = Kwanyo Service Worker man pe olare.

waiting = Kuro…
