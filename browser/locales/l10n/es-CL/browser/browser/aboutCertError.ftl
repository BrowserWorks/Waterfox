# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } usa un certificado de seguridad inválido.

cert-error-mitm-intro = Los sitios web proveen su identidad a través de certificados, los que son emitidos por autoridades certificadoras.

cert-error-mitm-mozilla = { -brand-short-name } es respaldado por la organización sin fines de lucro Mozilla, la cual administra un almacén de autoridades certificadoras (CA) completamente abierto. El almacén de CA ayuda a asegurar que las autoridades certificadoras sigan las mejores prácticas para la seguridad del usuario.

cert-error-mitm-connection = { -brand-short-name } usa el almacén de CA de Mozilla para verificar que la conexión es segura, en lugar de los certificados suministrados por el sistema operativo del usuario. Por ello, si un programa antivirus o una red está interceptando una conexión con un certificado de seguridad emitido por una CA que no está en el almacén de CA de Mozilla, la conexión es considerada como insegura.

cert-error-trust-unknown-issuer-intro = Alguien podría estar intentando suplantar el sitio y no deberías continuar.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Los sitios web prueban su identidad a través de certificados. { -brand-short-name } no confía en { $hostname } porque el emisor del certificado es desconocido, el certificado es autofirmado, o el servidor no está enviando los certificados intermedios adecuados.

cert-error-trust-cert-invalid = No se confía en el certificado porque fue emitido por un certificado CA no válido.

cert-error-trust-untrusted-issuer = No se confía en el certificado porque no se confía en el certificado emisor.

cert-error-trust-signature-algorithm-disabled = No se confía en el certificado porque fue firmado usando un algoritmo de firma que fue desactivado por no ser seguro.

cert-error-trust-expired-issuer = No se confía en el certificado porque el certificado emisor ha vencido.

cert-error-trust-self-signed = No se confía en el certificado porque está autofirmado.

cert-error-trust-symantec = Los certificados emitidos por GeoTrust, RapidSSL, Symantec, Thawte y VeriSign ya no son considerados seguros porque estas autoridades certificadoras fallaron al seguir las prácticas de seguridad en el pasado.

cert-error-untrusted-default = El certificado no viene de una fuente confiada.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Los sitios web prueban su identidad a través de certificados. { -brand-short-name } no confía en este sitio porque usa un certificado que no es válido para { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Los sitios web prueban su identidad a través de certificados. { -brand-short-name } no confía en este sitio porque usa un certificado que no es válido para { $hostname }. El certificado es válido solo para <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Los sitios web prueban su identidad a través de certificados. { -brand-short-name } no confía en este sitio porque usa un certificado que no es válido para { $hostname }. El certificado es válido solo para { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Los sitios web prueban su identidad a través de certificados. { -brand-short-name } no confía en este sitio porque usa un certificado que no es válido para { $hostname }. El certificado solo es válido para los siguientes nombres: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Los sitios web prueban su identidad a través de certificados, los que son válidos por un periodo de tiempo definido. El certificado para { $hostname } expiró el { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Los sitios web prueban su identidad a través de certificados, los que son válidos por un periodo de tiempo definido. El certificado para { $hostname } no será válido hasta el { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Código de error: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Los sitios web prueban su identidad a través de certificados, los que son emitidos por autoridades certificadoras. La mayoría de los navegadores ya no confía en certificados emitidos por GeoTrust, RapidSSL, Symantec, Thawte y VeriSign. { $hostname } usa un certificado de una de estas autoridades y por ello la identidad del sitio no puede ser probada.

cert-error-symantec-distrust-admin = Puedes avisar al administrador de la página web acerca de este problema.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Cadena de certificado:

open-in-new-window-for-csp-or-xfo-error = Abrir sitio en una nueva ventana

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Para proteger tu seguridad, { $hostname } no permitirá que { -brand-short-name } muestre la página si otro sitio la ha incrustado. Para ver esta página, debes abrirla en una nueva ventana.

## Messages used for certificate error titles

connectionFailure-title = No se pudo conectar
deniedPortAccess-title = Esta dirección está restringida
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Estamos teniendo problemas para encontrar ese sitio.
fileNotFound-title = Archivo no encontrado
fileAccessDenied-title = El acceso al archivo fue denegado
generic-title = Chita.
captivePortal-title = Conectarse a la red
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Esa dirección no luce bien.
netInterrupt-title = La conexión fue interrumpida
notCached-title = Documento expirado
netOffline-title = Modo sin conexión
contentEncodingError-title = Error de codificación de contenido
unsafeContentType-title = Tipo de archivo inseguro
netReset-title = La conexión fue reiniciada
netTimeout-title = La conexión ha caducado
unknownProtocolFound-title = La dirección no fue comprendida
proxyConnectFailure-title = El servidor proxy está rechazando conexiones
proxyResolveFailure-title = No se pudo encontrar el servidor proxy
redirectLoop-title = La página no está redirigiendo adecuadamente
unknownSocketType-title = Respuesta inesperada del servidor
nssFailure2-title = Falló la conexión segura
csp-xfo-error-title = { -brand-short-name } no puede abrir esta página
corruptedContentError-title = Error de contenido corrupto
remoteXUL-title = XUL remoto
sslv3Used-title = No se puede conectar de forma segura
inadequateSecurityError-title = Tu conexión no es segura
blockedByPolicy-title = Página bloqueada
clockSkewError-title = El reloj de tu computador está mal
networkProtocolError-title = Error de protocolo de red
nssBadCert-title = Advertencia: Riesgo potencial de seguridad a continuación
nssBadCert-sts-title = No se conectó: Posible problema de seguridad
certerror-mitm-title = Hay un software que impide a { -brand-short-name } de conectarse de forma segura a este sitio
