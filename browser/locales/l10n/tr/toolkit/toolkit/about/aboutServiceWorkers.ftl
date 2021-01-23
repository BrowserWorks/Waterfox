# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Service Worker'lar hakkında
about-service-workers-main-title = Kayıtlı Service Worker'lar
about-service-workers-warning-not-enabled = Service Worker'lar etkinleştirilmemiş.
about-service-workers-warning-no-service-workers = Hiçbir Service Worker kayıtlı değil.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Köken: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Kapsam:</strong> { $name }
script-spec = <strong>Betik özellikleri:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>Geçerli Worker URL’si:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Aktif önbellek adı:</strong> { $name }
waiting-cache-name = <strong>Bekleyen önbellek adı:</strong> { $name }
push-end-point-waiting = <strong>Anında ilet uç noktası:</strong> { waiting }
push-end-point-result = <strong>Anında ilet uç noktası:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Güncelle

unregister-button = Kaydı sil

unregister-error = Bu Service Worker'ın kaydı silinemedi.

waiting = Bekleniyor…
