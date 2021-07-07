# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Certyfikat

## Error messages

certificate-viewer-error-message = Nie można odnaleźć informacji o certyfikacie lub certyfikat jest uszkodzony. Proszę spróbować ponownie.
certificate-viewer-error-title = Coś się nie powiodło.

## Certificate information labels

certificate-viewer-algorithm = Algorytm
certificate-viewer-certificate-authority = Organ certyfikacji
certificate-viewer-cipher-suite = Szyfr
certificate-viewer-common-name = Nazwa pospolita
certificate-viewer-email-address = Adres e-mail
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certyfikat dla „{ $firstCertName }”
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Państwo założenia
certificate-viewer-country = Państwo
certificate-viewer-curve = Krzywa
certificate-viewer-distribution-point = Punkt dystrybucji
certificate-viewer-dns-name = Nazwa DNS
certificate-viewer-ip-address = Adres IP
certificate-viewer-other-name = Inna nazwa
certificate-viewer-exponent = Wykładnik
certificate-viewer-id = Identyfikator
certificate-viewer-key-exchange-group = Grupa wymiany kluczy
certificate-viewer-key-id = Identyfikator klucza
certificate-viewer-key-size = Rozmiar klucza
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Region założenia
certificate-viewer-locality = Region
certificate-viewer-location = Położenie
certificate-viewer-logid = Identyfikator dziennika
certificate-viewer-method = Metoda
certificate-viewer-modulus = Modulo
certificate-viewer-name = Nazwa
certificate-viewer-not-after = Nieważny po
certificate-viewer-not-before = Nieważny przed
certificate-viewer-organization = Organizacja
certificate-viewer-organizational-unit = Jednostka organizacyjna
certificate-viewer-policy = Zasady
certificate-viewer-protocol = Protokół
certificate-viewer-public-value = Wartość publiczna
certificate-viewer-purposes = Zastosowania
certificate-viewer-qualifier = Kwalifikator
certificate-viewer-qualifiers = Kwalifikatory
certificate-viewer-required = Wymagane
certificate-viewer-unsupported = &lt;nieobsługiwane&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Województwo założenia
certificate-viewer-state-province = Województwo
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Numer seryjny
certificate-viewer-signature-algorithm = Algorytm podpisu
certificate-viewer-signature-scheme = Schemat podpisu
certificate-viewer-timestamp = Czas
certificate-viewer-value = Wartość
certificate-viewer-version = Wersja
certificate-viewer-business-category = Rodzaj firmy
certificate-viewer-subject-name = Nazwa podmiotu
certificate-viewer-issuer-name = Nazwa wystawcy
certificate-viewer-validity = Ważność
certificate-viewer-subject-alt-names = Alternatywne nazwy podmiotu
certificate-viewer-public-key-info = Informacje o kluczu publicznym
certificate-viewer-miscellaneous = Różne
certificate-viewer-fingerprints = Odciski
certificate-viewer-basic-constraints = Podstawowe ograniczenia
certificate-viewer-key-usages = Zastosowania klucza
certificate-viewer-extended-key-usages = Rozszerzone zastosowania klucza
certificate-viewer-ocsp-stapling = Podpięcie OCSP
certificate-viewer-subject-key-id = Identyfikator klucza podmiotu
certificate-viewer-authority-key-id = Identyfikator klucza organu
certificate-viewer-authority-info-aia = Informacje o organie (AIA)
certificate-viewer-certificate-policies = Zasady certyfikatu
certificate-viewer-embedded-scts = Osadzone SCT
certificate-viewer-crl-endpoints = Punkty końcowe CRL
# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Pobierz
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Tak
       *[false] Nie
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (certyfikat)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (łańcuch)
    .download = { $fileName }-łańcuch.pem
# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = To rozszerzenie zostało oznaczone jako krytyczne, co oznacza, że klienci muszą odrzucić certyfikat, jeśli go nie rozumieją.
certificate-viewer-export = Eksportuj
    .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (nieznane)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Użytkownik
certificate-viewer-tab-people = Osoby
certificate-viewer-tab-servers = Serwery
certificate-viewer-tab-ca = Organy certyfikacji
certificate-viewer-tab-unkonwn = Nieznane
