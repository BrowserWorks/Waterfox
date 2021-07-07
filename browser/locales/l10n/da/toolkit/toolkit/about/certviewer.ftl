# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Certifikat

## Error messages

certificate-viewer-error-message = Vi kunne ikke finde information om certifikatet - eller certifikatet er fejlbehæftet. Prøv igen.
certificate-viewer-error-title = Noget gik galt.

## Certificate information labels

certificate-viewer-algorithm = Algoritme
certificate-viewer-certificate-authority = Certifikatautoritet
certificate-viewer-cipher-suite = Cipher suite
certificate-viewer-common-name = Normalt navn
certificate-viewer-email-address = Mailadresse
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certifikat for { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Virksomhedens hjemland
certificate-viewer-country = Land
certificate-viewer-curve = Kurve
certificate-viewer-distribution-point = Distributions-punkt
certificate-viewer-dns-name = DNS-navn
certificate-viewer-ip-address = IP-adresse
certificate-viewer-other-name = Andet navn
certificate-viewer-exponent = Eksponent
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Nøgleudvekslingsgruppe
certificate-viewer-key-id = Nøgle-ID
certificate-viewer-key-size = Nøgle-størrelse
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Virksomhedens placering
certificate-viewer-locality = Lokalitet
certificate-viewer-location = Placering
certificate-viewer-logid = Log-ID
certificate-viewer-method = Metode
certificate-viewer-modulus = Modulus
certificate-viewer-name = Navn
certificate-viewer-not-after = Ikke efter
certificate-viewer-not-before = Ikke før
certificate-viewer-organization = Organisation
certificate-viewer-organizational-unit = Organisatorisk enhed
certificate-viewer-policy = Politik
certificate-viewer-protocol = Protokol
certificate-viewer-public-value = Offentlig værdi
certificate-viewer-purposes = Formål
certificate-viewer-qualifier = Qualifier
certificate-viewer-qualifiers = Qualifiers
certificate-viewer-required = Påkrævet
certificate-viewer-unsupported = &lt;ikke understøttet&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Virkomhedens hjem-stat/-provins
certificate-viewer-state-province = Stat/provins
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Serienummer
certificate-viewer-signature-algorithm = Signatur-algoritme
certificate-viewer-signature-scheme = Signatur-skema
certificate-viewer-timestamp = Tidsstempel
certificate-viewer-value = Værdi
certificate-viewer-version = Version
certificate-viewer-business-category = Virksomheds-kategori
certificate-viewer-subject-name = Subjektets navn
certificate-viewer-issuer-name = Udsteders navn
certificate-viewer-validity = Gyldighed
certificate-viewer-subject-alt-names = Subjektets alternative navne
certificate-viewer-public-key-info = Offentlig nøgleinformation
certificate-viewer-miscellaneous = Diverse
certificate-viewer-fingerprints = Fingeraftryk
certificate-viewer-basic-constraints = Grundlæggende begrænsninger
certificate-viewer-key-usages = Nøglebrug
certificate-viewer-extended-key-usages = Udvidet nøglebrug
certificate-viewer-ocsp-stapling = OCSP Stapling
certificate-viewer-subject-key-id = Subjektets nøgle-ID
certificate-viewer-authority-key-id = Autoritetens nøgle-ID
certificate-viewer-authority-info-aia = Information om autoritet (AIA)
certificate-viewer-certificate-policies = Certifikatpolitikker
certificate-viewer-embedded-scts = Indlejrede SCT'er
certificate-viewer-crl-endpoints = Slutpunkter for CRL
# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Hent
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Ja
       *[false] Nej
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (cert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (kæde)
    .download = { $fileName }-chain.pem
# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Denne udvidelse er blevet markeret som kritisk, hvilket betyder at klienter skal afvise certifikatet, hvis de ikke forstår det.
certificate-viewer-export = Eksporter
    .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (ukendt)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Dine certifikater
certificate-viewer-tab-people = Personer
certificate-viewer-tab-servers = Servere
certificate-viewer-tab-ca = Autoriteter
certificate-viewer-tab-unkonwn = Ukendt
