# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Tungkol sa mga Service Worker
about-service-workers-main-title = Mga Nakarehistrong Service Worker
about-service-workers-warning-not-enabled = Hindi naka-enable ang mga Service Worker.
about-service-workers-warning-no-service-workers = Walang naka-rehistrong mga Service Worker.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Pinagmulan: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Saklaw:</strong> { $name }
script-spec = <strong>Script Spec:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>Kasalukuyang Worker URL:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Pangalan ng Aktibong Cache:</strong> { $name }
waiting-cache-name = <strong>Pangalan ng Nag-iintay na Cache:</strong> { $name }
push-end-point-waiting = <strong>Push Endpoint:</strong> { waiting }
push-end-point-result = <strong>Push Endpoint:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Update

unregister-button = Unregister

unregister-error = Bigong i-unregister ang Service Worker na ito.

waiting = Naghihintay…
