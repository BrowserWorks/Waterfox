# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Ruwujil b'i'aj

## Error messages

certificate-viewer-error-message = Man xqïl ta retamab'al iqitzijib'äl o itzel chi iqitzijib'äl. Tatojtob'ej chik.
certificate-viewer-error-title = K'o itzel xub'än.

## Certificate information labels

certificate-viewer-algorithm = Alworit
certificate-viewer-certificate-authority = SSL Taqonel Taqöy Ruwujil B'i'aj
certificate-viewer-cipher-suite = Molaj taq man Etaman ta:
certificate-viewer-common-name = Relik Rub'i'
certificate-viewer-email-address = Rochochib'al Taqoya'l
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Ruwujil { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Amaq'
certificate-viewer-country = Amaq'
certificate-viewer-curve = Nik'set
certificate-viewer-distribution-point = Ruk'ojlemal Jachoj
certificate-viewer-dns-name = DNS B'i'aj
certificate-viewer-ip-address = IP Ochochib'äl
certificate-viewer-other-name = Jun Chik B'i'aj
certificate-viewer-exponent = Eponen
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Rujalwachinik Ruxe'el Tzij Molaj:
certificate-viewer-key-id = ID ewan tzij
certificate-viewer-key-size = Runimilem Ewan
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Inc. K'ojlib'äl
certificate-viewer-locality = Tinamital
certificate-viewer-location = K'ojlib'äl
certificate-viewer-logid = Tz'ib'anïk ID
certificate-viewer-method = B'eyal
certificate-viewer-modulus = Tanaj
certificate-viewer-name = B'i'aj
certificate-viewer-not-after = Man Chi Rij Ta
certificate-viewer-not-before = Man Chuwa Ta
certificate-viewer-organization = Moloj
certificate-viewer-organizational-unit = Ruq'a' Moloj
certificate-viewer-policy = Na'ojil
certificate-viewer-protocol = Rub'eyal Samaj
certificate-viewer-public-value = Rejqalem Winaqilal
certificate-viewer-purposes = Taq ojqanem
certificate-viewer-qualifier = Ya'öl Rejqalem
certificate-viewer-qualifiers = Taq Ya'öl Rejqalem
certificate-viewer-required = Ajowan
certificate-viewer-unsupported = &lt;man k'amonel ta&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Inc. Amaq'/Province:
certificate-viewer-state-province = Amaq'/Province:
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Rucholajem rajilab'al
certificate-viewer-signature-algorithm = Ralgoritmo Jux
certificate-viewer-signature-scheme = Ruchib'al Juch'b'i'aj
certificate-viewer-timestamp = Retal q'ijul
certificate-viewer-value = Retal
certificate-viewer-version = Ruwäch
certificate-viewer-business-category = Ruwäch K'ayij
certificate-viewer-subject-name = Rub'i' Taqikil
certificate-viewer-issuer-name = Rub'i' ya'onel
certificate-viewer-validity = Ruq'ijul
certificate-viewer-subject-alt-names = Jun Chik Rub'i'
certificate-viewer-public-key-info = Retamab'al Winaqil Ewan
certificate-viewer-miscellaneous = K'ib'anob'äl
certificate-viewer-fingerprints = Retal taq ruwi' q'ab'aj
certificate-viewer-basic-constraints = Temel taq Q'atoj
certificate-viewer-key-usages = Nïm taq Okisanïk
certificate-viewer-extended-key-usages = Ruwi' Rokisaxik ri Ewan Tzij
certificate-viewer-ocsp-stapling = OCSP Tata'aj
certificate-viewer-subject-key-id = ID Ruxe' Taqikil
certificate-viewer-authority-key-id = ID Ruxe' Taqonelal
certificate-viewer-authority-info-aia = Retamab'al Taqonel (AIA)
certificate-viewer-certificate-policies = Taq Kina'ojil Ruwujil B'i'aj
certificate-viewer-embedded-scts = Ronojel SCTs
certificate-viewer-crl-endpoints = CRL K'isib'äl k'ojlemal

# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Tiqasäx
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Ja'
       *[false] Mani
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (cert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (cadena)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Re k'amal re' xya' retal achi'el chi k'ayew rik'in, ri nuq'ajuj chi ri ruwinaq k'o chi nikixutuj ri wujil we man niq'ax ta pa kiwi'.
certificate-viewer-export = Tik'wäx el
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Taq Ruwujil Ab'i'
certificate-viewer-tab-people = Winaqi'
certificate-viewer-tab-servers = Taq ruk'u'x samaj
certificate-viewer-tab-ca = K'amöl taq b'ey
certificate-viewer-tab-unkonwn = Man etaman ta ruwäch
