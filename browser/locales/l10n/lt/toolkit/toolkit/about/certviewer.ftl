# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Liudijimas

## Error messages

certificate-viewer-error-message = Mums nepavyko rasti liudijimo informacijos, arba pats liudijimas yra pažeistas. Pabandykite dar kartą.
certificate-viewer-error-title = Nutiko kažkas negero.

## Certificate information labels

certificate-viewer-algorithm = Algoritmas
certificate-viewer-certificate-authority = Liudijimų įstaiga
certificate-viewer-cipher-suite = Šifrų rinkinys
certificate-viewer-common-name = Bendrasis vardas
certificate-viewer-email-address = El. pašto adresas
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = „{ $firstCertName }“ liudijimas
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Registravimo šalis
certificate-viewer-country = Šalis
certificate-viewer-curve = Kreivė
certificate-viewer-distribution-point = Platinimo vieta
certificate-viewer-dns-name = DNS vardas
certificate-viewer-ip-address = IP adresas
certificate-viewer-other-name = Kitas pavadinimas
certificate-viewer-exponent = Eksponentė
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Apsikeitimo raktais grupė
certificate-viewer-key-id = Rakto identifikatorius
certificate-viewer-key-size = Rakto dydis
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Centrinė buveinė
certificate-viewer-locality = Vietovė
certificate-viewer-location = Vieta
certificate-viewer-logid = Įrašo identifikatorius
certificate-viewer-method = Metodas
certificate-viewer-modulus = Modulis
certificate-viewer-name = Pavadinimas
certificate-viewer-not-after = Ne vėliau
certificate-viewer-not-before = Ne anksčiau
certificate-viewer-organization = Įstaiga
certificate-viewer-organizational-unit = Įstaigos padalinys
certificate-viewer-policy = Nuostatas
certificate-viewer-protocol = Protokolas
certificate-viewer-public-value = Viešoji reikšmė
certificate-viewer-purposes = Paskirtys
certificate-viewer-qualifier = Kvalifikatorius
certificate-viewer-qualifiers = Kvalifikatoriai
certificate-viewer-required = Privaloma
certificate-viewer-unsupported = &lt;nepalaikomas&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Registracijos valstija / sritis / provincija
certificate-viewer-state-province = Valstija / sritis / provincija
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Numeris
certificate-viewer-signature-algorithm = Parašo algoritmas
certificate-viewer-signature-scheme = Parašo schema
certificate-viewer-timestamp = Laiko žymė
certificate-viewer-value = Reikšmė
certificate-viewer-version = Laida
certificate-viewer-business-category = Verslo kategorija
certificate-viewer-subject-name = Subjekto vardas
certificate-viewer-issuer-name = Išdavėjo vardas
certificate-viewer-validity = Galiojimas
certificate-viewer-subject-alt-names = Subjekto alternatyvieji vardai
certificate-viewer-public-key-info = Viešojo rakto informacija
certificate-viewer-miscellaneous = Kitkas
certificate-viewer-fingerprints = Kontroliniai kodai
certificate-viewer-basic-constraints = Pagrindiniai apribojimai
certificate-viewer-key-usages = Rakto panaudojimai
certificate-viewer-extended-key-usages = Išplėstiniai rakto panaudojimai
certificate-viewer-ocsp-stapling = OCSP susegimas
certificate-viewer-subject-key-id = Subjekto rakto identifikatorius
certificate-viewer-authority-key-id = Įstaigos rakto identifikatorius
certificate-viewer-authority-info-aia = Įstaigos informacija (AIA)
certificate-viewer-certificate-policies = Liudijimo nuostatai
certificate-viewer-embedded-scts = Įterptieji SCT
certificate-viewer-crl-endpoints = CRL galiniai taškai

# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Parsiųsti
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Taip
       *[false] Ne
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (cert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (chain)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Šis plėtinys buvo pažymėtas kaip kritinis, kas reiškia, kad klientai privalo atmesti liudijimą, jeigu jo nesupranta.
certificate-viewer-export = Eksportuoti
    .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (nežinoma)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Jūsų liudijimai
certificate-viewer-tab-people = Žmonės
certificate-viewer-tab-servers = Serveriai
certificate-viewer-tab-ca = Liudijimų įstaigos
certificate-viewer-tab-unkonwn = Nežinoma
