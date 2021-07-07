# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = Para enviar mensagens criptografadas ou assinadas digitalmente, você precisa configurar uma tecnologia de criptografia, pode ser OpenPGP ou S/MIME.
e2e-intro-description-more = Selecione sua chave pessoal para ativar o uso de OpenPGP, ou seu certificado pessoal para ativar o uso de S/MIME. Para uma chave pessoal ou certificado, você tem a chave secreta correspondente.
e2e-advanced-section = Configurações avançadas
e2e-attach-key =
    .label = Anexar minha chave pública ao adicionar uma assinatura digital OpenPGP
    .accesskey = p
e2e-encrypt-subject =
    .label = Criptografar o assunto de mensagens OpenPGP
    .accesskey = s
e2e-encrypt-drafts =
    .label = Armazenar rascunhos de mensagens em formato criptografado
    .accesskey = r
openpgp-key-user-id-label = Conta / ID do usuário
openpgp-keygen-title-label =
    .title = Gerar chave OpenPGP
openpgp-cancel-key =
    .label = Cancelar
    .tooltiptext = Cancelar geração de chave
openpgp-key-gen-expiry-title =
    .label = Validade da chave
openpgp-key-gen-expire-label = A chave expira em
openpgp-key-gen-days-label =
    .label = dias
openpgp-key-gen-months-label =
    .label = meses
openpgp-key-gen-years-label =
    .label = anos
openpgp-key-gen-no-expiry-label =
    .label = A chave não expira
openpgp-key-gen-key-size-label = Tamanho da chave
openpgp-key-gen-console-label = Geração de chave
openpgp-key-gen-key-type-label = Tipo de chave
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (curva elíptica)
openpgp-generate-key =
    .label = Gerar chave
    .tooltiptext = Gera uma nova chave em conformidade com OpenPGP para criptografia e/ou assinatura
openpgp-advanced-prefs-button-label =
    .label = Avançado…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">NOTA: A geração de chaves pode levar vários minutos para ser concluída. Não saia do aplicativo enquanto a geração de chaves estiver em andamento. Navegar ativamente ou realizar operações com uso intenso de disco durante a geração de chaves irá reabastecer o 'pool de aleatoriedade' e acelerar o processo. Você será alertado quando a geração de chaves for concluída.
openpgp-key-expiry-label =
    .label = Validade
openpgp-key-id-label =
    .label = ID da chave
openpgp-cannot-change-expiry = Esta é uma chave com uma estrutura complexa, não é suportado alterar sua data de validade.
openpgp-key-man-title =
    .title = Gerenciador de chaves OpenPGP
openpgp-key-man-generate =
    .label = Novo par de chaves
    .accesskey = v
openpgp-key-man-gen-revoke =
    .label = Certificado de revogação
    .accesskey = v
openpgp-key-man-ctx-gen-revoke-label =
    .label = Gerar e salvar certificado de revogação
openpgp-key-man-file-menu =
    .label = Arquivo
    .accesskey = A
openpgp-key-man-edit-menu =
    .label = Editar
    .accesskey = E
openpgp-key-man-view-menu =
    .label = Exibir
    .accesskey = x
openpgp-key-man-generate-menu =
    .label = Gerar
    .accesskey = G
openpgp-key-man-keyserver-menu =
    .label = Servidor de chaves
    .accesskey = r
openpgp-key-man-import-public-from-file =
    .label = Importar chaves públicas de arquivo
    .accesskey = I
openpgp-key-man-import-secret-from-file =
    .label = Importar chaves secretas de arquivo
openpgp-key-man-import-sig-from-file =
    .label = Importar revogações de arquivo
openpgp-key-man-import-from-clipbrd =
    .label = Importar chaves da área de transferência
    .accesskey = I
openpgp-key-man-import-from-url =
    .label = Importar chaves a partir de URL
    .accesskey = U
openpgp-key-man-export-to-file =
    .label = Exportar chaves públicas para arquivo
    .accesskey = E
openpgp-key-man-send-keys =
    .label = Enviar chaves públicas por email
    .accesskey = m
openpgp-key-man-backup-secret-keys =
    .label = Fazer backup de chaves secretas em arquivo
    .accesskey = b
