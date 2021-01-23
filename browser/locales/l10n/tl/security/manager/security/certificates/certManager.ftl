# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Certificate Manager

certmgr-tab-mine =
    .label = Mga Certificate Mo

certmgr-tab-people =
    .label = Mga Tao

certmgr-tab-servers =
    .label = Mga Server

certmgr-tab-ca =
    .label = Mga AuthorityMga Awtoridad

certmgr-mine = May mga certificate ka mula sa mga organisasyong ito na nakakakilala sa iyo
certmgr-people = May mga certificate kang nakatago na kumikilala sa mga taong ito
certmgr-servers = May mga certificate kang nakatago na kumikilala sa mga server na ito
certmgr-ca = May mga certificate ka na nakatago na kumikilala sa mga certificate authority na ito

certmgr-detail-general-tab-title =
    .label = Pangkalahatan
    .accesskey = P

certmgr-detail-pretty-print-tab-title =
    .label = Mga Detalye
    .accesskey = D

certmgr-pending-label =
    .value = Kasalukuyan pang beneberipika ang certificate...

certmgr-subject-label = Ibinigay Kay

certmgr-issuer-label = Ibinigay Ni

certmgr-period-of-validity = Panahon ng Bisa

certmgr-fingerprints = Mga Fingerprint

certmgr-cert-detail =
    .title = Detalye ng Sertipiko
    .buttonlabelaccept = Isara
    .buttonaccesskeyaccept = I

certmgr-cert-detail-commonname = Common Name (CN)

certmgr-cert-detail-org = Organisasyon (O)

certmgr-cert-detail-orgunit = Organizational Unit (OU)

certmgr-cert-detail-serial-number = Serial Number

certmgr-cert-detail-sha-256-fingerprint = SHA-256 Fingerprint

certmgr-cert-detail-sha-1-fingerprint = SHA1 Fingerprint

certmgr-edit-ca-cert =
    .title = i-Edit ang CA certificate trust settings
    .style = width: 48em;

certmgr-edit-cert-edit-trust = i-Edit ang trust settings:

certmgr-edit-cert-trust-ssl =
    .label = This certificate can identify web sites.

certmgr-edit-cert-trust-email =
    .label = Ang sertipiko na ito ay maaaring makilala ang mga gumagamit ng mail.

certmgr-delete-cert =
    .title = Burahin ang Sertipiko
    .style = width: 48em; height: 24em;

certmgr-cert-name =
    .label = Pangalan ng Sertipiko

certmgr-cert-server =
    .label = Server

certmgr-override-lifetime =
    .label = Haba ng buhay

certmgr-token-name =
    .label = Security Device

certmgr-begins-on = Nagsisimula Sa

certmgr-begins-label =
    .label = Nagsisimula Sa

certmgr-expires-on = Mawawalan ng Bisa Sa

certmgr-expires-label =
    .label = Mawawalan ng Bisa Sa

certmgr-email =
    .label = E-Mail Address

certmgr-serial =
    .label = Serial Number

certmgr-view =
    .label = Tingnan
    .accesskey = T

certmgr-edit =
    .label = Baguhin ang Trust...
    .accesskey = E

certmgr-export =
    .label = I-export...
    .accesskey = x

certmgr-delete =
    .label = Burahin…
    .accesskey = B

certmgr-delete-builtin =
    .label = Burahin o I-distrust...
    .accesskey = D

certmgr-backup =
    .label = Backup…
    .accesskey = B

certmgr-backup-all =
    .label = I-backup ang Lahat…
    .accesskey = k

certmgr-restore =
    .label = I-import...
    .accesskey = m

certmgr-details =
    .value = Mga Patlang ng Certificate
    .accesskey = F

certmgr-fields =
    .value = Halaga ng Patlang
    .accesskey = V

certmgr-hierarchy =
    .value = Certificate Hierarchy
    .accesskey = H

