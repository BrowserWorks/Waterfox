# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } wužiwa njepłaćiwy wěstotny certifikat.

cert-error-mitm-intro = Websydła swoju identitu přez certifikaty dopokazuja, kotrež so wot certifikanišćow wudawaja.

cert-error-mitm-mozilla = { -brand-short-name } so wot powšitkownosći wužitneje załožby Mozilla podpěruje, kotraž dospołnje wotewrjeny wobchod certifikatowanišća (CA) zarjaduje. Wobchod certifikowanišća pomha zawěsćić, zo so certifikowanišća najlěpšich praktikow za wužiwarsku wěstotu dźerža.

cert-error-mitm-connection = { -brand-short-name } wobchod certifikowanišćow Mozilla wužiwa, zo by přepruwował, hač zwisk je wěsty, a nic certifikaty z dźěłoweho systema wužiwarja. Jeli tuž antiwirusowy program abo syć zwisk z wěstotnym certifikatom wotpopadnje, kotrež je certifikowanišćo wudało, kotrež we wobchodźe certifikowanišćow Mozilla njeje, so zwisk ma za njewěsty.

cert-error-trust-unknown-issuer-intro = Něchtó móhł spytać, sydło imitować a wy njeměł pokročować.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Websydła swoju identitu přez certifikaty dopokazuja. { -brand-short-name } { $hostname } njedowěrja, dokelž jeho certifikatowy wudawar je njeznaty, certifikat je samosignowany abo serwer korektne mjezcertifikaty njesćele.

cert-error-trust-cert-invalid = Certifikat njeje dowěry hódny, dokelž bu přez njepłaćiwy certifikat certifikatoweje awtority wudaty.

cert-error-trust-untrusted-issuer = Certifikat njeje dowěry hódny, dokelž wudawarski certifikat dowěry hódny njeje.

cert-error-trust-signature-algorithm-disabled = Tutón certifikat dowěry hódny njeje, dokelž je so ze signowanskim algoritmom signował, kotryž je so znjemóžnił, dokelž algoritm wěsty njeje.

cert-error-trust-expired-issuer = Certifikat njeje dowěry hódny, dokelž wudawarski certifikat je spadnjeny.

cert-error-trust-self-signed = Certifikat njeje dowěry hódny, dokelž je so sam podpisał.

cert-error-trust-symantec = Certifikaty, kotrež su GeoTrust, RapidSSL, Symantec, Thawte a VeriSign wudali hižo za wěste nimaja, dokelž tute certifikowanišća w zańdźenosći njejsu so wěstotnych zwučenosćow dźerželi.

cert-error-untrusted-default = Certifikat njepochadźa z dowěry hódneho žórła.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Websydła swoju identitu přez certifikaty dopokazuja. { -brand-short-name } tutomu sydłu njedowěrja, dokelž certifikat wužiwa, kotryž za { $hostname } płaćiwy njeje.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Websydła swoju identitu přez certifikaty dopokazuja. { -brand-short-name } tutomu sydłu njedowěrja, dokelž certifikat wužiwa, kotryž za { $hostname } płaćiwy njeje. Certifikat je jenož płaćiwy za <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Websydła swoju identitu přez certifikaty dopokazuja. { -brand-short-name } tutomu sydłu njedowěrja, dokelž certifikat wužiwa, kotryž za { $hostname } płaćiwy njeje. Certifikat je jenož płaćiwy za { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Websydła swoju identitu přez wěstotne certifikaty dopokazuja. { -brand-short-name } tutomu sydłu njedowěrja, dokelž certifikat wužiwa, kotryž za { $hostname } płaćiwy njeje. Certifikat je płaćiwy jenož za slědowace mjena: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Websydła swoju identitu přez certifikaty dopokazuja, kotrež su płaćiwe za nastajenu periodu. Certifikat za { $hostname } je { $not-after-local-time } spadnjeny.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Websydła swoju identitu přez certifikaty dopokazuja, kotrež su płaćiwe za nastajenu periodu. Certifikat za { $hostname } njebudźe płaćiwy hač do { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Zmylkowy kod: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Websydła swoju identitu přez certifikaty dopokazuja, kotrež certifikowanišća wudawaja. Najwjace wobhladowakow hižo certifikatam njedowěrja, kotrež su GeoTrust, RapidSSL, Symantec, Thawte a VeriSign wudali. { $hostname } certifikat jednoho z tutych certifikowanišćow wužiwa a tohodla njeda so identita websydła dopokazać.

cert-error-symantec-distrust-admin = Snano chceće administratora websydła wo tutym problemje informować.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Certifikatowy rjećaz:

open-in-new-window-for-csp-or-xfo-error = Sydło w nowym woknje wočinić

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Zo byšće swoju wěstotu škitał, { $hostname } { -brand-short-name } njedowoli, stronu pokazać, jeli je zasadźeny w druhim sydle. Zo byšće tutu stronu widźał, dyrbiće ju w nowym woknje wočinić.

## Messages used for certificate error titles

connectionFailure-title = Zwisk móžny njeje
deniedPortAccess-title = Tuta adresa je wobmjezowana
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hm. Mamy problemy, te sydło namakać.
fileNotFound-title = Dataja njeje so namakała
fileAccessDenied-title = Přistup na dataju je so wotpokazał
generic-title = Hopla.
captivePortal-title = So pola syće přizjewić
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hm. Zda so, zo tuta adresa korektna njeje.
netInterrupt-title = Zwisk je so přetorhnył
notCached-title = Dokument je njepłaćiwy
netOffline-title = Offline-modus
contentEncodingError-title = Zmylk při kodowanju wobsaha
unsafeContentType-title = Njewěsty datajowy typ
netReset-title = Zwisk je so wróćo stajił
netTimeout-title = Zwisk je čas překročił
unknownProtocolFound-title = Adresa njeje so zrozumiła
proxyConnectFailure-title = Proksyserwer zwiski wotpokazuje
proxyResolveFailure-title = Njeje móžno, proksyserwer namakać
redirectLoop-title = Strona njeprawje posrědkuje
unknownSocketType-title = Njewočakowana wotmołwa ze serwera
nssFailure2-title = Wěsty zwisk móžny njeje
csp-xfo-error-title = { -brand-short-name } njemóže tutu stronu wočinić
corruptedContentError-title = Zmylk - wobškodźeny wobsah
remoteXUL-title = Zdaleny XUL
sslv3Used-title = Wěsty zwisk móžny njeje
inadequateSecurityError-title = Waš zwisk wěsty njeje
blockedByPolicy-title = Zablokowana strona
clockSkewError-title = Waš ličakowy časnik wopak dźe
networkProtocolError-title = Zmylk syćoweho protokola
nssBadCert-title = Warnowanje: Potencielne wěstotne riziko prědku
nssBadCert-sts-title = Njeje so zwjazało: Potencielny wěstotny problem
certerror-mitm-title = Software { -brand-short-name } při wěstym zwjazowanju z tutym sydłom haći