openpgp-key-man-discover-cmd =
    .label = Descobrir chaves online
    .accesskey = D
openpgp-key-man-discover-prompt = Para descobrir chaves OpenPGP online, em servidores de chaves ou usando o protocolo WKD, digite um endereço de email ou um ID de chave.
openpgp-key-man-discover-progress = Procurando…
openpgp-key-copy-key =
    .label = Copiar chave pública
    .accesskey = C
openpgp-key-export-key =
    .label = Exportar chave pública para arquivo
    .accesskey = E
openpgp-key-backup-key =
    .label = Fazer backup de chave secreta em arquivo
    .accesskey = b
openpgp-key-send-key =
    .label = Enviar chave pública por email
    .accesskey = m
openpgp-key-man-copy-key-ids =
    .label =
        { $count ->
            [one] Copiar ID da chave para área de transferência
           *[other] Copiar ID das chaves para área de transferência
        }
    .accesskey = h
openpgp-key-man-copy-fprs =
    .label =
        { $count ->
            [one] Copiar impressão digital para área de transferência
           *[other] Copiar impressões digitais para área de transferência
        }
    .accesskey = m
openpgp-key-man-copy-to-clipboard =
    .label =
        { $count ->
            [one] Copiar chave pública para área de transferência
           *[other] Copiar chaves públicas para área de transferência
        }
    .accesskey = b
openpgp-key-man-ctx-expor-to-file-label =
    .label = Exportar chaves para arquivo
openpgp-key-man-ctx-copy =
    .label = Copiar
    .accesskey = C
openpgp-key-man-ctx-copy-fprs =
    .label =
        { $count ->
            [one] Impressão digital
           *[other] Impressões digitais
        }
    .accesskey = m
openpgp-key-man-ctx-copy-key-ids =
    .label =
        { $count ->
            [one] ID da chave
           *[other] ID das chaves
        }
    .accesskey = h
openpgp-key-man-ctx-copy-public-keys =
    .label =
        { $count ->
            [one] Chave pública
           *[other] Chaves públicas
        }
    .accesskey = p
openpgp-key-man-close =
    .label = Fechar
openpgp-key-man-reload =
    .label = Recarregar cache de chaves
    .accesskey = R
openpgp-key-man-change-expiry =
    .label = Alterar data de validade
    .accesskey = v
openpgp-key-man-del-key =
    .label = Excluir chaves
    .accesskey = x
openpgp-delete-key =
    .label = Excluir chave
    .accesskey = x
openpgp-key-man-revoke-key =
    .label = Revogar chave
    .accesskey = R
openpgp-key-man-key-props =
    .label = Propriedades da chave
    .accesskey = c
openpgp-key-man-key-more =
    .label = Mais
    .accesskey = M
openpgp-key-man-view-photo =
    .label = ID de foto
    .accesskey = f
openpgp-key-man-ctx-view-photo-label =
    .label = Ver ID de foto
openpgp-key-man-show-invalid-keys =
    .label = Exibir chaves inválidas
    .accesskey = x
openpgp-key-man-show-others-keys =
    .label = Exibir chaves de outras pessoas
    .accesskey = o
openpgp-key-man-user-id-label =
    .label = Nome
openpgp-key-man-fingerprint-label =
    .label = Impressão digital
openpgp-key-man-select-all =
    .label = Selecionar todas as chaves
    .accesskey = t
openpgp-key-man-empty-tree-tooltip =
    .label = Digite os termos de pesquisa no campo acima
openpgp-key-man-nothing-found-tooltip =
    .label = Nenhuma chave corresponde aos termos de pesquisa
openpgp-key-man-please-wait-tooltip =
    .label = Aguarde enquanto as chaves estão sendo carregadas…
openpgp-key-man-filter-label =
    .placeholder = Procurar chaves
openpgp-key-man-select-all-key =
    .key = T
openpgp-key-man-key-details-key =
    .key = I
openpgp-key-details-title =
    .title = Propriedades da chave
openpgp-key-details-signatures-tab =
    .label = Certificações
openpgp-key-details-structure-tab =
    .label = Estrutura
