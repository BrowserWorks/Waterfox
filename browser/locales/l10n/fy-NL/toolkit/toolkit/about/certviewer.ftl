# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Sertifikaat

## Error messages

certificate-viewer-error-message = Wy koenen de sertifikaatynformaasje net fine, of it sertifikaat is skansearre. Probearje it opnij.
certificate-viewer-error-title = Der is wat misgien.

## Certificate information labels

certificate-viewer-algorithm = Algoritme
certificate-viewer-certificate-authority = Sertifikaatautoriteit
certificate-viewer-cipher-suite = Kodearringssuite
certificate-viewer-common-name = Algemiene namme
certificate-viewer-email-address = E-mailadres
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Sertifikaat foar { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Lân fan fêstiging
certificate-viewer-country = Lân
certificate-viewer-curve = Kromme
certificate-viewer-distribution-point = Distribúsjepunt
certificate-viewer-dns-name = DNS-namme
certificate-viewer-ip-address = IP-adres
certificate-viewer-other-name = Oare namme
certificate-viewer-exponent = Eksponint
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Kaaiútwikselingsgroep
certificate-viewer-key-id = Kaai-ID
certificate-viewer-key-size = Kaaigrutte
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Fêstigingsplak
certificate-viewer-locality = Plak
certificate-viewer-location = Lokaasje
certificate-viewer-logid = Log-ID
certificate-viewer-method = Metoade
certificate-viewer-modulus = Modulus
certificate-viewer-name = Namme
certificate-viewer-not-after = Net nei
certificate-viewer-not-before = Net foar
certificate-viewer-organization = Organisaasje
certificate-viewer-organizational-unit = Organisatoaryske ienheid
certificate-viewer-policy = Belied
certificate-viewer-protocol = Protokol
certificate-viewer-public-value = Publike wearde
certificate-viewer-purposes = Doelen
certificate-viewer-qualifier = Kwalifikaasje
certificate-viewer-qualifiers = Kwalifikaasjes
certificate-viewer-required = Fereaske
certificate-viewer-unsupported = &lt;net stipe&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Steat/provinsje fan fêstiging
certificate-viewer-state-province = Steat/provinsje
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Searjenûmer
certificate-viewer-signature-algorithm = Hantekeningsalgoritme
certificate-viewer-signature-scheme = Hantekeningskema
certificate-viewer-timestamp = Tiidstimpel
certificate-viewer-value = Wearde
certificate-viewer-version = Ferzje
certificate-viewer-business-category = Bedriuwskategory
certificate-viewer-subject-name = Underwerpnamme
certificate-viewer-issuer-name = Namme útjouwer
certificate-viewer-validity = Jildichheid
certificate-viewer-subject-alt-names = Alternative nammen hâlder
certificate-viewer-public-key-info = Ynformaasje publike kaai
certificate-viewer-miscellaneous = Diversken
certificate-viewer-fingerprints = Fingerôfdrukken
certificate-viewer-basic-constraints = Basisbeheiningen
certificate-viewer-key-usages = Wichtichste brûksmooglikheden
certificate-viewer-extended-key-usages = Wiidweidige brûksmooglikheden
certificate-viewer-ocsp-stapling = OCSP-stapling
certificate-viewer-subject-key-id = Kaai-ID hâlder
certificate-viewer-authority-key-id = Kaai-ID autoriteit
certificate-viewer-authority-info-aia = Autoriteit-ynfo (AIA)
certificate-viewer-certificate-policies = Sertifikaatbelied
certificate-viewer-embedded-scts = Ynbedde SCT’s
certificate-viewer-crl-endpoints = CRL-einpunten

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Downloade
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Ja
       *[false] Nee
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (sert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (keten)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Dizze útwreiding is as krityk markearre, wat betsjut dat clients it sertifikaat wegerje moatten as se it net begripe.
certificate-viewer-export = Eksportearje
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Jo sertifikaten
certificate-viewer-tab-people = Minsken
certificate-viewer-tab-servers = Servers
certificate-viewer-tab-ca = Organisaasjes
certificate-viewer-tab-unkonwn = Unbekend
