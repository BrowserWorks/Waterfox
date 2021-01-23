# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Certifikát

## Error messages

certificate-viewer-error-message = Informácie o certifikáte sa nám nepodarilo nájsť alebo je certifikát poškodený. Skúste to znova.
certificate-viewer-error-title = Nastala chyba.

## Certificate information labels

certificate-viewer-algorithm = Algoritmus
certificate-viewer-certificate-authority = Certifikačná autorita
certificate-viewer-cipher-suite = Šifrovacia množina
certificate-viewer-common-name = Bežný názov
certificate-viewer-email-address = E-mailová adresa
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certifikát pre { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Krajina
certificate-viewer-country = Krajina
certificate-viewer-curve = Krivka
certificate-viewer-distribution-point = Distribučný bod
certificate-viewer-dns-name = Záznam DNS
certificate-viewer-ip-address = IP adresa
certificate-viewer-other-name = Iný názov
certificate-viewer-exponent = Exponent
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Skupina pre výmenu kľúčov
certificate-viewer-key-id = ID kľúča
certificate-viewer-key-size = Veľkosť kľúča
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Sídlo spoločnosti
certificate-viewer-locality = Lokalita
certificate-viewer-location = Umiestnenie
certificate-viewer-logid = ID protokolu
certificate-viewer-method = Metóda
certificate-viewer-modulus = Modul
certificate-viewer-name = Názov
certificate-viewer-not-after = Neplatný po
certificate-viewer-not-before = Neplatný pred
certificate-viewer-organization = Organizácia
certificate-viewer-organizational-unit = Organizačná jednotka (OU)
certificate-viewer-policy = Zásady
certificate-viewer-protocol = Protokol
certificate-viewer-public-value = Verejná hodnota
certificate-viewer-purposes = Účely
certificate-viewer-qualifier = Kvalifikátor
certificate-viewer-qualifiers = Kvalifikátory
certificate-viewer-required = Vyžadované
certificate-viewer-unsupported = &lt;nepodporované&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Štát/kraj
certificate-viewer-state-province = Štát/provincia
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Sériové číslo
certificate-viewer-signature-algorithm = Algoritmus podpisu
certificate-viewer-signature-scheme = Schéma podpisu
certificate-viewer-timestamp = Časová známka
certificate-viewer-value = Hodnota
certificate-viewer-version = Verzia
certificate-viewer-business-category = Druh spoločnosti
certificate-viewer-subject-name = Názov subjektu
certificate-viewer-issuer-name = Názov vydavateľa
certificate-viewer-validity = Platnosť
certificate-viewer-subject-alt-names = Alternatívne názvy subjektu
certificate-viewer-public-key-info = Informácie o verejnom kľúči
certificate-viewer-miscellaneous = Rôzne
certificate-viewer-fingerprints = Odtlačky
certificate-viewer-basic-constraints = Základné obmedzenia
certificate-viewer-key-usages = Použitia kľúča
certificate-viewer-extended-key-usages = Rozšírené použitia kľúča
certificate-viewer-ocsp-stapling = OCSP Stapling
certificate-viewer-subject-key-id = ID kľúča subjektu
certificate-viewer-authority-key-id = ID kľúča autority
certificate-viewer-authority-info-aia = Informácie o autorite
certificate-viewer-certificate-policies = Pravidlá certifikátu
certificate-viewer-embedded-scts = Vstavané SCTs
certificate-viewer-crl-endpoints = CRL koncové body

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Prevziať
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Áno
       *[false] Nie
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (certifikát)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (reťazec)
    .download = { $fileName }-chain.pem

certificate-viewer-export = Exportovať
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Vaše certifikáty
certificate-viewer-tab-people = Ľudia
certificate-viewer-tab-servers = Servery
certificate-viewer-tab-ca = Autority
certificate-viewer-tab-unkonwn = Neznáme
