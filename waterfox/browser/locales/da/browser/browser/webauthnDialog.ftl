# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-pin-invalid-long-prompt =
    { $retriesLeft ->
        [one] Forkert pinkode. Du har { $retriesLeft } forsøg tilbage, inden du permanent mister adgangen til login-informationerne på denne enhed.
       *[other] Forkert pinkode. Du har { $retriesLeft } forsøg tilbage, inden du permanent mister adgangen til login-informationerne på denne enhed.
    }
webauthn-pin-invalid-short-prompt = Forkert pinkode. Prøv igen.
webauthn-pin-required-prompt = Indtast pinkoden for din enhed.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-uv-invalid-long-prompt =
    { $retriesLeft ->
        [one] Brugergodkendelse slog fejl. Du har { $retriesLeft } forsøg tilbage. Prøv igen.
       *[other] Brugergodkendelse slog fejl. Du har { $retriesLeft } forsøg tilbage. Prøv igen.
    }
webauthn-uv-invalid-short-prompt = Brugergodkendelse slog fejl. Prøv igen.
