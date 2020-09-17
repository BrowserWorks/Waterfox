# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Certificato

## Error messages

certificate-viewer-error-message = Impossibile trovar le informationes del certificato o illo es corrupte. Retenta.
certificate-viewer-error-title = Alco errate eveniva.

## Certificate information labels

certificate-viewer-algorithm = Algorithmo
certificate-viewer-certificate-authority = Autoritate de certificato
certificate-viewer-cipher-suite = Suite de cifra
certificate-viewer-common-name = Nomine commun
certificate-viewer-email-address = Adresse de e-mail
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certificato pro { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Pais de constitution
certificate-viewer-country = Pais
certificate-viewer-curve = Curva
certificate-viewer-distribution-point = Puncto de distribution
certificate-viewer-dns-name = Nomine de DNS
certificate-viewer-ip-address = Adresse IP
certificate-viewer-other-name = Altere nomine
certificate-viewer-exponent = Exponente
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Gruppo de excambio de clave
certificate-viewer-key-id = ID de clave
certificate-viewer-key-size = Dimension de clave
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Loco del interprisa
certificate-viewer-locality = Loco
certificate-viewer-location = Position
certificate-viewer-logid = ID log
certificate-viewer-method = Methodo
certificate-viewer-modulus = Modulo
certificate-viewer-name = Nomine
certificate-viewer-not-after = Non post
certificate-viewer-not-before = Non ante
certificate-viewer-organization = Organisation
certificate-viewer-organizational-unit = Unitate organisative
certificate-viewer-policy = Criterio
certificate-viewer-protocol = Protocollo
certificate-viewer-public-value = Valor del criterio
certificate-viewer-purposes = Propositos
certificate-viewer-qualifier = Qualificator
certificate-viewer-qualifiers = Qualificatores
certificate-viewer-required = Necessari
certificate-viewer-unsupported = &lt;non supportate&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Stato/provincia constitutional
certificate-viewer-state-province = Stato/provincia
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Numero serial
certificate-viewer-signature-algorithm = Algorithmo de firma
certificate-viewer-signature-scheme = Schema de firma
certificate-viewer-timestamp = Marca temporal
certificate-viewer-value = Valor
certificate-viewer-version = Version
certificate-viewer-business-category = Categoria de negotio
certificate-viewer-subject-name = Nomine del subjecto
certificate-viewer-issuer-name = Nomine del emissor
certificate-viewer-validity = Validitate
certificate-viewer-subject-alt-names = Nomines alternative del subjecto
certificate-viewer-public-key-info = Informationes sur le clave public
certificate-viewer-miscellaneous = Miscellanea
certificate-viewer-fingerprints = Dactylogrammas
certificate-viewer-basic-constraints = Limitationes basic
certificate-viewer-key-usages = Utilisationes del claves
certificate-viewer-extended-key-usages = Usos extense del clave
certificate-viewer-ocsp-stapling = Agrafage OCSP
certificate-viewer-subject-key-id = ID del clave del subjecto
certificate-viewer-authority-key-id = ID del clave del autoritate
certificate-viewer-authority-info-aia = Info del autoritate (AIA)
certificate-viewer-certificate-policies = Politicas de certificato
certificate-viewer-embedded-scts = SCT incorporate
certificate-viewer-crl-endpoints = Punctos final CRL

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Discargar
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Sì
       *[false] No
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (certificato)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (catena)
    .download = { $fileName }-catena.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Iste extension era marcate como critic, lo que significa que le clientes debe rejectar le certificato si non lo comprende.
certificate-viewer-export = Exportar
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Tu certificatos
certificate-viewer-tab-people = Personas
certificate-viewer-tab-servers = Servitores
certificate-viewer-tab-ca = Autoritates
certificate-viewer-tab-unkonwn = Incognite
