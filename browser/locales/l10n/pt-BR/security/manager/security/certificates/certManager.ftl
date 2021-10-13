# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Gerenciador de certificados

certmgr-tab-mine =
    .label = Seus certificados

certmgr-tab-remembered =
    .label = Decisões de autenticação

certmgr-tab-people =
    .label = Pessoas

certmgr-tab-servers =
    .label = Servidores

certmgr-tab-ca =
    .label = Autoridades

certmgr-mine = Você possui certificados dessas organizações que identificam você
certmgr-remembered = Estes certificados são usados para identificar você em sites
certmgr-people = Você possui certificados arquivados que identificam estas pessoas
certmgr-server = Esses itens identificam exceções de erro de certificados de servidores
certmgr-ca = Você possui certificados arquivados que identificam estas autoridades certificadoras

certmgr-edit-ca-cert =
    .title = Configurações de confiança do certificado da CA
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Editar as configurações de confiança:

certmgr-edit-cert-trust-ssl =
    .label = Este certificado pode identificar sites.

certmgr-edit-cert-trust-email =
    .label = Este certificado pode identificar usuários de email.

certmgr-delete-cert =
    .title = Excluir certificados
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = Servidor

certmgr-cert-name =
    .label = Nome do certificado

certmgr-cert-server =
    .label = Servidor

certmgr-override-lifetime =
    .label = Duração

certmgr-token-name =
    .label = Dispositivo de segurança

certmgr-begins-label =
    .label = Início

certmgr-expires-label =
    .label = Fim

certmgr-email =
    .label = Endereço de email

certmgr-serial =
    .label = Número de série

certmgr-view =
    .label = Ver…
    .accesskey = V

certmgr-edit =
    .label = Confiança…
    .accesskey = o

certmgr-export =
    .label = Exportar…
    .accesskey = E

certmgr-delete =
    .label = Excluir…
    .accesskey = c

certmgr-delete-builtin =
    .label = Excluir ou deixar de confiar…
    .accesskey = c

certmgr-backup =
    .label = Backup…
    .accesskey = B

certmgr-backup-all =
    .label = Fazer backup de tudo…
    .accesskey = F

certmgr-restore =
    .label = Importar…
    .accesskey = I

certmgr-add-exception =
    .label = Adicionar exceção…
    .accesskey = A

exception-mgr =
    .title = Adicionar exceção de segurança

exception-mgr-extra-button =
    .label = Confirmar exceção de segurança
    .accesskey = C

exception-mgr-supplemental-warning = Bancos, lojas e outros sites públicos legítimos nunca solicitarão a você que faça isso.

exception-mgr-cert-location-url =
    .value = Endereço:

exception-mgr-cert-location-download =
    .label = Verificar certificado
    .accesskey = V

exception-mgr-cert-status-view-cert =
    .label = Ver…
    .accesskey = x

exception-mgr-permanent =
    .label = Salvar esta exceção permanentemente
    .accesskey = S

pk11-bad-password = A senha fornecida estava incorreta.
pkcs12-decode-err = Falha em decodificar o arquivo. Ou ele não está no formato PKCS #12, foi corrompido ou a senha fornecida está incorreta.
pkcs12-unknown-err-restore = Falha ao restaurar o arquivo PKCS #12 por motivos desconhecidos.
pkcs12-unknown-err-backup = Falha ao criar o arquivo de backup PKCS #12 por motivos desconhecidos.
pkcs12-unknown-err = Falha na operação PKCS #12 por motivos desconhecidos.
pkcs12-info-no-smartcard-backup = Não é possível efetuar backup de certificados de dispositivo de segurança em hardware (como um smart card).
pkcs12-dup-data = O certificado e a chave privada já existem no dispositivo de segurança.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Arquivo para fazer o backup
file-browse-pkcs12-spec = Arquivos PKCS12
choose-p12-restore-file-dialog = Importar arquivo de certificado