openpgp-key-details-uid-certified-col =
    .label = ID de usuário / Certificado por
openpgp-key-details-user-id2-label = Proprietário alegado da chave
openpgp-key-details-id-label =
    .label = ID
openpgp-key-details-key-type-label = Tipo
openpgp-key-details-key-part-label =
    .label = Parte da chave
openpgp-key-details-algorithm-label =
    .label = Algoritmo
openpgp-key-details-size-label =
    .label = Tamanho
openpgp-key-details-created-label =
    .label = Criação
openpgp-key-details-created-header = Criação
openpgp-key-details-expiry-label =
    .label = Validade
openpgp-key-details-expiry-header = Validade
openpgp-key-details-usage-label =
    .label = Uso
openpgp-key-details-fingerprint-label = Impressão digital
openpgp-key-details-sel-action =
    .label = Selecionar ação…
    .accesskey = S
openpgp-key-details-also-known-label = Identidades alternativas alegadas do proprietário da chave:
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Fechar
openpgp-acceptance-label =
    .label = Sua aceitação
openpgp-acceptance-rejected-label =
    .label = Não, rejeitar esta chave.
openpgp-acceptance-undecided-label =
    .label = Ainda não, talvez mais tarde.
openpgp-acceptance-unverified-label =
    .label = Sim, mas não verifiquei se é a chave correta.
openpgp-acceptance-verified-label =
    .label = Sim, verifiquei pessoalmente que esta chave tem a impressão digital correta.
key-accept-personal =
    Nesta chave, você tem a parte pública e a parte secreta. Você pode usar como uma chave pessoal.
    Se esta chave foi dada a você por outra pessoa, não a use como chave pessoal.
key-personal-warning = Você mesmo criou esta chave e a propriedade da chave exibida refere-se a você?
openpgp-personal-no-label =
    .label = Não, não usar como minha chave pessoal.
openpgp-personal-yes-label =
    .label = Sim, tratar esta chave como uma chave pessoal.
openpgp-copy-cmd-label =
    .label = Copiar

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] O Thunderbird não tem uma chave OpenPGP pessoal de <b>{ $identity }</b>
        [one] O Thunderbird encontrou { $count } chave OpenPGP pessoal associada a <b>{ $identity }</b>
       *[other] O Thunderbird encontrou { $count } chaves OpenPGP pessoais associadas a <b>{ $identity }</b>
    }
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-have-key = Sua configuração atual usa a chave com ID <b>{ $key }</b>
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = Sua configuração atual usa a chave <b>{ $key }</b>, que está vencida.
openpgp-add-key-button =
    .label = Adicionar chave…
    .accesskey = A
e2e-learn-more = Saiba mais
openpgp-keygen-success = Chave OpenPGP criada com sucesso!
openpgp-keygen-import-success = Chaves OpenPGP importadas com sucesso!
openpgp-keygen-external-success = ID da chave GnuPG externa foi salva!

## OpenPGP Key selection area

openpgp-radio-none =
    .label = Nenhuma
openpgp-radio-none-desc = Não usar OpenPGP para esta identidade.
openpgp-radio-key-not-usable = Esta chave não pode ser usada como chave pessoal, porque está faltando a chave secreta!
openpgp-radio-key-not-accepted = Para usar esta chave, você precisa aprovar como sendo uma chave pessoal!
openpgp-radio-key-not-found = Esta chave não foi encontrada! Se quiser usar, você precisa importar para o { -brand-short-name }.
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Expira em: { $date }
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Expirou em: { $date }
openpgp-key-expires-within-6-months-icon =
    .title = A chave expira em menos de 6 meses
openpgp-key-has-expired-icon =
    .title = Chave expirada
openpgp-key-expand-section =
    .tooltiptext = Mais informações
openpgp-key-revoke-title = Revogar chave
openpgp-key-edit-title = Alterar chave OpenPGP
openpgp-key-edit-date-title = Estender data de validade
openpgp-manager-description = Use o gerenciador de chaves OpenPGP para ver e gerenciar chaves públicas de seus correspondentes e todas as outras chaves não listadas acima.
openpgp-manager-button =
    .label = Gerenciador de chaves OpenPGP
    .accesskey = G
