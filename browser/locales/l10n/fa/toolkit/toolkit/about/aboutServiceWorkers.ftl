# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = درباره Service Workerها
about-service-workers-main-title = Service Workerهای ثبت شده
about-service-workers-warning-not-enabled = Service Workerها فعال نشده‌اند.
about-service-workers-warning-no-service-workers = هیچ Service Workerای ثبت نشده است.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = مبدا:{ $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>حوزه:</strong> { $name }
script-spec = <strong>خصوصیات کدنوشته:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>آدرس Worker فعلی:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>فعال کردن نام حافظه نهان:</strong> { $name }
waiting-cache-name = <strong>در انتظار نام حافظه نهان:</strong> { $name }
push-end-point-waiting = <strong>مقصد ارسال:</strong> { waiting }
push-end-point-result = <strong>مقصد ارسال:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = بروزرسانی

unregister-button = حذف ثبت نام

unregister-error = لغو ثبت Service Worker شکست خورد.

waiting = در حال انتظار…
