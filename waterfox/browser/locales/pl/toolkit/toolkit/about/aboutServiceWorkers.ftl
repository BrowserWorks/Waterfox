# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = O wątkach usługowych
about-service-workers-main-title = Zarejestrowane wątki usługowe
about-service-workers-warning-not-enabled = Obsługa wątków usługowych jest wyłączona.
about-service-workers-warning-no-service-workers = Brak zarejestrowanych wątków usługowych.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Źródło: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Zakres</strong>: { $name }
script-spec = <strong>Specyfikacja skryptu</strong>: <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>Bieżący adres wątku</strong>: <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Aktywna pamięć podręczna</strong>: { $name }
waiting-cache-name = <strong>Oczekująca pamięć podręczna</strong>: { $name }
push-end-point-waiting = <strong>pushEndpoint</strong>: { waiting }
push-end-point-result = <strong>pushEndpoint</strong>: { $name }

# This term is used as a button label (verb, not noun).
update-button = Uaktualnij

unregister-button = Wyrejestruj

unregister-error = Nie udało się wyrejestrować wątku usługowego

waiting = Oczekiwanie…