openpgp-key-remove-external =
    .label = Remover ID de chave externa
    .accesskey = e
key-external-label = Chave GnuPG externa
# Strings in keyDetailsDlg.xhtml
key-type-public = chave pública
key-type-primary = chave primária
key-type-subkey = subchave
key-type-pair = par de chaves (chave secreta e chave pública)
key-expiry-never = nunca
key-usage-encrypt = Criptografar
key-usage-sign = Assinar
key-usage-certify = Certificar
key-usage-authentication = Autenticação
key-does-not-expire = A chave não expira
key-expired-date = A chave expirou em { $keyExpiry }
key-expired-simple = A chave expirou
key-revoked-simple = A chave foi revogada
key-do-you-accept = Você aceita esta chave para verificar assinaturas digitais e para criptografar mensagens?
key-accept-warning = Evite aceitar chaves de trapaceiros. Use um canal de comunicação diferente de email para verificar a impressão digital da chave de seu correspondente.
# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Não foi possível enviar a mensagem, porque há um problema com sua chave pessoal. { $problem }
cannot-encrypt-because-missing = Não foi possível enviar esta mensagem com criptografia de ponta a ponta, porque há problemas com as chaves dos seguintes destinatários: { $problem }
window-locked = A janela de edição está bloqueada; envio cancelado
# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = Parte criptografada da mensagem
mime-decrypt-encrypted-part-concealed-data = Esta é uma parte criptografada da mensagem. Você precisa abrir em uma janela separada, clicando no anexo.
# Strings in keyserver.jsm
keyserver-error-aborted = Interrompido
keyserver-error-unknown = Ocorreu um erro desconhecido
keyserver-error-server-error = O servidor de chaves relatou um erro.
keyserver-error-import-error = Falha ao importar a chave baixada.
keyserver-error-unavailable = O servidor de chaves não está disponível.
keyserver-error-security-error = O servidor de chaves não oferece suporte a acesso criptografado.
keyserver-error-certificate-error = O certificado do servidor de chaves não é válido.
keyserver-error-unsupported = O servidor de chaves não é suportado.
# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Seu provedor de email processou sua solicitação de enviar sua chave pública para o OpenPGP Web Key Directory.
    Confirme para concluir a publicação de sua chave pública.
wkd-message-body-process =
    Este é um email relacionado ao processamento automático de envio de sua chave pública para o OpenPGP Web Key Directory.
    Você não precisa fazer nenhuma ação manual neste momento.
# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Não foi possível decifrar a mensagem com assunto
    { $subject }.
    Quer tentar novamente com outra senha, ou quer ignorar a mensagem?
# Strings in gpg.jsm
unknown-signing-alg = Algoritmo de assinatura desconhecido (ID: { $id })
unknown-hash-alg = Hash de criptografia desconhecido (ID: { $id })
# Strings in keyUsability.jsm
expiry-key-expires-soon =
    Sua chave { $desc } irá expirar em menos de { $days } dias.
    Recomendamos que você crie um novo par de chaves e configure as contas correspondentes para usá-las.
expiry-keys-expire-soon =
    Suas seguintes chaves irão expirar em menos de { $days } dias: { $desc }.
    Recomendamos que você crie novas chaves e configure as contas correspondentes para usá-las.
expiry-key-missing-owner-trust =
    Sua chave secreta { $desc } não pode ser considerada de confiança.
    Recomendamos que você defina "Você confia em certificações" como "definitivo" nas propriedades da chave.
expiry-keys-missing-owner-trust =
    As seguintes chaves secretas suas não podem ser consideradas de confiança.
    { $desc }.
    Recomendamos que você defina "Você confia em certificações" como "definitivo" nas propriedades das chaves.
expiry-open-key-manager = Abrir gerenciador de chaves OpenPGP
expiry-open-key-properties = Abrir propriedades da chave
# Strings filters.jsm
filter-folder-required = Você deve selecionar uma pasta destino.
filter-decrypt-move-warn-experimental =
    Aviso - A ação do filtro "Descriptografar permanentemente" pode levar à destruição de mensagens.
    Recomendamos fortemente que você tente primeiro o filtro "Criar cópia descriptografada", teste o resultado cuidadosamente e só comece a usar este filtro quando estiver satisfeito com o resultado.
