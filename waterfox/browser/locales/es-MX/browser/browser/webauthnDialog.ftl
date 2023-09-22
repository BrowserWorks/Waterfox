# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-pin-invalid-long-prompt =
    { $retriesLeft ->
        [one] PIN incorrecto. Te queda { $retriesLeft } intento antes de que pierdas el acceso a las credenciales en este dispositivo.
       *[other] PIN incorrecto. Te quedan { $retriesLeft } intentos antes de que pierdas el acceso a las credenciales en este dispositivo.
    }
webauthn-pin-invalid-short-prompt = PIN incorrecto. Intenta de nuevo.
webauthn-pin-required-prompt = Por favor, ingresa el PIN de tu dispositivo.

