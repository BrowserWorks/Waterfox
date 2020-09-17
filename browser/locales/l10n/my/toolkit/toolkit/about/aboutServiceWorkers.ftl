# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Service Workers အကြောင်း
about-service-workers-main-title = စာရင်းပြုထားသည့် Service Workers
about-service-workers-warning-not-enabled = Service Workers များကို ဆောင်ရွက်ခွင့် ပိတ်ထားသည်။
about-service-workers-warning-no-service-workers = မည်သည့် Service Workers မျှ စာရင်းပြုထားခြင်း မရှိပါ။

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = မူလ။ { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>အပိုင်းအခြား။</strong> { $name }
script-spec = <strong>Script Spec:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>လက်ရှိ Worker URL။</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>အသုံးပြုဆဲ Cache အမည်။</strong> { $name }
waiting-cache-name = <strong>Cache အမည်ကို စောင့်ဆိုင်းနေသည်။</strong> { $name }
push-end-point-waiting = <strong>Push Endpoint:</strong> { waiting }
push-end-point-result = <strong>Push Endpoint:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = မွမ်းမံချက်

unregister-button = စာရင်းမပေးသွင်းတော့ပါ

unregister-error = ဒီ Service Worker ကို စာရင်းပေးထားခြင်းမှ ပယ်ဖျက်ရာတွင် အမှားဖြစ်ခဲ့သည်။

waiting = စောင့်နေသည်...
