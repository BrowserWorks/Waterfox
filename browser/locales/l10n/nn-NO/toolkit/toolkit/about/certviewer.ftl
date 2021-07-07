# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Sertifikat

## Error messages

certificate-viewer-error-message = Vi klarte ikkje å finne sertifikatinformasjonen, eller sertifikatet er skada. Prøv på nytt.
certificate-viewer-error-title = Noko gjekk gale.

## Certificate information labels

certificate-viewer-algorithm = Algoritme
certificate-viewer-certificate-authority = Sertifikatutskrivar
certificate-viewer-cipher-suite = Krypteringssuite
certificate-viewer-common-name = Vanleg namn
certificate-viewer-email-address = E-postadresse
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Sertifikat for { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Organisasjonsland
certificate-viewer-country = Land
certificate-viewer-curve = Kurve
certificate-viewer-distribution-point = Distribusjonspunkt
certificate-viewer-dns-name = DNS-namn
certificate-viewer-ip-address = IP-adresse
certificate-viewer-other-name = Anna namn
certificate-viewer-exponent = Eksponent
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Gruppe for nøkkelutveksling
certificate-viewer-key-id = Nøkkel-ID
certificate-viewer-key-size = Nøkkelstorleik
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Organisasjonsplassering
certificate-viewer-locality = Stad
certificate-viewer-location = Adresse
certificate-viewer-logid = Logg-ID
certificate-viewer-method = Metode
certificate-viewer-modulus = Modulus
certificate-viewer-name = Namn
certificate-viewer-not-after = Ikkje etter
certificate-viewer-not-before = Ikkje før
certificate-viewer-organization = Organisasjon
certificate-viewer-organizational-unit = Organisasjonseining
certificate-viewer-policy = Policy
certificate-viewer-protocol = Protokoll
certificate-viewer-public-value = Offentleg verdi
certificate-viewer-purposes = Føremål
certificate-viewer-qualifier = Kvalifikator
certificate-viewer-qualifiers = Kvalifikatorar
certificate-viewer-required = Nødvendig
certificate-viewer-unsupported = &lt;ustøtta&gt;
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
certificate-viewer-business-category = Føretakskategori
certificate-viewer-subject-name = Namn skrive ut til
certificate-viewer-issuer-name = Namn til utskrivar
certificate-viewer-validity = Gyldigheit
certificate-viewer-subject-alt-names = Alternativt namn skrive ut til
certificate-viewer-public-key-info = Informasjon om offentleg nøkkel
certificate-viewer-miscellaneous = Diverse
certificate-viewer-fingerprints = Fingeravtrykk
certificate-viewer-basic-constraints = Grunnleggande avgrensingar
certificate-viewer-key-usages = Nøkkelbruk
certificate-viewer-extended-key-usages = Utvida nøkkelbruk
certificate-viewer-ocsp-stapling = OCSP-stapling
certificate-viewer-subject-key-id = Emneøkkel-ID
certificate-viewer-authority-key-id = Autoritetsnøkkel-ID
certificate-viewer-authority-info-aia = Autoritetsinfo (AIA)
certificate-viewer-certificate-policies = Reglar for sertifikat
certificate-viewer-embedded-scts = Innebygde SCT-ar
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
    .title = Denne utvidinga er merkt som kritisk, noko som tyder at klientar må avvise sertifikatet dersom dei ikkje forstår det.
certificate-viewer-export = Eksporter
    .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (ukjend)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Dine sertifikat
certificate-viewer-tab-people = Personar
certificate-viewer-tab-servers = Serverar
certificate-viewer-tab-ca = Utskrivarar
certificate-viewer-tab-unkonwn = Ukjent
