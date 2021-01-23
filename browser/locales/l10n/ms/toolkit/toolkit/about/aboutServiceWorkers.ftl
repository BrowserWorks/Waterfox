# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Perihal Service Workers
about-service-workers-main-title = Service Workers Berdaftar
about-service-workers-warning-not-enabled = Service Workers tidak didayakan.
about-service-workers-warning-no-service-workers = Tiada Service Workers didaftar.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Asalan: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Skop:</strong> { $name }
script-spec = <strong>Spesifikasi Skrip:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL Current Worker:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nama Cache Aktif:</strong> { $name }
waiting-cache-name = <strong>Menunggu Nama Cache:</strong> { $name }
push-end-point-waiting = <strong>Dorang Titik akhir:</strong> { waiting }
push-end-point-result = <strong>Dorang Titik akhir:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Kemaskini

unregister-button = Nyahdaftar

unregister-error = Gagal mendaftar Service Worker ini.

waiting = Menunggu…
