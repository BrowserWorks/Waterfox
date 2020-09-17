# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Certificat

## Error messages

certificate-viewer-error-message = Avèm pas pogut encontrar las informacions de certificat o lo certificat es corromput. Tornatz assajar.
certificate-viewer-error-title = I a quicòm que truca.

## Certificate information labels

certificate-viewer-algorithm = Algoritme
certificate-viewer-certificate-authority = Autoritat de certificacion
certificate-viewer-cipher-suite = Seria de chiframent
certificate-viewer-common-name = Nom comun
certificate-viewer-email-address = Adreça electronica
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certificat per { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = País d’enregistrament
certificate-viewer-country = País
certificate-viewer-curve = Corba
certificate-viewer-distribution-point = Punt de distribucion
certificate-viewer-dns-name = Nom DNS
certificate-viewer-ip-address = Adreça IP
certificate-viewer-other-name = Autre nom
certificate-viewer-exponent = Exponent
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Grop d’escambi de claus
certificate-viewer-key-id = ID de la clau
certificate-viewer-key-size = Talha de clau
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Sèti social
certificate-viewer-locality = Localitat
certificate-viewer-location = Emplaçament
certificate-viewer-logid = ID de jornal
certificate-viewer-method = Metòde
certificate-viewer-modulus = Modul
certificate-viewer-name = Nom
certificate-viewer-not-after = Pas aprèp
certificate-viewer-not-before = Pas abans
certificate-viewer-organization = Organizacion
certificate-viewer-organizational-unit = Unitat d'organizacion
certificate-viewer-policy = Politica
certificate-viewer-protocol = Protocòl
certificate-viewer-public-value = Valor publica
certificate-viewer-purposes = Usatges
certificate-viewer-qualifier = Qualificatiu
certificate-viewer-qualifiers = Qualificatius
certificate-viewer-required = Requesit
certificate-viewer-unsupported = &lt;non pres en carga&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Estat/Província d’enregistrament
certificate-viewer-state-province = Estat/Província
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Numèro de seria
certificate-viewer-signature-algorithm = Signatura algoritmica
certificate-viewer-signature-scheme = Esquèma de signatura
certificate-viewer-timestamp = Orodatatge
certificate-viewer-value = Valor
certificate-viewer-version = Version
certificate-viewer-business-category = Categoria d'entrepresa
certificate-viewer-subject-name = Nom del subjècte
certificate-viewer-issuer-name = Nom de l’emissor
certificate-viewer-validity = Validitat
certificate-viewer-subject-alt-names = Noms alternatius del subjècte
certificate-viewer-public-key-info = Informacion sus la clau publica
certificate-viewer-miscellaneous = Divèrs
certificate-viewer-fingerprints = Emprentas numericas
certificate-viewer-basic-constraints = Restriccions basicas
certificate-viewer-key-usages = Usatge de la clau
certificate-viewer-extended-key-usages = Usatges espandits de la clau
certificate-viewer-ocsp-stapling = Marca orària OCSP
certificate-viewer-subject-key-id = Identificant de la clau del subjècte
certificate-viewer-authority-key-id = Identificant de la clau de l'autoritat
certificate-viewer-authority-info-aia = Informacion sus l'autoritat (AIA)
certificate-viewer-certificate-policies = Politicas del certificat
certificate-viewer-embedded-scts = SCT integrats
certificate-viewer-crl-endpoints = Punts finals CRL

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Telecargar
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Òc
       *[false] Non
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (cert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (chain)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Aquesta extension foguèt marcada coma critica, vòl dire que los clients devon regetar lo certificat se lo comprenon pas.
certificate-viewer-export = Exportar
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Vòstres certificats
certificate-viewer-tab-people = Personas
certificate-viewer-tab-servers = Servidors
certificate-viewer-tab-ca = Autoritats
certificate-viewer-tab-unkonwn = Desconegut
