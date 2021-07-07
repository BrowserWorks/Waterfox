# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Tentang Service Worker
about-service-workers-main-title = Service Worker Terdaftar
about-service-workers-warning-not-enabled = Service Worker tidak diaktifkan.
about-service-workers-warning-no-service-workers = Tidak ada Service Worker terdaftar.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Sumber: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Cakupan:</strong> { $name }
script-spec = <strong>Spesifikasi Skrip:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL Worker Saat Ini:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nama Tembolok Aktif:</strong> { $name }
waiting-cache-name = <strong>Nama Tembolok Menunggu:</strong> { $name }
push-end-point-waiting = <strong>Endpoint Push:</strong> { waiting }
push-end-point-result = <strong>Endpoint Push:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Perbarui

unregister-button = Batalkan Pendaftaran

unregister-error = Gagal membatalkan pendaftaran Service Worker ini.

waiting = Menunggu…
