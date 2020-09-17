# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Certifikat

## Error messages

certificate-viewer-error-message = Nismo mogli pronaći informacije o certifikatu ili je certifikat oštećen. Pokušaj ponovo.
certificate-viewer-error-title = Nešto je pošlo naopako.

## Certificate information labels

certificate-viewer-algorithm = Algoritam
certificate-viewer-certificate-authority = Certifikacijsko tijelo
certificate-viewer-cipher-suite = Skup šifratora
certificate-viewer-common-name = Uobičajeni naziv
certificate-viewer-email-address = Adresa e-pošte
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certifikat za { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Država osnivanja
certificate-viewer-country = Država
certificate-viewer-curve = Krivulja
certificate-viewer-distribution-point = Distribucijska točka
certificate-viewer-dns-name = DNS naziv
certificate-viewer-ip-address = IP adresa
certificate-viewer-other-name = Drugo ime
certificate-viewer-exponent = Potencija
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Grupa razmjene ključeva
certificate-viewer-key-id = ID ključa
certificate-viewer-key-size = Veličina ključa
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Mjesto osnivanja
certificate-viewer-locality = Područje
certificate-viewer-location = Lokacija
certificate-viewer-logid = ID dnevnika
certificate-viewer-method = Metoda
certificate-viewer-modulus = Modul
certificate-viewer-name = Naziv
certificate-viewer-not-after = Ne nakon
certificate-viewer-not-before = Ne prije
certificate-viewer-organization = Organizacija
certificate-viewer-organizational-unit = Poslovna jedinica
certificate-viewer-policy = Pravila
certificate-viewer-protocol = Protokol
certificate-viewer-public-value = Javna vrijednost
certificate-viewer-purposes = Svrhe
certificate-viewer-qualifier = Kvalifikator
certificate-viewer-qualifiers = Kvalifikatori
certificate-viewer-required = Obavezno
certificate-viewer-unsupported = &lt;nepodržano&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Država/pokrajina
certificate-viewer-state-province = Država/pokrajina
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Serijski broj
certificate-viewer-signature-algorithm = Algoritam potpisa
certificate-viewer-signature-scheme = Shema potpisa
certificate-viewer-timestamp = Vremenska oznaka
certificate-viewer-value = Vrijednost
certificate-viewer-version = Verzija
certificate-viewer-business-category = Kategorija poslovanja
certificate-viewer-subject-name = Naziv predmeta
certificate-viewer-issuer-name = Ime izdavača
certificate-viewer-validity = Valjanost
certificate-viewer-subject-alt-names = Alternativni nazivi predmeta
certificate-viewer-public-key-info = Informacije o javnom ključu
certificate-viewer-miscellaneous = Razno
certificate-viewer-fingerprints = Otisci prstiju
certificate-viewer-basic-constraints = Osnovna ograničenja
certificate-viewer-key-usages = Upotrebe ključa
certificate-viewer-extended-key-usages = Proširena upotrebe ključa
certificate-viewer-ocsp-stapling = OCSP potvrđivanje
certificate-viewer-subject-key-id = ID ključa predmeta
certificate-viewer-authority-key-id = ID ključa certifikacijskog tijela
certificate-viewer-authority-info-aia = Podaci certifikacijskog tijela (AIA)
certificate-viewer-certificate-policies = Pravila certifikata
certificate-viewer-embedded-scts = Ugrađeni SCT-ovi
certificate-viewer-crl-endpoints = Krajnje točke CRL-a

# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Preuzmi
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

certificate-viewer-download-pem = PEM (certifikat)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (lanac)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Ovaj dodatak je označen kao kritičan, što znači da klijenti moraju odbaciti certifikat ukoliko ga ne razumiju.
certificate-viewer-export = Izvoz
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Tvoji certifikati
certificate-viewer-tab-people = Osobe
certificate-viewer-tab-servers = Poslužitelji
certificate-viewer-tab-ca = Certifikacijska tijela
certificate-viewer-tab-unkonwn = Nepoznato
