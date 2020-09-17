# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Gestionari de certificats

certmgr-tab-mine =
    .label = Vòstres certificats

certmgr-tab-remembered =
    .label = Decisions d’autentificacion

certmgr-tab-people =
    .label = Personas

certmgr-tab-servers =
    .label = Servidors

certmgr-tab-ca =
    .label = Autoritats

certmgr-mine = De certificats d'aquestas organizacions vos identifican
certmgr-remembered = Aquestes certificats servisson per vos identificar suls sites Web
certmgr-people = De certificats d'aqueste fichièr identifican aqueles personas
certmgr-servers = De certificats d'aqueste fichièr identifican aqueles servidors
certmgr-ca = De certificats d'aqueste fichièr identifican aquelas autoritats de certificat

certmgr-detail-general-tab-title =
    .label = General
    .accesskey = G

certmgr-detail-pretty-print-tab-title =
    .label = Detalhs
    .accesskey = D

certmgr-pending-label =
    .value = Verificacion dels certificats en cors…

certmgr-subject-label = Emes cap a

certmgr-issuer-label = Emes per

certmgr-period-of-validity = Periòde de Validitat

certmgr-fingerprints = Emprentas numericas

certmgr-cert-detail =
    .title = Detalhs del certificat
    .buttonlabelaccept = Tampar
    .buttonaccesskeyaccept = T

certmgr-cert-detail-commonname = Nom comun (CN)

certmgr-cert-detail-org = Organizacion (O)

certmgr-cert-detail-orgunit = Unitat d'organizacion (OU)

certmgr-cert-detail-serial-number = Numèro de seria

certmgr-cert-detail-sha-256-fingerprint = Emprenta numerica SHA-256

certmgr-cert-detail-sha-1-fingerprint = Emprenta numerica SHA1

certmgr-edit-ca-cert =
    .title = Edicion dels paramètres de fisança de l'autoritat de certificacion (CA)
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Modificar los paramètres de fisança :

certmgr-edit-cert-trust-ssl =
    .label = Aqueste certificat pòt identificar de sites Web.

certmgr-edit-cert-trust-email =
    .label = Aqueste certificat pòt identificar d'utilizaires de corrièr electronic.

certmgr-delete-cert =
    .title = Suprimir un certificat
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = Òste

certmgr-cert-name =
    .label = Nom del certificat

certmgr-cert-server =
    .label = Servidor

certmgr-override-lifetime =
    .label = Durada de vida

certmgr-token-name =
    .label = Periferic de seguretat

certmgr-begins-on = Comença lo

certmgr-begins-label =
    .label = Comença lo

certmgr-expires-on = Expira lo

certmgr-expires-label =
    .label = Expira lo

certmgr-email =
    .label = Adreça electronica

certmgr-serial =
    .label = Numèro de seria

certmgr-view =
    .label = Veire…
    .accesskey = V

certmgr-edit =
    .label = Modificar la fisança…
    .accesskey = M

certmgr-export =
    .label = Exportar…
    .accesskey = x

certmgr-delete =
    .label = Suprimir…
    .accesskey = S

certmgr-delete-builtin =
    .label = Suprimir o far pas mai fisança…
    .accesskey = S

certmgr-backup =
    .label = Salvagardar…
    .accesskey = S

certmgr-backup-all =
    .label = Salvagardar tot…
    .accesskey = t

certmgr-restore =
    .label = Importar…
    .accesskey = I

certmgr-details =
    .value = Camps del certificat
    .accesskey = C

certmgr-fields =
    .value = Valor del camp
    .accesskey = V

certmgr-hierarchy =
    .value = Ierarquia dels certificats
    .accesskey = H

certmgr-add-exception =
    .label = Apondre una excepcion…
    .accesskey = x

exception-mgr =
    .title = Apondre una excepcion de seguretat

exception-mgr-extra-button =
    .label = Confirmar l'excepcion de seguretat
    .accesskey = C

exception-mgr-supplemental-warning = Las bancas, magazins e autres sites Web publics legitims vos demandaràn pas de far aquò.

exception-mgr-cert-location-url =
    .value = Emplaçament :

exception-mgr-cert-location-download =
    .label = Obténer lo certificat
    .accesskey = O

exception-mgr-cert-status-view-cert =
    .label = Veire…
    .accesskey = V

exception-mgr-permanent =
    .label = Conservar aquesta excepcion d'un biais permanent
    .accesskey = s

pk11-bad-password = Lo senhal PK11 es incorrècte.
pkcs12-decode-err = Fracàs de desencodatge del fichièr. Siá es pas al format PKCS#12, siá es corromput, o lo senhal es incorrècte.
pkcs12-unknown-err-restore = Fracàs de recuperacion del fichièr PKCS#12 per una rason desconeguda.
pkcs12-unknown-err-backup = Fracàs del salvament del fichièr PKCS#12 per una rason desconeguda.
pkcs12-unknown-err = L'operacion PKCS #12 a fracassat per de rasons desconegudas.
pkcs12-info-no-smartcard-backup = Es impossible de salvar los certificats d'un periferic material de seguretat tal coma una carta intelligenta.
pkcs12-dup-data = Lo certificat e la clau privada existisson ja sul periferic de seguretat.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Nom de fichièr de salvagardar
file-browse-pkcs12-spec = Fichièrs PKCS12
choose-p12-restore-file-dialog = Fichièr de certificat d'importar

## Import certificate(s) file dialog

