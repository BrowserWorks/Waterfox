# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-key-assistant-title = Assistente de chaves OpenPGP
openpgp-key-assistant-rogue-warning = Evite aceitar uma chave falsificada. Para garantir que você obteve a chave correta, você deve verificar. <a data-l10n-name="openpgp-link">Saiba mais…</a>

## Encryption status

openpgp-key-assistant-recipients-issue-header = Não é possível criptografar
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-issue-description =
    { $count ->
        [one] Para criptografar, você deve obter e aceitar uma chave usável de um destinatário. <a data-l10n-name="openpgp-link">Saiba mais…</a>
       *[other] Para criptografar, você deve obter e aceitar chaves usáveis de { $count } destinatários. <a data-l10n-name="openpgp-link">Saiba mais…</a>
    }
openpgp-key-assistant-info-alias = Normalmente o { -brand-short-name } exige que a chave pública do destinatário contenha um ID de usuário com um endereço de email correspondente. Isso pode ser alterado usando regras de sinônimos de destinatário OpenPGP. <a data-l10n-name="openpgp-link">Saiba mais…</a>
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-description =
    { $count ->
        [one] Você já tem uma chave usável e aceita de um destinatário.
       *[other] Você já tem chaves usáveis e aceitas de { $count } destinatários.
    }
openpgp-key-assistant-recipients-description-no-issues = Esta mensagem pode ser criptografada. Você tem chaves usáveis e aceitas de todos os destinatários.

## Resolve section

# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
# $numKeys (Number) - The number of keys.
openpgp-key-assistant-resolve-title =
    { $numKeys ->
        [one] O { -brand-short-name } encontrou a seguinte chave de { $recipient }.
       *[other] O { -brand-short-name } encontrou as seguintes chaves de { $recipient }.
    }
openpgp-key-assistant-valid-description = Selecione a chave que você quer aceitar
# Variables:
# $numKeys (Number) - The number of available keys.
openpgp-key-assistant-invalid-title =
    { $numKeys ->
        [one] A seguinte chave não pode ser usada, a menos que você obtenha uma atualização.
       *[other] As seguintes chaves não podem ser usadas, a menos que você obtenha uma atualização.
    }
openpgp-key-assistant-no-key-available = Nenhuma chave disponível.
openpgp-key-assistant-multiple-keys = Várias chaves estão disponíveis.
# Variables:
# $count (Number) - The number of unaccepted keys.
openpgp-key-assistant-key-unaccepted =
    { $count ->
        [one] Uma chave está disponível, mas ainda não foi aceita.
       *[other] Várias chaves estão disponíveis, mas nenhuma delas foi aceita ainda.
    }
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-accepted-expired = Uma chave aceita expirou em { $date }.
openpgp-key-assistant-keys-accepted-expired = Várias chaves aceitas expiraram.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-this-key-accepted-expired = Esta chave foi aceita anteriormente, mas expirou em { $date }.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-unaccepted-expired-one = A chave expirou em { $date }.
openpgp-key-assistant-key-unaccepted-expired-many = Várias chaves expiraram.
openpgp-key-assistant-key-fingerprint = Impressão digital
openpgp-key-assistant-key-source =
    { $count ->
        [one] Origem
       *[other] Origens
    }
openpgp-key-assistant-key-collected-attachment = anexo de email
openpgp-key-assistant-key-collected-autocrypt = Criptografar cabeçalho automaticamente
openpgp-key-assistant-key-collected-keyserver = servidor de chaves
openpgp-key-assistant-key-collected-wkd = Diretório de chaves da web
openpgp-key-assistant-keys-has-collected =
    { $count ->
        [one] Uma chave foi encontrada, mas ainda não foi aceita.
       *[other] Várias chaves foram encontradas, mas nenhuma delas foi aceita ainda.
    }
openpgp-key-assistant-key-rejected = Esta chave foi rejeitada anteriormente.
openpgp-key-assistant-key-accepted-other = Esta chave foi aceita anteriormente em outro endereço de email.
# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
openpgp-key-assistant-resolve-discover-info = Descubra online chaves adicionais ou atualizadas de { $recipient }, ou importe de um arquivo.

## Discovery section

openpgp-key-assistant-discover-title = Descoberta online em andamento.
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-discover-keys = Descobrindo chaves de { $recipient }…
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-expired-key-update =
    Foi encontrada uma atualização de uma das chaves de { $recipient } aceitas anteriormente.
    Ela pode ser usada agora, pois não está mais expirada.

## Dialog buttons

openpgp-key-assistant-discover-online-button = Descobrir chaves públicas online…
openpgp-key-assistant-import-keys-button = Importar chaves públicas de arquivo…
openpgp-key-assistant-issue-resolve-button = Resolver…
openpgp-key-assistant-view-key-button = Exibir chave…
openpgp-key-assistant-recipients-show-button = Exibir
openpgp-key-assistant-recipients-hide-button = Ocultar
openpgp-key-assistant-cancel-button = Cancelar
openpgp-key-assistant-back-button = Voltar
openpgp-key-assistant-accept-button = Aceitar
openpgp-key-assistant-close-button = Fechar
openpgp-key-assistant-disable-button = Desativar criptografia
openpgp-key-assistant-confirm-button = Enviar criptografado
# Variables:
# $date (String) - The key creation date.
openpgp-key-assistant-key-created = criada em { $data }
