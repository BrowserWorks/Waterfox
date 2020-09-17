# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Certifikat

## Error messages

certificate-viewer-error-message = Njejsmy mógli certifikatowe informacije namakaś, abo certifikat jo wobškóźony. Pšosym wopytajśo hyšći raz.
certificate-viewer-error-title = Něco njejo se raźiło.

## Certificate information labels

certificate-viewer-algorithm = Algoritmus
certificate-viewer-certificate-authority = Certifikatowa awtorita
certificate-viewer-cipher-suite = Šyfrowa zběrka
certificate-viewer-common-name = Zwucone mě
certificate-viewer-email-address = E-mailowa adresa
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certifikat za { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Kraj zapisanja
certificate-viewer-country = Kraj
certificate-viewer-curve = Kśiwanka
certificate-viewer-distribution-point = Rozdźěleński dypk
certificate-viewer-dns-name = DNS-mě
certificate-viewer-ip-address = IP-adresa
certificate-viewer-other-name = Druge mě
certificate-viewer-exponent = Eksponent
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Kupka za wuměnu klucow
certificate-viewer-key-id = ID kluca
certificate-viewer-key-size = Wjelikosć kluca
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Městno pśedewześa
certificate-viewer-locality = Městnosć
certificate-viewer-location = Městno
certificate-viewer-logid = Protokolowy ID
certificate-viewer-method = Metoda
certificate-viewer-modulus = Modul
certificate-viewer-name = Mě
certificate-viewer-not-after = Nic pó tom
certificate-viewer-not-before = Nic pjerwjej
certificate-viewer-organization = Organizacija
certificate-viewer-organizational-unit = Organizaciska jadnotka
certificate-viewer-policy = Pšawidło
certificate-viewer-protocol = Protokol
certificate-viewer-public-value = Zjawna gódnota
certificate-viewer-purposes = Zaměry
certificate-viewer-qualifier = Kwalifikator
certificate-viewer-qualifiers = Kwalifikatory
certificate-viewer-required = Trěbny
certificate-viewer-unsupported = &lt;njepódprěty&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Zwězkowy kraj zapisanja
certificate-viewer-state-province = Zwězkowy kraj
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Serijowy numer
certificate-viewer-signature-algorithm = Signaturowy algoritmus
certificate-viewer-signature-scheme = Signaturowa šema
certificate-viewer-timestamp = Casowy kołk
certificate-viewer-value = Gódnota
certificate-viewer-version = Wersija
certificate-viewer-business-category = Wobchodowa kategorija
certificate-viewer-subject-name = Subjektne mě
certificate-viewer-issuer-name = Mě wudawarja
certificate-viewer-validity = Płaśiwosć
certificate-viewer-subject-alt-names = Alternatiwne subjektne mjenja
certificate-viewer-public-key-info = Informacije wó zjawnem klucu
certificate-viewer-miscellaneous = Wšake
certificate-viewer-fingerprints = Palcowe wótśišće
certificate-viewer-basic-constraints = Zakładne wobgranicowanja
certificate-viewer-key-usages = Wužyśa klucow
certificate-viewer-extended-key-usages = Rozšyrjone wužyśa kluca
certificate-viewer-ocsp-stapling = OCSP-stapling
certificate-viewer-subject-key-id = ID subjektnego kluca
certificate-viewer-authority-key-id = ID kluca awtority
certificate-viewer-authority-info-aia = Informacije awtority (AIA)
certificate-viewer-certificate-policies = Certifikatowe pšawidła
certificate-viewer-embedded-scts = Zasajźone SCT
certificate-viewer-crl-endpoints = Kóńcne dypki CRL

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Ześěgnjenje
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Jo
       *[false] Ně
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (certifikat)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (rjeśazk)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Toś to rozšyrjenje jo se markěrowało ako kritiske, to groni, až klienty muse certifikat wótpokazaś, jolic jen njerozměju.
certificate-viewer-export = Eksportěrowaś
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Waše certifikaty
certificate-viewer-tab-people = Luźe
certificate-viewer-tab-servers = Serwery
certificate-viewer-tab-ca = Awtority
certificate-viewer-tab-unkonwn = Njeznaty
