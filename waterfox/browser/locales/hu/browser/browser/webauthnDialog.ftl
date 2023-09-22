# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-pin-invalid-long-prompt =
    { $retriesLeft ->
        [one] Helytelen PIN-kód. Még { $retriesLeft } próbálkozása van hátra, mielőtt véglegesen elveszíti a hitelesítő adatait ezen az eszközön.
       *[other] Helytelen PIN-kód. Még { $retriesLeft } próbálkozása van hátra, mielőtt véglegesen elveszíti a hitelesítő adatait ezen az eszközön.
    }
webauthn-pin-invalid-short-prompt = Helytelen PIN-kód. Próbálja meg újra.
webauthn-pin-required-prompt = Adja meg az eszköze PIN-kódját.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-uv-invalid-long-prompt =
    { $retriesLeft ->
        [one] A felhasználó ellenőrzése sikertelen. Még { $retriesLeft } próbálkozása van hátra. Próbálja újra.
       *[other] A felhasználó ellenőrzése sikertelen. Még { $retriesLeft } próbálkozása van hátra. Próbálja újra.
    }
webauthn-uv-invalid-short-prompt = A felhasználó ellenőrzése sikertelen. Próbálja újra.
