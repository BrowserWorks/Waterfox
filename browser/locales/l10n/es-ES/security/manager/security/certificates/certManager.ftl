# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Administrador de certificados
certmgr-tab-mine =
    .label = Sus certificados
certmgr-tab-remembered =
    .label = Decisiones de autenticación
certmgr-tab-people =
    .label = Personas
certmgr-tab-servers =
    .label = Servidores
certmgr-tab-ca =
    .label = Autoridades
certmgr-mine = Tiene certificados de estas organizaciones que le identifican
certmgr-remembered = Estos certificados se utilizan para identificarle en los sitios web.
certmgr-people = Tiene certificados guardados que identifican estas personas
certmgr-servers = Tiene certificados guardados que identifican estos servidores
certmgr-server = Estas entradas identifican las excepciones de error del certificado del servidor
certmgr-ca = Tiene certificados guardados que identifican estas autoridades de certificación
certmgr-detail-general-tab-title =
    .label = General
    .accesskey = G
certmgr-detail-pretty-print-tab-title =
    .label = Detalles
    .accesskey = D
certmgr-pending-label =
    .value = Verificando ahora el certificado…
certmgr-subject-label = Emitido para
certmgr-issuer-label = Emitido por
certmgr-period-of-validity = Periodo de validez
certmgr-fingerprints = Huellas digitales
certmgr-cert-detail =
    .title = Detalle del certificado
    .buttonlabelaccept = Cerrar
    .buttonaccesskeyaccept = C
certmgr-cert-detail-commonname = Nombre común (CN)
certmgr-cert-detail-org = Organización (O)
certmgr-cert-detail-orgunit = Unidad organizativa (OU)
certmgr-cert-detail-serial-number = Número de serie
certmgr-cert-detail-sha-256-fingerprint = Huella digital SHA-256
certmgr-cert-detail-sha-1-fingerprint = Huella digital SHA1
certmgr-edit-ca-cert =
    .title = Editar configuración de confianza de la CA
    .style = width: 48em;
certmgr-edit-cert-edit-trust = Editar configuraciones de confianza:
certmgr-edit-cert-trust-ssl =
    .label = Este certificado puede identificar sitios web.
certmgr-edit-cert-trust-email =
    .label = Este certificado puede identificar a los usuarios de correo.
certmgr-delete-cert =
    .title = Eliminar certificado
    .style = width: 48em; height: 24em;
certmgr-cert-host =
    .label = Servidor
certmgr-cert-name =
    .label = Nombre del certificado
certmgr-cert-server =
    .label = Servidor
certmgr-override-lifetime =
    .label = Vida útil
certmgr-token-name =
    .label = Dispositivo de seguridad
certmgr-begins-on = Comienza el
certmgr-begins-label =
    .label = Comienza el
certmgr-expires-on = Caduca el
certmgr-expires-label =
    .label = Caduca el
certmgr-email =
    .label = Dirección de correo electr.
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
    .accesskey = r
certmgr-delete-builtin =
    .label = Eliminar o dejar de confiar…
    .accesskey = n
certmgr-backup =
    .label = Hacer copia…
    .accesskey = H
certmgr-backup-all =
    .label = Hacer copia de todo…
    .accesskey = t
certmgr-restore =
    .label = Importar…
    .accesskey = m
certmgr-details =
    .value = Campos del certificado
    .accesskey = F
certmgr-fields =
    .value = Valor del campo
    .accesskey = V
certmgr-hierarchy =
    .value = Jerarquía de certificados
    .accesskey = J
certmgr-add-exception =
    .label = Añadir excepción…
    .accesskey = x
exception-mgr =
    .title = Añadir excepción de seguridad
exception-mgr-extra-button =
    .label = Confirmar excepción de seguridad
    .accesskey = C
exception-mgr-supplemental-warning = Los bancos, tiendas y otros sitios públicos legítimos no le pedirán hacer esto.
exception-mgr-cert-location-url =
    .value = Dirección:
exception-mgr-cert-location-download =
    .label = Obtener certificado
    .accesskey = O
exception-mgr-cert-status-view-cert =
    .label = Ver…
    .accesskey = V
exception-mgr-permanent =
    .label = Guardar esta excepción de manera permanente
    .accesskey = P
pk11-bad-password = La contraseña introducida era incorrecta.
pkcs12-decode-err = Fallo al decodificar el archivo. O no está en formato PKCS #12, o está corrupto, o la contraseña suministrada es incorrecta.
pkcs12-unknown-err-restore = Fallo en la recuperación del archivo PKCS #12 por motivos desconocidos.
pkcs12-unknown-err-backup = Se produjo un fallo por motivos desconocidos al guardar la copia de seguridad del archivo PKCS #12.
pkcs12-unknown-err = La operación PKCS #12 falló por razones desconocidas.
pkcs12-info-no-smartcard-backup = No es posible hacer copias de seguridad de certificados procedentes de dispositivos de seguridad hardware tales como tarjetas inteligentes.
pkcs12-dup-data = El certificado y la clave privada ya existen en el dispositivo de seguridad.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Nombre del archivo a salvaguardar
file-browse-pkcs12-spec = Archivos PKCS12
choose-p12-restore-file-dialog = Archivo de certificado para importar

## Import certificate(s) file dialog

