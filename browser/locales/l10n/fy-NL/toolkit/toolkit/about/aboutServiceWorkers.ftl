# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Oer Service Workers
about-service-workers-main-title = Registrearre Service Workers
about-service-workers-warning-not-enabled = Service Workers binne net ynskeakele.
about-service-workers-warning-no-service-workers = Gjin Service Workers registrearre.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Oarsprong: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Berik:</strong> { $name }
script-spec = <strong>Scriptspesifikaasje:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL fan aktuele Worker:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Namme fan aktive buffer:</strong> { $name }
waiting-cache-name = <strong>Namme fan wachtbuffer:</strong> { $name }
push-end-point-waiting = <strong>Push-einpunt:</strong> { waiting }
push-end-point-result = <strong>Push-einpunt:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Bywurkje

unregister-button = Registraasje opheffe

unregister-error = Opheffen fan registraasje fan dizze Service Worker mislearre.

waiting = Wachtsje…
