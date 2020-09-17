# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Service Worker-lər haqqında
about-service-workers-main-title = Qeyd Olunmuş Service Worker-lar
about-service-workers-warning-not-enabled = Service Worker-lər aktiv edilməyiblər.
about-service-workers-warning-no-service-workers = Heç bir Service Worker qeydiyyatlı deyil.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Mənbə: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Əhatə:</strong> { $name }
script-spec = <strong>Skript Özəllikləri:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>Mövcud Worker URL-u:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Aktiv Keş Adı:</strong> { $name }
waiting-cache-name = <strong>Gözləyən Keş Adı:</strong> { $name }
push-end-point-waiting = <strong>Göndərmə nöqtəsi:</strong> { waiting }
push-end-point-result = <strong>Göndərmə nöqtəsi:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Yenilə

unregister-button = Qeydiyyatsız

unregister-error = Bu Service Worker-i qeydiyyatdan silmək mümkün olmadı.

waiting = Gözlənilir…
