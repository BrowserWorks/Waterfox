# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Certificate

## Error messages

certificate-viewer-error-message = Bigo kaming hanapin ang impormasyon tungkol sa certificate, o kaya ay sira ang certificate. Pakisubukan uli.
certificate-viewer-error-title = May maling nangyari.

## Certificate information labels

certificate-viewer-algorithm = Algorithm
certificate-viewer-certificate-authority = Certificate Authority
certificate-viewer-cipher-suite = Cipher Suite
certificate-viewer-common-name = Common Name
certificate-viewer-email-address = Email Address
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certificate for { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Inc. Country
certificate-viewer-country = Bansa
certificate-viewer-curve = Curve
certificate-viewer-distribution-point = Distribution Point
certificate-viewer-dns-name = DNS Name
certificate-viewer-ip-address = IP Address
certificate-viewer-other-name = Ibang Pangalan
certificate-viewer-exponent = Exponent
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Key Exchange Group
certificate-viewer-key-id = Key ID
certificate-viewer-key-size = Key Size
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Inc. Locality
certificate-viewer-locality = Locality
certificate-viewer-location = Lokasyon
certificate-viewer-logid = Log ID
certificate-viewer-method = Method
certificate-viewer-modulus = Modulus
certificate-viewer-name = Pangalan
certificate-viewer-not-after = Not After
certificate-viewer-not-before = Not Before
certificate-viewer-organization = Organisasyon
certificate-viewer-organizational-unit = Organizational Unit (OU)
certificate-viewer-policy = Patakaran
certificate-viewer-protocol = Protocol
certificate-viewer-public-value = Public Value
certificate-viewer-purposes = Mga Hangarin
certificate-viewer-qualifier = Qualifier
certificate-viewer-qualifiers = Mga Qualifier
certificate-viewer-required = Kinakailangan
certificate-viewer-unsupported = &lt;hindi suportado&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Estado/Lalawigan kung saan Na-Incorporate
certificate-viewer-state-province = Estado/Lalawigan
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Serial Number
certificate-viewer-signature-algorithm = Signature Algorithm
certificate-viewer-signature-scheme = Signature Scheme
certificate-viewer-timestamp = Timestamp
certificate-viewer-value = Value
certificate-viewer-version = Bersyon
certificate-viewer-business-category = Kategorya ng Negosyo
certificate-viewer-subject-name = Pangalan ng Paksa
certificate-viewer-issuer-name = Pangalan ng Nagbigay
certificate-viewer-validity = Bisa
certificate-viewer-subject-alt-names = Mga Alternatibong Pangalan ng Paksa
certificate-viewer-public-key-info = Public Key Info
certificate-viewer-miscellaneous = Iba Pa
certificate-viewer-fingerprints = Mga Fingerprint
certificate-viewer-basic-constraints = Mga Basic Constraint
certificate-viewer-key-usages = Mga Key Usage
certificate-viewer-extended-key-usages = Mga Extended Key Usage
certificate-viewer-ocsp-stapling = OCSP Stapling
certificate-viewer-subject-key-id = Subject Key ID
certificate-viewer-authority-key-id = Authority Key ID
certificate-viewer-authority-info-aia = Authority Info (AIA)
certificate-viewer-certificate-policies = Mga Polisiya ng Certificate
certificate-viewer-embedded-scts = Mga Embedded SCT
certificate-viewer-crl-endpoints = Mga CRL Endpoint

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Mag-download
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Oo
       *[false] Hindi
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (cert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (chain)
    .download = { $fileName }-chain.pem

certificate-viewer-export = Export
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Your Certificates
certificate-viewer-tab-people = People
certificate-viewer-tab-servers = Servers
certificate-viewer-tab-ca = Authorities
certificate-viewer-tab-unkonwn = Unknown
