# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Tystysgrif

## Error messages

certificate-viewer-error-message = Nid oeddem yn gallu dod o hyd i fanylion y dystysgrif, neu mae'r dystysgrif yn llygredig. Ceisiwch eto.
certificate-viewer-error-title = Aeth rhywbeth o'i le.

## Certificate information labels

certificate-viewer-algorithm = Algorithm
certificate-viewer-certificate-authority = Awdurdod Tystysgrif
certificate-viewer-cipher-suite = Casgliad Seiffr
certificate-viewer-common-name = Enw Cyffredin
certificate-viewer-email-address = Cyfeiriad E-bost
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Tystysgrif ar gyfer { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Gwlad Corfforedig
certificate-viewer-country = Gwlad
certificate-viewer-curve = Cromlin
certificate-viewer-distribution-point = Pwynt Dosbarthu
certificate-viewer-dns-name = Enw DNS
certificate-viewer-ip-address = Cyfeiriad IP
certificate-viewer-other-name = Enw Arall
certificate-viewer-exponent = Esbonydd
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Grŵp Cyfnewid Allwedd
certificate-viewer-key-id = ID Allwedd
certificate-viewer-key-size = Maint Allwedd
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Ardal Corffori
certificate-viewer-locality = Lleoliad
certificate-viewer-location = Lleoliad
certificate-viewer-logid = ID Cofnod
certificate-viewer-method = Dull
certificate-viewer-modulus = Modwlws
certificate-viewer-name = Enw
certificate-viewer-not-after = Nid ar Ôl
certificate-viewer-not-before = Nid Cyn
certificate-viewer-organization = Corff
certificate-viewer-organizational-unit = Uned Corff
certificate-viewer-policy = Polisi
certificate-viewer-protocol = Protocol
certificate-viewer-public-value = Gwerth Cyhoeddus
certificate-viewer-purposes = Pwrpasau
certificate-viewer-qualifier = Cymhwyster
certificate-viewer-qualifiers = Cymhwysterau
certificate-viewer-required = Gofynnol
certificate-viewer-unsupported = &lt;heb ei gynnal&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Corfforedig Talaith/Ardal
certificate-viewer-state-province = Talaith/Ardal
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Rhif Cyfresol
certificate-viewer-signature-algorithm = Algorithm Llofnod
certificate-viewer-signature-scheme = Cynllun Llofnod
certificate-viewer-timestamp = Stamp Amser
certificate-viewer-value = Gwerth
certificate-viewer-version = Fersiwn
certificate-viewer-business-category = Categori Busnes
certificate-viewer-subject-name = Enw'r Pwnc
certificate-viewer-issuer-name = Enw Cyhoeddwr
certificate-viewer-validity = Dilysrwydd
certificate-viewer-subject-alt-names = Enwau Alt Pwnc
certificate-viewer-public-key-info = Manylion Allweddol Cyhoeddus
certificate-viewer-miscellaneous = Amrywiol
certificate-viewer-fingerprints = Bysbrint
certificate-viewer-basic-constraints = Cyfyngiadau Sylfaenol
certificate-viewer-key-usages = Defnyddiau Allweddol
certificate-viewer-extended-key-usages = Defnydd Allwedd Estynedig
certificate-viewer-ocsp-stapling = Strapio OCSP
certificate-viewer-subject-key-id = ID Allwedd Pwnc
certificate-viewer-authority-key-id = ID Allwedd yr Awdurdod
certificate-viewer-authority-info-aia = Manylion yr Awdurdod (AIA)
certificate-viewer-certificate-policies = Polisïau Tystysgrif
certificate-viewer-embedded-scts = SCTs mewnblanedig
certificate-viewer-crl-endpoints = Diweddbwynt CRL

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Llwytho i Lawr
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Iawn
       *[false] na
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (tystysgrif)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (cadwyn)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Mae'r estyniad hwn wedi'i nodi fel un hanfodol, sy'n golygu bod yn rhaid i gleientiaid wrthod y dystysgrif os nad ydyn nhw'n ei deall.
certificate-viewer-export = Allforio
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Eich Tystysgrifau
certificate-viewer-tab-people = Pobl
certificate-viewer-tab-servers = Gweinyddion
certificate-viewer-tab-ca = Awdurdodau
certificate-viewer-tab-unkonwn = Anhysbys
