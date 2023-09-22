# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-pin-invalid-long-prompt =
    { $retriesLeft ->
        [one] Code PIN incorrect. Il vous reste { $retriesLeft } tentative avant de perdre de façon permanente l’accès aux identifiants sur cet appareil.
       *[other] Code PIN incorrect. Il vous reste { $retriesLeft } tentatives avant de perdre de façon permanente l’accès aux identifiants sur cet appareil.
    }
webauthn-pin-invalid-short-prompt = Code PIN incorrect. Veuillez réessayer.
webauthn-pin-required-prompt = Veuillez saisir le code PIN de votre appareil.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-uv-invalid-long-prompt =
    { $retriesLeft ->
        [one] Échec de la vérification utilisateur. { $retriesLeft } tentative restante. Réessayez.
       *[other] Échec de la vérification utilisateur. { $retriesLeft } tentatives restantes. Réessayez.
    }
webauthn-uv-invalid-short-prompt = Échec de la vérification utilisateur. Réessayez.
