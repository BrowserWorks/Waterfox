# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Xestor de certificados
certmgr-tab-mine =
    .label = Os seus certificados
certmgr-tab-remembered =
    .label = Decisións de autentificación
certmgr-tab-people =
    .label = Persoas
certmgr-tab-servers =
    .label = Servidores
certmgr-tab-ca =
    .label = Entidades
certmgr-mine = Ten certificados destas organizacións que o identifican
certmgr-remembered = Estes certificados úsanse para identificalo a sitios web
certmgr-people = Ten certificados arquivados que identifican a estas persoas
certmgr-servers = Ten certificados arquivados que identifican a estes servidores
certmgr-ca = Ten certificados arquivados que identifican a estas entidades de acreditación
certmgr-detail-general-tab-title =
    .label = Xeral
    .accesskey = X
certmgr-detail-pretty-print-tab-title =
    .label = Detalles
    .accesskey = D
certmgr-pending-label =
    .value = Verificando o certificado…
certmgr-subject-label = Emitido a
certmgr-issuer-label = Emitido por
certmgr-period-of-validity = Período de validez
certmgr-fingerprints = Pegadas dixitais
certmgr-cert-detail =
    .title = Detalles do certificado
    .buttonlabelaccept = Pechar
    .buttonaccesskeyaccept = P
certmgr-cert-detail-commonname = Nome común (NC)
certmgr-cert-detail-org = Organización (O)
certmgr-cert-detail-orgunit = Unidade organizativa (UO)
certmgr-cert-detail-serial-number = Número de serie
certmgr-cert-detail-sha-256-fingerprint = Pegada dixital SHA-256
certmgr-cert-detail-sha-1-fingerprint = Pegada dixital SHA1
certmgr-edit-ca-cert =
    .title = Editar a configuración de confianza do certificado da AC
    .style = width: 48em;
certmgr-edit-cert-edit-trust = Editar a configuración de confianza:
certmgr-edit-cert-trust-ssl =
    .label = Este certificado identifica sitios web.
certmgr-edit-cert-trust-email =
    .label = Este certificado identifica usuarios de correo.
certmgr-delete-cert =
    .title = Eliminar certificado
    .style = width: 48em; height: 24em;
certmgr-cert-host =
    .label = Servidor
certmgr-cert-name =
    .label = Nome do certificado
certmgr-cert-server =
    .label = Servidor
certmgr-override-lifetime =
    .label = Duración
certmgr-token-name =
    .label = Dispositivo de seguranza
certmgr-begins-on = Comeza o
certmgr-begins-label =
    .label = Comeza o
certmgr-expires-on = Caduca o
certmgr-expires-label =
    .label = Caduca o
certmgr-email =
    .label = Enderezo de correo electrónico
certmgr-serial =
    .label = Número de serie
certmgr-view =
    .label = Ver…
    .accesskey = V
certmgr-edit =
    .label = Editar confianza…
    .accesskey = E
certmgr-export =
    .label = Exportar…
    .accesskey = x
certmgr-delete =
    .label = Eliminar…
    .accesskey = m
certmgr-delete-builtin =
    .label = Eliminar ou deixar de confiar…
    .accesskey = d
certmgr-backup =
    .label = Copia de seguranza…
    .accesskey = C
certmgr-backup-all =
    .label = Copia de seguranza de todo…
    .accesskey = s
certmgr-restore =
    .label = Importar…
    .accesskey = I
certmgr-details =
    .value = Campos do certificado
    .accesskey = o
certmgr-fields =
    .value = Valor do campo
    .accesskey = V
certmgr-hierarchy =
    .value = Xerarquía do certificado
    .accesskey = q
certmgr-add-exception =
    .label = Engadir excepción…
    .accesskey = x
exception-mgr =
    .title = Engadir excepción de seguranza
exception-mgr-extra-button =
    .label = Confirmar excepción de seguranza
    .accesskey = C
exception-mgr-supplemental-warning = A lexitimación de bancos, tendas e outros sitios públicos non requirirá este proceso.
exception-mgr-cert-location-url =
    .value = Localización:
exception-mgr-cert-location-download =
    .label = Obter certificado
    .accesskey = O
exception-mgr-cert-status-view-cert =
    .label = Ver…
    .accesskey = V
exception-mgr-permanent =
    .label = Almacenar esta excepción de forma permanente
    .accesskey = A
pk11-bad-password = O contrasinal introducido é incorrecto.
pkcs12-decode-err = Erro ao descodificar o ficheiro. Non está en formato PKCS #12, foi danado, ou ben o contrasinal que introduciu era incorrecto.
pkcs12-unknown-err-restore = Erro ao restaurar o ficheiro PKCS #12 por motivos descoñecidos.
pkcs12-unknown-err-backup = Erro ao crear o ficheiro de copia de seguranza de PKCS #12 por motivos descoñecidos.
pkcs12-unknown-err = A operación PKCS #12 fallou por motivos descoñecidos.
pkcs12-info-no-smartcard-backup = Non é posíbel facer copias de seguranza de certificados a partir de dispositivos de seguranza hardware como, por exemplo, un cartón intelixente.
pkcs12-dup-data = O certificado e a chave privada xa existen no dispositivo de seguranza.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Nome do ficheiro para copiar
file-browse-pkcs12-spec = Ficheiros PKCS12
choose-p12-restore-file-dialog = Ficheiro de certificado para importar

