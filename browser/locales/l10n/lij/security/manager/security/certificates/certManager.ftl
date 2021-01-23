# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Gestô di certificati

certmgr-tab-mine =
    .label = I teu Certificati

certmgr-tab-people =
    .label = Personn-e

certmgr-tab-servers =
    .label = Server

certmgr-tab-ca =
    .label = Aotoritæ

certmgr-mine = Ti gh'é sti certificati da ste organizaçioin che te identifican
certmgr-people = Ti gh'é sti certificati che identifican ste personn-e
certmgr-servers = Ti gh'é sti certificati che identifican sti server
certmgr-ca = Ti gh'é sti certificati inti schedai che identifican ste aotoritæ

certmgr-detail-general-tab-title =
    .label = Generale
    .accesskey = G

certmgr-detail-pretty-print-tab-title =
    .label = Detalli
    .accesskey = D

certmgr-pending-label =
    .value = Verifico o certificato…

certmgr-subject-label = Rilasciòu a

certmgr-issuer-label = Publicou da

certmgr-period-of-validity = Periodo de validitæ

certmgr-fingerprints = Inpronte digitali

certmgr-cert-detail =
    .title = Detalli do certificato
    .buttonlabelaccept = Særa
    .buttonaccesskeyaccept = S

certmgr-cert-detail-commonname = Nomme Comune (CN)

certmgr-cert-detail-org = Organizaçion (O)

certmgr-cert-detail-orgunit = Unitæ de Organizaçion (OU)

certmgr-cert-detail-serial-number = Numero de serie

certmgr-cert-detail-sha-256-fingerprint = Inpronta digitale SHA-256

certmgr-cert-detail-sha-1-fingerprint = Inpronta digitale SHA1

certmgr-edit-ca-cert =
    .title = Cangia e inpostaçioin de fiduccia do certificato CA
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Cangia e inpostaçioin de fiduccia:

certmgr-edit-cert-trust-ssl =
    .label = Sto certificato o peu identificâ sti sciti.

certmgr-edit-cert-trust-email =
    .label = Sto certificato o peu identificâ email.

certmgr-delete-cert =
    .title = Scancella certificato
    .style = width: 48em; height: 24em;

certmgr-cert-name =
    .label = Nomme do certificato

certmgr-cert-server =
    .label = Server

certmgr-override-lifetime =
    .label = Durata de vitta

certmgr-token-name =
    .label = Aparato de seguessa

certmgr-begins-on = L'iniçia o

certmgr-begins-label =
    .label = L'iniçia o

certmgr-expires-on = Scazze o

certmgr-expires-label =
    .label = Scazze o

certmgr-email =
    .label = Indirisso e-mail

certmgr-serial =
    .label = Numero de serie

certmgr-view =
    .label = Fanni vedde…
    .accesskey = v

certmgr-edit =
    .label = Cangia fiduccia…
    .accesskey = M

certmgr-export =
    .label = Espòrta…
    .accesskey = E

certmgr-delete =
    .label = Scancella…
    .accesskey = S

certmgr-delete-builtin =
    .label = Scancella ò leva a fiduccia…
    .accesskey = d

certmgr-backup =
    .label = Fanni 'na còpia de seguessa…
    .accesskey = c

certmgr-backup-all =
    .label = Fanni 'na còpia de seguessa de tutto…
    .accesskey = F

certmgr-restore =
    .label = Inpòrta…
    .accesskey = I

certmgr-details =
    .value = Canpi do certificato
    .accesskey = f

certmgr-fields =
    .value = Valô do canpo
    .accesskey = V

certmgr-hierarchy =
    .value = Gerarchia di certificati
    .accesskey = t

certmgr-add-exception =
    .label = Azonzi 'na eceçion…
    .accesskey = A

exception-mgr =
    .title = Azonzi eceçion de seguessa

exception-mgr-extra-button =
    .label = Conferma eceçion de seguessa
    .accesskey = C

exception-mgr-supplemental-warning = Legitima banche, negòççi, e atri sciti publici e no te saiâ ciù domandou de fâ cosci.

exception-mgr-cert-location-url =
    .value = Indirisso

exception-mgr-cert-location-download =
    .label = Danni o certificato
    .accesskey = G

exception-mgr-cert-status-view-cert =
    .label = Fanni vedde…
    .accesskey = V

exception-mgr-permanent =
    .label = Tegni sarvâ sta eceçion de longo
    .accesskey = T

pk11-bad-password = A paròlla segreta a l'é sbalia.
pkcs12-decode-err = Inposcibile decodificâ l'archivio. Ò o no l'é into formato PKCS #12, ò o l'é corotto, ò a paròlla d'ordine a l'é scoretta.
pkcs12-unknown-err-restore = Inposcibile arecuviâ l'archivio PKCS #12 pe de raxoin sconosciue.
pkcs12-unknown-err-backup = Inposcibile creâ o schedaio de backup do PKCS #12 pe de raxoin sconosciue.
pkcs12-unknown-err = A procedua do PKCS #12 a l'é falia pe de raxoin sconosciue.
pkcs12-info-no-smartcard-backup = Inposcibile agiornâ i certificati da un apægio hardware de seguessa comme 'na smart card.
pkcs12-dup-data = O certificato e a ciave privâ existan za inte l'apægio de seguessa.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Nomme do schedaio da archiviâ
file-browse-pkcs12-spec = Schedaio PKCS12
choose-p12-restore-file-dialog = Schedaio de certificato da inportâ

