# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Mboajepyréva

## Error messages

certificate-viewer-error-message = Ndorojuhúi marandu jeguerohyvéva rehegua térã pe jeguerohyvéva imarã. Eha’ãjey.
certificate-viewer-error-title = Oĩ osẽvaíva

## Certificate information labels

certificate-viewer-algorithm = Algoritmo
certificate-viewer-certificate-authority = Ñemboajeha moakãhára
certificate-viewer-cipher-suite = Suite ipapapýva
certificate-viewer-common-name = Téra tapia
certificate-viewer-email-address = Ñanduti veve kundaharape
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Mboajepyre { $firstCertName } peg̃uarã
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Tetã
certificate-viewer-country = Tetã
certificate-viewer-curve = Mbojere
certificate-viewer-distribution-point = Ñemyasãiha
certificate-viewer-dns-name = DNS réra
certificate-viewer-ip-address = IP kundaharape
certificate-viewer-other-name = Ambue Téra
certificate-viewer-exponent = Ñe’ẽhára
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Ñe’ẽñemi moambueha aty
certificate-viewer-key-id = ID ñe’ẽñemi
certificate-viewer-key-size = Ñe’ẽñemi tuichakue
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Inc. Tendaite
certificate-viewer-locality = Tenda
certificate-viewer-location = Tendaite
certificate-viewer-logid = ID ñemboguapy
certificate-viewer-method = Tapereko
certificate-viewer-modulus = Ha’ãha
certificate-viewer-name = Téra
certificate-viewer-not-after = Ani uperire
certificate-viewer-not-before = Ani upemboyve
certificate-viewer-organization = Atyguasu
certificate-viewer-organizational-unit = Joaju Atyguasugua
certificate-viewer-policy = Purureko
certificate-viewer-protocol = Taperekoite
certificate-viewer-public-value = Opavavemba’éva repykue
certificate-viewer-purposes = Japose
certificate-viewer-qualifier = Tekome’ẽha
certificate-viewer-qualifiers = Tekome’ẽha
certificate-viewer-required = Tekotevẽva
certificate-viewer-unsupported = &lt;ndojokupytýi&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Tetã/tetãvore
certificate-viewer-state-province = Tetã/tetãvore
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Papapy syryrýva
certificate-viewer-signature-algorithm = Mboheraguapy algoritmo
certificate-viewer-signature-scheme = Mboheraguapy apopyre
certificate-viewer-timestamp = Ára ha aravo
certificate-viewer-value = Tepykue
certificate-viewer-version = Peteĩchagua
certificate-viewer-business-category = Ñemuha jehechaukaha
certificate-viewer-subject-name = Téma réra
certificate-viewer-issuer-name = Me’ẽhára réra
certificate-viewer-validity = Oikóva
certificate-viewer-subject-alt-names = Téma réra mokõiha
certificate-viewer-public-key-info = Marandu ñemiguáva
certificate-viewer-miscellaneous = Jehe’apa
certificate-viewer-fingerprints = Ñemokuãhũ
certificate-viewer-basic-constraints = Jejoko’imi
certificate-viewer-key-usages = Ojepuruvéva
certificate-viewer-extended-key-usages = Ojepuru hetavéva
certificate-viewer-ocsp-stapling = OCSP Tuichavéva
certificate-viewer-subject-key-id = Téma ñemigua ID
certificate-viewer-authority-key-id = Mburuvicha ñemigua ID
certificate-viewer-authority-info-aia = Mburuvicha marandu (AIA)
certificate-viewer-certificate-policies = Jerohoryvéva purureko
certificate-viewer-embedded-scts = Ojehe’áva SCTs
certificate-viewer-crl-endpoints = CRL kyta paha

# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Mboguejy
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Héẽ
       *[false] Ahániri
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (cert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (juajuha)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Ko jepysokue oñemongurusúma ivaikuaávaramo, he’iséva puruhára omboykeva’erã mboajepyre noikumbýiramo.
certificate-viewer-export = Guerahauka
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Ne mboajepyre
certificate-viewer-tab-people = Yvypóra
certificate-viewer-tab-servers = Mohendahavusu
certificate-viewer-tab-ca = Moakãhára
certificate-viewer-tab-unkonwn = Ojekuaa’ỹva