certmgr-add-exception =
    .label = Magdagdag ng Exception…
    .accesskey = x

exception-mgr =
    .title = Magdagdag ng Security Exception

exception-mgr-extra-button =
    .label = I-Confirm ang Security Exception
    .accesskey = C

exception-mgr-supplemental-warning = Hindi hihilingin ng mga lehitimong bangko, tindahan, at iba pang mga site na gawin mo ito.

exception-mgr-cert-location-url =
    .value = Lokasyon:

exception-mgr-cert-location-download =
    .label = Kuhanin ang Certificate
    .accesskey = G

exception-mgr-cert-status-view-cert =
    .label = Tingnan…
    .accesskey = v

exception-mgr-permanent =
    .label = Permanenteng i-store ang exception na ito
    .accesskey = P

pk11-bad-password = Hindi tama ang pinasok mong password.
pkcs12-decode-err = Bigong i-decode ang file. Maaaring wala ito sa PKCS #12 format, nasira, o mali ang password na naipasok.
pkcs12-unknown-err-restore = Bigong maibalik ang PKCS #12 file sa mga di-kilalang dahilan.
pkcs12-unknown-err-backup = Bigong makagawa ng PKCS #12 backup file sa mga di-kilalang dahilan.
pkcs12-unknown-err = Bigo ang operasyon ng PKCS #12 sa di-kilalang dahilan.
pkcs12-info-no-smartcard-backup = Hindi posibleng i-back up ang mga certificate mula sa hardware security device gaya ng smart card.
pkcs12-dup-data = Mayroon nang certificate at private key sa security device.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = File Name ng Backup
file-browse-pkcs12-spec = Mga PKCS12 File
choose-p12-restore-file-dialog = Certificate File na Iiimport

## Import certificate(s) file dialog

file-browse-certificate-spec = Mga Certificate File
import-ca-certs-prompt = Piliin ang File na naglalaman ng CA certificate (s) upang i-import
import-email-cert-prompt = Pumili ng file na may nglalaman na Email certificate ng isang tao upang i-import

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Ang certificate na “{ $certName }” ay isang Certificate Authority.

## For Deleting Certificates

delete-user-cert-title =
    .title = Burahin ang iyong mga Sertipiko
delete-user-cert-confirm = Nakasisiguro ka bang nais mong burahin ang mga sertipikong ito?
delete-user-cert-impact = Kung tatangalin mo ang isa sa iyong mga sariling sertipiko, maaari mong hindi na magagamit ito upang kilalanin ang iyong sarili.


delete-ssl-cert-title =
    .title = Burahin ang mga Server Certificate Exception
delete-ssl-cert-confirm = Sigurado ka bang gusto mong burahin ang mga server exception na ito?
delete-ssl-cert-impact = Kung ibubura mo ang serverver exception, ibalik mo ang mga karaniwang na pagsusuri ng seguridad para sa server at kailangan ito ay gumagamit ng isang wastong sertipiko.

delete-ca-cert-title =
    .title = Burahin o Tigilang Pagkatiwalaan ang mga CA Certificate
delete-ca-cert-confirm = Hiningi mong burahin ang mga CA certificate na ito. Para sa mga built-in certificate lahat ay tatanggalin, na kapareho lang ng epekto. Sigurado ka bang gusto mong burahin ito o tigilang pagkatiwalaan?
delete-ca-cert-impact = Kapag binura mo o tinigilang pagkatiwalaan ang isang certificate authority (CA) certificate, hindi na magtitiwala ang application na ito sa kahit anong certificate na binigay ng CA na iyon.


delete-email-cert-title =
    .title = Burahin ang E-Mail Certificates
delete-email-cert-confirm = Nakasisiguro ka bang nais mong burahin ang mga sertipiko sa email ng mga taong ito?
delete-email-cert-impact = Kung tatangalin mo ang e-mail certificate ng isang tao, hindi mo na magagawang magpadala ng naka-encrypt na e-mail sa taong iyon.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Certificate na may serial number: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Certificate Viewer: ”{ $certName }”

