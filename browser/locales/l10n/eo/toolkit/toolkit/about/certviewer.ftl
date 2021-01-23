# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Atestilo

## Error messages

certificate-viewer-error-message = Ni ne povis trovi la atestilan informon, aŭ la atestilo estas difektita. Bonvolu klopodi denove.
certificate-viewer-error-title = Io ne bone funkciis.

## Certificate information labels

certificate-viewer-algorithm = Algoritmo
certificate-viewer-certificate-authority = Atestila aŭtoritato
certificate-viewer-cipher-suite = Ĉifraro
certificate-viewer-common-name = Normala nomo
certificate-viewer-email-address = Retpoŝta adreso
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Atestilo por { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Lando
certificate-viewer-country = Lando
certificate-viewer-curve = Kurbo
certificate-viewer-distribution-point = Distribua punkto
certificate-viewer-dns-name = DNS nomo
certificate-viewer-ip-address = Adreso IP
certificate-viewer-other-name = Alia nomo
certificate-viewer-exponent = Eksponento
certificate-viewer-id = Identigilo
certificate-viewer-key-exchange-group = Grupo de interŝanĝo de ŝlosiloj
certificate-viewer-key-id = Identigilo de ŝlosilo
certificate-viewer-key-size = Grando de ŝlosilo
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Sidejo
certificate-viewer-locality = Loko
certificate-viewer-location = Loko
certificate-viewer-logid = Identigilo de registro
certificate-viewer-method = Metodo
certificate-viewer-modulus = Modulo
certificate-viewer-name = Nomo
certificate-viewer-not-after = Ne post
certificate-viewer-not-before = Ne antaŭ
certificate-viewer-organization = Organizo
certificate-viewer-organizational-unit = Organiza unuo (OU)
certificate-viewer-policy = Politiko
certificate-viewer-protocol = Protokolo
certificate-viewer-public-value = Publika valoro
certificate-viewer-purposes = Celoj
certificate-viewer-qualifier = Klasifikilo
certificate-viewer-qualifiers = Kalsifikiloj
certificate-viewer-required = Postulata
certificate-viewer-unsupported = &lt;nesubtenata&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Ŝtato/provinco
certificate-viewer-state-province = Ŝtato/provinco
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Seria numero
certificate-viewer-signature-algorithm = Subskriba algoritmo
certificate-viewer-signature-scheme = Subskriba skemo
certificate-viewer-timestamp = Tempindiko
certificate-viewer-value = Valoro
certificate-viewer-version = Versio
certificate-viewer-business-category = Tipo de negoco
certificate-viewer-subject-name = Nomo de la ricevinto
certificate-viewer-issuer-name = Nomo de la eldoninto
certificate-viewer-validity = Valideco
certificate-viewer-subject-alt-names = Alternativa nomo de la ricevinto
certificate-viewer-public-key-info = Informo pri publika ŝlosilo
certificate-viewer-miscellaneous = Aliaj informoj
certificate-viewer-fingerprints = Ciferecaj fingrospuroj
certificate-viewer-basic-constraints = Bazaj limigoj
certificate-viewer-key-usages = Uzoj de ŝlosilo
certificate-viewer-extended-key-usages = Etenditaj uzoj de ŝlosilo
certificate-viewer-ocsp-stapling = Tempoindiko de OCSP
certificate-viewer-subject-key-id = Identigilo de ŝlosilo de ricevinto
certificate-viewer-authority-key-id = Identigilo de ŝlosilo de aŭtoritato
certificate-viewer-authority-info-aia = Informo pri aŭtoritato (AIA)
certificate-viewer-certificate-policies = Atestilaj politikoj
certificate-viewer-embedded-scts = Enmetitaj SCT
certificate-viewer-crl-endpoints = Ekstrempunktoj CRL

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Elŝuti
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Jes
       *[false] Ne
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (cert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (chain)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Tiu ĉi etendaĵo estis markita kiel gravega. Tio signifas ke klientoj devus rifuzi la atestilon se ili ne komprenas ĝin.
certificate-viewer-export = Elporti
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Viaj atestiloj
certificate-viewer-tab-people = Personoj
certificate-viewer-tab-servers = Serviloj
certificate-viewer-tab-ca = Aŭtoritatoj
certificate-viewer-tab-unkonwn = Nekonata
