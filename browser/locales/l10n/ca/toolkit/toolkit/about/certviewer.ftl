# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Certificat

## Error messages

certificate-viewer-error-message = No s'ha trobat la informació del certificat o el certificat està malmès. Torneu-ho a provar.
certificate-viewer-error-title = Alguna cosa ha anat malament.

## Certificate information labels

certificate-viewer-algorithm = Algorisme
certificate-viewer-certificate-authority = Entitat certificadora
certificate-viewer-cipher-suite = Entorn de xifratge
certificate-viewer-common-name = Nom comú
certificate-viewer-email-address = Adreça electrònica
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certificat per a { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = País (empresa)
certificate-viewer-country = País
certificate-viewer-curve = Corba
certificate-viewer-distribution-point = Punt de distribució
certificate-viewer-dns-name = Nom DNS
certificate-viewer-ip-address = Adreça IP
certificate-viewer-other-name = Nom alternatiu
certificate-viewer-exponent = Exponent
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Grup d'intercanvi de claus
certificate-viewer-key-id = ID de la clau
certificate-viewer-key-size = Mida de la clau
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Localitat (empresa)
certificate-viewer-locality = Localitat
certificate-viewer-location = Ubicació
certificate-viewer-logid = ID de registre
certificate-viewer-method = Mètode
certificate-viewer-modulus = Mòdul
certificate-viewer-name = Nom
certificate-viewer-not-after = No després
certificate-viewer-not-before = No abans
certificate-viewer-organization = Organització
certificate-viewer-organizational-unit = Unitat organitzativa
certificate-viewer-policy = Política
certificate-viewer-protocol = Protocol
certificate-viewer-public-value = Valor públic
certificate-viewer-purposes = Finalitats
certificate-viewer-qualifier = Qualificador
certificate-viewer-qualifiers = Qualificadors
certificate-viewer-required = Obligatori
certificate-viewer-unsupported = &lt;incompatible&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Estat/província (empresa)
certificate-viewer-state-province = Estat/província
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Número de sèrie
certificate-viewer-signature-algorithm = Algorisme de signatura
certificate-viewer-signature-scheme = Esquema de signatura
certificate-viewer-timestamp = Marca horària
certificate-viewer-value = Valor
certificate-viewer-version = Versió
certificate-viewer-business-category = Categoria empresarial
certificate-viewer-subject-name = Nom del subjecte
certificate-viewer-issuer-name = Nom de l'emissor
certificate-viewer-validity = Validesa
certificate-viewer-subject-alt-names = Noms alternatius del subjecte
certificate-viewer-public-key-info = Informació sobre la clau pública
certificate-viewer-miscellaneous = Altres
certificate-viewer-fingerprints = Empremtes digitals
certificate-viewer-basic-constraints = Restriccions bàsiques
certificate-viewer-key-usages = Usos de la clau
certificate-viewer-extended-key-usages = Usos de la clau ampliats
certificate-viewer-ocsp-stapling = Marca horària OCSP
certificate-viewer-subject-key-id = Identificador de la clau del subjecte
certificate-viewer-authority-key-id = Identificador de la clau de l'entitat certificadora
certificate-viewer-authority-info-aia = Informació de l'entitat certificadora (AIA)
certificate-viewer-certificate-policies = Polítiques de certificats
certificate-viewer-embedded-scts = SCT incrustats
certificate-viewer-crl-endpoints = Punts finals CRL
# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Baixa
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Sí
       *[false] No
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (cert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (cadena)
    .download = { $fileName }-chain.pem
# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Aquesta extensió s'ha marcat com a crítica, que significa que els clients han de rebutjar el certificat si no l'entenen.
certificate-viewer-export = Exporta
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Els vostres certificats
certificate-viewer-tab-people = Persones
certificate-viewer-tab-servers = Servidors
certificate-viewer-tab-ca = Entitats
certificate-viewer-tab-unkonwn = Desconegut
