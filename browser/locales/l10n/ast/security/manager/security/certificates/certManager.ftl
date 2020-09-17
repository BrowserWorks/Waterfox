# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Xestor de certificaos

certmgr-tab-mine =
    .label = Los tos certificaos

certmgr-tab-people =
    .label = Persones

certmgr-tab-servers =
    .label = Sirvidores

certmgr-tab-ca =
    .label = Autoridaes

certmgr-mine = Tienes certificaos d'estes organización que t'identifiquen
certmgr-people = Tienes certificaos nel ficheru qu'identifiquen a estes persones
certmgr-servers = Tienes certificaos nel ficheru qu'identifiquen a estos sirvidores
certmgr-ca = Tienes certificaos nel ficheru qu'identifiquen a estes autoridaes certificadores

certmgr-detail-general-tab-title =
    .label = Xeneral
    .accesskey = X

certmgr-detail-pretty-print-tab-title =
    .label = Detalles
    .accesskey = D

certmgr-pending-label =
    .value = Verificando'l certificáu nesti momentu…

certmgr-subject-label = Emitíu pa

certmgr-issuer-label = Emitíu por

certmgr-period-of-validity = Periodu de validez

certmgr-fingerprints = Buelgues

certmgr-cert-detail =
    .title = Detalle del certificáu
    .buttonlabelaccept = Zarrar
    .buttonaccesskeyaccept = Z

certmgr-cert-detail-commonname = Nome común (CN)

certmgr-cert-detail-org = Organización (O)

certmgr-cert-detail-orgunit = Unidá organizativa (OU)

certmgr-cert-detail-serial-number = Númberu de serie

certmgr-cert-detail-sha-256-fingerprint = Buelga SHA-256

certmgr-cert-detail-sha-1-fingerprint = Buelga SHA1

certmgr-edit-ca-cert =
    .title = Editar axustes d'enfotu del certificáu CA
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Editar axustes d'enfotu:

certmgr-edit-cert-trust-ssl =
    .label = Esti certificáu pue identificar sitios web.

certmgr-edit-cert-trust-email =
    .label = Esti certificáu pue identificar a los usuarios de corréu.

certmgr-delete-cert =
    .title = Desaniciar certificáu
    .style = width: 48em; height: 24em;

certmgr-cert-name =
    .label = Nome del certificáu

certmgr-cert-server =
    .label = Sirvidor

certmgr-override-lifetime =
    .label = Vida útil

certmgr-token-name =
    .label = Preséu de seguranza

certmgr-begins-on = Entama'l

certmgr-begins-label =
    .label = Entama'l

certmgr-expires-on = Caduca'l

certmgr-expires-label =
    .label = Caduca'l

certmgr-email =
    .label = Direición de corréu

certmgr-serial =
    .label = Númberu de serie

certmgr-view =
    .label = Ver…
    .accesskey = V

certmgr-edit =
    .label = Editar enfotu…
    .accesskey = E

certmgr-export =
    .label = Esportar…
    .accesskey = s

certmgr-delete =
    .label = Desaniciar…
    .accesskey = e

certmgr-delete-builtin =
    .label = Desaniciar o dexar d'enfotase…
    .accesskey = n

certmgr-backup =
    .label = Respaldar…
    .accesskey = R

certmgr-backup-all =
    .label = Respaldar too…
    .accesskey = c

certmgr-restore =
    .label = Importar…
    .accesskey = m

certmgr-details =
    .value = Campos del certificáu
    .accesskey = p

certmgr-fields =
    .value = Valor del campu
    .accesskey = V

certmgr-hierarchy =
    .value = Xerarquía de certificaos
    .accesskey = J

certmgr-add-exception =
    .label = Amestar esceición…
    .accesskey = e

exception-mgr =
    .title = Amestar esceición de seguranza

exception-mgr-extra-button =
    .label = Confirmar esceición de seguranza
    .accesskey = C

exception-mgr-supplemental-warning = Los bancos, tiendes y otros sitios públicos llexítimos nun van pidite facer esto.

exception-mgr-cert-location-url =
    .value = Direición:

exception-mgr-cert-location-download =
    .label = Consiguir certificáu
    .accesskey = C

exception-mgr-cert-status-view-cert =
    .label = Ver…
    .accesskey = V

exception-mgr-permanent =
    .label = Atroxar esta esceición de mou permanente
    .accesskey = t

pk11-bad-password = La contraseña introducida yera incorreuta.
pkcs12-decode-err = Fallu al descodificar el ficheru.  O nun ta en formatu PKCS #12, o ta toyíu, o la contraseña introducida ye incorreuta.
pkcs12-unknown-err-restore = Falló la recuperación del ficheru PKCS #12 por razones desconocíes.
pkcs12-unknown-err-backup = Falló la creación del ficheru de respaldu PKCS #12 por razones desconocíes.
pkcs12-unknown-err = La operación PKCS #12 falló por razones desconocíes.
pkcs12-info-no-smartcard-backup = Nun ye posible respaldar certificaos d'un preséu de seguranza per hardware talu como una tarxeta intelixente.
pkcs12-dup-data = El certificáu y la clave privada yá esisten nel preséu de seguranza.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Nome del ficheru pa respaldar
file-browse-pkcs12-spec = Ficheros PKCS12
choose-p12-restore-file-dialog = Ficheru de certificáu pa importar

## Import certificate(s) file dialog

