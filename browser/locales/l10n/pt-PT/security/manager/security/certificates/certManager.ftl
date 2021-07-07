# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Gestor de certificados

certmgr-tab-mine =
    .label = Os seus certificados

certmgr-tab-remembered =
    .label = Decisões de autenticação

certmgr-tab-people =
    .label = Pessoas

certmgr-tab-servers =
    .label = Servidores

certmgr-tab-ca =
    .label = Autoridades

certmgr-mine = Tem certificados destas organizações que lhe identificam
certmgr-remembered = Estes certificados são utilizados para o identificar em sites.
certmgr-people = Tem certificados em ficheiro que identificam estas pessoas
certmgr-server = Estas entradas identificam exceções de erro do certificado do servidor
certmgr-ca = Tem certificados em ficheiro que identificam estas autoridades de certificados

certmgr-edit-ca-cert =
    .title = Editar definições de confiança do certificado CA
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Editar definições de confiança:

certmgr-edit-cert-trust-ssl =
    .label = Este certificado pode identificar sites.

certmgr-edit-cert-trust-email =
    .label = Este certificado pode identificar utilizadores de e-mail.

certmgr-delete-cert =
    .title = Apagar certificado
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = Anfitrião

certmgr-cert-name =
    .label = Nome do certificado

certmgr-cert-server =
    .label = Servidor

certmgr-override-lifetime =
    .label = Validade

certmgr-token-name =
    .label = Dispositivo de segurança

certmgr-begins-label =
    .label = Inicia em

certmgr-expires-label =
    .label = Expira em

certmgr-email =
    .label = Endereço de e-mail

certmgr-serial =
    .label = Número de série

certmgr-view =
    .label = Ver…
    .accesskey = V

certmgr-edit =
    .label = Editar confiança…
    .accesskey = E

certmgr-export =
    .label = Exportar…
    .accesskey = x

certmgr-delete =
    .label = Apagar…
    .accesskey = A

certmgr-delete-builtin =
    .label = Apagar ou desconfiar…
    .accesskey = A

certmgr-backup =
    .label = Cópia de segurança…
    .accesskey = s

certmgr-backup-all =
    .label = Copiar todos…
    .accesskey = t

certmgr-restore =
    .label = Importar…
    .accesskey = m

certmgr-add-exception =
    .label = Adicionar exceção…
    .accesskey = A

exception-mgr =
    .title = Adicionar exceção de segurança

exception-mgr-extra-button =
    .label = Confirmar exceção de segurança
    .accesskey = C

exception-mgr-supplemental-warning = Bancos, lojas e outros sites públicos legítimos não lhe irão pedir para fazer isto.

exception-mgr-cert-location-url =
    .value = Localização:

exception-mgr-cert-location-download =
    .label = Obter certificado
    .accesskey = O

exception-mgr-cert-status-view-cert =
    .label = Ver…
    .accesskey = V

exception-mgr-permanent =
    .label = Guardar exceção permanentemente
    .accesskey = p

pk11-bad-password = A palavra-passe introduzida está incorreta.
pkcs12-decode-err = Falha ao descodificar ficheiro.  Ou não está no formato PKCS #12, ou está corrompido, ou a palavra-passe inserida está incorreta.
pkcs12-unknown-err-restore = Falhou a restauração do ficheiro PKCS #12 for razões desconhecidas.
pkcs12-unknown-err-backup = Falha ao criar o ficheiro de backup PKCS #12 por razões desconhecidas.
pkcs12-unknown-err = A operação PKCS #12 falhou por razões desconhecidas.
pkcs12-info-no-smartcard-backup = Não é possível criar cópias de segurança de certificados a partir de um dispositivos com segurança como, por exemplo, um smart card.
pkcs12-dup-data = O certificado e a chave privada já existem no dispositivo de segurança.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Nome do ficheiro a guardar
file-browse-pkcs12-spec = Ficheiros PKCS12
choose-p12-restore-file-dialog = Ficheiro do certificado para importar

