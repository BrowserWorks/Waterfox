# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Digitalno potrdilo

## Error messages

certificate-viewer-error-message = Podatkov o digitalnem potrdilu ni bilo mogoče najti ali pa je potrdilo poškodovano. Poskusite znova.
certificate-viewer-error-title = Prišlo je do napake.

## Certificate information labels

certificate-viewer-algorithm = Algoritem
certificate-viewer-certificate-authority = Uradna oseba za digitalna potrdila
certificate-viewer-cipher-suite = Zbirka šifre
certificate-viewer-common-name = Skupno ime
certificate-viewer-email-address = E-poštni naslov
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Digitalno potrdilo za { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Država ustanovitve
certificate-viewer-country = Država
certificate-viewer-curve = Krivulja
certificate-viewer-distribution-point = Distribucijska točka
certificate-viewer-dns-name = Ime DNS
certificate-viewer-ip-address = Naslov IP
certificate-viewer-other-name = Drugo ime
certificate-viewer-exponent = Eksponent
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Skupina izmenjave ključev
certificate-viewer-key-id = ID ključa
certificate-viewer-key-size = Velikost ključa
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Kraj registracije
certificate-viewer-locality = Kraj
certificate-viewer-location = Lokacija
certificate-viewer-logid = ID dnevnika
certificate-viewer-method = Metoda
certificate-viewer-modulus = Modulo
certificate-viewer-name = Ime
certificate-viewer-not-after = Ne po
certificate-viewer-not-before = Ne pred
certificate-viewer-organization = Organizacija
certificate-viewer-organizational-unit = Organizacijska enota
certificate-viewer-policy = Pravilnik
certificate-viewer-protocol = Protokol
certificate-viewer-public-value = Javna vrednost
certificate-viewer-purposes = Nameni
certificate-viewer-qualifier = Kvalifikator
certificate-viewer-qualifiers = Kvalifikatorji
certificate-viewer-required = Zahtevano
certificate-viewer-unsupported = &lt;nepodprto&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Država/območje registracije
certificate-viewer-state-province = Država/območje
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Serijska številka
certificate-viewer-signature-algorithm = Algoritem podpisa
certificate-viewer-signature-scheme = Podpisna shema
certificate-viewer-timestamp = Časovni žig
certificate-viewer-value = Vrednost
certificate-viewer-version = Različica
certificate-viewer-business-category = Kategorija podjetja
certificate-viewer-subject-name = Ime subjekta
certificate-viewer-issuer-name = Ime izdajatelja
certificate-viewer-validity = Veljavnost
certificate-viewer-subject-alt-names = Alternativna imena subjekta
certificate-viewer-public-key-info = Podatki o javnem ključu
certificate-viewer-miscellaneous = Razno
certificate-viewer-fingerprints = Prstni odtisi
certificate-viewer-basic-constraints = Osnovne omejitve
certificate-viewer-key-usages = Raba ključa
certificate-viewer-extended-key-usages = Razširjena raba ključa
certificate-viewer-ocsp-stapling = Spenjanje OCSP
certificate-viewer-subject-key-id = ID ključa subjekta
certificate-viewer-authority-key-id = ID ključa uradne osebe
certificate-viewer-authority-info-aia = Podatki o uradni osebi (AIA)
certificate-viewer-certificate-policies = Politika digitalnih potrdil
certificate-viewer-embedded-scts = Vgrajeni SCT-ji
certificate-viewer-crl-endpoints = Končne točke CRL

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Prenesi
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Da
       *[false] Ne
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (potrdilo)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (veriga)
    .download = { $fileName }-veriga.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Ta razširitev je bila označena kot kritična, kar pomeni, da morajo uporabniki zavrniti potrdilo, če ga ne razumejo.
certificate-viewer-export = Izvozi
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Vaša digitalna potrdila
certificate-viewer-tab-people = Ljudje
certificate-viewer-tab-servers = Strežniki
certificate-viewer-tab-ca = Overitelji
certificate-viewer-tab-unkonwn = Neznano
