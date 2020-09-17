# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = אודות Service Workers
about-service-workers-main-title = Service Workers רשומים
about-service-workers-warning-not-enabled = Service Workers אינם מופעלים.
about-service-workers-warning-no-service-workers = אין Service Workers רשומים.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = מקור: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>היקף:</strong> { $name }
current-worker-url = <strong>כתובת ה־Worker הנוכחי:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>שם המטמון הפעיל:</strong> { $name }
waiting-cache-name = <strong>שם מטמון המתנה:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = עדכון

unregister-button = ביטול רישום

unregister-error = ביטול הרישום של Service Worker זה נכשל.

waiting = ממתין…
