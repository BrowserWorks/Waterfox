# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Zerbitzu-langileei buruz
about-service-workers-main-title = Erregistratutako zerbitzu-langileak
about-service-workers-warning-not-enabled = Zerbitzu-langileak ez daude gaituta.
about-service-workers-warning-no-service-workers = Ez da zerbitzu-langilerik erregistratu.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Jatorria: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Esparrua:</strong> { $name }
script-spec = <strong>Scriptaren espezifikazioa:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>Uneko langilearen URLa:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Cache aktiboaren izena:</strong> { $name }
waiting-cache-name = <strong>Zain dagoen cachearen izena:</strong> { $name }
push-end-point-waiting = <strong>Push amaiera-puntua:</strong> { waiting }
push-end-point-result = <strong>Push amaiera-puntua:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Eguneratu

unregister-button = Kendu erregistroa

unregister-error = Huts egin du zerbitzu-langile hau erregistrotik kentzean.

waiting = Itxaroten…