filter-term-pgpencrypted-label = OpenPGP criptografado
filter-key-required = Você deve selecionar uma chave de destinatário.
filter-key-not-found = Não foi possível encontrar uma chave de criptografia para '{ $desc }'.
filter-warn-key-not-secret =
    Aviso - A ação do filtro "Criptografar com chave" substitui os destinatários.
    Se você não tiver a chave secreta de '{ $desc }', não poderá mais ler os emails.
# Strings filtersWrapper.jsm
filter-decrypt-move-label = Descriptografar permanentemente (OpenPGP)
filter-decrypt-copy-label = Criar cópia descriptografada (OpenPGP)
filter-encrypt-label = Criptografar com chave (OpenPGP)
# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Sucesso! Chaves importadas
import-info-bits = Bits
import-info-created = Criação
import-info-fpr = Impressão digital
import-info-details = Ver detalhes e gerenciar aceitação de chaves
import-info-no-keys = Nenhuma chave importada.
# Strings in enigmailKeyManager.js
import-from-clip = Quer importar algumas chaves da área de transferência?
import-from-url = Baixar chave pública a partir desta URL:
copy-to-clipbrd-failed = Não foi possível copiar as chaves selecionadas para área de transferência.
copy-to-clipbrd-ok = Chaves copiadas para área de transferência
delete-secret-key =
    AVISO: Você está prestes a excluir uma chave secreta!
    
    Se você excluir sua chave secreta, não poderá mais descriptografar nenhuma mensagem criptografada com essa chave, nem poderá revogá-la.
    
    Você realmente quer excluir AMBAS, a chave secreta e a chave pública
    '{ $userId }'?
delete-mix =
    AVISO: Você está prestes a excluir chaves secretas!
    Se você excluir sua chave secreta, não poderá mais descriptografar nenhuma mensagem criptografada com essa chave.
    Você realmente quer excluir AMBAS, as chaves secreta e pública selecionadas?
delete-pub-key =
    Quer excluir a chave pública
    '{ $userId }'?
delete-selected-pub-key = Quer excluir as chaves públicas?
refresh-all-question = Você não selecionou nenhuma chave. Quer atualizar TODAS as chaves?
key-man-button-export-sec-key = Exportar chaves &secretas
key-man-button-export-pub-key = Exportar só chaves &públicas
key-man-button-refresh-all = &Atualizar todas as chaves
key-man-loading-keys = Carregando chaves, aguarde…
ascii-armor-file = Arquivos ASCII blindados (*.asc)
no-key-selected = Você deve selecionar pelo menos uma chave para executar a operação selecionada
export-to-file = Exportar chave pública para arquivo
export-keypair-to-file = Exportar chaves secretas e públicas para arquivo
export-secret-key = Quer incluir a chave secreta no arquivo de chave OpenPGP salvo?
save-keys-ok = As chaves foram salvas com sucesso
save-keys-failed = Falha ao salvar as chaves
default-pub-key-filename = Chaves-públicas-exportadas
default-pub-sec-key-filename = Backup-de-chaves-secretas
refresh-key-warn = Aviso: dependendo do número de chaves e da velocidade da conexão, atualizar todas as chaves pode ser um processo demorado!
preview-failed = Não é possível ler o arquivo de chave pública.
general-error = Erro: { $reason }
dlg-button-delete = &Excluir

## Account settings export output

