# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Tietoja Service Workers -apukomentosarjoista
about-service-workers-main-title = Rekisteröidyt Service Workers -apukomentosarjat
about-service-workers-warning-not-enabled = Service Workers -apukomentosarjat eivät ole päällä.
about-service-workers-warning-no-service-workers = Ei rekisteröityjä Service Workers -apukomentosarjoja.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Lähde: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Laajuus:</strong> { $name }
script-spec = <strong>Komentosarjan tiedot:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>Tämänhetkinen Worker-osoite:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Aktiivisen välimuistin nimi:</strong> { $name }
waiting-cache-name = <strong>Odottavan välimuistin nimi:</strong> { $name }
push-end-point-waiting = <strong>Tulosteen päätepiste:</strong> { waiting }
push-end-point-result = <strong>Tulosteen päätepiste:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Päivitä

unregister-button = Poista rekisteröinti

unregister-error = Rekisteröinnin poisto Service Worker -apukomentosarjalle epäonnistui.

waiting = Odotetaan…
