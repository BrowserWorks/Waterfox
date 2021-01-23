# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = Un error ocurrió durante una conexión a { $hostname } porque usa un certificado de seguridad no válido.

cert-error-mitm-intro = Los sitios web demuestran su identidad a través de certificados que son emitidos por las autoridades de certificación.

cert-error-mitm-mozilla = { -brand-short-name } está respaldado por Mozilla, la organización sin fines de lucro que administra un almacén de autoridad de certificados (CA) completamente abierto. La tienda de CA ayuda a garantizar que las autoridades de certificación sigan las mejores prácticas para la seguridad del usuario.

cert-error-mitm-connection = { -brand-short-name } usa el almacén de Mozilla CA para verificar que la conexión sea segura, en lugar de los certificados proporcionados por el sistema operativo del usuario. Por lo tanto, si un programa antivirus o una red está interceptando una conexión con un certificado de seguridad emitido por una CA que no está en el almacén de la CA de Mozilla, la conexión se considera insegura.

cert-error-trust-unknown-issuer-intro = Alguien podría estar intentando imitar el sitio y usted no debería continuar.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Los sitios web prueban su identidad a través de certificados. { -brand-short-name } no confía en { $hostname } porque su emisor del certificado es desconocido, el certificado es autofirmado, o el servidor no envía los certificados intermedios correctos.

cert-error-trust-cert-invalid = El certificado no es confiable porque fue emitido por una CA no válida.

cert-error-trust-untrusted-issuer = El certificado no es confiable porque el certificado del emisor no es confiable.

cert-error-trust-signature-algorithm-disabled = El certificado no es confiable porque fue firmado usando un algoritmo que fue deshabilitado porque no es seguro.

cert-error-trust-expired-issuer = El certificado no es confiable porque el certificado del emisor ha expirado.

cert-error-trust-self-signed = El certificado no es confiable porque es auto firmado.

cert-error-trust-symantec = Los certificados emitidos por GeoTrust, RapidSSL, Symantec, Thawte y VeriSign ya no se consideran seguros porque estas autoridades de certificación no siguieron las prácticas de seguridad en el pasado.

cert-error-untrusted-default = El certificado no viene de una fuente confiable.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Los sitios web prueban su identidad a través de certificados. { -brand-short-name } no confía en este sitio porque usa un certificado que no es válido para { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Los sitios web prueban su identidad a través de certificados. { -brand-short-name } no confía en este sitio porque usa un certificado que no es válido para { $hostname }. El certificado es válido solamente para <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Los sitios web prueban su identidad a través de certificados. { -brand-short-name } no confía en este sitio porque usa un certificado que no es válido para { $hostname }. El certificado es válido solamente para { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Los sitios web prueban su identidad a través de certificados. { -brand-short-name } no confía en este sitio porque usa un certificado que no es válido para { $hostname }. El certificado solo es válido para los siguientes nombres: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Los sitios web demuestran su identidad mediante certificados, que son válidos durante un cierto periodo de tiempo. El certificado para { $hostname } dejó de ser válido en { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Los sitios web demuestran su identidad mediante certificados, que son válidos durante un cierto periodo de tiempo. El certificado para { $hostname } solo será válido a partir de { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Código de error: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Los sitios web prueban su identidad a través de certificados que son emitidos por las autoridades de certificación. La mayoría de los navegadores ya no confían en los certificados emitidos por GeoTrust, RapidSSL, Symantec, Thawte y VeriSign. { $hostname } usa un certificado de una de estas autoridades y, por lo tanto, no se puede probar la identidad del sitio web.

cert-error-symantec-distrust-admin = Puede notificar al administrador del sitio web acerca de este problema.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = Seguridad de transporte estricto HTTP: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Cadena de certificados:

open-in-new-window-for-csp-or-xfo-error = Abrir sitio en una ventana nueva

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Para proteger su seguridad, { $hostname } no permitirá que { -brand-short-name } muestre la página si otro sitio la ha incrustado. Para ver esta página, debe abrirla en una nueva ventana.

## Messages used for certificate error titles

connectionFailure-title = No se puede conectar
deniedPortAccess-title = Esta dirección está restringida
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Estamos teniendo problemas encontrando ese sitio.
fileNotFound-title = Archivo no encontrado
fileAccessDenied-title = Acceso denegado al archivo
generic-title = Oops.
captivePortal-title = Ingresar a una red
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm, esa dirección no parece estar bien.
netInterrupt-title = La conexión fue interrumpida
notCached-title = Documento expirado
netOffline-title = Modo sin conexión a la red
contentEncodingError-title = Error de codificación de contenido
unsafeContentType-title = Tipo de archivo inseguro
netReset-title = La conexión fue restablecida
netTimeout-title = La conexión tardó demasiado tiempo
unknownProtocolFound-title = La dirección no fue comprendida
proxyConnectFailure-title = El servidor proxy está rechazando las conexiones
proxyResolveFailure-title = No se puede encontrar el servidor proxy
redirectLoop-title = La página no está siendo redireccionada correctamente
unknownSocketType-title = Respuesta inesperada del servidor
nssFailure2-title = Fallo en conexión segura
csp-xfo-error-title = { -brand-short-name } no puede abrir esta página
corruptedContentError-title = Error de contenido corrupto
remoteXUL-title = XUL remoto
sslv3Used-title = No se puede conectar de forma segura
inadequateSecurityError-title = La conexión no es segura
blockedByPolicy-title = Página bloqueada
clockSkewError-title = El reloj de la computadora está equivocado
networkProtocolError-title = Error de protocolo de red
nssBadCert-title = Advertencia: Potencial riesgo de seguridad próximo
nssBadCert-sts-title = No se conectó: Posible problema de seguridad
certerror-mitm-title = El software está impidiendo que { -brand-short-name } se conecte a este sitio de manera segura
