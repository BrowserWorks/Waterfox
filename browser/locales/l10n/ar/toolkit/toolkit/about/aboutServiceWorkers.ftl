# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = عن عمّال الخدمة
about-service-workers-main-title = عمّال الخدمة المسجلين
about-service-workers-warning-not-enabled = عمّال الخدمة غير مفعّلة.
about-service-workers-warning-no-service-workers = لم يُسجل أي عمّال خدمة.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = الأصل: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>المدى:</strong> { $name }
script-spec = <strong>مواصفات السكربت:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>مسار العامل الحالي:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>اسم الخبيئة النشطة:</strong> { $name }
waiting-cache-name = <strong>اسم الخبيئة المنتظرة:</strong> { $name }
push-end-point-waiting = <strong>نقطة نهاية الدفع:</strong> { waiting }
push-end-point-result = <strong>نقطة نهاية الدفع:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = حدّث

unregister-button = أزل التسجيل

unregister-error = فشل إلغاء تسجيل عامل الخدمة هذا.

waiting = ينتظر…
