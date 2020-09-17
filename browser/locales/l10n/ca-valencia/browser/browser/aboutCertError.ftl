# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } utilitza un certificat de seguretat que no és vàlid.

cert-error-mitm-intro = Els llocs web demostren la seua identitat mitjançant certificats emesos per entitats certificadores.

cert-error-mitm-mozilla = El { -brand-short-name } té el suport de l'organització sense ànim de lucre Mozilla, que gestiona un magatzem d'entitat certificadora (CA) completament obert. El magatzem de CA vos garanteix que les entitats certificadores segueixen les millors pràctiques per a la seguretat dels usuaris.

cert-error-mitm-connection = El { -brand-short-name } utilitza el magatzem de CA de Mozilla per verificar que una connexió és segura, en lloc d'utilitzar certificats subministrats pel sistema operatiu de l'usuari. Per tant, si un programa antivirus o una xarxa intercepten una connexió amb un certificat de seguretat emés per una CA que no es troba al magatzem de CA de Mozilla, la connexió es considera insegura.

cert-error-trust-unknown-issuer-intro = És possible que algú estiga intentant suplantar el lloc i no hauríeu de continuar.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Els llocs web demostren la seua identitat mitjançant certificats. El { -brand-short-name } no confia en { $hostname } perquè l'emissor del seu certificat és desconegut, el certificat està signat per ell mateix o el servidor no envia els certificats intermedis correctes.

cert-error-trust-cert-invalid = No es confia en el certificat perquè fou emés per un certificat de CA no vàlid.

cert-error-trust-untrusted-issuer = No es confia en el certificat perquè no es confia tampoc en l'emissor del certificat.

cert-error-trust-signature-algorithm-disabled = No es confia en el certificat perquè ha estat signat amb un algorisme de signatura que va ser inhabilitat per no ser segur.

cert-error-trust-expired-issuer = No es confia en el certificat perquè l'emissor del certificat ha vençut.

cert-error-trust-self-signed = No es confia en el certificat perquè està signat per ell mateix.

cert-error-trust-symantec = Els certificats emesos per GeoTrust, RapidSSL, Symantec, Thawte i VeriSign ja no es consideren segurs, ja que estes entitats certificadores no han seguit les pràctiques de seguretat en el passat.

cert-error-untrusted-default = El certificat no prové d'una font de confiança.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Els llocs web demostren la seua identitat mitjançant certificats. El { -brand-short-name } no confia en este lloc perquè utilitza un certificat que no és vàlid per a { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Els llocs web demostren la seua identitat mitjançant certificats. El { -brand-short-name } no confia en este lloc perquè utilitza un certificat que no és vàlid per a { $hostname }. El certificat només és vàlid per a <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Els llocs web demostren la seua identitat mitjançant certificats. El { -brand-short-name } no confia en este lloc perquè utilitza un certificat que no és vàlid per a { $hostname }. El certificat només és vàlid per a { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Els llocs web demostren la seua identitat mitjançant certificats. El { -brand-short-name } no confia en este lloc perquè utilitza un certificat que no és vàlid per a { $hostname }. El certificat només és vàlid per als noms següents: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Els llocs web demostren la seua identitat mitjançant certificats, que són vàlids durant un període de temps determinat. El certificat de { $hostname } va caducar el { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Els llocs web demostren la seua identitat mitjançant certificats, que són vàlids durant un període de temps determinat. El certificat de { $hostname } no serà vàlid fins al { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Codi d'error: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Els llocs web demostren la seua identitat mitjançant certificats emesos per entitats certificadores.  La majoria de navegadors ja no confien en els certificats emesos per GeoTrust, RapidSSL, Symantec, Thawte i VeriSign. { $hostname } utilitza un certificat d'una d'estes entitats i, per tant, no es pot provar la identitat del lloc web.

cert-error-symantec-distrust-admin = Podeu notificar el problema a l'administrador del lloc web.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = Seguretat estricta de transport HTTP: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = Fixació de claus públiques HTTP: { $hasHPKP }

cert-error-details-cert-chain-label = Cadena de certificats:

open-in-new-window-for-csp-or-xfo-error = Obri el lloc en una finestra nova

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Per protegir la vostra seguretat, { $hostname } no permetrà al { -brand-short-name } mostrar la pàgina si està incrustada en un altre lloc. Per veure esta pàgina, cal obrir-la en una finestra nova.

## Messages used for certificate error titles

connectionFailure-title = No s'ha pogut connectar
deniedPortAccess-title = L'adreça està restringida
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Tenim problemes per trobar este lloc.
fileNotFound-title = No s'ha trobat el fitxer
fileAccessDenied-title = S'ha denegat l'accés al fitxer
generic-title = Ups.
captivePortal-title = Inicieu la sessió a la xarxa
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Esta adreça no pareix correcta.
netInterrupt-title = S'ha interromput la connexió
notCached-title = El document ha caducat
netOffline-title = Mode fora de línia
contentEncodingError-title = Error de codificació del contingut
unsafeContentType-title = Tipus de fitxer insegur
netReset-title = S'ha reiniciat la connexió
netTimeout-title = S'ha esgotat el temps d'espera de la connexió
unknownProtocolFound-title = No s'ha entés l'adreça
proxyConnectFailure-title = El servidor intermediari està rebutjant les connexions
proxyResolveFailure-title = No s'ha pogut trobar el servidor intermediari
redirectLoop-title = La pàgina no està redirigint correctament
unknownSocketType-title = Resposta inesperada del servidor
nssFailure2-title = Ha fallat la connexió segura
csp-xfo-error-title = El { -brand-short-name } no pot obrir esta pàgina
corruptedContentError-title = Error de contingut malmés
remoteXUL-title = XUL remot
sslv3Used-title = No s'ha pogut connectar de forma segura
inadequateSecurityError-title = La connexió no és segura
blockedByPolicy-title = Pàgina blocada
clockSkewError-title = L'hora del vostre ordinador no és correcta
networkProtocolError-title = Error del protocol de xarxa
nssBadCert-title = Avís: Risc potencial de seguretat
nssBadCert-sts-title = No s'ha connectat: Problema potencial de seguretat
certerror-mitm-title = Hi ha programari que impedeix que el { -brand-short-name } es connecte de forma segura a este lloc
