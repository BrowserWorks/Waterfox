# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Service Workers को बारेमा
about-service-workers-main-title = दर्ता भएका Service Workers
about-service-workers-warning-not-enabled = Service Workers सक्षम छैनन्।
about-service-workers-warning-no-service-workers = कुनै पनि Service Workers दर्ता गरिएको छैन।

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = मूल: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>कार्यक्षेत्र:</strong> { $name }
script-spec = <strong>लिपि युक्ति:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>हालको वर्कर URL:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>एक्टिभ क्यास नाम:</strong> { $name }
waiting-cache-name = <strong>वेटिङ क्यास नाम:</strong> { $name }
push-end-point-waiting = <strong>अन्तिमबिन्दु मा धकेल्नु:</strong> { waiting }
push-end-point-result = <strong>अन्तिमबिन्दु मा धकेल्नु:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = अद्यावधिक

unregister-button = दर्ता हटाउनुहोस्

unregister-error = यो Service Worker दर्ता रद्ध गर्न असफल भयो।

waiting = प्रतिक्षा गर्दैछ...
