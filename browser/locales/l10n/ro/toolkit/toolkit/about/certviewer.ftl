# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Certificat

## Error messages

certificate-viewer-error-message = Nu am reușit să găsim informațiile certificatului sau certificatul este corupt. Te rugăm să încerci din nou.
certificate-viewer-error-title = Ceva nu a funcționat.

## Certificate information labels

certificate-viewer-algorithm = Algoritm
certificate-viewer-certificate-authority = Autoritate de certificare
certificate-viewer-cipher-suite = Suită de cifru
certificate-viewer-common-name = Denumire comună
certificate-viewer-email-address = Adresă de e-mail
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certificat pentru { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Țara firmei
certificate-viewer-country = Țară
certificate-viewer-curve = Curbă
certificate-viewer-distribution-point = Punct de distribuție
certificate-viewer-dns-name = Denumire DNS
certificate-viewer-ip-address = Adresă IP
certificate-viewer-other-name = Alt nume
certificate-viewer-exponent = Exponent
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Grup de schimb de chei
certificate-viewer-key-id = ID cheie
certificate-viewer-key-size = Mărime cheie
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Sediu social
certificate-viewer-locality = Localitate
certificate-viewer-location = Loc
certificate-viewer-logid = ID de jurnal
certificate-viewer-method = Metodă
certificate-viewer-modulus = Modul
certificate-viewer-name = Denumire
certificate-viewer-not-after = Nu după
certificate-viewer-not-before = Nu înainte
certificate-viewer-organization = Organizație
certificate-viewer-organizational-unit = Unitate organizațională
certificate-viewer-policy = Politică
certificate-viewer-protocol = Protocol
certificate-viewer-public-value = Valoare publică
certificate-viewer-purposes = Scopuri
certificate-viewer-qualifier = Calificativ
certificate-viewer-qualifiers = Calificative
certificate-viewer-required = Obligatoriu
certificate-viewer-unsupported = &lt;fără suport&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Stat/Provincie firmă
certificate-viewer-state-province = Stat/Provincie
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Număr de serie
certificate-viewer-signature-algorithm = Algoritm de semnături
certificate-viewer-signature-scheme = Schemă de semnături
certificate-viewer-timestamp = Marcaj temporal
certificate-viewer-value = Valoare
certificate-viewer-version = Versiune
certificate-viewer-business-category = Categorie comercială
certificate-viewer-subject-name = Denumire subiect
certificate-viewer-issuer-name = Denumire emitent
certificate-viewer-validity = Valabilitate
certificate-viewer-subject-alt-names = Denumiri alternative subiect
certificate-viewer-public-key-info = Informații despre cheia publică
certificate-viewer-miscellaneous = Diverse
certificate-viewer-fingerprints = Amprente digitale
certificate-viewer-basic-constraints = Constrângeri de bază
certificate-viewer-key-usages = Utilizările cheii
certificate-viewer-extended-key-usages = Utilizări extinse ale cheii
certificate-viewer-ocsp-stapling = Marcaj OCSP
certificate-viewer-subject-key-id = ID cheie subiect
certificate-viewer-authority-key-id = ID cheie de autoritate
certificate-viewer-authority-info-aia = Informații despre autoritate (AIA)
certificate-viewer-certificate-policies = Politicile certificatului
certificate-viewer-embedded-scts = SCT înglobate
certificate-viewer-crl-endpoints = Puncte de sfârșit CRL

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Descărcare
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Da
       *[false] Nu
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (cert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (lanț)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Această extensie a fost marcată drept critică, iar clienții trebuie să respingă certificatul dacă nu îl înțeleg.
certificate-viewer-export = Exportă
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Certificatele tale
certificate-viewer-tab-people = Persoane
certificate-viewer-tab-servers = Servere
certificate-viewer-tab-ca = Autorități
certificate-viewer-tab-unkonwn = Necunoscut
