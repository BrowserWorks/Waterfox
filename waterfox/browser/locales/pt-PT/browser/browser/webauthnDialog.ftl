# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-pin-invalid-long-prompt =
    { $retriesLeft ->
        [one] PIN incorreto. Tem { $retriesLeft } tentativa remanescente antes de perder, de forma permanente, o acesso às credenciais neste dispositivo.
       *[other] PIN incorreto. Tem { $retriesLeft } tentativas remanescentes antes de perder, de forma permanente, o acesso às credenciais neste dispositivo.
    }
webauthn-pin-invalid-short-prompt = PIN incorreto. Tente novamente.
webauthn-pin-required-prompt = Por favor, insira o PIN para o seu dispositivo.
# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-uv-invalid-long-prompt =
    { $retriesLeft ->
        [one] A verificação do utilizador falhou. Resta { $retriesLeft } tentativa. Tente novamente.
       *[other] A verificação do utilizador falhou. Restam { $retriesLeft } tentativas. Tente novamente.
    }
webauthn-uv-invalid-short-prompt = A verificação do utilizador falhou. Tente novamente.
