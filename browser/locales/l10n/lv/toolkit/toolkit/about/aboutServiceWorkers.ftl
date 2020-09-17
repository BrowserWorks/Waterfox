# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Par pakalpojumu darbiniekiem
about-service-workers-main-title = Reģistrētie pakalpojumu darbinieki
about-service-workers-warning-not-enabled = Neaktivizētie pakalpojumu darbinieki.
about-service-workers-warning-no-service-workers = Nav reģistrēts neviens pakalpojumu darbinieks.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Avots: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Darbības apgabals:</strong> { $name }
script-spec = <strong>Script Spec:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>Pašreizējā darbinieka adrese:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Aktīvā kešatmiņa:</strong> { $name }
waiting-cache-name = <strong>Gaidošā kešatmiņa:</strong> { $name }
push-end-point-waiting = <strong>Push galamērķis:</strong> { waiting }
push-end-point-result = <strong>Push galamērķis:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Atjaunināt

unregister-button = Atreģistrēt

unregister-error = Neizdevās atreģistrēt pakalpojuma darbinieku.

waiting = Gaida…
