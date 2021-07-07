# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Certificaat

## Error messages

certificate-viewer-error-message = We konden de certificaatinformatie niet vinden, of het certificaat is beschadigd. Probeer het opnieuw.
certificate-viewer-error-title = Er is iets misgegaan.

## Certificate information labels

certificate-viewer-algorithm = Algoritme
certificate-viewer-certificate-authority = Certificaatautoriteit
certificate-viewer-cipher-suite = Coderingssuite
certificate-viewer-common-name = Algemene naam
certificate-viewer-email-address = E-mailadres
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certificaat voor { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Land van vestiging
certificate-viewer-country = Land
certificate-viewer-curve = Kromme
certificate-viewer-distribution-point = Distributiepunt
certificate-viewer-dns-name = DNS-naam
certificate-viewer-ip-address = IP-adres
certificate-viewer-other-name = Andere naam
certificate-viewer-exponent = Exponent
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Sleuteluitwisselingsgroep
certificate-viewer-key-id = Sleutel-ID
certificate-viewer-key-size = Sleutelgrootte
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Vestigingsplaats
certificate-viewer-locality = Plaats
certificate-viewer-location = Locatie
certificate-viewer-logid = Log-ID
certificate-viewer-method = Methode
certificate-viewer-modulus = Modulus
certificate-viewer-name = Naam
certificate-viewer-not-after = Niet na
certificate-viewer-not-before = Niet voor
certificate-viewer-organization = Organisatie
certificate-viewer-organizational-unit = Organisatorische eenheid
certificate-viewer-policy = Beleid
certificate-viewer-protocol = Protocol
certificate-viewer-public-value = Publieke waarde
certificate-viewer-purposes = Doeleinden
certificate-viewer-qualifier = Kwalificatie
certificate-viewer-qualifiers = Kwalificaties
certificate-viewer-required = Vereist
certificate-viewer-unsupported = &lt;niet ondersteund&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Staat/provincie van vestiging
certificate-viewer-state-province = Staat/provincie
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Serienummer
certificate-viewer-signature-algorithm = Handtekeningsalgoritme
certificate-viewer-signature-scheme = Handtekeningschema
certificate-viewer-timestamp = Tijdstempel
certificate-viewer-value = Waarde
certificate-viewer-version = Versie
certificate-viewer-business-category = Bedrijfscategorie
certificate-viewer-subject-name = Naam houder
certificate-viewer-issuer-name = Naam uitgever
certificate-viewer-validity = Geldigheid
certificate-viewer-subject-alt-names = Alternatieve namen houder
certificate-viewer-public-key-info = Informatie publieke sleutel
certificate-viewer-miscellaneous = Diversen
certificate-viewer-fingerprints = Vingerafdrukken
certificate-viewer-basic-constraints = Basisbeperkingen
certificate-viewer-key-usages = Belangrijkste gebruiksmogelijkheden
certificate-viewer-extended-key-usages = Uitgebreide gebruiksmogelijkheden
certificate-viewer-ocsp-stapling = OCSP-stapling
certificate-viewer-subject-key-id = Sleutel-ID houder
certificate-viewer-authority-key-id = Sleutel-ID autoriteit
certificate-viewer-authority-info-aia = Autoriteit-info (AIA)
certificate-viewer-certificate-policies = Certificaatbeleid
certificate-viewer-embedded-scts = Ingebedde SCT’s
certificate-viewer-crl-endpoints = CRL-eindpunten
# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Downloaden
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Ja
       *[false] Nee
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (cert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (keten)
    .download = { $fileName }-chain.pem
# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Deze extensie is als kritiek gemarkeerd, wat betekent dat clients het certificaat moeten weigeren als ze het niet begrijpen.
certificate-viewer-export = Exporteren
    .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (onbekend)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Uw certificaten
certificate-viewer-tab-people = Personen
certificate-viewer-tab-servers = Servers
certificate-viewer-tab-ca = Organisaties
certificate-viewer-tab-unkonwn = Onbekend
