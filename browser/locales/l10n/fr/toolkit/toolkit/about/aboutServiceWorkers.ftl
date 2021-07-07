# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = À propos des Service workers
about-service-workers-main-title = Service workers inscrits
about-service-workers-warning-not-enabled = Les Service workers ne sont pas activés.
about-service-workers-warning-no-service-workers = Aucun service worker inscrit.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Origine : { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Portée :</strong> { $name }
script-spec = <strong>Script des spécifications :</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL du Worker courant :</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nom de cache actif :</strong> { $name }
waiting-cache-name = <strong>Nom de cache en attente :</strong> { $name }
push-end-point-waiting = <strong>Point de terminaison pour l’envoi :</strong> { waiting }
push-end-point-result = <strong>Point de terminaison pour l’envoi :</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Mettre à jour

unregister-button = Désinscrire

unregister-error = Échec de la désinscription de ce Service worker.

waiting = Veuillez patienter…
