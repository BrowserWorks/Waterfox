# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Certifikát

## Error messages

certificate-viewer-error-message = Informace o certifikátu se nepodařilo najít, nebo je certifikát poškozený. Zkuste to prosím znovu.
certificate-viewer-error-title = Nastala chyba.

## Certificate information labels

certificate-viewer-algorithm = Algoritmus
certificate-viewer-certificate-authority = Certifikační autorita
certificate-viewer-cipher-suite = Šifrovací sada
certificate-viewer-common-name = Obecné jméno
certificate-viewer-email-address = E-mailová adresa
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certifikát pro { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Země vyžádání
certificate-viewer-country = Země
certificate-viewer-curve = Křivka
certificate-viewer-distribution-point = Distribuční bod
certificate-viewer-dns-name = DNS název
certificate-viewer-ip-address = IP adresa
certificate-viewer-other-name = Další jméno
certificate-viewer-exponent = Exponent
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Grupa pro výměnu klíčů
certificate-viewer-key-id = ID klíče
certificate-viewer-key-size = Velikost klíče
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Místo zápisu organizace
certificate-viewer-locality = Region
certificate-viewer-location = Umístění
certificate-viewer-logid = ID protokolu
certificate-viewer-method = Metoda
certificate-viewer-modulus = Modul
certificate-viewer-name = Název
certificate-viewer-not-after = Platnost do
certificate-viewer-not-before = Platnost od
certificate-viewer-organization = Organizace
certificate-viewer-organizational-unit = Jednotka organizace
certificate-viewer-policy = Zásady
certificate-viewer-protocol = Protokol
certificate-viewer-public-value = Veřejná hodnota
certificate-viewer-purposes = Účel
certificate-viewer-qualifier = Kvalifikátor
certificate-viewer-qualifiers = Kvalifikátory
certificate-viewer-required = Vyžadováno
certificate-viewer-unsupported = &lt;nepodporováno&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Stát/Kraj vyžádání
certificate-viewer-state-province = Stát/Kraj
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Sériové číslo
certificate-viewer-signature-algorithm = Algoritmus podpisu
certificate-viewer-signature-scheme = Schéma podpisu
certificate-viewer-timestamp = Časová značka
certificate-viewer-value = Hodnota
certificate-viewer-version = Verze
certificate-viewer-business-category = Druh společnosti
certificate-viewer-subject-name = Jméno subjektu
certificate-viewer-issuer-name = Jméno vydavatele
certificate-viewer-validity = Platnost
certificate-viewer-subject-alt-names = Alternativní jména subjektu
certificate-viewer-public-key-info = Informace o veřejném klíči
certificate-viewer-miscellaneous = Různé
certificate-viewer-fingerprints = Otisky
certificate-viewer-basic-constraints = Základní omezení
certificate-viewer-key-usages = Použití klíče
certificate-viewer-extended-key-usages = Rozšířená použití klíče
certificate-viewer-ocsp-stapling = OCSP Stapling
certificate-viewer-subject-key-id = ID klíče subjektu
certificate-viewer-authority-key-id = ID klíče autority
certificate-viewer-authority-info-aia = Informace o autoritě (AIA)
certificate-viewer-certificate-policies = Pravidla certifikátu
certificate-viewer-embedded-scts = Vložené SCTs
certificate-viewer-crl-endpoints = CRL endpointy
# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Stáhnout
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Ano
       *[false] Ne
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (certifikát)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (řetězec)
    .download = { $fileName }-chain.pem
# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Toto rozšíření bylo označeno jako kritické, což znamená, že klienti musí certifikát odmítnout, pokud mu neporozumí.
certificate-viewer-export = Exportovat
    .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (neznámý)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Osobní
certificate-viewer-tab-people = Lidé
certificate-viewer-tab-servers = Servery
certificate-viewer-tab-ca = Autority
certificate-viewer-tab-unkonwn = Neznámé
