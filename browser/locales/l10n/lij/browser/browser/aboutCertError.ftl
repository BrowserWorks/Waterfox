# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } o l'adeuvia 'n certificato de seguessa che o no l'é valido.

cert-error-mitm-intro = I sciti dimonstran a seu identitæ pe mezo di certificati, che son distriboii da-e aotoritæ de certificaçion.

cert-error-trust-unknown-issuer-intro = Quarchedun o porrieiva ese apreuvo a provâ a usurpâ l'identitæ do scito. No ti dovieiva anâ avanti.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = I sciti dimonstran a seu identitæ pe mezo di certificati. { -brand-short-name } o no se fia de { $hostname } perché o distribotô do seu certificato o l'é sconosciuo, o certificato o l'é aoto-firmou, ò o server o no l'à mandou i certificati intermezi previsti.

cert-error-trust-cert-invalid = O certificato o no l'é fidou perché o l'é pubricou da 'na CA che a no l'é valida.

cert-error-trust-untrusted-issuer = O certificato o no l'é fidou perché o l'é pubricou da un pubricatô no fidou.

cert-error-trust-signature-algorithm-disabled = O certificato o no l'é afidabile perché o l'é stæto firmou co-in algoritmo de firma dizativou in quanto no seguo.

cert-error-trust-expired-issuer = O certificato o no l'é fidou perché o pubricatô o l'é scheito.

cert-error-trust-self-signed = O certificato o no l'é fidou perché s'é firmou da solo.

cert-error-untrusted-default = A fonte de questo certificato a no l'é da fiase.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Còdice d'erô: <a data-l10n-name="error-code-link">{ $error }</a>

cert-error-symantec-distrust-admin = Ti peu segnalâ o problema a l'aministratô do scito.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = Key Pinning HTTP pubrico: { $hasHPKP }

cert-error-details-cert-chain-label = Cadenna de certificati:

## Messages used for certificate error titles

connectionFailure-title = No riescio a conetime
deniedPortAccess-title = L'acesso a-a pòrta o l'é dizabilitou pe raxoin de seguessa
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Ahime mi. Gh'emmo di problemi a trovâ sto scito.
fileNotFound-title = Schedaio no trovou
fileAccessDenied-title = Acesso a-o schedaio negou
generic-title = Ahime mi!
captivePortal-title = Intra inta ræ
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Oh belin. St'indirisso me pâ segge sbaliou.
netInterrupt-title = Trasferimento di dæti scancellou
notCached-title = Documento scheito
netOffline-title = Mòddo feua linia
contentEncodingError-title = Erô de còdifica do contegnuo
unsafeContentType-title = Tipo de schedaio no seguo
netReset-title = Conescion Scancelâ
netTimeout-title = A ræ a no risponde
unknownProtocolFound-title = Indirisso no interpretabile
proxyConnectFailure-title = O proxy o refua a conescion
proxyResolveFailure-title = No treuvo o proxy
redirectLoop-title = A pagina a no redireçionn-a ben
unknownSocketType-title = Risposta sbaliâ da-o server
nssFailure2-title = Conescion segua no riescia
corruptedContentError-title = Erô de contegnuo andæto a mâ
remoteXUL-title = XUL Remòtto
sslv3Used-title = Inposcibile conetise in mòddo seguo
inadequateSecurityError-title = A teu conescion a no l'é segua
blockedByPolicy-title = Pagina blocâ
clockSkewError-title = O releuio do computer o l'é erou
networkProtocolError-title = Erô de protocòllo de ræ
nssBadCert-title = Atençion: gh'é 'n reizego de seguessa potensiâ
nssBadCert-sts-title = Conescion fermâ: reizego potensiâ de seguessa
