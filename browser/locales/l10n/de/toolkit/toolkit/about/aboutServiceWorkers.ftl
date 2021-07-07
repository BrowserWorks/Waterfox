# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Über Service-Worker
about-service-workers-main-title = Angemeldete Service-Worker
about-service-workers-warning-not-enabled = Service-Worker sind deaktiviert.
about-service-workers-warning-no-service-workers = Keine Service-Worker angemeldet.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Quelle: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Gültigkeitsbereich:</strong> { $name }
script-spec = <strong>Skript-Spezifikation:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>Aktuelle Worker-Adresse:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Name des aktiven Caches:</strong> { $name }
waiting-cache-name = <strong>Name des wartenden Caches:</strong> { $name }
push-end-point-waiting = <strong>Push-Endpunkt:</strong> { waiting }
push-end-point-result = <strong>Push-Endpunkt:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Aktualisieren

unregister-button = Abmelden

unregister-error = Fehler beim Abmelden des Service-Workers

waiting = Warten…
