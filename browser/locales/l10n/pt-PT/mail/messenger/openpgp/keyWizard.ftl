# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Adicionar uma chave OpenPGP pessoal para { $identity }

key-wizard-button =
    .buttonlabelaccept = Continuar
    .buttonlabelhelp = Retroceder

key-wizard-warning = <b>Se você já tiver uma chave pessoal</b> para este endereço de e-mail, deve importar a mesma. Caso contrário, você não terá acesso aos arquivos dos seus e-mails encriptados nem poderá ler e-mails encriptados recebidos de pessoas que ainda estejam a utilizar a sua chave existente.

key-wizard-learn-more = Saber mais

radio-create-key =
    .label = Criar uma nova chave OpenPGP
    .accesskey = C

radio-import-key =
    .label = Importar uma chave OpenPGP existente
    .accesskey = I

radio-gnupg-key =
    .label = Utilizar a sua chave externa através do GnuPG (por exemplo, a partir de um smartcard)
    .accesskey = U

## Generate key section

openpgp-generate-key-title = Gerar chave OpenPGP

openpgp-generate-key-info = <b>A geração da chave pode levar vários minutos para ser concluída.</b> Não saia da aplicação enquanto a geração da chave estiver em curso. Navegar ativamente ou realizar operações com uma utilização intensiva do disco durante a geração de chaves irá reabastecer a 'fonte de aleatoriedade' e acelerar o processo. Será alertado quando a geração da chave for concluída.

openpgp-keygen-expiry-title = Validade da chave

openpgp-keygen-expiry-description = Define validade da sua chave recém-gerada. Você poderá controlar a data à posteriori para a estender, se for necessário.

radio-keygen-expiry =
    .label = A chave expira em
    .accesskey = e

radio-keygen-no-expiry =
    .label = A chave não expira
    .accesskey = x

openpgp-keygen-days-label =
    .label = dias
openpgp-keygen-months-label =
    .label = meses
openpgp-keygen-years-label =
    .label = anos

openpgp-keygen-advanced-title = Definições avançadas

openpgp-keygen-advanced-description = Controle as definições avançadas da sua chave OpenPGP.

openpgp-keygen-keytype =
    .value = Tipo de chave:
    .accesskey = t

openpgp-keygen-keysize =
    .value = Tamanho da chave:
    .accesskey = h

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (curva elíptica)

openpgp-keygen-button = Gerar chave

openpgp-keygen-progress-title = A gerar a sua nova chave OpenPGP ...

openpgp-keygen-import-progress-title = A importar as suas chaves OpenPGP…

openpgp-import-success = Chaves OpenPGP importadas com sucesso!

openpgp-import-success-title = Conclua o processo de importação

openpgp-import-success-description = Para começar a utilizar a sua chave OpenPGP importada para encriptar e-mail, feche esta janela e aceda às Definições da conta para a selecionar.

openpgp-keygen-confirm =
    .label = Confirmar

openpgp-keygen-dismiss =
    .label = Cancelar

openpgp-keygen-cancel =
    .label = Cancelar processo...

openpgp-keygen-import-complete =
    .label = Fechar
    .accesskey = c

openpgp-keygen-missing-username = Não existe nenhum nome especificado para a conta atual. Por favor, introduza um valor no campo "O seu nome" nas definições da conta.
openpgp-keygen-long-expiry = Não pode criar uma chave que expire em mais de 100 anos.
openpgp-keygen-short-expiry = A sua chave deve ser válida durante, pelo menos, um dia.

openpgp-keygen-ongoing = Geração de chave já em curso!

openpgp-keygen-error-core = Não foi possível inicializar o OpenPGP Core Service

openpgp-keygen-error-failed = A geração da chave OpenPGP falhou inesperadamente

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = Chave OpenPGP criada com sucesso, mas falhou a obtenção da revogação para a chave { $key }

openpgp-keygen-abort-title = Abortar geração de chave?
openpgp-keygen-abort = Geração de chaves OpenPGP em curso. Tem a certeza de que deseja cancelar este processo?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Gerar chave pública e secreta para { $identity }?

## Import Key section

openpgp-import-key-title = Importar uma chave OpenPGP pessoal existente

openpgp-import-key-legend = Selecione um ficheiro de cópia anterior.

openpgp-import-key-description = Pode importar chaves pessoais que foram criadas com outro software OpenPGP.

openpgp-import-key-info = Outros softwares podem descrever uma chave pessoal utilizando termos alternativos, como chave própria, chave secreta, chave privada ou par de chaves.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] O Thunderbird encontrou { $count } chave que pode ser importada.
       *[other] O Thunderbird encontrou { $count } chaves que podem ser importadas.
    }

openpgp-import-key-list-description = Confirme quais as chaves podem ser tratadas como as suas chaves pessoais. Apenas as chaves que você mesmo criou e que mostram a sua própria identidade devem ser utilizadas como chaves pessoais. Você pode alterar esta opção mais tarde na janela Propriedades da chave.

openpgp-import-key-list-caption = As chaves marcadas para serem tratadas como chaves pessoais serão listadas na secção Encriptação de ponto a ponto. As outras estarão disponíveis dentro do Gestor de chaves.

openpgp-passphrase-prompt-title = Frase secreta necessária

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Por favor, especifique a sua frase secreta para desbloquear a seguinte chave: { $key }

openpgp-import-key-button =
    .label = Selecionar o ficheiro a importar...
    .accesskey = S

import-key-file = Importar o ficheiro de chave OpenPGP

import-key-personal-checkbox =
    .label = Tratar esta chave como uma chave pessoal

gnupg-file = Ficheiros GnuPG

import-error-file-size = <b>Erro!</b> Não são suportados ficheiros maiores que 5MB.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Erro!</b> A importação do ficheiro falhou. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Erro!</b> A importação das chaves falhou. { $error }

openpgp-import-identity-label = Identidade

openpgp-import-fingerprint-label = Impressão digital

openpgp-import-created-label = Criada

openpgp-import-bits-label = Bits

openpgp-import-key-props =
    .label = Propriedades da chave
    .accesskey = v

## External Key section

openpgp-external-key-title = Chave GnuPG externa

openpgp-external-key-description = Configure uma chave GnuPG externa inserindo o ID da chave

openpgp-external-key-info = Além disto, você deve utilizar o Gestor de chaves para importar e aceitar a chave pública correspondente.

openpgp-external-key-warning = <b>Apenas pode configurar uma chave GnuPG externa.</b> A sua entrada anterior será substituída.

openpgp-save-external-button = Guardar ID da chave

openpgp-external-key-label = ID da chave secreta:

openpgp-external-key-input =
    .placeholder = 123456789341298340