openpgp-export-public-success = <b>Chave pública exportada com sucesso!</b>
openpgp-export-public-fail = <b>Não foi possível exportar a chave pública selecionada!</b>
openpgp-export-secret-success = <b>Chave secreta exportada com sucesso!</b>
openpgp-export-secret-fail = <b>Não foi possível exportar a chave secreta selecionada!</b>
# Strings in keyObj.jsm
key-ring-pub-key-revoked = A chave { $userId } (ID da chave { $keyId }) foi revogada.
key-ring-pub-key-expired = A chave { $userId } (ID da chave { $keyId }) está vencida.
key-ring-no-secret-key = Parece que você não tem a chave secreta de { $userId } (ID da chave { $keyId }) em seu chaveiro. Você não pode usar a chave para assinar.
key-ring-pub-key-not-for-signing = A chave { $userId } (ID da chave { $keyId }) não pode ser usada para assinar.
key-ring-pub-key-not-for-encryption = A chave { $userId } (ID da chave { $keyId }) não pode ser usada para criptografar.
key-ring-sign-sub-keys-revoked = Todas as subchaves de assinatura da chave { $userId } (ID da chave { $keyId }) foram revogadas.
key-ring-sign-sub-keys-expired = Todas as subchaves de assinatura da chave { $userId } (ID da chave { $keyId }) estão vencidas.
key-ring-enc-sub-keys-revoked = Todas as subchaves de criptografia da chave { $userId } (ID da chave { $keyId }) foram revogadas.
key-ring-enc-sub-keys-expired = Todas as subchaves de criptografia da chave { $userId } (ID da chave { $keyId }) estão vencidas.
# Strings in gnupg-keylist.jsm
keyring-photo = Foto
user-att-photo = Atributo do usuário (imagem JPEG)
# Strings in key.jsm
already-revoked = Esta chave já foi revogada.
#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    Você está prestes a revogar a chave '{ $identity }'.
    Não poderá mais assinar com esta chave e, uma vez distribuída, outras pessoas não poderão mais criptografar com esta chave. Você ainda pode usar a chave para descriptografar mensagens antigas.
    Quer prosseguir?
#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    Você não tem nenhuma chave (0x{ $keyId }) que corresponda a este certificado de revogação!
    Se você perdeu sua chave, deve importá-la (por exemplo, de um servidor de chaves) antes de importar o certificado de revogação!
#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = A chave 0x{ $keyId } já foi revogada.
key-man-button-revoke-key = &Revogar chave
openpgp-key-revoke-success = Chave revogada com sucesso.
after-revoke-info =
    A chave foi revogada.
    Compartilhe esta chave pública novamente, enviando por email ou enviando para servidores de chaves, para que outras pessoas saibam que você revogou sua chave.
    Assim que os softwares usados por outras pessoas tomarem conhecimento da revogação, deixarão de usar sua chave antiga.
    Se você estiver usando uma nova chave para o mesmo endereço de email e anexar a nova chave pública aos emails que enviar, as informações sobre sua chave antiga revogada serão incluídas automaticamente.
# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = &Importar
delete-key-title = Excluir chave OpenPGP
delete-external-key-title = Remover a chave GnuPG externa
delete-external-key-description = Quer remover este ID de chave GnuPG externa?
key-in-use-title = Chave OpenPGP em uso no momento
delete-key-in-use-description = Não foi possível prosseguir! A chave que você selecionou para ser excluída está sendo usada no momento por esta identidade. Selecione outra chave ou não selecione nenhuma e tente novamente.
revoke-key-in-use-description = Não foi possível prosseguir! A chave que você selecionou para ser revogada está sendo usada no momento por esta identidade. Selecione outra chave ou não selecione nenhuma e tente novamente.
# Strings used in errorHandling.jsm
key-error-key-spec-not-found = O endereço de email '{ $keySpec }' não corresponde a nenhuma chave de seu chaveiro.
key-error-key-id-not-found = O ID de chave '{ $keySpec }' configurado não foi encontrado em seu chaveiro.
key-error-not-accepted-as-personal = Você não confirmou se a chave com ID '{ $keySpec }' é sua chave pessoal.
# Strings used in enigmailKeyManager.js & windows.jsm
need-online = A função que você selecionou não está disponível no modo offline. Fique online e tente novamente.
# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = Não foi possível encontrar nenhuma chave que corresponda aos critérios de pesquisa especificados.
# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = Erro - Falha no comando de extração de chave
# Strings used in keyRing.jsm
fail-cancel = Erro - Recebimento de chave cancelado pelo usuário
not-first-block = Erro - Primeiro bloco OpenPGP não é bloco de chave pública
import-key-confirm = Importar chaves públicas incorporadas na mensagem?
fail-key-import = Erro - Falha na importação de chave
file-write-failed = Falha ao gravar no arquivo { $output }
no-pgp-block = Erro - Não foi encontrado nenhum bloco blindado válido de dados OpenPGP
confirm-permissive-import = Falha na importação. A chave que você está tentando importar pode estar corrompida ou usar atributos desconhecidos. Quer tentar importar as partes que estão corretas? Isso pode resultar na importação de chaves incompletas e inutilizáveis.
# Strings used in trust.jsm
key-valid-unknown = desconhecida
key-valid-invalid = inválida
key-valid-disabled = desativada
key-valid-revoked = revogada
key-valid-expired = expirada
key-trust-untrusted = não confiável
key-trust-marginal = marginal
key-trust-full = confiável
key-trust-ultimate = definitivo
key-trust-group = (grupo)
# Strings used in commonWorkflows.js
import-key-file = Importar arquivo de chave OpenPGP
import-rev-file = Importar arquivo de revogação OpenPGP
gnupg-file = Arquivos GnuPG
import-keys-failed = Falha na importação das chaves
passphrase-prompt = Digite a senha que desbloqueia a seguinte chave: { $key }
file-to-big-to-import = Este arquivo é grande demais. Não importe um conjunto grande de chaves de uma só vez.
# Strings used in enigmailKeygen.js
save-revoke-cert-as = Criar e salvar certificado de revogação
revoke-cert-ok = O certificado de revogação foi criado com sucesso. Você pode usar para invalidar sua chave pública, por exemplo no caso de perder sua chave secreta.
revoke-cert-failed = O certificado de revogação não pôde ser criado.
gen-going = Geração de chaves já em andamento!
keygen-missing-user-name = Não há um nome especificado na conta/identidade selecionada. Digite algo no campo "Seu nome" nas configurações da conta.
expiry-too-short = Sua chave precisa ser válida por pelo menos um dia.
expiry-too-long = Você não pode criar uma chave com validade de mais de 100 anos.
key-confirm = Gerar chaves pública e secreta para '{ $id }'?
key-man-button-generate-key = &Gerar chaves
key-abort = Interromper geração de chave?
key-man-button-generate-key-abort = &Interromper geração de chave
key-man-button-generate-key-continue = &Continuar geração de chaves

# Strings used in enigmailMessengerOverlay.js

failed-decrypt = Erro - Falha na descriptografia
fix-broken-exchange-msg-failed = Não foi possível reparar a mensagem.
attachment-no-match-from-signature = Não foi possível combinar o arquivo de assinatura '{ $attachment }' com um anexo
attachment-no-match-to-signature = Não foi possível combinar o anexo '{ $attachment }' com um arquivo de assinatura
signature-verified-ok = A assinatura do anexo { $attachment } foi verificada com sucesso
signature-verify-failed = A assinatura do anexo { $attachment } não pôde ser verificada
decrypt-ok-no-sig =
    Aviso
    A descriptografia foi bem-sucedida, mas a assinatura não pôde ser verificada corretamente
msg-ovl-button-cont-anyway = &Continuar assim mesmo
enig-content-note = *Anexos desta mensagem não foram assinados nem criptografados*
# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = &Enviar mensagem
msg-compose-details-button-label = Detalhes…
msg-compose-details-button-access-key = D
send-aborted = Operação de envio interrompida
key-not-trusted = Confiança insuficiente na chave '{ $key }'
key-not-found = Chave '{ $key }' não encontrada
key-revoked = Chave '{ $key }' revogada
key-expired = Chave '{ $key }' expirada
msg-compose-internal-error = Ocorreu um erro interno.
keys-to-export = Selecione chaves OpenPGP a inserir
msg-compose-partially-encrypted-inlinePGP =
    A mensagem que você está respondendo continha tanto partes criptografadas como não criptografadas. Se o remetente não conseguiu descriptografar algumas partes da mensagem originalmente, você pode estar vazando informações confidenciais que o remetente não conseguiu descriptografar originalmente.
    Considere remover todo o texto citado de sua resposta a este remetente.
