# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Ynghylch Service Workers
about-service-workers-main-title = Service Workers Cofrestredig
about-service-workers-warning-not-enabled = Nid yw Service Workers wedi eu galluogi.
about-service-workers-warning-no-service-workers = Does dim Service Workers wedi eu cofrestru.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Tarddiad: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Ystod:</strong> { $name }
script-spec = <strong>Manyleb Sgript:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL Worker Cyfredol:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Enw'r Storfa Dros Dro Weithredol:</strong> { $name }
waiting-cache-name = <strong>Enw'r Storfa Dros Dro sy'n Aros:</strong> { $name }
push-end-point-waiting = <strong>Push Endpoint:</strong> { waiting }
push-end-point-result = <strong>Push Endpoint:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Diweddaru

unregister-button = Dadgofrestru

unregister-error = Methwyd dadgofrestru'r Service Workers.

waiting = Aros…
