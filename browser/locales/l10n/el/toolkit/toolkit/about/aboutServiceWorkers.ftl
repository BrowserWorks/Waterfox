# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Σχετικά με τα Service Workers
about-service-workers-main-title = Εγγεγραμμένα Service Workers
about-service-workers-warning-not-enabled = Τα Service Workers δεν είναι ενεργοποιημένα.
about-service-workers-warning-no-service-workers = Κανένα εγγεγραμμένο Service Worker.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Προέλευση: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Εμβέλεια:</strong> { $name }
script-spec = <strong>Προδιαγραφές σεναρίου:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL τρέχοντος Worker:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Όνομα ενεργής προσωρινής μνήμη:</strong> { $name }
waiting-cache-name = <strong>Όνομα προσωρινής μνήμης σε αναμονή:</strong> { $name }
push-end-point-waiting = <strong>Σημείο τερματισμού:</strong> { waiting }
push-end-point-result = <strong>Σημείο τερματισμού:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Ενημέρωση

unregister-button = Διαγραφή

unregister-error = Απέτυχε η κατάργηση αυτού του Service Worker.

waiting = Σε αναμονή…
