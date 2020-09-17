# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Aselkin

## Error messages

certificate-viewer-error-message = Ur nessaweḍ ara ad d-naf talɣut ɣef uselkin neɣ ma yexseṛ uselkin. Ma ulac aɣilif, ɛreḍ tikkelt-nniḍen.
certificate-viewer-error-title = Teḍra-d tuccḍa.

## Certificate information labels

certificate-viewer-algorithm = Alguritm
certificate-viewer-certificate-authority = Adabu n uselken
certificate-viewer-cipher-suite = Asartu n uwgelhen
certificate-viewer-common-name = ISem amagnu
certificate-viewer-email-address = Tansa imayl
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Aselkin i { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Tamurt n usekles
certificate-viewer-country = Tamurt
certificate-viewer-curve = Tamaknayt
certificate-viewer-distribution-point = Aggaz n uwziwez
certificate-viewer-dns-name = Isem DNS
certificate-viewer-ip-address = Tansa IP
certificate-viewer-other-name = Isem-nniḍen
certificate-viewer-exponent = Ameskan
certificate-viewer-id = Asulay
certificate-viewer-key-exchange-group = Agraw n usemmeskel n tsura
certificate-viewer-key-id = Asulay n tsarut
certificate-viewer-key-size = Teɣzi n tsarut
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Tamnaḍt n usekles
certificate-viewer-locality = Tamnaḍt
certificate-viewer-location = Adig
certificate-viewer-logid = Asulay n uɣmis
certificate-viewer-method = Tarrayt
certificate-viewer-modulus = Beṭṭu ɣef
certificate-viewer-name = Isem
certificate-viewer-not-after = Mačči ɣer zdat
certificate-viewer-not-before = Mačči send
certificate-viewer-organization = Tuddsa
certificate-viewer-organizational-unit = Tayunt tudsant
certificate-viewer-policy = Tasertit
certificate-viewer-protocol = Aneggaf
certificate-viewer-public-value = Azal azayaz
certificate-viewer-purposes = Iswiyen
certificate-viewer-qualifier = Aɣaray
certificate-viewer-qualifiers = Iɣarayen
certificate-viewer-required = Yettawsra
certificate-viewer-unsupported = &lt;ur yettwasefrak ara&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Agezdu/ Tamnaḍt n usekles
certificate-viewer-state-province = Aɣir/Tamnaḍt
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Uṭṭun n umazrar
certificate-viewer-signature-algorithm = Alguritm n usezmel
certificate-viewer-signature-scheme = Azenziɣ n usezmel
certificate-viewer-timestamp = Azemzakud
certificate-viewer-value = Azal
certificate-viewer-version = Lqem
certificate-viewer-business-category = Taggayt n uweẓlu
certificate-viewer-subject-name = Isem n uzwel
certificate-viewer-issuer-name = ISem n umazan
certificate-viewer-validity = Taneɣbalt
certificate-viewer-subject-alt-names = Ismawen-nniden n uzwel
certificate-viewer-public-key-info = Talɣult n tsarrut tazayezt
certificate-viewer-miscellaneous = Ayen nniḍen
certificate-viewer-fingerprints = Idsilen umḍinen
certificate-viewer-basic-constraints = Tamara tazadurt
certificate-viewer-key-usages = Aseqdec n tsarut
certificate-viewer-extended-key-usages = Aseqdec-nniḍen n tsarut
certificate-viewer-ocsp-stapling = Asenṭeḍ OCSP
certificate-viewer-subject-key-id = Asulay n tsarut n uzwel
certificate-viewer-authority-key-id = Asulay ID n tsarut n udabu
certificate-viewer-authority-info-aia = Talɣut ɣef udabu (AIA)
certificate-viewer-certificate-policies = Tisertiyin n uselkin
certificate-viewer-embedded-scts = SCT usliɣ
certificate-viewer-crl-endpoints = Agazen n tagara CRL

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Sader
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Ih
       *[false] Ala
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (cert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (chain)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Asiɣzef-agi yettwacreḍ d uzɣin, ayagi yebɣa ad d-yini dakken ilaq imsaɣen ad agin aselkin ma yella ur tegzin ara.
certificate-viewer-export = Kter
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Iselkinen-ik(im)
certificate-viewer-tab-people = Medden
certificate-viewer-tab-servers = Iqeddacen
certificate-viewer-tab-ca = Iduba
certificate-viewer-tab-unkonwn = Arussin