## Import certificate(s) file dialog

file-browse-certificate-spec = Ficheiros de certificados
import-ca-certs-prompt = Selecione o ficheiro que contém o(s) certificado(s) de CA a importar
import-email-cert-prompt = Selecione o ficheiro que contém o certificado de email de alguém para importar

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = O certificado “{ $certName }” representa uma autoridade certificadora.

## For Deleting Certificates

delete-user-cert-title =
    .title = Apagar os meus certificados
delete-user-cert-confirm = Tem a certeza que pretende eliminar estes certificados?
delete-user-cert-impact = Se apagar um dos seus certificados, não o poderá mais utilizar para se identificar.


delete-ssl-override-title =
    .title = Eliminar exceção do certificado de servidor
delete-ssl-override-confirm = Tem a certeza que pretende eliminar esta exceção de servidor?
delete-ssl-override-impact = Se eliminar uma exceção de servidor, irá restaurar as verificações de segurança habituais para este servidor, obrigando a que o mesmo utilize um certificado válido.

delete-ca-cert-title =
    .title = Apagar ou desconfiar de certificados CA
delete-ca-cert-confirm = Pediu para eliminar estes certificados CA. Para certificados integrados, será removida toda a confiança, que tem o mesmo efeito. Tem a certeza que pretende eliminar ou deixar de confiar?
delete-ca-cert-impact = Se apagar ou desconfiar um certificado de uma autoridade certificada (CA), esta aplicação deixará de confiar de qualquer certificado dessa CA.


delete-email-cert-title =
    .title = Apagar certificados de e-mail
delete-email-cert-confirm = Tem a certeza que pretende eliminar os certificados de e-mail destas pessoas?
delete-email-cert-impact = Se apagar o certificado de e-mail de uma pessoa, já não será capaz de enviar e-mails encriptados para essa pessoa.

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
no-cert-stored-for-override = (Não armazenada)

# When a certificate is unavailable (for example, it has been deleted or the token it exists on has been removed).
certificate-not-available = (indisponível)

## Used to show whether an override is temporary or permanent

permanent-override = Permanente
temporary-override = Temporária

## Add Security Exception dialog

add-exception-branded-warning = Está prestes a sobrepor a forma como o { -brand-short-name } identifica este site.
add-exception-invalid-header = Este site tenta identificar-se com informação inválida.
add-exception-domain-mismatch-short = Site errado
add-exception-domain-mismatch-long = Este certificado pertence a um site diferente, o que pode indiciar que alguém está a tentar fazer-se passar por este site.
add-exception-expired-short = Informação desatualizada
add-exception-expired-long = O certificado não é atualmente válido. Pode ter sido furtado ou perdido, e pode ser utilizado por alguém para fazer-se passar por este site.
add-exception-unverified-or-bad-signature-short = Identidade desconhecida
add-exception-unverified-or-bad-signature-long = O certificado não é de confiança, uma vez que não foi verificado por uma autoridade reconhecida usando uma assinatura segura.
add-exception-valid-short = Certificado válido
add-exception-valid-long = Este site fornece uma identificação válida e verificável.  Não é necessário adicionar uma exceção.
add-exception-checking-short = A verificar a informação
add-exception-checking-long = A tentar identificar o site…
add-exception-no-cert-short = Informação indisponível
add-exception-no-cert-long = Não foi possível obter o estado da identificação para este site.

## Certificate export "Save as" and error dialogs

save-cert-as = Guardar certificado para ficheiro
cert-format-base64 = Certificado X.509 (PEM)
cert-format-base64-chain = Certificado X.509 com cadeia (PEM)
cert-format-der = Certificado X.509 (DER)
cert-format-pkcs7 = Certificado X.509 (PKCS#7)
cert-format-pkcs7-chain = Certificado X.509 com cadeia (PKCS#7)
write-file-failure = Erro no ficheiro
