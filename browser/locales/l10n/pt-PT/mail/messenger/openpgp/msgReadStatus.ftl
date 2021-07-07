# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Message Header Encryption Button

message-header-show-security-info-key = S
#   $type (String) - the shortcut key defined in the message-header-show-security-info-key
message-security-button =
    .title =
        { PLATFORM() ->
            [macos] Mostrar Segurança da Mensagem (⌘ ⌥ { message-header-show-security-info-key })
           *[other] Mostrar Segurança da Mensagem (Ctrl+Alt+{ message-header-show-security-info-key })
        }
openpgp-view-signer-key =
    .label = Ver chave do signatário
openpgp-view-your-encryption-key =
    .label = Ver a sua chave de desencriptação
openpgp-openpgp = OpenPGP
openpgp-no-sig = Sem assinatura digital
openpgp-uncertain-sig = Assinatura digital incerta
openpgp-invalid-sig = Assinatura digital inválida
openpgp-good-sig = Assinatura digital válida
openpgp-sig-uncertain-no-key = Esta mensagem contém uma assinatura digital, mas não é garantido que a mesma correta. Para verificar a assinatura, você precisa de obter uma cópia da chave pública do remetente.
openpgp-sig-uncertain-uid-mismatch = Esta mensagem contém uma assinatura digital, mas foi detetada uma disparidade. A mensagem foi enviada a partir de um endereço de e-mail que não corresponde à chave pública do assinante.
openpgp-sig-uncertain-not-accepted = Esta mensagem contém uma assinatura digital, mas você ainda não decidiu se a chave do assinante é aceitável para si.
openpgp-sig-invalid-rejected = Esta mensagem contém uma assinatura digital, mas você anteriormente decidiu rejeitar a chave do assinante.
openpgp-sig-invalid-technical-problem = Esta mensagem contém uma assinatura digital, mas foi detetado um erro técnico. A mensagem foi corrompida ou modificada por outra pessoa.
openpgp-sig-valid-unverified = Esta mensagem inclui uma assinatura digital válida de uma chave que você já aceitou. No entanto, você ainda não verificou se a chave realmente pertence ao remetente.
openpgp-sig-valid-verified = Esta mensagem inclui uma assinatura digital válida de uma chave verificada.
openpgp-sig-valid-own-key = Esta mensagem inclui uma assinatura digital válida da sua chave pessoal.
openpgp-sig-key-id = ID da chave do signatário: { $key }
openpgp-sig-key-id-with-subkey-id = ID da chave do signatário: { $key } (ID da sub-chave: { $subkey }
openpgp-enc-key-id = O ID da sua chave de desencriptação: { $key }
openpgp-enc-key-with-subkey-id = O ID da sua chave de desencriptação: { $key } (ID da sub-chave: { $subkey })
openpgp-unknown-key-id = Chave desconhecida
openpgp-other-enc-additional-key-ids = Adicionalmente, a mensagem foi encriptada para os proprietários das seguintes chaves:
openpgp-other-enc-all-key-ids = A mensagem foi encriptada para os proprietários das seguintes chaves:
