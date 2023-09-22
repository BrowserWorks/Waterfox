# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-pin-invalid-long-prompt =
    { $retriesLeft ->
        [one] Falsche PIN. Sie haben noch { $retriesLeft } Versuch, bevor Sie dauerhaft den Zugriff auf die Zugangsdaten auf diesem Gerät verlieren.
       *[other] Falsche PIN. Sie haben noch { $retriesLeft } Versuche, bevor Sie dauerhaft den Zugriff auf die Zugangsdaten auf diesem Gerät verlieren.
    }
webauthn-pin-invalid-short-prompt = Falsche PIN. Versuchen Sie es erneut.
webauthn-pin-required-prompt = Bitte geben Sie die PIN für Ihr Gerät ein.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-uv-invalid-long-prompt =
    { $retriesLeft ->
        [one] Benutzerüberprüfung fehlgeschlagen. Sie haben noch { $retriesLeft } Versuche. Versuchen Sie es erneut.
       *[other] Benutzerüberprüfung fehlgeschlagen. Sie haben noch { $retriesLeft } Versuch. Versuchen Sie es erneut.
    }
webauthn-uv-invalid-short-prompt = Benutzerüberprüfung fehlgeschlagen. Versuchen Sie es erneut.
