# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = Mae { $hostname } yn defnyddio tystysgrif diogelwch annilys.

cert-error-mitm-intro = Mae gwefannau'n profi eu hunaniaeth drwy dystysgrifau, sy'n cael eu cyhoeddi gan awdurdodau tystysgrifau.

cert-error-mitm-mozilla = Mae { -brand-short-name } yn cael ei gefnogi gan Mozilla y corff dim-er-elw, sy'n gweinyddu storfa awdurdod tystysgrifau (CA) cwbl agored. Mae'r storfa'n cynorthwyo i sicrhau fod awdurdodau tystysgrif yn dilyn ymarfer gorau ar gyfer diogelwch defnyddwyr.

cert-error-mitm-connection = Mae { -brand-short-name } yn defnyddio storfa CA Mozilla i wirio bod cysylltiad yn ddiogel, yn hytrach na thystysgrifau wedi eu cyflenwi gan system weithredu'r defnyddiwr. Felly, os yw rhaglen gwrth-firws neu rwydwaith yn rhyng-gipio cysylltiad â thystysgrif diogelwch a gyhoeddwyd gan CA nad yw yn storfa CA Mozilla, mae'n ystyried bod y cysylltiad yn anniogel.

cert-error-trust-unknown-issuer-intro = Gall fod rhywun yn ceisio efelychu'r wefan a pheidiwch â mynd yn eich blaen.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Mae gwefannau'n profi eu hunaniaeth drwy dystysgrifau. Nid yw { -brand-short-name } yn ymddiried yn { $hostname } gan nad yw ei gyhoeddwr tystysgrifau'n hysbys, mae'r dystysgrif wedi ei llofnodi ganddo'i hun neu nid yw'r gweinydd yn anfon y tystysgrifau rhyngol cywir.

cert-error-trust-cert-invalid = Nid oes modd ymddiried yn y dystysgrif am ei fod wedi rhyddhau tystysgrif CA annilys.

cert-error-trust-untrusted-issuer = Nid oes modd ymddiried yn y dystysgrif oherwydd nad oes modd ymddiried yn ei chyhoeddwr.

cert-error-trust-signature-algorithm-disabled = Nid oes ymddiriedaeth i'r dystysgrif gan ei fod wedi ei lofnodi gan ddefnyddio algorithm llofnod sydd wedi ei analluogi am nad yw'r algorithm yn anniogel.

cert-error-trust-expired-issuer = Nid oes modd ymddiried yn y dystysgrif oherwydd bod y dystysgrif ryddhau wedi dod i ben.

cert-error-trust-self-signed = Nid oes modd ymddiried yn y dystysgrif am ei fod wedi ei hunanlofnodi.

cert-error-trust-symantec = Nid yw tystysgrifau a gyhoeddwyd gan GeoTrust, RapidSSL, Symantec, Thawte, a VeriSign bellach yn cael eu hystyried yn ddiogel oherwydd nad oedd yr awdurdodau tystysgrif hyn yn dilyn arferion diogelwch yn y gorffennol.