## Import certificate(s) file dialog

file-browse-certificate-spec = Schedai de certificato
import-ca-certs-prompt = Seleçionn-a o schedaio ch'o gh'à i certificati CA da inportâ
import-email-cert-prompt = Seleçionn-a o schedaio ch'o gh'à o certificato do destinataio de posta da inportâ

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = O certificato "{ $certName }" o rapresenta 'na aotoritæ de certificaçion.

## For Deleting Certificates

delete-user-cert-title =
    .title = Scancella i teu certificati
delete-user-cert-confirm = T'ê seguo de scancelâ sti certificati?
delete-user-cert-impact = Se ti ti scancelli un di teu certificati, ti no poriæ ciù deuvialo pe identificate.


delete-ssl-cert-title =
    .title = Scancella e eceçioin di certificati di server
delete-ssl-cert-confirm = T'ê seguo de scancelâ i teu mòdoli de seguessa?
delete-ssl-cert-impact = Se ti ti scancelli sta eceçion do server, ghe saian i mæximi contròlli de seguessa pe sto server o quæ o doviâ mostrâ 'n certificato bon.

delete-ca-cert-title =
    .title = Scancella ò leva a fiduccia a-i certificati CA
delete-ca-cert-confirm = T'æ domandou de scancelâ sti cerficati CA. Mia che saiâ scancelâ anche a fiduccia di cerficati relativi a questa CA. T'ê seguo de scancelâ ò levâ a fiduccia?
delete-ca-cert-impact = Se ti ti scancelli o ti levi a fiduccia a ina aotoritæ de certificaçion (CA), st'aplicaçion a no poriâ ciù fiase di certificati fæti da sta CA.


delete-email-cert-title =
    .title = Scancella certificati email
delete-email-cert-confirm = T'ê seguo de scancelâ sti certificati de personn-e?
delete-email-cert-impact = Se ti ti scancelli un certificato email, ti no saiæ ciù in graddo de spedî 'na email criptâ a sta personn-a.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Cartificato con numero seriale: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Vizolizatô de certificati: “{ $certName }”

not-present =
    .value = <No l'é parte do certificato>

# Cert verification
cert-verified = Sto certificato o l'é stæto verificou pe ste raxoin:

# Add usage
verify-ssl-client =
    .value = Certificato SSL do Client

verify-ssl-server =
    .value = Certificato SSL do Server

verify-ssl-ca =
    .value = Aotoritæ de certificaçion SSL

verify-email-signer =
    .value = Certificato do mitente e-mail

verify-email-recip =
    .value = Certificato de destin e-mail

# Cert verification
cert-not-verified-cert-revoked = No pòsso verificâ sto certificato perché o l'é stæto revocou.
cert-not-verified-cert-expired = No pòsso verificâ sto certificato perché o scazze.
cert-not-verified-cert-not-trusted = No pòsso verificâ sto certificato perché o no l'é fidou.
cert-not-verified-issuer-not-trusted = No pòsso verificâ sto certificato perché l'à fæto un aotô no fidou.
cert-not-verified-issuer-unknown = No pòsso verificâ sto certificato perché n'ou sò chi o l'à fæto.
cert-not-verified-ca-invalid = No pòsso verificâ sto certificato CA perché o no l'é valido.
cert-not-verified_algorithm-disabled = Inposcibile verificâ sto certificato perché o l'é firmou co-in algoritmo de firma dizativou perché no seguo.
cert-not-verified-unknown = No pòsso verificâ sto certificato e sò asæ perche.

## Add Security Exception dialog

add-exception-branded-warning = T'ê apreuvo a cangiâ o mòddo ch'o l'à { -brand-short-name } de identificâ sto scito.
add-exception-invalid-header = Sto scito o preuva a identificase con dæti no validi.
add-exception-domain-mismatch-short = Scito sbagliou
add-exception-domain-mismatch-long = O certificato o l'é de 'n'atro scito, o porieva ese 'n tentativo de sostitoise a-o scito òriginale.
add-exception-expired-short = Informaçion vegia
add-exception-expired-long = O certificato o no l'é ciù valido. L'é poscibile ch'o segge stæto arobou ò perduo, e o porieiva ese adeuviou into tentativo de sostitoise a-o scito òriginale.
add-exception-unverified-or-bad-signature-short = Identitæ no conosciua
add-exception-unverified-or-bad-signature-long = O certificato o no l'é afidabile perché no l'é poscibile verificâ ch'o segge emesso da 'na Autoritæ riconosciua co-ina firma segua.
add-exception-valid-short = Certificato valido
add-exception-valid-long = O scito o gh'à 'na identificaçion valida e verificâ, coscì no gh'é bezeugno de azonze 'na eceçion.
add-exception-checking-short = contròllo e informaçioin
add-exception-checking-long = Tentativo d'identificaçion do scito…
add-exception-no-cert-short = No gh'é nisciunn-a informaçion
add-exception-no-cert-long = Inposcibile pigiâ o stæto de identificaçion de sto scito.

## Certificate export "Save as" and error dialogs

save-cert-as = Sarva o Certificato in sce schedaio
cert-format-base64 = Certificato X.509 (PEM)
cert-format-base64-chain = Certificato X.509 con cadenn-a (PEM)
cert-format-der = Certificato X.509 (DER)
cert-format-pkcs7 = Certificato X.509 (PKCS#7)
cert-format-pkcs7-chain = Certificato X.509 con cadenn-a (PKCS#7)
write-file-failure = Erô do schedaio