not-present =
    .value = <Not Part Of Certificate>

# Cert verification
cert-verified = Ang sertipikong ito ay nasiyasat para sa mga sumusunod na gamit:

# Add usage
verify-ssl-client =
    .value = SSL Client Certificate

verify-ssl-server =
    .value = SSL Server Certificate

verify-ssl-ca =
    .value = SSL Certificate Authority

verify-email-signer =
    .value = Email Signer Certificate

verify-email-recip =
    .value = Email Recipient Certificate

# Cert verification
cert-not-verified-cert-revoked = Hindi masiyasat ang sertipikong ito dahil napawalang-bisa ito.
cert-not-verified-cert-expired = Hindi masiyasat ang sertipikong ito dahil ito ay lumipas na.
cert-not-verified-cert-not-trusted = Hindi masiyasat ang sertipikong ito dahil hindi ito mapagkakatiwalaan.
cert-not-verified-issuer-not-trusted = Hindi ma-verify itong sertipiko dahil ang issuer ay hindi mapagkakatiwalaan.
cert-not-verified-issuer-unknown = Hindi ma-verify itong sertipiko dahil ang issuer ay hindi kilala.
cert-not-verified-ca-invalid = Hindi ma-verify itong sertipiko dahil ang CA certificate ay hindi wasto.
cert-not-verified_algorithm-disabled = Hindi ma-verify ang certificate na ito dahil ito ay signed gamit ang signature algorithm na naka-disable dahil hindi ito ligtas gamitin.
cert-not-verified-unknown = Hindi ma-verify ang sertipiko na ito para sa hindi kilalang dahilan.

## Add Security Exception dialog

add-exception-branded-warning = Mao-override mo rito kung paano kinikilala ng { -brand-short-name } ang site na ito.
add-exception-invalid-header = Ang site na ito ay nagtatangkang makilala ang sarili nito na may di-wastong impormasyon.
add-exception-domain-mismatch-short = Maling Site
add-exception-domain-mismatch-long = Ang sertipiko ay kabilang sa isang iba't ibang mga site, na maaaring mangahulugan na ang isang tao ay nagsisikap na magpanggap sa site na ito.
add-exception-expired-short = Outdated na impormasyon
add-exception-expired-long = Kasalukuyang hindi wasto ang sertipiko. Maaaring ito ay ninakaw o nawala, at maaaring magamit ng isang tao upang ipagmalaki ang site na ito.
add-exception-unverified-or-bad-signature-short = Hindi Kilalang Identity
add-exception-unverified-or-bad-signature-long = Ang sertipiko ay hindi pinagkakatiwalaan dahil hindi ito napatunayan na ibinigay ng isang pinagkakatiwalaang awtoridad gamit ang isang secure na pirma.
add-exception-valid-short = Valid Certificate
add-exception-valid-long = Ang site na ito ay nagbibigay ng wasto, verify ang pagkakakilanlan. Hindi na kailangang magdagdag ng isang exception.
add-exception-checking-short = Sinusuri ang Impormasyon
add-exception-checking-long = Tinatangkang kilalanin ang site na ito...
add-exception-no-cert-short = Walang available na impormasyon
add-exception-no-cert-long = Hindi nakakuha ng katayuang pagkakakilanlan para sa site na ito.

## Certificate export "Save as" and error dialogs

save-cert-as = I-save ang sertipiko sa File
cert-format-base64 = X.509 Certificate (PEM)
cert-format-base64-chain = X.509 Certificate na may chain (PEM)
cert-format-der = X.509 Certificate (DER)
cert-format-pkcs7 = X.509 Certificate (PKCS#7)
cert-format-pkcs7-chain = X.509 Certificate na may chain (PKCS#7)
write-file-failure = Ang File ay mali
