# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } fa servir un certificau de seguranza no valido.
cert-error-mitm-intro = Los puestos web preban la suya identidat per medio de certificaus emesos per entidatz certificaderas.
cert-error-mitm-mozilla = { -brand-short-name } ye refirmau per Mozilla, una organización sin animo de lucro que administra un almagazén d'autoridatz de certificación (CA) ubierto de tot. L'almagazén aduya a asegurar que las autoridatz de certificación respectan las milloras practicas de seguranza pa protecher los usuarios.
cert-error-mitm-connection = { -brand-short-name } emplega l'almagazén de CA de Mozilla pa verfificar si una connexion ye segura, millor que con certificaus daus por o sistema operativo de l'usuario. Per ixo, si un antivirus u un ret intercepta una connexion con bell certificau dau per una CA que no ye en l'almagazén de Mozilla, la conexión se considera insegura.
cert-error-trust-unknown-issuer-intro = Belún puet estar mirando d'impersonar lo puesto, y no habráis de continar.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Las pachinas web prueban as suyas identidatz con certificaus. { -brand-short-name } no confía en { $hostname } perque lo suyo creador de certificaus ye desconoixiu, lo certificau ye autofirmau u lo servidor no ye ninviando los certificaus intermedios correctos.
cert-error-trust-cert-invalid = No se confía en o certificau porque estió emitiu por un certificau de CA no valido.
cert-error-trust-untrusted-issuer = No se confía en o certificau porque tampoco no se confía en o certificau d'o emisor.
cert-error-trust-signature-algorithm-disabled = No se confía en o certificau porque s'ha sinyau con un algoritmo de sinyadura que se desactivó porque no yera seguro.
cert-error-trust-expired-issuer = No se confía en o certificau porque o certificau d'o emisor ha venciu.
cert-error-trust-self-signed = No se confía en o certificau porque ye sinyau por ell mesmo.
cert-error-trust-symantec = Los certificaus expedius por GeoTrust, RapidSSL, Symantec, Thawte y VeriSign ya no se consideran seguras perque estas autoridatz de certificaus no han seguiu practicas de seguranza en o pasau.
cert-error-untrusted-default = O certificau no procede d'una fuent de confianza.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Las pachinas web gosan prebar la suya identidat con certificaus. { -brand-short-name } no confía en este puesto perque fa servir un certificau que no ye valido pa { $hostname }.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Las pachinas web preban a suya identidat per medio de certificaus. { -brand-short-name } no confia en ista pachina perque fa servir un certificau que no ye valido pa { $hostname }. O certificau ye valido nomás pa <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Las pachinas web preban a suya identidat per medio de certificaus. { -brand-short-name } no confia en ista pachina perque fa servir un certificau que no ye valido pa { $hostname }. Lo certificau ye valido nomás pa <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.
# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Las pachinas web preban a suya identidat per medio de certificaus. { -brand-short-name } no confia en ista pachina perque fa servir un certificau que no ye valido pa { $hostname }. Lo certificau ye valido nomás pa los nombres siguients:{ $subject-alt-names }
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Las pachinas web preban a suya identidat per medio de certificaus, que son validos per un cierto tiempo. Lo certificau para { $hostname } caducó lo { $not-after-local-time }.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Las pachinas web preban a suya identidat per medio de certificaus que son validos per un cierto tiempo. Lo certificau para { $hostname } no ye valido hasta { $not-before-local-time }.
# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Codigo d'error: <a data-l10n-name="error-code-link">{ $error }</a>
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Los puestos web preban la suya identidat per medio de certificaus, que son emesos per autoridatz de certificación. La mayor parte d'os navegadors ya no se fían d'os certificaus emesos per GeoTrust, RapidSSL, Symantec, Thawte y VeriSign. { $hostname } fa servir un certificau d'una d'estas autoridatz y per ixo la identidat d'o puesto web no se puede prebar.
cert-error-symantec-distrust-admin = Puetz notificar lo problema a l'administrador d'o puesto web.
# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = Seguranza de Transporte Estricto HTTP: { $hasHSTS }
# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = Fixación de Clau Publica HTTP: { $hasHPKP }
cert-error-details-cert-chain-label = Cadena de certificaus:
open-in-new-window-for-csp-or-xfo-error = Ubrir pachina en una finestra nueva
# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Pa protecher la tuya seguranza, { $hostname } no permitirá que { -brand-short-name } amuestre la pachina si atro puesto la tiene incrustada. Pa veyer esta pachina la has d'ubrir en una nueva finestra.

## Messages used for certificate error titles

connectionFailure-title = No s'ha puesto connectar
deniedPortAccess-title = L'adreza ye restrinchida
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Umm. Somos tenendo bell problema pa trobar este puesto.
fileNotFound-title = No s'ha trobau o fichero
fileAccessDenied-title = S'ha denegau l'acceso a lo fichero
generic-title = Ups.
captivePortal-title = Iniciar sesión de ret
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Umm. Ixa adreza no fa buena cara.
netInterrupt-title = S'ha interrumpiu a connexión
notCached-title = O documento ha circumduciu
netOffline-title = Modo sin connexión
contentEncodingError-title = Error de codificación d'o conteniu
unsafeContentType-title = Tipo de fichero inseguro
netReset-title = S'ha reiniciau a connexión
netTimeout-title = S'ha acotolau o tiempo d'aspera d'a connexión
unknownProtocolFound-title = No s'ha entendiu l'adreza
proxyConnectFailure-title = O servidor proxy ye refusando as connexions
proxyResolveFailure-title = No s'ha puesto trobar o servidor proxy
redirectLoop-title = A pachina no ye reendrezando adequadament
unknownSocketType-title = Respuesta inasperada d'o servidor
nssFailure2-title = Ha fallau la connexión segura
csp-xfo-error-title = { -brand-short-name } no puet ubrir esta pachina
corruptedContentError-title = Error en o conteniu d'a pachina
remoteXUL-title = XUL remoto
sslv3Used-title = No ye posible connectar de traza segura
inadequateSecurityError-title = La connexion no ye pas segura
blockedByPolicy-title = Pachina blocada
clockSkewError-title = Lo reloch d'o tuyo ordinador ye mal
networkProtocolError-title = Error de protocolo de ret
nssBadCert-title = Atención: risgo potencial de seguranza
nssBadCert-sts-title = Connexión blocada: problema potencial de seguranza
certerror-mitm-title = Un programa ye privando que { -brand-short-name } se connecte de manera segura a este puesto
