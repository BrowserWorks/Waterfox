# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Apie aptarnavimo scenarijus
about-service-workers-main-title = Registruoti aptarnavimo scenarijai
about-service-workers-warning-not-enabled = Aptarnavimo scenarijai yra išjungti.
about-service-workers-warning-no-service-workers = Nėra registruotų aptarnavimo scenarijų.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Kilmė: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Galiojimo sritis:</strong> { $name }
script-spec = <strong>Scenarijaus aprašymas:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>Dabartinio scenarijaus URL:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Aktyvaus podėlio pavadinimas:</strong> { $name }
waiting-cache-name = <strong>Laukiančio podėlio pavadinimas:</strong> { $name }
push-end-point-waiting = <strong>Galinis siuntimo taškas:</strong> { waiting }
push-end-point-result = <strong>Galinis siuntimo taškas:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Atnaujinti

unregister-button = Išregistruoti

unregister-error = Nepavyko išregistruoti šio scenarijaus.

waiting = Laukiama…
