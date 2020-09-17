# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Service Worker-ების შესახებ
about-service-workers-main-title = დარეგისტრებული Service Worker-ები
about-service-workers-warning-not-enabled = Service Worker-ები ჩართული არაა.
about-service-workers-warning-no-service-workers = დარეგისტრებული Service Worker-ები არ მოიძებნა.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = წარმომქმნელი: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>არეალი:</strong> { $name }
script-spec = <strong>სკრიპტის მახასიათებლები:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>მიმდინარე Worker-ის URL:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>მოქმედი კეშის დასახელება:</strong> { $name }
waiting-cache-name = <strong>დაყოვნებული კეშის დასახელება:</strong> { $name }
push-end-point-waiting = <strong>Push-ის ბოლო წერტილი:</strong> { waiting }
push-end-point-result = <strong>Push-ის ბოლო წერტილი:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = განახლება

unregister-button = რეგისტრაციის გაუქმება

unregister-error = ამ Service Worker-ის ჩანაწერიდან ამოშლა ვერ მოხერხდა.

waiting = დაცდა…
