# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } utilisescha in certificat da segirezza nunvalid.

cert-error-mitm-intro = Websites cumprovan lur identitad cun certificats che vegnan emess dad autoritads da certificaziun.

cert-error-mitm-mozilla = { -brand-short-name } vegn sustegnì da l'organisaziun senza finamira da profit Mozilla che administrescha ina banca da datas cumplettamain averta per autoritads da certificaziun (CA). Questa banca da datas gida a garantir che las autoritads da certificaziun resguardian las directivas da segirezza per proteger ils clients.

cert-error-mitm-connection = Per verifitgar ch'ina connexiun saja segira utilisescha { -brand-short-name } la banca da datas da Mozilla (CA store) per autoritads da certificaziun empè da certificats mess a disposiziun dal sistem operativ da l'utilisader. Sche in program antivirus u ina rait s'intermettan en ina connexiun cun in certificat emess dad ina autoritad da certificaziun che n'è betg en la banca da datas da Mozilla per autoritads da certificaziun vegn la connexiun considerada sco betg segirada.

cert-error-trust-unknown-issuer-intro = Eventualmain emprova in'autra website da sa dar per la website giavischada. I vegn recumandà da betg cuntinuar.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Websites cumprovan lur identitad cun certificats. { -brand-short-name } na sa fida betg da { $hostname } perquai che l'emettur dal certificat n'è betg enconuschent, perquai ch'il certificat è auto-signà u perquai ch'il server na trametta betg ils certificats intermediars corrects.

cert-error-trust-cert-invalid = I na vegn betg fidà al certificat, perquai ch'el è vegnì emess d'in certificat d'in post da certificaziun nunvalid.

cert-error-trust-untrusted-issuer = I na vegn betg fidà al certificat, perquai ch'i na vegn betg fidà al certificat da l'emettur.

cert-error-trust-signature-algorithm-disabled = Da quest certificat na vegn betg fidà perquai ch'el è vegnì suttascrit cun in algoritmus da suttascriver ch'è vegnì deactivà perquai ch'el n'è betg segir.

cert-error-trust-expired-issuer = I na vegn betg fidà al certificat, perquai ch'il certificat da l'emettur è scrudà.

cert-error-trust-self-signed = I na vegn betg fidà al certificat, perquai ch'el è vegnì suttascrit sez.

cert-error-trust-symantec = Certificats emess da GeoTrust, RapidSSL, Symantec, Thawte e VeriSign na vegnan betg pli considerads sco segirs cunquai che questas autoritads da certificaziun n'han betg resguardà directivas da segirezza en il passà.

cert-error-untrusted-default = Il certificat na deriva betg d'ina funtauna degna da confidenza.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Websites cumprovan lur identitad cun certificats. { -brand-short-name } na sa fida betg da questa website perquai ch'ella utilisescha in certificat nunvalid per { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Websites cumprovan lur identitad cun certificats. { -brand-short-name } na sa fida betg da questa website perquai ch'ella utilisescha in certificat nunvalid per { $hostname }. Il certificat è mo valid per <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Websites cumprovan lur identitad cun certificats. { -brand-short-name } na sa fida betg da questa website perquai ch'ella utilisescha in certificat nunvalid per { $hostname }. Il certificat è mo valid per { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Websites cumprovan lur identitad cun certificats. { -brand-short-name } na sa fida betg da questa website perquai ch'ella utilisescha in certificat nunvalid per { $hostname }. Il certificat vala sulettamain per ils suandants nums: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Websites cumprovan lur identitad cun certificats che valan per ina tscherta perioda definida. Il certificat per { $hostname } è scrudà ils { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Websites cumprovan lur identitad cun certificats che valan per ina tscherta perioda definida. Il certificat per { $hostname } è pir valid a partir da { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Code d'errur: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Websites cumprovan lur identitad cun certificats che vegnan emess dad autoritads da certificaziun. Ils blers navigaturs na sa fidan betg pli da certificats emess da GeoTrust, RapidSSL, Symantec, Thawte e VeriSign. { $hostname } utilisescha in certificat dad ina da questas autoritads, uschia ch'i n'è betg pussaivel da verifitgar l'identitad da la website.

cert-error-symantec-distrust-admin = Ti pos infurmar l'administratur da la website davart quest problem.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Chadaina da certificats:

open-in-new-window-for-csp-or-xfo-error = Avrir la website en ina nova fanestra

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Per proteger tia segirezza na permetta { $hostname } betg a { -brand-short-name } da visualisar la pagina sche in'autra website l'ha incorporada. Per vesair questa pagina la stos ti avrir en ina nova fanestra.

## Messages used for certificate error titles

connectionFailure-title = Connexiun betg reussida
deniedPortAccess-title = Il port è bloccà per motivs da segirezza
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Dianteren. Nus avain difficultads da chattar questa pagina.
fileNotFound-title = Impussibel da chattar la datoteca
fileAccessDenied-title = Refusà l'access a la datoteca
generic-title = Oh Dieu!
captivePortal-title = S'annunziar tar la rait
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Questa adressa na para betg correcta.
netInterrupt-title = La connexiun è interrutta
notCached-title = Document scrudà
netOffline-title = Modus offline
contentEncodingError-title = Cuntegns cun codaziun nunvalida
unsafeContentType-title = Tip da datoteca malsegir
netReset-title = La connexiun è interrutta
netTimeout-title = Il temp da la rait è surpassà
unknownProtocolFound-title = Impussibel da chapir l'adressa
proxyConnectFailure-title = Il proxy server refusescha la connexiun
proxyResolveFailure-title = Impussibel da chattar il proxy server
redirectLoop-title = Cirquit da sviament
unknownSocketType-title = Resposta nuncorrecta
nssFailure2-title = La connexiun segira n'è betg reussida
csp-xfo-error-title = { -brand-short-name } na po betg avrir questa pagina
corruptedContentError-title = Errur da cuntegn donnegià
remoteXUL-title = Remote-XUL
sslv3Used-title = Impussibel da connectar a moda segira
inadequateSecurityError-title = Tia connexiun n'è betg segirada
blockedByPolicy-title = Pagina bloccada
clockSkewError-title = L'ura da tes computer na constat betg
networkProtocolError-title = Errur dal protocol da rait
nssBadCert-title = Attenziun: Eventual ristg per la segirezza en vista
nssBadCert-sts-title = Bloccà la connexiun: Eventual problem da segirezza
certerror-mitm-title = Software impedescha che { -brand-short-name } connecteschia a moda segira cun questa website
