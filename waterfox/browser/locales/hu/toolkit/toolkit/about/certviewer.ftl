# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Tanúsítvány

## Error messages

certificate-viewer-error-message = A tanúsítványinformációkat nem sikerült megtalálni, vagy a tanúsítvány sérült. Próbálja újra.
certificate-viewer-error-title = Valami hiba történt.

## Certificate information labels

certificate-viewer-algorithm = Algoritmus
certificate-viewer-certificate-authority = Hitelesítésszolgáltató
certificate-viewer-cipher-suite = Titkosító csomag
certificate-viewer-common-name = Általános név
certificate-viewer-email-address = E-mail cím
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = A(z) { $firstCertName } tanúsítványa
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Szervezet országa
certificate-viewer-country = Ország
certificate-viewer-curve = Görbe
certificate-viewer-distribution-point = Terjesztési pont
certificate-viewer-dns-name = Tartománynév
certificate-viewer-ip-address = IP-cím
certificate-viewer-other-name = Egyéb név
certificate-viewer-exponent = Kitevő
certificate-viewer-id = Azonosító
certificate-viewer-key-exchange-group = Kulcscsere csoport
certificate-viewer-key-id = Kulcsazonosító
certificate-viewer-key-size = Kulcsméret
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Bejegyzés helyszíne
certificate-viewer-locality = Helység
certificate-viewer-location = Hely
certificate-viewer-logid = Naplóazonosító
certificate-viewer-method = Módszer
certificate-viewer-modulus = Modulus
certificate-viewer-name = Név
certificate-viewer-not-after = Vége
certificate-viewer-not-before = Kezdete
certificate-viewer-organization = Szervezet
certificate-viewer-organizational-unit = Szervezeti egység
certificate-viewer-policy = Irányelv
certificate-viewer-protocol = Protokoll
certificate-viewer-public-value = Nyilvános érték
certificate-viewer-purposes = Célok
certificate-viewer-qualifier = Minősítő
certificate-viewer-qualifiers = Minősítők
certificate-viewer-required = Kötelező
certificate-viewer-unsupported = &lt;nem támogatott&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Szervezet állama/tartománya
certificate-viewer-state-province = Állam/tartomány
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Sorozatszám
certificate-viewer-signature-algorithm = Aláírási algoritmus
certificate-viewer-signature-scheme = Aláírási séma
certificate-viewer-timestamp = Időbélyeg
certificate-viewer-value = Érték
certificate-viewer-version = Verzió
certificate-viewer-business-category = Üzleti kategória
certificate-viewer-subject-name = Tárgy neve
certificate-viewer-issuer-name = Kibocsátó neve
certificate-viewer-validity = Érvényesség
certificate-viewer-subject-alt-names = Tárgy alternatív nevei
certificate-viewer-public-key-info = Nyilvános kulcs információ
certificate-viewer-miscellaneous = Egyebek
certificate-viewer-fingerprints = Ujjlenyomatok
certificate-viewer-basic-constraints = Alapvető korlátozások
certificate-viewer-key-usages = Kulcs felhasználások
certificate-viewer-extended-key-usages = Bővített kulcs felhasználások
certificate-viewer-ocsp-stapling = OCSP-rögzítés
certificate-viewer-subject-key-id = Tárgy kulcsazonosítója
certificate-viewer-authority-key-id = Hitelesítő kulcsazonosítója
certificate-viewer-authority-info-aia = Hitelesítői információk (AIA)
certificate-viewer-certificate-policies = Tanúsítvány házirendek
certificate-viewer-embedded-scts = Beágyazott SCT-k
certificate-viewer-crl-endpoints = CRL végpontok

# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Letöltés
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Igen
       *[false] Nem
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (tanúsítvány)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (lánc)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Ez a kiegészítő kritikusként lett megjelölve, ami azt jelenti, hogy a klienseknek el kell utasítaniuk a tanúsítványt, ha nem értik azt.
certificate-viewer-export = Exportálás
    .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (ismeretlen)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Saját tanúsítványok
certificate-viewer-tab-people = Emberek
certificate-viewer-tab-servers = Kiszolgálók
certificate-viewer-tab-ca = Hitelesítésszolgáltatók
certificate-viewer-tab-unkonwn = Ismeretlen