cert-error-untrusted-default = Nid yw'r dystysgrif yn dod o fan gellir ymddiried ynddo.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Mae gwefannau'n profi eu hunaniaeth drwy dystysgrifau. Nid yw { -brand-short-name } yn ymddiried yn y wefan hon gan ei fod yn defnyddio tystysgrif nad yw'n ddilys ar gyfer { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Mae gwefannau'n profi eu hunaniaeth drwy dystysgrifau. Nid yw { -brand-short-name } yn ymddiried yn y wefan hon gan ei fod yn defnyddio tystysgrif nad yw'n ddilys ar gyfer { $hostname }. Dim ond ar gyfer <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a> mae'r dystysgrif yn ddilys.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Mae gwefannau'n profi eu hunaniaeth drwy dystysgrifau. Nid yw { -brand-short-name } yn ymddiried yn y wefan hon gan ei fod yn defnyddio tystysgrif nad yw'n ddilys ar gyfer { $hostname }. Dim ond ar gyfer { $alt-name } mae'r dystysgrif yn ddilys.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Mae gwefannau yn profi eu hunaniaeth trwy dystysgrifau. Nid yw { -brand-short-name } yn ymddiried yn y wefan hon oherwydd ei fod yn defnyddio tystysgrif nad yw'n ddilys ar gyfer { $hostname }. Mae'r dystysgrif yn ddilys yn unig ar gyfer yr enwau canlynol: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Mae gwefannau yn profi eu hunaniaeth trwy dystysgrifau, sy'n ddilys am gyfnod penodol. Daeth y dystysgrif ar gyfer { $hostname } i ben ar { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Mae gwefannau yn profi eu hunaniaeth trwy dystysgrifau, sy'n ddilys am gyfnod penodol. Ni fydd y dystysgrif ar gyfer { $hostname } yn ddilys tan { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Cod gwall: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Mae gwefannau yn profi eu hunaniaeth trwy dystysgrifau, sy'n cael eu cyhoeddir gan awdurdodau tystysgrif. Nid yw'r mwyafrif o borwyr bellach yn ymddiried mewn tystysgrifau a gyhoeddir gan GeoTrust, RapidSSL, Symantec, Thawte, a VeriSign. Mae { $hostname } yn defnyddio tystysgrif gan un o'r awdurdodau hyn ac felly nid oes modd profi hunaniaeth y wefan.

cert-error-symantec-distrust-admin = Gallwch hysbysu gweinyddwr y wefan am y broblem hon.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = Diogelwch Trosglwyddo Llym HTTP: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = Pinio Allwedd Cyhoeddus HTTP: { $hasHPKP }

cert-error-details-cert-chain-label = Cadwyn tystysgrif:

open-in-new-window-for-csp-or-xfo-error = Agor Gwefan mewn Ffenestr Newydd

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Er mwyn amddiffyn eich diogelwch, ni fydd { $hostname } yn caniatáu i { -brand-short-name } ddangos y dudalen os yw gwefan arall wedi'i mewnblannu ynddi. I weld y dudalen hon, bydd angen i chi ei hagor mewn ffenestr newydd.

## Messages used for certificate error titles

connectionFailure-title = Methu cysylltu
deniedPortAccess-title = Mae'r cyfeiriad wedi ei gyfyngu
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Rydym yn cael trafferth canfod y wefan honno.
fileNotFound-title = Heb ganfod ffeil
fileAccessDenied-title = Mae mynediad i'r ffeil wedi ei wrthod
generic-title = Wps.
captivePortal-title = Mewngofnodi i'r rhwydwaith
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Dyw'r cyfeiriad yna ddim yn edrych yn iawn.
netInterrupt-title = Cafodd y cysylltiad ei darfu
notCached-title = Daeth y Ddogfen i Ben
netOffline-title = Modd all-lein
contentEncodingError-title = Gwall Amgodio Cynnwys
unsafeContentType-title = Math Anniogel o ffeil
netReset-title = Cafodd y cysylltiad ei ailosod
netTimeout-title = Mae cyfnod y cyswllt wedi dod i ben
unknownProtocolFound-title = Heb ddeall y cyfeiriad
proxyConnectFailure-title = Mae'r gweinydd dirprwy yn gwrthod cysylltiadau
proxyResolveFailure-title = Methu canfod y gweinydd dirprwyol
redirectLoop-title = Nid yw'r dudalen yn ailgyfeirio'n iawn
unknownSocketType-title = Ymateb annisgwyl gan y gweinydd
nssFailure2-title = Methodd y Cysylltiad Diogel
csp-xfo-error-title = Nid yw { -brand-short-name } yn Gallu Agor y Dudalen hon
corruptedContentError-title = Gwall Cynnwys Llygredig
remoteXUL-title = XUL pell
sslv3Used-title = Methu Cysylltu'n Ddiogel
inadequateSecurityError-title = Nid yw eich cysylltiad yn ddiogel
blockedByPolicy-title = Tudalen wedi'i Rhwystro
clockSkewError-title = Mae cloc eich cyfrifiadur yn anghywir
networkProtocolError-title = Gwall Protocol Rhwydwaith
nssBadCert-title = Rhybudd: Risg Diogelwch Posibl o'ch Blaen
nssBadCert-sts-title = Peidiwch Cysylltu: Mater Diogelwch Posib
certerror-mitm-title = Mae Meddalwedd yn Rhwystro { -brand-short-name } Rhag Cysylltu'n Ddiogel i'r Wefan Hon