## Import certificate(s) file dialog

file-browse-certificate-spec = Ficheiros con certificados
import-ca-certs-prompt = Escolla o ficheiro que contén os certificados de AC para importar
import-email-cert-prompt = Escolla o ficheiro que contén o certificado de correo electrónico de alguén para importar

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = O certificado "{ $certName }" representa unha entidade de acreditación.

## For Deleting Certificates

delete-user-cert-title =
    .title = Eliminar os seus certificados
delete-user-cert-confirm = Confirma que quere eliminar estes certificados?
delete-user-cert-impact = Se elimina un dos seus certificados, xa non o poderá utilizar para se identificar.
delete-ssl-cert-title =
    .title = Eliminar as excepcións de certificado de servidor
delete-ssl-cert-confirm = Confirma que quere eliminar estas excepcións de servidor?
delete-ssl-cert-impact = Se elimina unha excepción de servidor restaurará as verificacións de seguranza habituais que requiren a utilización dun certificado válido.
delete-ca-cert-title =
    .title = Eliminar ou deixar de confiar nos certificados da CA
delete-ca-cert-confirm = Solicitou eliminar estes certificados da AC. Para os certificados incluídos deixase de confiar neles, o que ten o mesmo efecto. Confirma que quere facer isto?
delete-ca-cert-impact = Se elimina ou deixa de confiar nun certificado dunha entidade de acreditación (CA), este aplicativo non confiará máis nos certificados emitidos por ela.
delete-email-cert-title =
    .title = Eliminar os certificados do correo electrónico
delete-email-cert-confirm = Confirma que quere eliminar estes certificados de correo electrónico?
delete-email-cert-impact = Se elimina o certificado de correo electrónico dunha persoa non poderá enviarlle máis correos cifrados.
# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Certificado co número de serie: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Visor de certificados: «{ $certName }»
not-present =
    .value = <Non é parte do certificado>
# Cert verification
cert-verified = Este certificado está verificado para os seguintes usos:
# Add usage
verify-ssl-client =
    .value = Certificado cliente SSL
verify-ssl-server =
    .value = Certificado servidor SSL
verify-ssl-ca =
    .value = Entidade de acreditación SSL
verify-email-signer =
    .value = Certificado de asinante de correo electrónico.
verify-email-recip =
    .value = Certificado de destinatario de correo electrónico.
# Cert verification
cert-not-verified-cert-revoked = Non foi posíbel verificar este certificado porque foi revogado.
cert-not-verified-cert-expired = Non foi posíbel verificar este certificado porque caducou.
cert-not-verified-cert-not-trusted = Non foi posíbel verificar este certificado porque non é de confianza.
cert-not-verified-issuer-not-trusted = Non foi posíbel verificar este certificado porque o emisor non é de confianza.
cert-not-verified-issuer-unknown = Non foi posíbel verificar este certificado porque se descoñece o emisor.
cert-not-verified-ca-invalid = Non foi posíbel verificar este certificado porque o certificado da CA non é correcto.
cert-not-verified_algorithm-disabled = Non foi posíbel verificar este certificado porque se asinou usando un algoritmo de asinamento que foi desactivado porque non é seguro.
cert-not-verified-unknown = Non foi posíbel verificar este certificado por motivos descoñecidos.
# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Non enviar certificado de cliente

## Add Security Exception dialog

add-exception-branded-warning = Vai obviar a forma en que { -brand-short-name } identifica este sitio.
add-exception-invalid-header = Este sito está a tentar identificarse con información non válida.
add-exception-domain-mismatch-short = Sitio errado
add-exception-domain-mismatch-long = O certificado pertence a outro sitio, o que podería significar que alguén está tentando facerse pasar por este sitio.
add-exception-expired-short = Información anticuada
add-exception-expired-long = Agora o certificado xa non é válido. É posíbel que fora roubado ou se perdera, e podería ser usado por alguén para facerse pasar por este sitio.
add-exception-unverified-or-bad-signature-short = Identidade descoñecida
add-exception-unverified-or-bad-signature-long = O certificado non é de confianza xa que non foi verificado como emitido por unha entidade de acreditación de confianza usando unha sinatura segura.
add-exception-valid-short = Certificado válido
add-exception-valid-long = Este sitio fornece información válida e verificada. Non é necesario engadir unha excepción.
add-exception-checking-short = Verificando a información
add-exception-checking-long = Tentando identificar este sitio…
add-exception-no-cert-short = Non hai información dispoñíbel
add-exception-no-cert-long = Non foi posíbel obter o estado da identificación para este sitio.

## Certificate export "Save as" and error dialogs

save-cert-as = Gardar o certificado nun ficheiro
cert-format-base64 = Certificado X.509 (PEM)
cert-format-base64-chain = Certificado X.509 con cadea (PEM)
cert-format-der = Certificado X.509 (DER)
cert-format-pkcs7 = Certificado X.509 (PKCS#7)
cert-format-pkcs7-chain = Certificado X.509 con cadea (PKCS#7)
write-file-failure = Erro no ficheiro