msg-compose-cannot-save-draft = Erro ao salvar rascunho
msg-compose-partially-encrypted-short = Cuidado com o vazamento de informações sensíveis. Email parcialmente criptografado.
quoted-printable-warn =
    Você ativou a codificação 'quoted-printable' para enviar mensagens. Isso pode resultar na descriptografia e/ou verificação incorreta de sua mensagem.
    Quer desativar agora o envio de mensagens 'quoted-printable'?
minimal-line-wrapping =
    Você configurou a quebra de linhas em { $width } caracteres. Para criptografia e/ou assinatura correta, este valor precisa ser pelo menos 68.
    Quer alterar agora a quebra de linhas em 68 caracteres?
sending-news =
    A operação de envio criptografado foi interrompida.
    Esta mensagem não pode ser criptografada porque há destinatários de grupos de notícias. Reenvie a mensagem sem criptografia.
send-to-news-warning =
    Aviso: Você está prestes a enviar um email criptografado para um grupo de notícias.
    Isso é desencorajado porque só faz sentido se todos os membros do grupo puderem descriptografar a mensagem, ou seja, a mensagem precisa ser criptografada com as chaves de todos os participantes do grupo. Só envie esta mensagem se souber exatamente o que está fazendo.
    Continuar?
save-attachment-header = Salvar anexo descriptografado
no-temp-dir =
    Não foi possível encontrar um diretório temporário onde gravar
    Defina a variável de ambiente TEMP
possibly-pgp-mime = Mensagem possivelmente criptografada ou assinada por PGP/MIME. Use a função 'Descriptografar/Verificar' para verificar
cannot-send-sig-because-no-own-key = Não é possível assinar digitalmente esta mensagem, porque você ainda não configurou a criptografia de ponta a ponta de <{ $key }>
cannot-send-enc-because-no-own-key = Não é possível enviar esta mensagem criptografada, porque você ainda não configurou a criptografia de ponta a ponta de <{ $key }>
compose-menu-attach-key =
    .label = Anexar minha chave pública
    .accesskey = A
compose-menu-encrypt-subject =
    .label = Criptografia de assunto
    .accesskey = s
# Strings used in decryption.jsm
do-import-multiple =
    Importar as seguintes chaves?
    { $key }
do-import-one = Importar { $name } ({ $id })?
cant-import = Erro ao importar chave pública
unverified-reply = Parte deslocada da mensagem (resposta) provavelmente foi modificada
key-in-message-body = Uma chave foi encontrada no corpo da mensagem. Clique em 'Importar chave' para importar a chave
sig-mismatch = Erro - Assinatura não combina
invalid-email = Erro - Endereços de email inválidos
attachment-pgp-key =
    O anexo '{ $name }' que você está abrindo parece ser um arquivo de chave OpenPGP.
    Clique em 'Importar' para importar as chaves contidas, ou em 'Ver' para ver o conteúdo do arquivo em uma janela do navegador
dlg-button-view = E&xibir
# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Mensagem descriptografada (restaurado o formato de email PGP corrompido, provavelmente causado por um servidor Exchange antigo, de modo que o resultado pode não ser perfeito para leitura)
# Strings used in encryption.jsm
not-required = Erro - nenhuma criptografia necessária
# Strings used in windows.jsm
no-photo-available = Nenhuma foto disponível
error-photo-path-not-readable = O caminho da foto '{ $photo }' não é legível
debug-log-title = Log de debug OpenPGP
# Strings used in dialog.jsm
repeat-prefix = Este alerta se repete { $count }
repeat-suffix-singular = vez mais.
repeat-suffix-plural = vezes mais.
no-repeat = Este alerta não será exibido novamente.
dlg-keep-setting = Lembrar minha resposta e não perguntar novamente
dlg-button-ok = &OK
dlg-button-close = &Fechar
dlg-button-cancel = &Cancelar
dlg-no-prompt = Não mostrar esse diálogo novamente
enig-prompt = Pergunta OpenPGP
enig-confirm = Confirmação OpenPGP
enig-alert = Alerta OpenPGP
enig-info = Informação OpenPGP
# Strings used in persistentCrypto.jsm
dlg-button-retry = &Tentar novamente
dlg-button-skip = &Ignorar
# Strings used in enigmailMsgBox.js
enig-alert-title =
    .title = Alerta OpenPGP
