# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-pin-invalid-long-prompt =
    { $retriesLeft ->
        [one] PIN incorreto. Você tem mais { $retriesLeft } tentativa antes de perder permanentemente o acesso às credenciais neste dispositivo.
       *[other] PIN incorreto. Você tem { $retriesLeft } tentativas restantes antes de perder permanentemente o acesso às credenciais neste dispositivo.
    }
webauthn-pin-invalid-short-prompt = PIN incorreto. Tente novamente.
webauthn-pin-required-prompt = Insira o PIN do seu dispositivo.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-uv-invalid-long-prompt =
    { $retriesLeft ->
        [one] Falha na verificação de usuário. Você tem { $retriesLeft } tentativa restante. Tente novamente.
       *[other] Falha na verificação de usuário. Você tem { $retriesLeft } tentativas restantes. Tente novamente.
    }
webauthn-uv-invalid-short-prompt = Falha na verificação de usuário. Tente novamente.
