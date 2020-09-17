# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } utiliza un certificado de seguranza non válido.
cert-error-mitm-intro = Os sitios web demostran a súa identidade a través de certificados emitidos por autoridades certificadoras.
cert-error-mitm-mozilla = { -brand-short-name } está apoiado por Mozilla, organización sen ánimo de lucro que administra un almacén de autorización de certificados (CA) completamente aberto. O almacén de CA axuda a asegurarse de que as autoridades de certificados están a seguir as mellores prácticas para a seguridade dos usuarios.
cert-error-mitm-connection = { -brand-short-name } usa o almacén de CA da Mozilla para comprobar que a conexión é segura, máis que os certificados subministrados polo sistema operativo do usuario. Así, se un programa antivirus ou unha rede están a interceptar unha conexión cun certificado de seguridade emitido por unha CA que non se atopa no almacén de Mozilla, a conexión considérase insegura.
cert-error-trust-unknown-issuer-intro = Alguén podería estar tratando de suplantar o sitio e non debería continuar.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Os sitios web xustifican a súa identidade con certificados. { -brand-short-name } non confía en { $hostname } porque o emisor do seu certificado é descoñecido, o certificado está autoasinado ou o servidor non envía os certificados intermedios correctos.
cert-error-trust-cert-invalid = O certificado non é fiábel porque foi emitido por un certificado AC non válido.
cert-error-trust-untrusted-issuer = O certificado non é fiábel porque o certificado emisor non é de confianza.
cert-error-trust-signature-algorithm-disabled = O certificado non é fiábel porque se asinou usando un algoritmo de asinamento que foi desactivado porque non é seguro.
cert-error-trust-expired-issuer = O certificado non é fiábel porque o certificado emisor caducou.
cert-error-trust-self-signed = O certificado non é fiábel porque está autoasinado.
cert-error-trust-symantec = Os certificados emitidos por GeoTrust, RapidSSL, Symantec, Thawte e VeriSign xa non se consideran seguros porque estas entidades de acreditación, no pasado, non cumpriron coas prácticas de seguranza.
cert-error-untrusted-default = O certificado non procede dunha fonte fiábel.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Os sitios web xustifican a súa identidade con certificados. { -brand-short-name } non confía en { $hostname } porque usa un certificado que non é válido para { $hostname }.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Os sitios web xustifican a súa identidade con certificados. { -brand-short-name } non confía en { $hostname } porque usa un certificado que non é válido para { $hostname }. O certificado só e correcto para <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Os sitios web xustifican a súa identidade con certificados. { -brand-short-name } non confía en { $hostname } porque usa un certificado que non é válido para { $hostname }. O certificado só e correcto para { $alt-name }.
# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Os sitios web xustifican a súa identidade con certificados. { -brand-short-name } non confía en { $hostname } porque usa un certificado que non é válido para { $hostname }. O certificado só é válido para os seguintes nomes: { $subject-alt-names }
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Os sitios web proban a súa identidade a través de certificados, válidos durante un período de tempo establecido. O certificado de { $hostname } caducou o { $not-after-local-time }.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Os sitios web proban a súa identidade a través de certificados, válidos durante un período de tempo establecido. O certificado para { $hostname } non será válido ata { $not-before-local-time }.
# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Código de erro: <a data-l10n-name="error-code-link">{ $error }</a>
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Os sitios web xustifican a súa identidade con certificados, que son emitidos por entidades de acreditación. A maioría dos navegadores xa non confiarán nos certificados emitidos por GeoTrust, RapidSSL, Symantec, Thawte e VeriSign. { $hostname } usa un certificado emitido por unha destas entidades de acreditación, polo tanto, non é posíbel garantir a autenticidade do sitio.
cert-error-symantec-distrust-admin = Pode avisar ao administrador do sitio web sobre o problema.
# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = Seguranza de transporte estrita HTTP: { $hasHSTS }
# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }
cert-error-details-cert-chain-label = Cadea de certificados:
open-in-new-window-for-csp-or-xfo-error = Abrir sitio nunha xanela nova
# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Para protexer a súa seguridade, { $hostname } non permitirá que { -brand-short-name } amose a páxina se outro sitio a incrustou. Para ver esta páxina, é preciso abrila nunha xanela nova.

## Messages used for certificate error titles

connectionFailure-title = Non é posíbel conectarse
deniedPortAccess-title = Este enderezo está restrinxido
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Estamos tendo problemas para atopar ese sitio.
fileNotFound-title = Non se atopou o ficheiro
fileAccessDenied-title = Denegouse o acceso ao ficheiro
generic-title = Vaites.
captivePortal-title = Identificarse na rede
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = O enderezo non parece correcto.
netInterrupt-title = Interrompeuse a conexión
notCached-title = O documento caducou
netOffline-title = Modo sen conexión
contentEncodingError-title = Erro de codificación do contido
unsafeContentType-title = Tipo de ficheiro inseguro
netReset-title = Reiniciouse a conexión
netTimeout-title = A conexión esgotou o tempo
unknownProtocolFound-title = Non se entendeu o enderezo
proxyConnectFailure-title = O servidor proxy está a rexeitar as conexións
proxyResolveFailure-title = Non é posíbel atopar o servidor proxy
redirectLoop-title = A páxina non está a redirixir correctamente
unknownSocketType-title = Resposta inesperada do servidor
nssFailure2-title = Fallou a conexión segura
csp-xfo-error-title = { -brand-short-name } non pode abrir esta páxina
corruptedContentError-title = Erro de contido danado
remoteXUL-title = XUL remoto
sslv3Used-title = Non é posíbel conectarse de forma segura
inadequateSecurityError-title = A súa conexión non é segura
blockedByPolicy-title = Páxina bloqueada
clockSkewError-title = A hora do seu computador é incorrecta
networkProtocolError-title = Erro do protocolo de rede
nssBadCert-title = Aviso: potencial risco de seguranza
nssBadCert-sts-title = Conexión bloqueada: Potencial incidencia de seguranza
certerror-mitm-title = O software impide que { -brand-short-name } se conecte de forma segura a este sitio