file-browse-certificate-spec = Ficheros de certificaos
import-ca-certs-prompt = Esbilla'l ficheru que contién el certificáu(aos) CA pa importar
import-email-cert-prompt = Esbilla'l ficheru que contién el certificáu del corréu de daquién pa importar

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = El certificáu «{ $certName }» representa a una autoridá certificadora.

## For Deleting Certificates

delete-user-cert-title =
    .title = Desaniciar certificaos
delete-user-cert-confirm = ¿De xuru quies desaniciar estos certificaos?
delete-user-cert-impact = Si desanicies ún de los tos certificaos, nun vas poder usalu más pa identificate a tí mesmu.


delete-ssl-cert-title =
    .title = Desaniciar esceiciones de certificaos de sirvidor
delete-ssl-cert-confirm = ¿De xuru que quies desaniciar estes esceiciones de sirvidor?
delete-ssl-cert-impact = Si desanicies una esceición de sirvidor, vas restaurar les comprobaciones usuales de seguranza pa esi sirvidor y vas obligalu a usar un certificáu válidu.

delete-ca-cert-title =
    .title = Desaniciar o quitar l'enfotu a certificaos CA
delete-ca-cert-confirm = Solicitesti desanciar estos certificaos CA. Va quitase l'enfotu a los certificaos integraos que tien el mesmu efeutu. ¿De xuru que quies desaniciar o quitar l'enfotu?
delete-ca-cert-impact = Si desanicies o dexes d'enfotate nun certificáu d'autoridá certificadora (CA), esta aplicación nun va enfotase más en dengún certificáu emitíu por esa CA.


delete-email-cert-title =
    .title = Desaniciar certificaos de corréu electrónicu
delete-email-cert-confirm = ¿De xuru que quies desaniciar los certificaos de los correos electrónicos d'esta xente?
delete-email-cert-impact = Si desanicies el certificáu de corréu electrónicu d'una persona, nun vas ser más a unviar correos cifraos a esa persona.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Certificáu col númberu de serie: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Visor de certificaos: «{ $certName }»

not-present =
    .value = <Nun ye parte del certificáu>

# Cert verification
cert-verified = Esti certificáu verificóse pa los usos de darréu:

# Add usage
verify-ssl-client =
    .value = Certificáu SSL del veceru

verify-ssl-server =
    .value = Certificáu SSL del sirvidor

verify-ssl-ca =
    .value = Autoridá Certificadora (CA) SSL

verify-email-signer =
    .value = Certificáu del roblador del corréu electrónicu

verify-email-recip =
    .value = Certificáu del receutor del corréu electrónicu

# Cert verification
cert-not-verified-cert-revoked = Nun pudo verificase esti certificáu porque se revocó.
cert-not-verified-cert-expired = Nun pudo verificase esti certificáu porque caducó.
cert-not-verified-cert-not-trusted = Nun pudo verificase esti certificáu porque nun s'enfotó nelli.
cert-not-verified-issuer-not-trusted = Nun pudo verificase esti certificáu porque nun s'enfotó nel emisor.
cert-not-verified-issuer-unknown = Nun pudo verificase esti certificáu porque l'emisor ye desconocíu.
cert-not-verified-ca-invalid = Nun pudo verificase esti certificáu porque esti certificáu CA nun ye válidu.
cert-not-verified_algorithm-disabled = Nun pudo verificase esti certificáu porque se robló usando un algoritmu de robla que se desactivó porque esi algoritmu nun ye seguru.
cert-not-verified-unknown = Nun pudo verificase esti certificáu por razones desconocíes.

## Add Security Exception dialog

add-exception-branded-warning = Tas a piques d'anular cómo identifica { -brand-short-name } esti sitiu.
add-exception-invalid-header = Esti sitiu tenta d'identificase a sí mesmu con información non válida.
add-exception-domain-mismatch-short = Sitiu erróneu
add-exception-domain-mismatch-long = El certificáu pertenez a un sitiu diferente, lo que podría significar que daquién tea tentando de suplantar esti sitiu.
add-exception-expired-short = Información ensin anovar
add-exception-expired-long = Anguaño'l certificáu nun ye válidu. Podría ser que lu robaren o se perdiere, o incluso tar usándolu daquién pa suplantar esti sitiu.
add-exception-unverified-or-bad-signature-short = Identidá desconocida
add-exception-unverified-or-bad-signature-long = El certificáu nun ye d'enfotu porque nun lu verificó una autoridá d'enfotu usando una robla segura.
add-exception-valid-short = Certificáu válidu
add-exception-valid-long = Esti sitiu apurre una identificación válida y verificada.  Nun hai necesidá d'amestar una esceición.
add-exception-checking-short = Comprobando información
add-exception-checking-long = Tentando d'identificar esti sitiu…
add-exception-no-cert-short = Nun hai información disponible
add-exception-no-cert-long = Nun pue consiguise l'estáu d'identificación d'esti sitiu.

## Certificate export "Save as" and error dialogs

save-cert-as = Guardar certificáu en ficheru
cert-format-base64 = Certificáu X.509 (PEM)
cert-format-base64-chain = Certificáu X.509 con cadena (PEM)
cert-format-der = Certificáu X.509 (DER)
cert-format-pkcs7 = Certificáu X.509 (PKCS#7)
cert-format-pkcs7-chain = Certificáu X.509 con cadena (PKCX#7)
write-file-failure = Fallu de ficheru
