# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-one-recipient-status-title =
    .title = Segurança de mensagens OpenPGP
openpgp-one-recipient-status-status =
    .label = Status
openpgp-one-recipient-status-key-id =
    .label = ID da chave
openpgp-one-recipient-status-created-date =
    .label = Criação
openpgp-one-recipient-status-expires-date =
    .label = Validade
openpgp-one-recipient-status-open-details =
    .label = Abrir detalhes e editar aceitação…
openpgp-one-recipient-status-discover =
    .label = Descobrir chave nova ou atualizada

openpgp-one-recipient-status-instruction1 = Para enviar uma mensagem criptografada de ponta a ponta para um destinatário, você precisa obter a chave pública OpenPGP e marcar como aceita.
openpgp-one-recipient-status-instruction2 = Para obter sua chave pública, importe do email que foi enviado a você e que inclui a chave. Como alternativa, você pode tentar descobrir a chave pública em um diretório.

openpgp-key-own = Aceita (chave pessoal)
openpgp-key-secret-not-personal = Não usável
openpgp-key-verified = Aceita (confirmada)
openpgp-key-unverified = Aceita (não confirmada)
openpgp-key-undecided = Não aceita (pendente)
openpgp-key-rejected = Não aceita (rejeitada)
openpgp-key-expired = Expirado

openpgp-intro = Chaves públicas disponíveis de { $key }

openpgp-pubkey-import-id = ID: { $kid }
openpgp-pubkey-import-fpr = Impressão digital: { $fpr }

openpgp-pubkey-import-intro =
    { $num ->
        [one] O arquivo contém uma chave pública, como mostrado abaixo:
       *[other] O arquivo contém { $num } chaves públicas, como mostrado abaixo:
    }

openpgp-pubkey-import-accept =
    { $num ->
        [one] Você aceita esta chave para verificar assinaturas digitais e criptografar mensagens, de todos os endereços de email mostrados?
       *[other] Você aceita estas chaves para verificar assinaturas digitais e criptografar mensagens, de todos os endereços de email mostrados?
    }

pubkey-import-button =
    .buttonlabelaccept = Importar
    .buttonaccesskeyaccept = I
