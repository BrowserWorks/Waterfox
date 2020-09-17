# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Certificado

## Error messages

certificate-viewer-error-message = No pudimos encontrar la información del certificado o el certificado es corrupto. Pruebe de nuevo.
certificate-viewer-error-title = Algo salió mal

## Certificate information labels

certificate-viewer-algorithm = Algoritmo
certificate-viewer-certificate-authority = Autoridad de certificación
certificate-viewer-cipher-suite = Suite de cifrado
certificate-viewer-common-name = Nombre habitual
certificate-viewer-email-address = Dirección de correo electrónico
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certificado para { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = País
certificate-viewer-country = País
certificate-viewer-curve = Curva
certificate-viewer-distribution-point = Punto de distribución
certificate-viewer-dns-name = Nombre DNS
certificate-viewer-ip-address = Dirección IP
certificate-viewer-other-name = Otro nombre
certificate-viewer-exponent = Exponente
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Grupo de intercambio de claves
certificate-viewer-key-id = ID clave
certificate-viewer-key-size = Tamaño de la clave
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Inc. Localidad
certificate-viewer-locality = Ubicación
certificate-viewer-location = Ubicación
certificate-viewer-logid = ID de registro
certificate-viewer-method = Método
certificate-viewer-modulus = Módulo
certificate-viewer-name = Nombre
certificate-viewer-not-after = No después de
certificate-viewer-not-before = No antes de
certificate-viewer-organization = Organización
certificate-viewer-organizational-unit = Unidad Organizacional
certificate-viewer-policy = Política
certificate-viewer-protocol = Protocolo
certificate-viewer-public-value = Valor público
certificate-viewer-purposes = Propósitos
certificate-viewer-qualifier = Calificador
certificate-viewer-qualifiers = Calificadores
certificate-viewer-required = Necesario
certificate-viewer-unsupported = &lt;no compatible&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Estado/provincia
certificate-viewer-state-province = Estado/provincia
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Número de serie
certificate-viewer-signature-algorithm = Algoritmo de la firma
certificate-viewer-signature-scheme = Esquema de la firma
certificate-viewer-timestamp = Fecha y hora
certificate-viewer-value = Valor
certificate-viewer-version = Versión
certificate-viewer-business-category = Categoría de negocios
certificate-viewer-subject-name = Nombre del asunto
certificate-viewer-issuer-name = Nombre del emisor
certificate-viewer-validity = Validez
certificate-viewer-subject-alt-names = Nombres alternativos del sujeto
certificate-viewer-public-key-info = Información de clave pública
certificate-viewer-miscellaneous = Miscelánea
certificate-viewer-fingerprints = Huellas digitales
certificate-viewer-basic-constraints = Restricciones básicas
certificate-viewer-key-usages = Usos principales
certificate-viewer-extended-key-usages = Usos principales extendidos
certificate-viewer-ocsp-stapling = OCSP Principal
certificate-viewer-subject-key-id = ID de clave de asunto
certificate-viewer-authority-key-id = ID de clave de autoridad
certificate-viewer-authority-info-aia = Información de la autoridad (AIA)
certificate-viewer-certificate-policies = Políticas de certificado
certificate-viewer-embedded-scts = SCT integrados
certificate-viewer-crl-endpoints = Puntos finales de CRL

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Descargar
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
    .title = Esta extensión fue marcada como crítica, lo que significa que los clientes deben rechazar el certificado si no lo entienden.
certificate-viewer-export = Exportar
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Tus certificados
certificate-viewer-tab-people = Personas
certificate-viewer-tab-servers = Servidores
certificate-viewer-tab-ca = Autoridades
certificate-viewer-tab-unkonwn = Desconocido
