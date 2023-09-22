# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-pin-invalid-long-prompt =
    { $retriesLeft ->
        [one] PIN incorrecto. Le queda { $retriesLeft } intento antes de perder permanentemente el acceso a las credenciales en este dispositivo.
       *[other] PIN incorrecto. Le quedan { $retriesLeft } intentos antes de perder permanentemente el acceso a las credenciales en este dispositivo.
    }
webauthn-pin-invalid-short-prompt = PIN incorrecto. Pruebe de nuevo
webauthn-pin-required-prompt = Por favor, introduzca el PIN de su dispositivo.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-uv-invalid-long-prompt =
    { $retriesLeft ->
        [one] La verificación del usuario ha fallado. Te queda { $retriesLeft } intento. Inténtelo otra vez.
       *[other] La verificación del usuario ha fallado. Te quedan { $retriesLeft } intentos. Inténtelo otra vez.
    }
webauthn-uv-invalid-short-prompt = La verificación del usuario ha fallado. Inténtelo otra vez.