file-browse-certificate-spec = Archivos de certificados
import-ca-certs-prompt = Seleccione el archivo que contiene el/los certificado(s) CA a importar
import-email-cert-prompt = Seleccione el archivo que contiene el certificado de correo electrónico de otra persona a importar

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = El certificado “{ $certName }” representa a una autoridad certificadora.

## For Deleting Certificates

delete-user-cert-title =
    .title = Eliminar sus certificados
delete-user-cert-confirm = ¿Seguro que quiere eliminar estos certificados?
delete-user-cert-impact = Si elimina uno de sus propios certificados, no podrá utilizarlo para identificarse a sí mismo.
delete-ssl-cert-title =
    .title = Eliminar excepciones de certificados de servidor
delete-ssl-cert-confirm = ¿Seguro que quiere eliminar estas excepciones de servidor?
delete-ssl-cert-impact = Si elimina una excepción de servidor, restaurará los controles de seguridad habituales para ese servidor y se requerirá que use un certificado válido.
delete-ssl-override-title =
    .title = Eliminar la excepción del certificado del servidor
delete-ssl-override-confirm = ¿Seguro que quiere eliminar esta excepción de servidor?
delete-ssl-override-impact = Si elimina una excepción de servidor, restaurará los controles de seguridad habituales para ese servidor y se requerirá que use un certificado válido.
delete-ca-cert-title =
    .title = Eliminar o dejar de confiar certificados CA
delete-ca-cert-confirm = Ha solicitado eliminar estos certificados de CA. En el caso de los incluidos de serie, en lugar de borrarlos se les retira la confianza, lo que tiene el mismo efecto. ¿Seguro que quiere hacer esto?
delete-ca-cert-impact = Si elimina, o deja de confiar en, un certificado de autoridad certificadora (CA), esta aplicación dejará de confiar en cualquier certificado emitido por esta CA.
delete-email-cert-title =
    .title = Eliminar certificados de correo electrónico
delete-email-cert-confirm = ¿Seguro que quiere eliminar los certificados de correo electrónico de estas personas?
delete-email-cert-impact = Si borra el certificado de correo electrónico de una persona, ya no podrá enviar mensajes cifrados a esa persona.
# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Certificado con número de serie: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Visor de certificados: "{ $certName }"
not-present =
    .value = <No es parte de un certificado>
# Cert verification
cert-verified = Este certificado ha sido verificado para los siguientes usos:
# Add usage
verify-ssl-client =
    .value = Certificado del cliente SSL
verify-ssl-server =
    .value = Certificado del servidor SSL
verify-ssl-ca =
    .value = Autoridad Certificadora (CA) SSL
verify-email-signer =
    .value = Certificado del firmante del correo electrónico
verify-email-recip =
    .value = Certificado del receptor del correo electrónico
# Cert verification
cert-not-verified-cert-revoked = No se pudo verificar este certificado porque ha sido revocado.
cert-not-verified-cert-expired = No se pudo verificar este certificado porque ha caducado.
cert-not-verified-cert-not-trusted = No se pudo verificar este certificado porque no se confía en él.
cert-not-verified-issuer-not-trusted = No se pudo verificar este certificado porque no se confía en el emisor.
cert-not-verified-issuer-unknown = No se pudo verificar este certificado porque el emisor es desconocido.
cert-not-verified-ca-invalid = No se pudo verificar este certificado porque el certificado de la CA no es válido.
cert-not-verified_algorithm-disabled = No se ha podido verificar este certificado porque se ha firmado usando un algoritmo de firma que fue desactivado porque es inseguro.
cert-not-verified-unknown = No se pudo verificar este certificado por razones desconocidas.
# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = No enviar el certificado del cliente
# Used when no cert is stored for an override
no-cert-stored-for-override = (No guardado)

## Used to show whether an override is temporary or permanent

permanent-override = Permanente
temporary-override = Temporal

## Add Security Exception dialog

add-exception-branded-warning = Está a punto de alterar cómo identifica { -brand-short-name } este sitio.
add-exception-invalid-header = Este sitio intenta identificarse a sí mismo con información no válida.
add-exception-domain-mismatch-short = Sitio erróneo
add-exception-domain-mismatch-long = El certificado pertenece a un sitio diferente, lo que podría significar que alquien está intentando hacer pasar por este sitio.
add-exception-expired-short = Información obsoleta
add-exception-expired-long = El certificado no es actualmente válido. Puede haber sido robado o perdido, y podría estar siendo usado por alquien para hacerse pasar por este sitio.
add-exception-unverified-or-bad-signature-short = Identidad desconocida
add-exception-unverified-or-bad-signature-long = No se confía en el certificado porque no ha sido verificado como emitido por una autoridad confiable usando una firma segura.
add-exception-valid-short = Certificado válido
add-exception-valid-long = Este sitio proporciona identificación válida y verificada. No hay necesidad de añadir una excepción.
add-exception-checking-short = Comprobando información
add-exception-checking-long = Intentando identificar este sitio…
add-exception-no-cert-short = No hay información disponible
add-exception-no-cert-long = No es posible obtener el estado de identificación de este sitio.

## Certificate export "Save as" and error dialogs

save-cert-as = Guardar certificado en archivo
cert-format-base64 = Certificado X.509 (PEM)
cert-format-base64-chain = Certificado X.509 con cadena (PEM)
cert-format-der = Certificado X.509 (DER)
cert-format-pkcs7 = Certificado X.509 (PKCS#7)
cert-format-pkcs7-chain = Certificado X.509 con cadena (PKCX#7)
write-file-failure = Error de archivo
