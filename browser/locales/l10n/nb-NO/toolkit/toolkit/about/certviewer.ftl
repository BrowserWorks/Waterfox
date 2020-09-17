# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Sertifikat

## Error messages

certificate-viewer-error-message = Vi kunne ikke finne sertifikatinformasjonen, eller sertifikatet er ødelagt. Prøv på nytt.
certificate-viewer-error-title = Noe gikk galt.

## Certificate information labels

certificate-viewer-algorithm = Algoritme
certificate-viewer-certificate-authority = Sertifikatutsteder
certificate-viewer-cipher-suite = Krypteringssuite
certificate-viewer-common-name = Vanlig navn
certificate-viewer-email-address = E-postadresse
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Sertifikat for { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Organisasjonsland
certificate-viewer-country = Land
certificate-viewer-curve = Kurve
certificate-viewer-distribution-point = Distribusjonspunkt
certificate-viewer-dns-name = DNS-navn
certificate-viewer-ip-address = IP-adresse
certificate-viewer-other-name = Annet navn
certificate-viewer-exponent = Eksponent
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Gruppe for nøkkelutveksling
certificate-viewer-key-id = Nøkkel-ID
certificate-viewer-key-size = Nøkkelstørrelse
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Organisasjonsplassering
certificate-viewer-locality = Sted
certificate-viewer-location = Adresse
certificate-viewer-logid = Logg-ID
certificate-viewer-method = Metode
certificate-viewer-modulus = Modulus
certificate-viewer-name = Navn
certificate-viewer-not-after = Ikke etter
certificate-viewer-not-before = Ikke før
certificate-viewer-organization = Organisasjon
certificate-viewer-organizational-unit = Organisasjonsenhet
certificate-viewer-policy = Policy
certificate-viewer-protocol = Protokoll
certificate-viewer-public-value = Offentlig verdi
certificate-viewer-purposes = Formål
certificate-viewer-qualifier = Kvalifikator
certificate-viewer-qualifiers = Kvalifikatorer
certificate-viewer-required = Nødvendig
certificate-viewer-unsupported = &lt;ustøttet&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Organisasjonsstat/-provins
certificate-viewer-state-province = Delstat/provins
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Serienummer
certificate-viewer-signature-algorithm = Signaturalgoritme
certificate-viewer-signature-scheme = Signaturskjema
certificate-viewer-timestamp = Tidsstempel
certificate-viewer-value = Verdi
certificate-viewer-version = Versjon
certificate-viewer-business-category = Virksomhetskategori
certificate-viewer-subject-name = Utstedt til navn
certificate-viewer-issuer-name = Utstederens navn
certificate-viewer-validity = Gyldighet
certificate-viewer-subject-alt-names = Utstedt til alternativ navn
certificate-viewer-public-key-info = Informasjon om offentlig nøkkel
certificate-viewer-miscellaneous = Diverse
certificate-viewer-fingerprints = Fingeravtrykk
certificate-viewer-basic-constraints = Grunnleggende begrensninger
certificate-viewer-key-usages = Nøkkelbruk
certificate-viewer-extended-key-usages = Utvidet nøkkelbruk
certificate-viewer-ocsp-stapling = OCSP-stapling
certificate-viewer-subject-key-id = Emneøkkel-ID
certificate-viewer-authority-key-id = Autoritetsnøkkel-ID
certificate-viewer-authority-info-aia = Autoritetsinfo (AIA)
certificate-viewer-certificate-policies = Regler for sertifikat
certificate-viewer-embedded-scts = Innebygde SCT-er
certificate-viewer-crl-endpoints = CRL-endpoints

# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Last ned
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Ja
       *[false] Nei
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (cert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (chain)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Denne utvidelsen er merket som kritisk, noe som betyr at klienter må avvise sertifikatet hvis de ikke forstår det.
certificate-viewer-export = Eksporter
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Dine sertifikater
certificate-viewer-tab-people = Personer
certificate-viewer-tab-servers = Servere
certificate-viewer-tab-ca = Utstedere
certificate-viewer-tab-unkonwn = Ukjent
