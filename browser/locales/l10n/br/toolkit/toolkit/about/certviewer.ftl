# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Testeni

## Error messages

certificate-viewer-error-message = N'omp ket deuet a-benn da gaout titouroù an testeni pe an testeni a zo kontronet. Klaskit adarre mar plij.
certificate-viewer-error-title = Degouezhet ez eus bet ur fazi.

## Certificate information labels

certificate-viewer-algorithm = Algoritm
certificate-viewer-certificate-authority = Aotrouniezh testeniañ
certificate-viewer-cipher-suite = Hedad sifroù
certificate-viewer-common-name = Anv boutin
certificate-viewer-email-address = Chomlec'h postel
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Testeni evit { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Bro an enrolladur
certificate-viewer-country = Bro
certificate-viewer-curve = Krommenn
certificate-viewer-distribution-point = Poent skignañ
certificate-viewer-dns-name = Anv DNS
certificate-viewer-ip-address = Chomlec'h IP
certificate-viewer-other-name = Anv all
certificate-viewer-exponent = Diskouezher
certificate-viewer-id = ID
certificate-viewer-key-id = ID an alc'hwez
certificate-viewer-key-size = Ment an alc'hwez
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Sez sokial
certificate-viewer-locality = Kêr
certificate-viewer-location = Lec'hiadur
certificate-viewer-method = Hentenn
certificate-viewer-modulus = Modulenn
certificate-viewer-name = Anv
certificate-viewer-not-after = Ket goude
certificate-viewer-not-before = Ket a-raok
certificate-viewer-organization = Aozadur
certificate-viewer-organizational-unit = Unvez aozadurel
certificate-viewer-policy = Politikerezh
certificate-viewer-protocol = Protokol
certificate-viewer-public-value = Talvoudegezh foran
certificate-viewer-purposes = Palioù
certificate-viewer-required = Rediet
certificate-viewer-unsupported = &lt;diembreget&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Bro/Rannvro an enrolladur
certificate-viewer-state-province = Stad/Rannvro
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Niverenn steudad
certificate-viewer-signature-algorithm = Algoritm sinañ
certificate-viewer-timestamp = Merk amzer
certificate-viewer-value = Talvoudegezh
certificate-viewer-version = Handelv
certificate-viewer-business-category = Rummad business
certificate-viewer-subject-name = Anv an danvez
certificate-viewer-issuer-name = Anv ar skigner
certificate-viewer-validity = Talvoudegezh
certificate-viewer-subject-alt-names = Anvioù all an danvez
certificate-viewer-public-key-info = Titouroù an alc'hwez foran
certificate-viewer-miscellaneous = A bep seurt
certificate-viewer-fingerprints = Roudoù biz
certificate-viewer-basic-constraints = Rediennoù diazez
certificate-viewer-key-usages = Implijoù an alc'hwez
certificate-viewer-extended-key-usages = Implijoù astennet an alc'hwez
certificate-viewer-subject-key-id = ID alc'hwez an danvez
certificate-viewer-authority-key-id = ID alc'hwez an aotrouniezh
certificate-viewer-authority-info-aia = Titouroù diwar-benn an aotrouniezh (AIA)
certificate-viewer-certificate-policies = Politikerezhioù an testeni
certificate-viewer-embedded-scts = SCTs ebarzhet

# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Pellgargañ
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Ya
       *[false] Ket
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (testeni)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (chadenn)
    .download = { $fileName }-chain.pem

certificate-viewer-export = Ezporzhiañ
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Ho testenioù
certificate-viewer-tab-people = Tud
certificate-viewer-tab-servers = Servijerioù
certificate-viewer-tab-ca = Aotrouniezhoù
certificate-viewer-tab-unkonwn = Dianav