## Import certificate(s) file dialog

file-browse-certificate-spec = Arquivos de certificados
import-ca-certs-prompt = Selecionar arquivo contendo os certificados de CA a importar
import-email-cert-prompt = Selecione um arquivo contendo o certificado de email de alguém a importar

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = O certificado “{ $certName }” representa uma autoridade certificadora.

## For Deleting Certificates

delete-user-cert-title =
    .title = Excluir seus certificados
delete-user-cert-confirm = Tem certeza que quer excluir estes certificados?
delete-user-cert-impact = Caso exclua um de seus próprios certificados, não poderá mais usá-lo para se identificar.


delete-ssl-override-title =
    .title = Excluir exceção de certificado de servidor
delete-ssl-override-confirm = Tem certeza que quer excluir esta exceção de servidor?
delete-ssl-override-impact = Se excluir uma exceção de servidor, irá restaurar as verificações de segurança habituais nesse servidor e exigir que ele use um certificado válido.

delete-ca-cert-title =
    .title = Excluir ou deixar de confiar em certificados de CA
delete-ca-cert-confirm = Você solicitou excluir estes certificados de CA. Certificados internos passarão a ser rejeitados em vez de excluídos, o que produz o mesmo efeito. Tem certeza que quer excluir ou deixar de confiar?
delete-ca-cert-impact = Se você excluir ou deixar de confiar em um certificado de uma autoridade certificadora (CA), este aplicativo rejeitará qualquer certificado emitido pela CA.


delete-email-cert-title =
    .title = Excluir certificados de email
delete-email-cert-confirm = Tem certeza que quer excluir os certificados de email dessas pessoas?
delete-email-cert-impact = Se você excluir o certificado de email de alguém, não poderá mais enviar emails criptografados a esta pessoa.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Certificado com número de série: { $serialNumber }

## Cert Viewer

# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Não enviar nenhum certificado de cliente

# Used when no cert is stored for an override
no-cert-stored-for-override = (não armazenado)

# When a certificate is unavailable (for example, it has been deleted or the token it exists on has been removed).
certificate-not-available = (não disponível)

## Used to show whether an override is temporary or permanent

permanent-override = Permanente
temporary-override = Temporário

## Add Security Exception dialog

add-exception-branded-warning = Você irá substituir o modo como o { -brand-short-name } identifica este site.
add-exception-invalid-header = Este site tenta identificar-se com informação inválida.
add-exception-domain-mismatch-short = Site incorreto
add-exception-domain-mismatch-long = O certificado pertence a um site diferente, o que pode significar que alguém está tentando se passar por este site.
add-exception-expired-short = Informação desatualizada
add-exception-expired-long = O certificado não é válido no momento. Ele pode ter sido roubado ou perdido e pode ser usado por alguém para se fazer passar pelo site.
add-exception-unverified-or-bad-signature-short = Identidade desconhecida
add-exception-unverified-or-bad-signature-long = O certificado não é considerado confiável porque não foi homologado por uma autoridade reconhecida usando uma assinatura segura.
add-exception-valid-short = Certificado válido
add-exception-valid-long = Este site fornece identificação válida e homologada. Não é necessário adicionar uma exceção.
add-exception-checking-short = Verificando informações
add-exception-checking-long = Tentando identificar o site…
add-exception-no-cert-short = Nenhuma informação disponível
add-exception-no-cert-long = Não foi possível obter o status de identificação deste site.

## Certificate export "Save as" and error dialogs

save-cert-as = Salvar certificado como arquivo
cert-format-base64 = Certificado X.509 (PEM)
cert-format-base64-chain = Certificado X.509 com cadeia (PEM)
cert-format-der = Certificado X.509 (DER)
cert-format-pkcs7 = Certificado X.509 (PKCS#7)
cert-format-pkcs7-chain = Certificado X.509 com cadeia (PKCS#7)
write-file-failure = Erro de arquivo
