# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Certificado

## Error messages

certificate-viewer-error-message = Non puidemos atopar a información do certificado ou o certificado está corrompido. Por favor, inténteo de novo.
certificate-viewer-error-title = Algo saíu mal.

## Certificate information labels

certificate-viewer-algorithm = Algoritmo
certificate-viewer-certificate-authority = Autoridade de certificación
certificate-viewer-cipher-suite = Suite criptográfica
certificate-viewer-common-name = Nome común
certificate-viewer-email-address = Enderezo de correo electrónico
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certificado para { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = País da sede
certificate-viewer-country = País
certificate-viewer-curve = Curva
certificate-viewer-distribution-point = Punto de distribución
certificate-viewer-dns-name = Nome do DNS
certificate-viewer-ip-address = Enderezo de IP
certificate-viewer-other-name = Outro nome
certificate-viewer-exponent = Expoñente
certificate-viewer-id = Identificador
certificate-viewer-key-exchange-group = Grupo de intercambio de chaves
certificate-viewer-key-id = Identificador da clave
certificate-viewer-key-size = Tamaño da chave
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Localidade da sede
certificate-viewer-locality = Localidade
certificate-viewer-location = Localización
certificate-viewer-logid = ID de rexistro
certificate-viewer-method = Método
certificate-viewer-modulus = Módulo
certificate-viewer-name = Nome
certificate-viewer-not-after = Non posterior a
certificate-viewer-not-before = Non antes de
certificate-viewer-organization = Organización
certificate-viewer-organizational-unit = Unidade organizativa
certificate-viewer-policy = Política
certificate-viewer-protocol = Protocolo
certificate-viewer-public-value = Valor Público
certificate-viewer-purposes = Finalidades
certificate-viewer-qualifier = Cualificador
certificate-viewer-qualifiers = Cualificadores
certificate-viewer-required = Obrigatorio
certificate-viewer-unsupported = &lt;incompatíbel&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Estado/Provincia da sede
certificate-viewer-state-province = Estado/Provincia
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Número de serie
certificate-viewer-signature-algorithm = Algoritmo de sinatura
certificate-viewer-signature-scheme = Réxime de sinaturas
certificate-viewer-timestamp = Marca temporal
certificate-viewer-value = Valor
certificate-viewer-version = Versión
certificate-viewer-business-category = Categoría comercial
certificate-viewer-subject-name = Nome do asunto
certificate-viewer-issuer-name = Nome do emisor
certificate-viewer-validity = Validez
certificate-viewer-subject-alt-names = Nomes alternativos do asunto
certificate-viewer-public-key-info = Información de clave pública
certificate-viewer-miscellaneous = Diversos
certificate-viewer-fingerprints = Pegadas dixitais
certificate-viewer-basic-constraints = Restricións básicas
certificate-viewer-key-usages = Usos clave
certificate-viewer-extended-key-usages = Usos estendidos da chave
certificate-viewer-ocsp-stapling = Marcado OCSP
certificate-viewer-subject-key-id = Identificador de clave do asunto
certificate-viewer-authority-key-id = Identificación de clave de autoridade
certificate-viewer-authority-info-aia = Información da autoridade (AIA)
certificate-viewer-certificate-policies = Políticas do certificado
certificate-viewer-embedded-scts = SCT incorporados
certificate-viewer-crl-endpoints = Puntos de destino de CRL
# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Descargar
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Si
       *[false] Non
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (cert)
    .download = { $fileName }. pem
certificate-viewer-download-pem-chain = PEM (cadea)
    .download = { $fileName }-cadea.pem
# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Esta extensión foi marcada como crítica, o que significa que os clientes deben rexeitar o certificado se non o entenden.
certificate-viewer-export = Exportar
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Os seus certificados
certificate-viewer-tab-people = Persoas
certificate-viewer-tab-servers = Servidores
certificate-viewer-tab-ca = Autoridades
certificate-viewer-tab-unkonwn = Descoñecido
