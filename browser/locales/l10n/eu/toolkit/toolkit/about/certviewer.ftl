# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Ziurtagiria

## Error messages

certificate-viewer-error-message = Ezin dugu ziurtagiriaren informazioa aurkitu edo ziurtagiria hondatuta dago. Saiatu berriro mesedez.
certificate-viewer-error-title = Zerbait gaizki joan da.

## Certificate information labels

certificate-viewer-algorithm = Algoritmoa
certificate-viewer-certificate-authority = Ziurtagiri-autoritatea
certificate-viewer-cipher-suite = Zifratze-suitea
certificate-viewer-common-name = Ohiko izena
certificate-viewer-email-address = Helbide elektronikoa
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = { $firstCertName }(r)ako ziurtagiria
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Sozietate anonimoaren herrialdea
certificate-viewer-country = Herrialdea
certificate-viewer-curve = Kurba
certificate-viewer-distribution-point = Banaketa-puntua
certificate-viewer-dns-name = DNS izena
certificate-viewer-ip-address = IP Helbidea
certificate-viewer-other-name = Bestelako izena
certificate-viewer-exponent = Berretzailea
certificate-viewer-id = IDa
certificate-viewer-key-exchange-group = Gako-trukaketa taldea
certificate-viewer-key-id = Gakoaren IDa
certificate-viewer-key-size = Gakoaren tamaina
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Sorlekua
certificate-viewer-locality = Herria
certificate-viewer-location = Kokalekua
certificate-viewer-logid = Log IDa
certificate-viewer-method = Metodoa
certificate-viewer-modulus = Modulua
certificate-viewer-name = Izena
certificate-viewer-not-after = Ez ondoren
certificate-viewer-not-before = Ez lehenago
certificate-viewer-organization = Erakundea
certificate-viewer-organizational-unit = Erakundearen saila
certificate-viewer-policy = Gidalerroa
certificate-viewer-protocol = Protokoloa
certificate-viewer-public-value = Balio publikoa
certificate-viewer-purposes = Helburuak
certificate-viewer-qualifier = Sailkatzailea
certificate-viewer-qualifiers = Sailkatzaileak
certificate-viewer-required = Beharrezkoa
certificate-viewer-unsupported = &lt;euskarririk ez&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Sozietate anonimoaren estatua/probintzia
certificate-viewer-state-province = Estatua/probintzia
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Serie-zenbakia
certificate-viewer-signature-algorithm = Sinadura-algoritmoa
certificate-viewer-signature-scheme = Sinadura-eskema
certificate-viewer-timestamp = Denbora-marka
certificate-viewer-value = Balioa
certificate-viewer-version = Bertsioa
certificate-viewer-business-category = Enpresaren kategoria
certificate-viewer-subject-name = Hiritarraren izena
certificate-viewer-issuer-name = Jaulkitzailearen izena
certificate-viewer-validity = Balio-epea
certificate-viewer-subject-alt-names = Hiritarren ordezko izenak
certificate-viewer-public-key-info = Gako publikoaren informazioa
certificate-viewer-miscellaneous = Hainbat
certificate-viewer-fingerprints = Hatz-markak
certificate-viewer-basic-constraints = Oinarrizko murriztapenak
certificate-viewer-key-usages = Gakoaren erabilpenak
certificate-viewer-extended-key-usages = Gakoaren erabilpen hedatuak
certificate-viewer-ocsp-stapling = OCSP uztarketa
certificate-viewer-subject-key-id = Hiritarraren gako IDa
certificate-viewer-authority-key-id = Autoritatearen gako IDa
certificate-viewer-authority-info-aia = Autoritatearen informazioa (AIA)
certificate-viewer-certificate-policies = Ziurtagiri-politikak
certificate-viewer-embedded-scts = Kapsulatutako SCTak
certificate-viewer-crl-endpoints = CRL amaiera-puntuak

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Deskargatu
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Bai
       *[false] Ez
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (ziurtagiria)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (katea)
    .download = { $fileName }-katea.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Hedapen hau kritiko gisa markatu da, hau da, bezeroek ziurtagiria ulertzen ez badute, baztertu egin behar dute.
certificate-viewer-export = Esportatu
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Zure ziurtagiriak
certificate-viewer-tab-people = Norbanakoak
certificate-viewer-tab-servers = Zerbitzariak
certificate-viewer-tab-ca = Autoritateak
certificate-viewer-tab-unkonwn = Ezezaguna
