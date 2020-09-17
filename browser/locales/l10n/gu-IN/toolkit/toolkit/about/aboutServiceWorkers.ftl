# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Service Workers વિષે
about-service-workers-main-title = નોંધણી કરેલાં Service Workers
about-service-workers-warning-not-enabled = Service Workers સક્ષમ નથી.
about-service-workers-warning-no-service-workers = Service Workers નોંધાયેલ નથી.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = મૂળ: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>હદ:</strong> { $name }
script-spec = <strong>સ્ક્રિપ્ટ સ્પેક:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>વર્તમાન કાર્યકર્તા URL:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>સક્રિય કેશ નામ:</strong> { $name }
waiting-cache-name = <strong>પ્રતીક્ષા કેશ નામ:</strong> { $name }
push-end-point-waiting = <strong>એન્ડપોઇન્ટ દબાણ:</strong> { waiting }
push-end-point-result = <strong>એન્ડપોઇન્ટ દબાણ:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = અદ્યતન કરો

unregister-button = નોંધણી રદ કરો

unregister-error = આ Service Worker ની નોંધણી રદ કરવામાં નિષ્ફળ.

waiting = રાહ જોઇ રહ્યા છે…
