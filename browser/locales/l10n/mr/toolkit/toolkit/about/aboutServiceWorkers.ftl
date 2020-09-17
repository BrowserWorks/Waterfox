# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Service Workers विषयी
about-service-workers-main-title = नोंदणीकृत Service Workers
about-service-workers-warning-not-enabled = Service Workers सक्रीय केले नाहीत.
about-service-workers-warning-no-service-workers = कोणतेही Service Workers नोंदणीकृत नाहीत.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = स्त्रोत: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>व्याप्ती:</strong> { $name }
script-spec = <strong>स्क्रिप्ट विनिर्दीष्टे:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>सद्य Worker युआरएल:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>सक्रीय कॅशे नाव:</strong> { $name }
waiting-cache-name = <strong>कॅशेच्या नावाच्या प्रतीक्षेत आहे:</strong> { $name }
push-end-point-waiting = <strong>अंतिमबिंदू पुश करा:</strong> { waiting }
push-end-point-result = <strong>अंतिमबिंदू पुश करा:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = अद्ययतन करा

unregister-button = अनोंदणीकृत करा

unregister-error = हा Service Worker अनोंदणीकृत करण्यात अपयशी.

waiting = वाट पाहत आहे…
