# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Message Header Encryption Button

message-header-show-security-info-key = S

#   $type (String) - the shortcut key defined in the message-header-show-security-info-key
message-security-button =
    .title =
        { PLATFORM() ->
            [macos] Mostrar segurança da mensagem (⌘ ⌥ { message-header-show-security-info-key })
           *[other] Mostrar segurança da mensagem (Ctrl+Alt+{ message-header-show-security-info-key })
        }

openpgp-view-signer-key =
    .label = Ver chave do signatário
openpgp-view-your-encryption-key =
    .label = Ver sua chave de descriptografia
openpgp-openpgp = OpenPGP

openpgp-no-sig = Sem assinatura digital
openpgp-uncertain-sig = Assinatura digital duvidosa
openpgp-invalid-sig = Assinatura digital inválida
openpgp-good-sig = Boa assinatura digital

openpgp-sig-uncertain-no-key = Esta mensagem contém uma assinatura digital, mas não se sabe se está correta. Para verificar a assinatura, você precisa obter uma cópia da chave pública do remetente.
openpgp-sig-uncertain-uid-mismatch = Esta mensagem contém uma assinatura digital, mas foi detectada uma disparidade. A mensagem foi enviada de um endereço de email que não corresponde ao da chave pública do assinante.
openpgp-sig-uncertain-not-accepted = Esta mensagem contém uma assinatura digital, mas você ainda não decidiu se a chave do assinante é aceitável para você.
openpgp-sig-invalid-rejected = Esta mensagem contém uma assinatura digital, mas você já decidiu rejeitar a chave do assinante.
openpgp-sig-invalid-technical-problem = Esta mensagem contém uma assinatura digital, mas foi detectado um erro técnico. A mensagem foi corrompida, ou foi modificada por outra pessoa.
openpgp-sig-valid-unverified = Esta mensagem inclui uma assinatura digital válida de uma chave que você já aceitou. No entanto, você ainda não verificou se a chave realmente pertence ao remetente.
openpgp-sig-valid-verified = Esta mensagem inclui uma assinatura digital válida de uma chave verificada.
openpgp-sig-valid-own-key = Esta mensagem inclui uma assinatura digital válida de sua chave pessoal.

openpgp-sig-key-id = ID da chave do signatário: { $key }
openpgp-sig-key-id-with-subkey-id = ID da chave do signatário: { $key } (ID da subchave: { $subkey })

openpgp-enc-key-id = ID da sua chave de descriptografia: { $key }
openpgp-enc-key-with-subkey-id = ID da sua chave de descriptografia: { $key } (ID da subchave: { $subkey })

openpgp-unknown-key-id = Chave desconhecida

openpgp-other-enc-additional-key-ids = Além disso, a mensagem foi criptografada para os proprietários das seguintes chaves:
openpgp-other-enc-all-key-ids = A mensagem foi criptografada para os proprietários das seguintes chaves:

openpgp-message-header-encrypted-ok-icon =
    .alt = Descriptografia bem-sucedida
openpgp-message-header-encrypted-notok-icon =
    .alt = Falha na descriptografia

openpgp-message-header-signed-ok-icon =
    .alt = Assinatura boa
# Mismatch icon is used for notok state as well
openpgp-message-header-signed-mismatch-icon =
    .alt = Assinatura ruim
openpgp-message-header-signed-unknown-icon =
    .alt = Status de assinatura desconhecido
openpgp-message-header-signed-verified-icon =
    .alt = Assinatura verificada
openpgp-message-header-signed-unverified-icon =
    .alt = Assinatura não verificada
