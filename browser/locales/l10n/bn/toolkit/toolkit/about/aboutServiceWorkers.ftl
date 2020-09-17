# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = সার্ভিস কর্মীদের সম্বন্ধে
about-service-workers-main-title = নিবন্ধিত সার্ভিস কর্মীরা
about-service-workers-warning-not-enabled = সার্ভিস কর্মীদের আর সমর্থ নেই।
about-service-workers-warning-no-service-workers = কোন সার্ভিস কর্মী নিবন্ধিত নেই

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = উৎস: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>সুযোগ ।</strong> { $name }
script-spec = <strong>স্ত্রিপট স্পেস</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>বর্তমান কর্মীর URL:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>সক্রিয় ক্যাশের নাম</strong> { $name }
waiting-cache-name = <strong>ক্যাশ নামের জন্য অপেক্ষা:</strong> { $name }
push-end-point-waiting = <strong>পুশ এন্ডপয়েন্ট:</strong> { waiting }
push-end-point-result = <strong>পুশ এন্ডপয়েন্ট:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = হালনাগাদ করা

unregister-button = অনিবন্ধিত

unregister-error = এই সেবা কর্মী নিবন্ধমুক্ত করতে ব্যর্থ হল

waiting = অপেক্ষমাণ…
