# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-compose-key-status-intro-need-keys = Para enviar uma mensagem criptografada de ponta a ponta, você deve obter e aceitar uma chave pública de cada destinatário.
openpgp-compose-key-status-keys-heading = Disponibilidade de chaves OpenPGP:
openpgp-compose-key-status-title =
    .title = Segurança de mensagens OpenPGP
openpgp-compose-key-status-recipient =
    .label = Destinatário
openpgp-compose-key-status-status =
    .label = Status
openpgp-compose-key-status-open-details = Gerenciar chaves do destinatário selecionado…
openpgp-recip-good = ok
openpgp-recip-missing = nenhuma chave disponível
openpgp-recip-none-accepted = nenhuma chave aceita
openpgp-compose-general-info-alias = O { -brand-short-name } normalmente requer que a chave pública do destinatário contenha um ID de usuário com um endereço de email correspondente. Isso pode ser alterado usando regras de sinônimos de destinatário OpenPGP.
openpgp-compose-general-info-alias-learn-more = Saiba mais
openpgp-compose-alias-status-direct =
    { $count ->
        [one] mapeado a uma chave de sinônimo
       *[other] mapeado a { $count } chaves de sinônimo
    }
openpgp-compose-alias-status-error = chave de sinônimo inutilizável/indisponível
