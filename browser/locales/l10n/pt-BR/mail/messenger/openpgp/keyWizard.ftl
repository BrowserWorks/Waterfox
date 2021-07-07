# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Adicionar uma chave pessoal OpenPGP a { $identity }
key-wizard-button =
    .buttonlabelaccept = Avançar
    .buttonlabelhelp = Voltar
key-wizard-warning = <b>Se você já tem uma chave pessoal</b> deste endereço de email, deve importar a chave. Caso contrário, não terá acesso a seu arquivamento de emails criptografados, nem poderá ler emails criptografados recebidos de pessoas que ainda estão usando sua chave.
key-wizard-learn-more = Saiba mais
radio-create-key =
    .label = Criar uma nova chave OpenPGP
    .accesskey = C
radio-import-key =
    .label = Importar uma chave OpenPGP existente
    .accesskey = I
radio-gnupg-key =
    .label = Usar sua chave externa através do GnuPG (ex: um smartcard)
    .accesskey = U

## Generate key section

openpgp-generate-key-title = Gerar chave OpenPGP
openpgp-generate-key-info = <b>A geração de chaves pode levar vários minutos para ser concluída.</b> Não saia do aplicativo enquanto a geração de chaves estiver em andamento. Navegar ativamente ou realizar operações com uso intenso de disco durante a geração de chaves irá reabastecer o 'pool de aleatoriedade' e acelerar o processo. Você será alertado quando a geração de chaves for concluída.
openpgp-keygen-expiry-title = Validade da chave
openpgp-keygen-expiry-description = Defina a validade de sua chave recém-gerada. Você pode controlar a data mais tarde para estender, se necessário.
radio-keygen-expiry =
    .label = A chave expira em
    .accesskey = e
radio-keygen-no-expiry =
    .label = A chave não expira
    .accesskey = n
openpgp-keygen-days-label =
    .label = dias
openpgp-keygen-months-label =
    .label = meses
openpgp-keygen-years-label =
    .label = anos
openpgp-keygen-advanced-title = Configurações avançadas
openpgp-keygen-advanced-description = Controle as configurações avançadas da sua chave OpenPGP.
openpgp-keygen-keytype =
    .value = Tipo de chave:
    .accesskey = t
openpgp-keygen-keysize =
    .value = Tamanho da chave:
    .accesskey = t
openpgp-keygen-type-rsa =
    .label = RSA
openpgp-keygen-type-ecc =
    .label = ECC (curva elíptica)
openpgp-keygen-button = Gerar chave
openpgp-keygen-progress-title = Gerando sua nova chave OpenPGP…
openpgp-keygen-import-progress-title = Importando suas chaves OpenPGP…
openpgp-import-success = Chaves OpenPGP importadas com sucesso!
openpgp-import-success-title = Concluir o processo de importação
openpgp-import-success-description = Para começar a usar sua chave OpenPGP importada em criptografia de email, feche este diálogo e acesse as configurações da conta para selecionar a chave.
openpgp-keygen-confirm =
    .label = Confirmar
openpgp-keygen-dismiss =
    .label = Cancelar
openpgp-keygen-cancel =
    .label = Cancelar processo…
openpgp-keygen-import-complete =
    .label = Fechar
    .accesskey = F
openpgp-keygen-missing-username = Não há um nome especificado na conta atual. Digite algo no campo "Seu nome" nas configurações da conta.
openpgp-keygen-long-expiry = Você não pode criar uma chave com validade de mais de 100 anos.
openpgp-keygen-short-expiry = Sua chave precisa ser válida por pelo menos um dia.
openpgp-keygen-ongoing = Geração de chaves já em andamento!
openpgp-keygen-error-core = Não foi possível iniciar o serviço OpenPGP principal
openpgp-keygen-error-failed = Geração de chaves OpenPGP falhou inesperadamente
#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = Chave OpenPGP criada com sucesso, mas falhou ao obter a revogação da chave { $key }
openpgp-keygen-abort-title = Interromper geração de chave?
openpgp-keygen-abort = Geração de chave OpenPGP em andamento. Tem certeza que quer cancelar?
#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Gerar chaves pública e secreta para { $identity }?

## Import Key section

openpgp-import-key-title = Importar uma chave pessoal OpenPGP existente
openpgp-import-key-legend = Selecione um arquivo de backup criado anteriormente.
openpgp-import-key-description = Você pode importar chaves pessoais criadas com outro software OpenPGP.
openpgp-import-key-info = Outros softwares podem descrever uma chave pessoal usando termos alternativos, como chave própria, chave secreta, chave privada ou par de chaves.
#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] O Thunderbird encontrou uma chave que pode ser importada.
       *[other] O Thunderbird encontrou { $count } chaves que podem ser importadas.
    }
openpgp-import-key-list-description = Confirme quais podem ser tratadas como suas chaves pessoais. Somente chaves que você criou e que mostram sua própria identidade devem ser usadas como chaves pessoais. Você pode alterar esta opção mais tarde no diálogo de propriedades da chave.
openpgp-import-key-list-caption = Chaves marcadas para ser tratadas como chaves pessoais aparecem na seção de criptografia de ponta a ponta. As outras ficam disponíveis no gerenciador de chaves.
openpgp-passphrase-prompt-title = A senha é obrigatória
#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Digite a senha para desbloquear a seguinte chave: { $key }
openpgp-import-key-button =
    .label = Selecionar arquivo a importar…
    .accesskey = S
import-key-file = Importar arquivo de chave OpenPGP
import-key-personal-checkbox =
    .label = Tratar esta chave como uma chave pessoal
gnupg-file = Arquivos GnuPG
import-error-file-size = <b>Erro!</b> Arquivos maiores que 5MB não são suportados.
#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Erro!</b> Falha ao importar arquivo. { $error }
#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Erro!</b> Falha ao importar chaves. { $error }
openpgp-import-identity-label = Identidade
openpgp-import-fingerprint-label = Impressão digital
openpgp-import-created-label = Criação
openpgp-import-bits-label = Bits
openpgp-import-key-props =
    .label = Propriedades da chave
    .accesskey = c

## External Key section

openpgp-external-key-title = Chave GnuPG externa
openpgp-external-key-description = Configure uma chave GnuPG externa inserindo o ID da chave
openpgp-external-key-info = Além disso, você deve usar o gerenciador de chaves para importar e aceitar a chave pública correspondente.
openpgp-external-key-warning = <b>Você só pode configurar uma chave GnuPG externa.</b> Sua entrada anterior será substituída.
openpgp-save-external-button = Salvar ID da chave
openpgp-external-key-label = ID da chave secreta:
openpgp-external-key-input =
    .placeholder = 123456789341298340