file-browse-certificate-spec = Fichièrs de certificat
import-ca-certs-prompt = Seleccionar un fichièr que conten un (o de) certificat(s) d'AC d'importar
import-email-cert-prompt = Seleccionar un fichièr que conten un certificat de corrièr d'importar

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Lo certificat « { $certName } » representa una autoritat de certificacion.

## For Deleting Certificates

delete-user-cert-title =
    .title = Supression de certificats
delete-user-cert-confirm = Volètz vertadièrament suprimir aquestes certificats ?
delete-user-cert-impact = Se suprimissètz un de vòstres certificats, o poiretz pas mai utilizar per vos identificar vos-meteis.


delete-ssl-cert-title =
    .title = Supression de las excepcions de certificats de servidor
delete-ssl-cert-confirm = Volètz vertadièrament suprimir aquestas exceptions de servidors ?
delete-ssl-cert-impact = Se suprimissètz una excepcion de servidor, restablissètz las verificacions de seguretat usualas per aqueste servidor e demandatz qu'utilize un certificat valid.

delete-ca-cert-title =
    .title = Suprimir o far pas mai fisança a de certificats d'AC
delete-ca-cert-confirm = Avètz demandat de suprimir aqueles certificats d'AC. Se s'agís de certificats integrats, cap de fisança lor serà pas mai acordada, aquò's a lo meteis efèit. Volètz vertadièrament suprimir aqueles certificats o alara lor far pas mai fisança ?
delete-ca-cert-impact = Se suprimissètz un certificat d'autoritat de certificacion (AC), vòstra aplicacion ne farà pas mai fisança als certificats eissits d'aquesta AC.


delete-email-cert-title =
    .title = Supression de certificats de corrièr
delete-email-cert-confirm = Volètz vertadièrament suprimir los certificats de corrièr d'aquestas personas ?
delete-email-cert-impact = Se suprimissètz lo certificat de corrièr d'una persona, poiretz pas mai mandar de corrièr chifrat a la persona que li es associada

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Certificat amb nombre de seria : { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Visualizaira de cerficat : “{ $certName }”

not-present =
    .value = <Fa pas partida del certificat>

# Cert verification
cert-verified = Aqueste certificat es estat verificat per las utilizacions seguentas :

# Add usage
verify-ssl-client =
    .value = Certificat de client SSL

verify-ssl-server =
    .value = Certificat de servidor SSL

verify-ssl-ca =
    .value = Autoritat de certificacion SSL

verify-email-signer =
    .value = Certificat de signatura de corrièl

verify-email-recip =
    .value = Certificat de recepcion de corrièr

# Cert verification
cert-not-verified-cert-revoked = Impossible de verificar aqueste certificat perque es estat revocat.
cert-not-verified-cert-expired = Impossible de verificar aqueste certificat perque a expirat.
cert-not-verified-cert-not-trusted = Impossible de verificar aqueste certificat perque es pas digne de fisança.
cert-not-verified-issuer-not-trusted = Impossible de verificar aqueste certificat perque son emeteire es pas digne de fisança.
cert-not-verified-issuer-unknown = Impossible de verificar aqueste certificat perque l'emeteire es desconegut.
cert-not-verified-ca-invalid = Impossible de verificar aqueste certificat perque lo certificat d'AC es pas valid.
cert-not-verified_algorithm-disabled = Impossible de verificar aqueste certificat perque es estat signat amb l'ajuda d'un algoritme de signatura qu'es estat desactivat perque aqueste algoritme es pas securizat.
cert-not-verified-unknown = Impossible de verificar aqueste certificat per una rason desconeguda.

# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Enviar pas de certificat client

## Add Security Exception dialog

add-exception-branded-warning = Sètz a mand de passar enlà lo biais que { -brand-short-name } identifica aqueste site.
add-exception-invalid-header = Aqueste site ensaja de s'identificar ele-meteis amb d'entresenhas invalidas.
add-exception-domain-mismatch-short = Site marrit
add-exception-domain-mismatch-long = Lo certificat aparten a un site diferent, aquò vòl dire que qualqu'un ensaja de raubar l'identitat d'aqueste site.
add-exception-expired-short = Entresenhas obsoletas
add-exception-expired-long = Lo certificat es pas mai valid. Benlèu es estat raubat o perdut, e qualqu'un utilize per raubar l'identitat d'aqueste site.
add-exception-unverified-or-bad-signature-short = Identitat desconeguda
add-exception-unverified-or-bad-signature-long = Lo certificat es pas segur perque es pas estat verificat per una autoritat reconeguda.
add-exception-valid-short = Certificat valid
add-exception-valid-long = Aqueste site provesís una identificacion valida e certificada. Es pas necessari d'apondre una excepcion.
add-exception-checking-short = Verificacion de las entresenhas
add-exception-checking-long = Temptativa d'identificacion del site…
add-exception-no-cert-short = Pas d'entresenhas disponiblas
add-exception-no-cert-long = Impossible d'obténer l'estat d'identificacion pel site donat.

## Certificate export "Save as" and error dialogs

save-cert-as = Enregistrar lo certificat dins un fichièr
cert-format-base64 = Certificat X.509 (PEM)
cert-format-base64-chain = Certificat X.509 amb cadena (PEM)
cert-format-der = Certificat X.509 (DER)
cert-format-pkcs7 = Certificat X.509 (PKCS#7)
cert-format-pkcs7-chain = Certificat X.509 amb cadena (PKCS#7)
write-file-failure = Error de fichièr
